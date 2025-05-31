import SwiftUI

struct GridImageCard: View {
    let project: Project

    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(8)
            .overlay(
                // 못 불러왔을때의 기본이미지도 필요할듯
                Image(project.postList[project.postList.count - 1].postImageUrl ?? "tmpImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            )
            .clipped()
    }
}
