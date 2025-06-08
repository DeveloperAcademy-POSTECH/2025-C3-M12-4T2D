//
//  CameraEditView.swift
//  C3-4T2D
//
//  Created by  bishoe on 6/8/25.
//

import SwiftUI

///  iOS 기본 카메라 →   즉시 편집으로 연결하는 통합 뷰
struct CameraEditView: View {
    @Environment(\.dismiss) private var dismiss
    
    // 상태 관리
    @State private var currentStep: ViewStep = .camera
    @State private var capturedImage: UIImage?
    @State private var showImagePicker = true
    
    // 콜백
    let onComplete: (UIImage?) -> Void
    
    enum ViewStep {
        case camera
        case editing
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            switch currentStep {
            case .camera:
                cameraStep
            case .editing:
                editingStep
            }
        }
    }
    
    private var cameraStep: some View {
        Group {
            if showImagePicker {
                Color.clear
                    .sheet(isPresented: $showImagePicker) {
                        ImagePickerView { image in
                            handleCameraResult(image)
                        }
                    }
            } else {
                // 촬영 완료 후 편집 준비 중 - 간단한 로딩
                VStack(spacing: 20) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.2)
                    
                    Text("편집 준비 중...")
                        .foregroundColor(.white)
                        .font(.headline)
                }
            }
        }
        .onAppear {
            print("  카메라 단계 시작")
        }
    }
    
    // MARK: -   편집 단계

    private var editingStep: some View {
        Group {
            if let image = capturedImage {
                CropView(
                    image: image,
                    configuration: CropConfiguration(
                        rotateImage: true,
                        rectAspectRatio: 5.0 / 4.0,
                        texts: CropConfiguration.Texts(
                            cancelButton: "다시 촬영",
                            saveButton: "완료"
                        ),
                        colors: CropConfiguration.Colors(
                            cancelButton: .white,
                            saveButton: .white,
                            background: .black
                        )
                    )
                ) { editedImage in
                    handleEditComplete(editedImage)
                }
            } else {
                // 이미지가 없으면 카메라로 돌아가기
                Color.clear
                    .onAppear {
                        print("⚠️ 편집할 이미지가 없어서 카메라로 돌아갑니다")
                        resetToCamera()
                    }
            }
        }
        .onAppear {
            print("  편집 단계 시작")
        }
    }
    
    // MARK: - 🛠 Helper Methods

    private func handleCameraResult(_ image: UIImage?) {
        if let image = image {
            print("사진 촬영 완료: \(image.size)")
            capturedImage = image
            showImagePicker = false
            
            //   즉시 편집 단계로 전환 (딜레이 최소화)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                currentStep = .editing
            }
        } else {
            print("카메라 취소됨")
            onComplete(nil)
            dismiss()
        }
    }
    
    private func handleEditComplete(_ editedImage: UIImage?) {
        if let editedImage = editedImage {
            print("편집 완료: \(editedImage.size)")
            
            //   즉시 콜백 호출하고 dismiss (깜빡임 방지)
            onComplete(editedImage)
            dismiss()
        } else {
            print("다시 촬영 요청")
            resetToCamera()
        }
    }
    
    private func resetToCamera() {
        capturedImage = nil
        currentStep = .camera
        showImagePicker = true
    }
}

// MARK: - ImagePickerView (iOS 기본 카메라 래퍼)

struct ImagePickerView: UIViewControllerRepresentable {
    let onImageSelected: (UIImage?) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = false //   중간 편집 화면 제거
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickerView
        
        init(parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            //   원본 이미지만 가져옴 (편집 화면 건너뛰기)
            let image = info[.originalImage] as? UIImage
            parent.onImageSelected(image)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.onImageSelected(nil)
        }
    }
}

#Preview {
    CameraEditView { image in
        if let image = image {
            print("   최종 완료: \(image.size)")
        } else {
            print("    최종 취소")
        }
    }
}
