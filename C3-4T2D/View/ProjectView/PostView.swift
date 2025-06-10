//
//  Project.swift
//  C3-4T2D
//
//  Created by 차원준 on 5/29/25.
//
import SwiftUI

struct EnableSwipeBackGesture: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        DispatchQueue.main.async {
            if let navigationController = controller.navigationController {
                navigationController.interactivePopGestureRecognizer?.isEnabled = true
                navigationController.interactivePopGestureRecognizer?.delegate = nil
            }
        }
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

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
    @State private var showHeart = false
    @State private var heartAnim = false

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
            Text(DateFormatter.timestampFormatter.string(from: post.createdAt))
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 4)
                .padding(.top, -12)

            // 이미지
            if let imageUrl = post.postImageUrl {
                ZStack {
                    ImageView(image: imageUrl)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .padding(.horizontal, -20)
                        .onTapGesture(count: 2) {
                            if post.like == false {
                                post.like = true
                            }
                            try? modelContext.save()
                            heartAnim = false
                            showHeart = true
                            // 애니메이션 시작
                            withAnimation(.easeOut(duration: 0.2)) {
                                heartAnim = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                withAnimation(.easeIn(duration: 0.5)) {
                                    showHeart = false
                                    heartAnim = false
                                }
                            }
                        }
                    if showHeart {
                        GeometryReader { geo in
                            Image(systemName: "heart.fill")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 80, height: 80)
                                .opacity(heartAnim ? 0 : 0.85)
                                .offset(
                                    x: heartAnim ? -geo.size.width/2 + 60 : 0, // 좌측 하단으로 이동
                                    y: heartAnim ? geo.size.height/2 - 60 : 0
                                )
                                .position(x: geo.size.width/2, y: geo.size.height/2)
                        }
                        .allowsHitTesting(false)
                    }
                }
            }

            // 메모(설명)
            if let memo = post.memo, !memo.isEmpty {
                Text(memo)
                    .font(.body)
                    .padding(.top, 8)
            }

            LikeCommentBar(post: post, commentCount: comments.count, onCommentTap: { showCommentModal = true })
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
        .background(
            EnableSwipeBackGesture()
                .frame(width: 0, height: 0)
        )
    }
}

// #Preview {
//    PostView()
// }
