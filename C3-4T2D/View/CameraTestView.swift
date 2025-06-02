//
//  TestView.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 5/31/25.
//

import SwiftUI

struct CameraTestView: View {
    @State private var isPresentingCamera = false
    @State private var image: UIImage?

    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                isPresentingCamera = true
            }) {
                Text("test page")
            }
            Spacer()
        }
        .fullScreenCover(isPresented: $isPresentingCamera) {
            ZStack {
                Color.black.ignoresSafeArea() // Covers the system white edges
                CameraView { selectedImage in
                    self.image = selectedImage
                    isPresentingCamera = false
                }
            }
        }
    }
}

 #Preview {
    CameraTestView()
 }
