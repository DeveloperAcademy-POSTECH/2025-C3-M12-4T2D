//
//  CreateProjTitleView.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 5/30/25.
//

import SwiftUI

struct CreateProjTitleView: View {
    @Binding var projectName: String
    @Binding var showProjectSelector: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 프로젝트명 제목 + 화살표
            Button(action: {
                showProjectSelector = true
            }) {
                HStack {
                    Text("프로젝트명")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.black)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundColor(.black)
                }
            }

            // 텍스트 필드
            TextField("프로젝트명을 적어주세요", text: $projectName)
                .font(.system(size: 14))
                .submitLabel(.done)
                .padding(.vertical, 8)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray),
                    alignment: .bottom
                )
        }
    }
}
