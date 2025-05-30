import SwiftUI

struct GridImageCard: View {
    let image: String

    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(8)
            .overlay(
                Image("tmpImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(8) // 이것도 추가
            )
            .clipped()
    }
}
