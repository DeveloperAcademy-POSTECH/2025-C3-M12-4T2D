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
        VStack(alignment: .leading, spacing: 10) {
            // 스테이지 미리 준비
            HStack(alignment: .center, spacing: 8) {
//                if let stage = post.stage?.rawValue {
//                    Text(stage ?? "과정 없음")
//                        .font(.system(size: 24, weight: .bold))
//                }
                Text("채색(1)")
                    .font(.system(size: 19, weight: .bold))
                Spacer()
                // ... (더보기 버튼 등)
                Menu {
                    Button("편집", action: { /* 편집 액션 */ })
                    Button("삭제", role: .destructive, action: { /* 삭제 액션 */ })
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                        .padding(.trailing, 2)
                }
            }
            // 날짜
            Text(post.createdAt.formatted(date: .numeric, time: .shortened))
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 4)

            // 이미지
            if let imageUrl = post.postImageUrl {
                ImageView(image: imageUrl)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .padding(.horizontal, -20)
            }

            // 메모(설명)
            if let memo = post.memo, !memo.isEmpty {
                Text(memo)
                    .font(.body)
                    .padding(.top, 8)
            }

            LikeCommentBar()

        }
        .padding(.horizontal, 20)
    }
}

// #Preview {
//    ProjectView()
// }
