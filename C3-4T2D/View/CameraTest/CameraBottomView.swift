//
//  CameraBottomView.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 6/1/25.
//


import SwiftUI

struct CameraBottomView: View {
    @ObservedObject var model: CameraDataModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .leading) {
            // 취소 버튼
            Button(action: {
                dismiss()
            }) {
                Text("취소")
                    .foregroundColor(.white)
            }

            HStack {
                Spacer()

                // 촬영 버튼
                Button(action: {
                    model.camera.takePhoto()
                }) {
                    Circle()
                        .stroke(lineWidth: 6)
                        .foregroundColor(.white)
                        .frame(width: 70, height: 70)
                        .overlay(
                            Circle()
                                .fill(Color.white)
                                .frame(width: 50, height: 50)
                        )
                }

                Spacer()
            }
        }
        .padding(.horizontal, 50)
        .padding(.bottom, 40)
    }
}

//#Preview {
//    CameraBottomView()
//}
