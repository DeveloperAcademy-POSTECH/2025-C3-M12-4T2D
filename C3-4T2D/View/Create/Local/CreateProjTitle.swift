//
//  CreateProjTitle.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 5/30/25.
//

import SwiftUI

struct CreateProjTitle: View {
    @Binding var projTitle: String
    @Binding var showProjectSelector: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                showProjectSelector = true
            }) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("프로젝트명")
                        .font(.title3.weight(.bold))
                        .foregroundColor(.black)

                    HStack {
                        Text(projTitle.isEmpty ? "프로젝트명을 선택해주세요" : projTitle)
                            .font(.system(size: 15))
                            .foregroundColor(projTitle.isEmpty ? .gray : .black)

                        Spacer()

                        Image(systemName: "chevron.right")
                            .foregroundColor(.black)
                            .padding(.trailing, 8)
                    }

                    Divider()
                        .background(Color.gray)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
