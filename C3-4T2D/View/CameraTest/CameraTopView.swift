//
//  CameraTopView.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 6/1/25.
//

import SwiftUI

struct CameraTopView: View {
    @ObservedObject var model: CameraDataModel

    var body: some View {
        HStack {
            Button(action: {
                model.toggleFlash()
            }) {
                Image(systemName: model.isFlashOn ? "bolt.fill" : "bolt.slash")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .clipShape(Circle())
            }
            Spacer()
        }
        .padding(.bottom, 32)
        .padding(.horizontal, 20)
    }
}
//
//#Preview {
//    CameraTopView()
//}
