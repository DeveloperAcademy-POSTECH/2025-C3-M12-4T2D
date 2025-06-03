//
//  PhototEditView.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 6/3/25.
//

import SwiftUI

struct PhototEditView: View {
    let image: UIImage

    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .padding()

            // 여기에 편집 기능 넣기 (예: 자르기, 텍스트 추가 등)
            Text("여기서 편집 가능!")
        }
    }
}

//#Preview {
//    PhototEditView()
//}
