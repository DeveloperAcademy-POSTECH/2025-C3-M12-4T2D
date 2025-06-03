//
//  CameraCoordinator.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 6/2/25.
//

import UIKit

class CameraCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    // SwiftUI - CameraView 와 연결 및 이미지 전달 통로
    let parent: CameraView

    init(parent: CameraView) {
        self.parent = parent
    }

    // 사진 선택 완료 처리
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    {
        // 선택된 사진을 꺼내서 UIImage로 변환
        if let image = info[.originalImage] as? UIImage {
            // SwiftUI 쪽에 이미지를 넘겨줌
            parent.didFinishPicking(image)
        }
        parent.presentationMode.wrappedValue.dismiss()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        parent.presentationMode.wrappedValue.dismiss()
    }
}
