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
        HStack(spacing: 11) {
            Button(action: {
                post.like.toggle()
                try? modelContext.save()
            }) {
                (post.like ? Image("like_on") : Image("like_off"))
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(post.like ? .red : .gray)
            }
            Button(action: {
                onCommentTap()
            }) {
                HStackLayout(spacing: 5) {
                    Image("comment")
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("\(commentCount)")
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                        .foregroundColor(.gray3)
                }
            }
            Spacer()
        }
    }
}
