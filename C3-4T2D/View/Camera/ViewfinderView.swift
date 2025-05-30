//
//  ViewfinderView.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 5/29/25.
//

import SwiftUI

struct ViewfinderView: View {
    @Binding var image: Image?

    var body: some View {
        GeometryReader { geometry in
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
//                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .frame(width: geometry.size.width, height: geometry.size.width * 4 / 3)
            }
        }
    }
}

#Preview {
    ViewfinderView(image: .constant(Image(systemName: "pencil")))
}
