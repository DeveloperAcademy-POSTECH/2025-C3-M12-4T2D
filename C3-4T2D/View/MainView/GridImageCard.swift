import SwiftUI

struct GridImageCard: View {
    let index: Int

    var body: some View {
        // Rectangle -> 이미지로 변환 예정
        Rectangle()
            .foregroundColor(.gray.opacity(0.3))
            .aspectRatio(1, contentMode: .fit) // 정사각형
            .cornerRadius(8)
            .overlay(
                VStack {
                    Spacer()
                    HStack {
                        Text("그림 제목!")
                            .font(.system(size: 11, weight: .semibold))
                    }

                    .padding(.bottom, 8)
                }
            )
    }
}
