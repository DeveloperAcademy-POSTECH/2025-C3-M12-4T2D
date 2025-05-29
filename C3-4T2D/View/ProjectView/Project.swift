//
//  Project.swift
//  C3-4T2D
//
//  Created by 차원준 on 5/29/25.
//

import SwiftUI

struct Project: View {
    var body: some View {
        VStack(spacing: 10) { // 전체 그룹
            // 제목
            Title()
            // 사진
            ImageView()
            // Comment
            Comment()
        }
    }
}

// MARK: - Title

struct Title: View {
    var title: String = "스펀지밥과 콜라캔 - 채색(1)"
    var date: String = "2025.05.24 14:32pm"
    var body: some View {
        VStack(alignment: .leading, spacing: 5) { // 이미지 윗쪽 텍스트
            HStack {
                // 제목
                Text(title)

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

// MARK: - ImageView

struct ImageView: View {
    var image: String = "Image"

    var body: some View {
        Image(image)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
    }
}

// MARK: - Comment

struct Comment: View {
    @State private var isLiked: Bool = false
    @State private var isCommentModal: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                // 하트, 댓글
                Button(action: {
                    isLiked.toggle()
                }) {
                    isLiked ? Image(systemName: "heart.fill") : Image(systemName: "heart")
                }
                Button(action: {
                    isCommentModal.toggle()
                }) {
                    Image(systemName: "message")
                    Text("3")
                }
                Spacer()
            }
            TextView()
        }.padding(.horizontal)
            .sheet(isPresented: $isCommentModal) {
                CommentModal()
                    .presentationDetents([.medium, .large])
            }
    }
}

// MARK: - Text

struct TextView: View {
    var date: String = "05.21 14:32"
    var body: some View {
        // 피드백 내용
        Text("함께 걷고, 함께 웃고, 때론 아무 말 없이 시간을 보내는 그 순간들이 쌓여 지금의 우리를 만들었다는 생각이 든다.")
            .lineLimit(nil)
        // 날짜
        Text(date)
            .font(.caption2)
            .foregroundColor(Color.gray)
    }
}

// MARK: - CommentModal

struct CommentModal: View {
    var body: some View {
        Text("코멘트 창입니다.")
    }
}

#Preview {
    Project()
}
