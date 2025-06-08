//
//  CameraCoordinator.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 6/2/25.
//

import UIKit

/// CameraView용 코디네이터 (현재는 CameraEditView를 주로 사용)
class CameraCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let parent: CameraView

    init(parent: CameraView) {
        self.parent = parent
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let originalImage = info[.originalImage] as? UIImage {
            DispatchQueue.main.async {
                self.parent.didFinishPicking(originalImage)
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        DispatchQueue.main.async {
            self.parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
