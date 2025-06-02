//
//  CameraCoordinator.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 6/2/25.
//

import UIKit

class CameraCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let parent: CameraView

    init(parent: CameraView) {
        self.parent = parent
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            parent.didFinishPicking(image)
        }
        parent.presentationMode.wrappedValue.dismiss()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        parent.presentationMode.wrappedValue.dismiss()
    }
}
