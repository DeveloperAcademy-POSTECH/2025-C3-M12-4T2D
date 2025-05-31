//
//  CameraView.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 5/29/25.
//

import SwiftUI

struct CameraView: View {
    @StateObject private var model = CameraDataModel()

    @State private var isShowingCapturedImage = false
    @State private var capturedImage: Image?

    private static let barHeightFactor = 0.15

    var body: some View {
        GeometryReader { geometry in
            ViewfinderView(image: $model.viewfinderImage )
                .overlay(alignment: .top) {
                    Color.black
                        .opacity(0.75)
                        .frame(height: geometry.size.height * Self.barHeightFactor)
                }
                .overlay(alignment: .bottom) {
                    buttonsView()
                        .frame(height: geometry.size.height * Self.barHeightFactor)
                        .background(.black.opacity(0.75))
                }
                .overlay(alignment: .center) {
                    Color.clear
                        .frame(height: geometry.size.height * (1 - (Self.barHeightFactor * 2)))
                        .accessibilityElement()
                        .accessibilityLabel("View Finder")
                        .accessibilityAddTraits([.isImage])
                }
                .background(.black)
                .task {
                    await model.camera.start()
//                    await model.loadPhotos()
//                    await model.loadThumbnail()

                    // 사진 촬영 후 이미지 받아서 표시
                    model.onPhotoCaptured = { image in
                        capturedImage = image
                        isShowingCapturedImage = true
                    }
                }
                // 촬영한 이미지 전체 화면으로 표시
                .fullScreenCover(isPresented: $isShowingCapturedImage) {
                    if let image = capturedImage {
                        CapturedImageView(image: image) {
                            isShowingCapturedImage = false
                        }
                    }
                }
        }
        .ignoresSafeArea()
    }

    private func buttonsView() -> some View {
        HStack(spacing: 60) {
            Spacer()

            // 촬영 버튼
            Button {
                model.camera.takePhoto()
            } label: {
                Label {
                    Text("Take Photo")
                } icon: {
                    ZStack {
                        Circle().strokeBorder(.white, lineWidth: 3).frame(width: 62, height: 62)
                        Circle().fill(.white).frame(width: 50, height: 50)
                    }
                }
            }

            // 전면/후면 카메라 전환
            Button {
                model.camera.switchCaptureDevice()
            } label: {
                Label("Switch Camera", systemImage: "arrow.triangle.2.circlepath")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
            }

            Spacer()
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding()
    }
}

#Preview {
    CameraView()
}
