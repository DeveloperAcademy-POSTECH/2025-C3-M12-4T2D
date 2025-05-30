//
//  CameraView.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 5/29/25.
//

import SwiftUI

struct CameraView: View {
    @StateObject private var model = CameraDataModel()
    @Environment(\.dismiss) private var dismiss

    @State private var isShowingCapturedImage = false
    @State private var capturedImage: Image?

    private static let barHeightFactor = 0.15

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 미리보기 뷰
                ViewfinderView(image: $model.viewfinderImage)
                    .background(Color.black)

                // 상단 바 (플래시)
                VStack {
                    HStack {
                        Button(action: {
                            model.toggleFlash()
                        }) {
                            Image(systemName: model.isFlashOn ? "bolt.fill" : "bolt.slash")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .bold))
                                .padding()
                        }

                        Spacer()
                    }
                    .frame(height: geometry.size.height * Self.barHeightFactor)
                    .background(Color.black.opacity(0.75))

                    Spacer()
                }

                // 하단 바 (취소, 촬영)
                VStack {
                    Spacer()

                    HStack {
                        // 취소 버튼
                        Button("취소") {
                            dismiss()
                        }
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.white)

                        Spacer()

                        // 촬영 버튼
                        Button {
                            model.camera.takePhoto()
                        } label: {
                            ZStack {
                                Circle().strokeBorder(.white, lineWidth: 3).frame(width: 62, height: 62)
                                Circle().fill(.white).frame(width: 50, height: 50)
                            }
                        }

                        Spacer()
                    }
                    .padding(.horizontal, 32)
                    .frame(height: geometry.size.height * Self.barHeightFactor)
                    .background(Color.black.opacity(0.75))
                }
            }
            .ignoresSafeArea()
            .task {
                await model.camera.start()
                model.onPhotoCaptured = { image in
                    capturedImage = image
                    isShowingCapturedImage = true
                }
            }
            .fullScreenCover(isPresented: $isShowingCapturedImage) {
                if let image = capturedImage {
                    CapturedImageView(image: image) {
                        isShowingCapturedImage = false
                    }
                }
            }
        }
    }
}

#Preview {
    CameraView()
}
