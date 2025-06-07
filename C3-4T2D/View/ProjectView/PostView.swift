//
//  Project.swift
//  C3-4T2D
//
//  Created by 차원준 on 5/29/25.
//
import SwiftUI

struct PostView: View {
    let post: Post
    let project: Project
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(Router.self) private var router
    @State private var showDeleteAlert = false
    @State private var showEdit = false
    @State private var editImage: UIImage? = nil
    @State private var showCommentModal = false
    @State private var comments: [Comment] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // 스테이지 미리 준비
            HStack(alignment: .center, spacing: 8) {
                // 프로젝트 제목
                Text(project.projectTitle)
                    .font(.system(size: 19, weight: .bold))

                // 진행 단계
                Text(post.postStage.rawValue)
                    .font(.system(size: 11, weight: .medium))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(.prime4)
                    .foregroundColor(.gray3)
                    .cornerRadius(4)

                Spacer()
                // ... (더보기 버튼 등)
                Menu {
                    Button(action: {
                        // 이미지 파일이 있으면 미리 로드
                        if let imageUrl = post.postImageUrl, !imageUrl.isEmpty {
                            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(imageUrl)
                            if let data = try? Data(contentsOf: url), let uiImage = UIImage(data: data) {
                                editImage = uiImage
                            } else {
                                editImage = nil
                            }
                        } else {
                            editImage = nil
                        }
                        showEdit = true
                    }) {
                        HStack {
                            Image(systemName: "pencil")
                            Text("편집")
                        }
                    }
                    Button(role: .destructive, action: { showDeleteAlert = true }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("삭제")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 22))
                        .foregroundColor(.gray)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                        .padding(.trailing, -12)
                }
            }
            // 날짜
            Text(post.createdAt.formatted(date: .numeric, time: .shortened))
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 4)
                .padding(.top, -12)

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

            LikeCommentBar(commentCount: comments.count, onCommentTap: { showCommentModal = true })
                .sheet(isPresented: $showCommentModal, onDismiss: {
                    post.comments = comments
                    try? modelContext.save()
                }) {
                    CommentModal(comments: $comments)
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                }
        }
        .padding(.horizontal, 20)
        .alert("정말 삭제하시겠습니까?", isPresented: $showDeleteAlert) {
            Button("삭제", role: .destructive) {
                let isLastPost = post.project?.postList.count == 1
                Post.delete(post, context: modelContext)
                try? modelContext.save()
                if isLastPost {
                    router.navigateToRoot()
                }
            }
            Button("취소", role: .cancel) {}
        }
        .fullScreenCover(isPresented: $showEdit) {
            EditView(editingPost: post)
        }
        .onAppear {
            comments = post.comments
        }
    }
}

// #Preview {
//    PostView()
// }
