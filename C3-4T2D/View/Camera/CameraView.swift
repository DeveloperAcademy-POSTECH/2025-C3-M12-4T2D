//
//  CameraView.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 6/2/25.
//

import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {
    
    // 사진 찍은 이미지를 SwiftUI 쪽에 넘겨주기 위한 콜백 클로저
    var didFinishPicking: (UIImage) -> Void
    // 카메라 닫을 때 환경 변수
    @Environment(\.presentationMode) var presentationMode

    // SwiftUI → UIKit 연결 시 실제 UIKit 카메라 컨트롤러를 생성
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        // 바로 촬영 모드 실행
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = context.coordinator
        return picker
    }
    
    // SwiftUI 뷰가 업데이트될 때 호출되지만, 지금은 특별히 처리할 일이 없어서 비워둠
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    // SwiftUI와 UIKit의 연결 고리 역할을 하는 Coordinator 객체 생성
    func makeCoordinator() -> CameraCoordinator {
        CameraCoordinator(parent: self)
    }
}
