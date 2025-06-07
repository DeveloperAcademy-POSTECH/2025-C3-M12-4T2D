//
//  ImageView.swift
//  C3-4T2D
//
//  Created by 차원준 on 5/30/25.
//

import SwiftUI

struct ImageView: View {
    let image: String

    var body: some View {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(image),
           let data = try? Data(contentsOf: url),
           let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: 300)
                .clipped()
        } else {
            Rectangle()
                .foregroundColor(.gray.opacity(0.3))
                .frame(maxWidth: .infinity, maxHeight: 300)
        }
    }
}
