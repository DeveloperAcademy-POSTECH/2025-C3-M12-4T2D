//
//  CameraView.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 5/29/25.
//

import SwiftUI

struct UUCameraView: View {
    @StateObject private var model = CameraDataModel()

    @State private var isShowingPreview = false
    @State private var capturedImage: Image?
    @State private var isShowingCapturedImage = false

    var body: some View {
        ZStack {
            Color.green.ignoresSafeArea()

            VStack {
                CameraTopView(model: model)

                Spacer()

                GeometryReader { geometry in
                    let width = geometry.size.width
                    let height = width * 4 / 3

                    ViewfinderView(image: $model.viewfinderImage)
                        .frame(width: width, height: height)
                        .clipped()
//                        .cornerRadius(12)
//                        .padding(.horizontal)

//                GeometryReader { geometry in
//                    let width = geometry.size.width
//                    let height = width * 4 / 3
//
//                    Rectangle()
//                        .fill(Color.blue)
//                        .frame(width: width, height: height)
//                        .overlay(
//                            Text("카메라 미리보기 뷰 자리")
//                                .foregroundColor(.white)
//                                .bold()
//                        )
                }

                Spacer()

                CameraBottomView(model: model)
            }
        }
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


#Preview {
    UUCameraView()
}
