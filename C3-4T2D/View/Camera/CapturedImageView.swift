//
//  CapturedImageView.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 5/29/25.
//

import SwiftUI

struct CapturedImageView: View {
    let image: Image
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            image
                .resizable()
                .scaledToFit()
                .padding()

            VStack {
                Spacer()
                Button("닫기", action: onDismiss)
                    .padding()
                    .background(.white)
                    .foregroundColor(.black)
                    .clipShape(Capsule())
            }
        }
    }
}

// #Preview {
//    CapturedImageView()
// }
