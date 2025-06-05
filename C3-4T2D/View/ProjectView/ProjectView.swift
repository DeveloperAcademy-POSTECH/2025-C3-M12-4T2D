//
//  Project.swift
//  C3-4T2D
//
//  Created by 차원준 on 5/29/25.
//

import SwiftUI

struct ProjectView: View {
    var body: some View {
        VStack(spacing: 10) { // 전체 그룹
            // 제목
            ProjectTitleView(title: "스펀지밥과 콜라켄 - 채색(1)", date: "2025.05.24 14:32pm")
            // 사진
            ImageView(image: "Image")
            // Comment
            LikeCommentBar()
        }
    }
}

#Preview {
    ProjectView()
}
