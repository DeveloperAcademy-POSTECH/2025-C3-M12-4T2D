//
//  ImageView.swift
//  C3-4T2D
//
//  Created by 차원준 on 5/30/25.
//

import SwiftUI

struct ImageView: View {
    var image: String = "Image"

    var body: some View {
//        Rectangle()
        Image(image)
            .resizable()
            .frame(width: .infinity, height: 300)
//            .border(Color.gray)

//        UIScreen.main.bounds.width
    }
}
