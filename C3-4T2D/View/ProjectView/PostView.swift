//
//  Project.swift
//  C3-4T2D
//
//  Created by 차원준 on 5/29/25.
//
import SwiftUI

struct PostView: View {
    let post: Post
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(Router.self) private var router
    @State private var showDeleteAlert = false

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
                    Button("편집", action: { /* 수정 액션: 비워둠 */ })
                    Button("삭제", role: .destructive, action: { showDeleteAlert = true })
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                        .contentShape(Rectangle())
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
                    .allowsHitTesting(false)
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
        .alert("정말 삭제하시겠습니까?", isPresented: $showDeleteAlert) {
            Button("삭제", role: .destructive) {
                let project = post.project
                modelContext.delete(post)
                try? modelContext.save()
                if let project = project, (project.postList.count == 0) {
                    // 포스트가 0개면 메인으로 이동
                    router.navigateToRoot()
                } // else: 리스트에 남아있음 (dismiss 호출 안 함)
            }
            Button("취소", role: .cancel) {}
        }
    }
}

// #Preview {
//    ProjectView()
// }
