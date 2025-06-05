import SwiftUI

struct GridImageCard: View {
    let post: Post

    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .aspectRatio(1, contentMode: .fit)
            .overlay(
                // 못 불러왔을때의 기본이미지도 필요할듯
                Image(post.postImageUrl ?? "tmpImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            )
            .clipped()
    }
}
