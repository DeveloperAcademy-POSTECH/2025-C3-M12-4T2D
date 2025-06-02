//
//  CameraViewModel.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 5/28/25.
//

import Foundation
import Photos
import SwiftUI

class CameraViewModel: ObservableObject {
    @Published var isFlashOn = false
    @Published var isSilentModeOn = false
    @Published var isUsingFrontCamera = false
    @Published var capturedImage: UIImage?
    @Published var isShowingImagePicker = false

    func switchFlash() {
        isFlashOn.toggle()
    }

    func capturePhoto() {
        print("[CameraViewModel]: Photo captured!")

        // 테스트용 샘플 이미지 (실제 프로젝트에서는 AVFoundation으로 대체)
        if let sampleImage = UIImage(systemName: "camera") {
            capturedImage = sampleImage
            saveToPhotoAlbum(image: sampleImage)
        }
    }

    // MARK: - 앨범 접근

    func openImagePicker() {
        isShowingImagePicker = true
    }

    func changeCamera() {
        isUsingFrontCamera.toggle()
        print("[CameraViewModel]: Camera changed!")
    }

    // MARK: - 이미지 저장

    func saveToPhotoAlbum(image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized || status == .limited {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                print("[CameraViewModel]: Image saved to album")
            } else {
                print("[CameraViewModel]: Photo Library access denied")
            }
        }
    }
}
