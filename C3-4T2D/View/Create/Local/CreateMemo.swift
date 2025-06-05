//
//  CreateMemo.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 5/30/25.
//

import SwiftUI

struct CreateMemo: View {
    @Binding var descriptionText: String
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text("과정에 관한 설명")
                .font(.title3.weight(.bold))
                .foregroundColor(.black)
                .padding(.bottom, 8)

            ZStack(alignment: .topLeading) {
                if descriptionText.isEmpty && !isFocused {
                    Text("과정에 대하여 남기고 싶은 내용이 있으면 적어주세요")
                        .foregroundColor(.gray)
                        .padding(.top, 12)
                        .padding(.leading, 8)
                        .font(.system(size: 15))
                }

                TextEditor(text: $descriptionText)
                    .focused($isFocused)
                    .padding(8)
                    .font(.system(size: 15))
                    .scrollContentBackground(.hidden)
                    .scrollDisabled(true)
                    .frame(minHeight: 200, maxHeight: 300)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
            }
        }
//        .padding(.vertical, 16)
    }
}
