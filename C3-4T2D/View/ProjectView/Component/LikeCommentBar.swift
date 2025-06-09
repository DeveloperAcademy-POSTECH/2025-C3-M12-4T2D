//
//  Comment.swift
//  C3-4T2D
//
//  Created by 차원준 on 5/30/25.
//

import SwiftData
import SwiftUI

struct LikeCommentBar: View {
    let post: Post
    var commentCount: Int
    var onCommentTap: () -> Void
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                post.like.toggle()
                try? modelContext.save()
            }) {
                (post.like ? Image(systemName: "heart.fill") : Image(systemName: "heart"))
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(post.like ? .red : .gray)
            }
            Button(action: {
                onCommentTap()
            }) {
                Image("comment")
                Text("\(commentCount)")
                    .foregroundColor(.gray)
            }
            Spacer()
        }
    }
}
