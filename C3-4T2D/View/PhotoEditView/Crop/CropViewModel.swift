//
//  CropViewModel.swift
//  C3-4T2D
//
//  Created by Hwang Seyeon on 6/5/25.
//

import SwiftUI

/// 이미지 크롭 뷰에서의 확대/이동/회전 등의 상태를 관리하는 ViewModel입니다.
class CropViewModel: ObservableObject {
    // MARK: - 고정 설정값
    private let maskRadius: CGFloat                      // 마스크 반지름
    private let maxMagnificationScale: CGFloat          // 최대 확대 배율
    private let rectAspectRatio: CGFloat                // 마스크의 가로 세로 비율 (5:4 등)

    // MARK: - 이미지 및 마스크 상태
    var imageSizeInView: CGSize = .zero                 // 뷰에 표시되는 이미지의 실제 크기
    @Published var maskSize: CGSize = .zero             // 마스크의 크기

    // MARK: - 제스처 상태값
    @Published var scale: CGFloat = 1.0                 // 현재 확대 배율
    @Published var lastScale: CGFloat = 1.0             // 이전 확대 배율
    @Published var offset: CGSize = .zero               // 현재 이미지 위치 오프셋
    @Published var lastOffset: CGSize = .zero           // 이전 오프셋
    @Published var angle: Angle = .zero                 // 현재 회전 각도
    @Published var lastAngle: Angle = .zero             // 이전 회전 각도

    // MARK: - 초기화
    init(
        maskRadius: CGFloat,
        maxMagnificationScale: CGFloat,
        rectAspectRatio: CGFloat = 5.0 / 4.0
    ) {
        self.maskRadius = maskRadius
        self.maxMagnificationScale = maxMagnificationScale
        self.rectAspectRatio = rectAspectRatio
    }

    // MARK: - 마스크 크기 계산

    /// 주어진 화면 사이즈에 맞춰 마스크 크기를 계산합니다.
    private func updateMaskSize(for size: CGSize) {
        let availableWidth = size.width * 0.9
        let width = availableWidth
        let height = width / rectAspectRatio
        maskSize = CGSize(width: width, height: height)
    }

    /// 이미지 뷰 크기에 맞춰 마스크 크기와 기준값을 갱신합니다.
    func updateMaskDimensions(for imageSizeInView: CGSize) {
        self.imageSizeInView = imageSizeInView
        updateMaskSize(for: imageSizeInView)
    }

    // MARK: - 제스처 계산

    /// 드래그 제스처 시 허용되는 최대 오프셋 값을 계산합니다.
    func calculateDragGestureMax() -> CGPoint {
        let xLimit = max(0, ((imageSizeInView.width / 2) * scale) - (maskSize.width / 2))
        let yLimit = max(0, ((imageSizeInView.height / 2) * scale) - (maskSize.height / 2))
        return CGPoint(x: xLimit, y: yLimit)
    }

    /// 확대 제스처 시 허용되는 최소/최대 배율을 계산합니다.
    func calculateMagnificationGestureMaxValues() -> (CGFloat, CGFloat) {
        let minScale = max(
            maskSize.width / imageSizeInView.width,
            maskSize.height / imageSizeInView.height
        )
        return (minScale, maxMagnificationScale)
    }

    // MARK: - 이미지 처리

    /// 이미지와 현재 상태(스케일, 오프셋 등)를 바탕으로 잘라낸 이미지 반환
    func cropToRectangle(_ image: UIImage, displayedImageSize: CGSize) -> UIImage? {
        let imageSize = image.size

        let factor = min(
            imageSize.width / displayedImageSize.width,
            imageSize.height / displayedImageSize.height
        )

        let centerX = imageSize.width / 2
        let centerY = imageSize.height / 2

        let cropWidth = (maskSize.width * factor) / scale
        let cropHeight = (maskSize.height * factor) / scale
        let offsetX = offset.width * factor / scale
        let offsetY = offset.height * factor / scale

        let cropRect = CGRect(
            x: centerX - cropWidth / 2 - offsetX,
            y: centerY - cropHeight / 2 - offsetY,
            width: cropWidth,
            height: cropHeight
        )

        guard let cgImage = image.cgImage?.cropping(to: cropRect) else { return nil }
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }

    /// 이미지를 지정 각도만큼 회전하여 반환합니다.
    func rotate(_ image: UIImage, _ angle: Angle) -> UIImage? {
        guard let orientedImage = image.correctlyOriented,
              let cgImage = orientedImage.cgImage else { return nil }

        let ciImage = CIImage(cgImage: cgImage)

        guard let filter = CIFilter.straightenFilter(image: ciImage, radians: angle.radians),
              let output = filter.outputImage else { return nil }

        let context = CIContext()
        guard let result = context.createCGImage(output, from: output.extent) else { return nil }

        return UIImage(cgImage: result)
    }

    /// 이미지에서 크롭 영역(CGRect)을 계산합니다. (현재 사용되지 않음)
    private func calculateCropRect(_ orientedImage: UIImage) -> CGRect {
        let factor = min(
            orientedImage.size.width / imageSizeInView.width,
            orientedImage.size.height / imageSizeInView.height
        )

        let center = CGPoint(x: orientedImage.size.width / 2, y: orientedImage.size.height / 2)
        let cropSize = CGSize(
            width: (maskSize.width * factor) / scale,
            height: (maskSize.height * factor) / scale
        )
        let offsetX = offset.width * factor / scale
        let offsetY = offset.height * factor / scale

        return CGRect(
            origin: CGPoint(x: center.x - cropSize.width / 2 - offsetX,
                            y: center.y - cropSize.height / 2 - offsetY),
            size: cropSize
        )
    }
}

// MARK: - UIImage 방향 보정 확장

private extension UIImage {
    /// 이미지의 orientation이 .up이 아닐 경우, 방향을 보정해 반환합니다.
    var correctlyOriented: UIImage? {
        if imageOrientation == .up { return self }

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return normalizedImage
    }
}

// MARK: - CIFilter 회전 필터 확장

private extension CIFilter {
    /// CIStraightenFilter를 생성하여 이미지를 지정 라디안만큼 회전시킵니다.
    static func straightenFilter(image: CIImage, radians: Double) -> CIFilter? {
        let angle = radians != 0 ? -radians : 0
        guard let filter = CIFilter(name: "CIStraightenFilter") else { return nil }
        filter.setDefaults()
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(angle, forKey: kCIInputAngleKey)
        return filter
    }
}
