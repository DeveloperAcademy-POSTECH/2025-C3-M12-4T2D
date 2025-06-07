//
//  Comment.swift
//  C3-4T2D
//
//  Created by 차원준 on 5/30/25.
//

import SwiftUI

struct LikeCommentBar: View {
    var commentCount: Int
    var onCommentTap: () -> Void
    @State private var isLiked: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                isLiked.toggle()
            }) {
                (isLiked ? Image(systemName: "heart.fill") : Image(systemName: "heart"))
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.gray)
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
