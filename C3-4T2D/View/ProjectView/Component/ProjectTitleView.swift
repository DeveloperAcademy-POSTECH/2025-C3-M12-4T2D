//
//  Title.swift
//  C3-4T2D
//
//  Created by 차원준 on 5/30/25.
//

import SwiftUI

struct ProjectTitleView: View {
    let title : String
    let date: String
    var body: some View {
        VStack(alignment: .leading, spacing: 5) { // 이미지 윗쪽 텍스트
            HStack {
                // 제목
                Text(title)
                    .bold(true)

                Spacer()
                // 더보기

                Menu {
                    Button(action: {}) {
                        Text("수정")
                    }
                    Button(action: {}) {
                        Text("삭제")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .frame(width: 30, height: 30)
                }
            }
            // 날짜
            Text(date)
                .font(.caption2)
                .foregroundColor(Color.gray)
        }
        .padding(.horizontal)
    }
}
