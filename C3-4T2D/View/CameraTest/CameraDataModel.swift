//
//  CameraDataModel.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 5/29/25.
//

import AVFoundation
import os.log
import SwiftUI

final class CameraDataModel: ObservableObject {
    let camera = Camera()

    @Published var viewfinderImage: Image?
    @Published var isFlashOn: Bool = false

    /// 카메라로 촬영한 결과를 UI로 넘겨줄 콜백
    @MainActor
    var onPhotoCaptured: ((Image) -> Void)?

    @MainActor
    var onViewfinderImageUpdated: ((Image?) -> Void)?

    init() {
        Task {
            await handleCameraPreviews()
        }

        Task {
            await handleCameraPhotos()
        }
    }

    func toggleFlash() {
        isFlashOn.toggle()
        camera.toggleFlash(on: isFlashOn)
    }

    func handleCameraPreviews() async {
        let imageStream = camera.previewStream
            .map { $0.image }

        for await image in imageStream {
            Task { @MainActor in
                viewfinderImage = image
                self.onViewfinderImageUpdated?(image)
            }
        }
    }

    func handleCameraPhotos() async {
        let unpackedPhotoStream = camera.photoStream
            .compactMap { self.unpackPhoto($0) }

        for await photoData in unpackedPhotoStream {
            Task { @MainActor in
                // 전체 이미지로 변환
                if let uiImage = UIImage(data: photoData.imageData) {
                    let image = Image(uiImage: uiImage)
                    self.onPhotoCaptured?(image)
                }
            }
        }
    }

    private func unpackPhoto(_ photo: AVCapturePhoto) -> PhotoData? {
        guard let imageData = photo.fileDataRepresentation() else { return nil }

        guard let previewCGImage = photo.previewCGImageRepresentation(),
              let metadataOrientation = photo.metadata[String(kCGImagePropertyOrientation)] as? UInt32,
              let cgImageOrientation = CGImagePropertyOrientation(rawValue: metadataOrientation) else { return nil }

        let imageOrientation = Image.Orientation(cgImageOrientation)
        let thumbnailImage = Image(decorative: previewCGImage, scale: 1, orientation: imageOrientation)

        let photoDimensions = photo.resolvedSettings.photoDimensions
        let imageSize = (width: Int(photoDimensions.width), height: Int(photoDimensions.height))
        let previewDimensions = photo.resolvedSettings.previewDimensions
        let thumbnailSize = (width: Int(previewDimensions.width), height: Int(previewDimensions.height))

        return PhotoData(
            thumbnailImage: thumbnailImage,
            thumbnailSize: thumbnailSize,
            imageData: imageData,
            imageSize: imageSize
        )
    }
}

// PhotoData 구조체는 내부에서만 사용되므로 유지
private struct PhotoData {
    var thumbnailImage: Image
    var thumbnailSize: (width: Int, height: Int)
    var imageData: Data
    var imageSize: (width: Int, height: Int)
}

// CIImage를 SwiftUI Image로 변환
private extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}

// CGImagePropertyOrientation → SwiftUI Image.Orientation 변환기
private extension Image.Orientation {
    init(_ cgImageOrientation: CGImagePropertyOrientation) {
        switch cgImageOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}
