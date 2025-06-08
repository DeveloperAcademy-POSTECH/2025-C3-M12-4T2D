//
//  CameraView.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 6/2/25.
//

import SwiftUI
import UIKit

/// 단순한 iOS 기본 카메라 래퍼 (CameraEditView에서 사용되지 않음)
struct CameraView: UIViewControllerRepresentable {
    var didFinishPicking: (UIImage) -> Void
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = false  // 중간 편집 화면 제거
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> CameraCoordinator {
        CameraCoordinator(parent: self)
    }
}
