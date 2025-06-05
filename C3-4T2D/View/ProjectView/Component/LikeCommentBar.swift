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
                    .presentationDragIndicator(.visible)
            }
    }
}
