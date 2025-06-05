//
//  Project.swift
//  C3-4T2D
//
//  Created by 차원준 on 5/29/25.
//
import SwiftUI

struct PostView: View {
    let post: Post

    var body: some View {
        VStack(spacing: 10) {
            // 제목
            ProjectTitleView(
                title: post.memo ?? "새 포스트",
                date: post.createdAt.formatted(date: .abbreviated, time: .shortened)
            )
            // 이미지, 있을 때만 !
            if let imageUrl = post.postImageUrl {
                ImageView(image: imageUrl)
            }
            LikeCommentBar()
        }
    }
}

// #Preview {
//    ProjectView()
// }
