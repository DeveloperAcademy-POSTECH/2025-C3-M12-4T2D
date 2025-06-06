//
//  Comment.swift
//  C3-4T2D
//
//  Created by 차원준 on 5/30/25.
//

import SwiftUI

struct LikeCommentBar: View {
    @State private var isLiked: Bool = false
    @State private var isCommentModal: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                // 하트, 댓글
                Button(action: {
                    isLiked.toggle()
                }) {
                    (isLiked ? Image(systemName: "heart.fill") : Image(systemName: "heart"))
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.gray)
                }
                Button(action: {
                    isCommentModal.toggle()
                }) {
                    Image("comment")
                    Text("3")
                        .foregroundColor(.gray)
                }
                Spacer()
            }
        }
            .sheet(isPresented: $isCommentModal) {
                CommentModal()
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
    }
}
