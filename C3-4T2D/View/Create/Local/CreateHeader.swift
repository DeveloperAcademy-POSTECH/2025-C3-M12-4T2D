//
//  CreateHeader.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 5/29/25.
//

import SwiftUI

struct CreateHeader: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        HStack() {
            Button(action: {
                dismiss() // 창 닫기
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                    .frame(width: 60, alignment: .leading)
            }

            Spacer()

            Text("과정 기록하기")
                .font(.title3.weight(.bold))
                .foregroundColor(.black)

            Spacer()

            Button(action: {
                // 임시저장 동작
            }) {
                Text("임시저장")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .frame(width: 60, alignment: .leading)
            }
        }
        .padding(.top, 16)
        .padding(.bottom, 12)

    }
}

#Preview {
    CreateHeader()
}
