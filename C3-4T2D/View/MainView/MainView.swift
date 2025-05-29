import SwiftUI

struct MainView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Header()

                // BANNER
                VStack {
                    HStack { // 진행중 프로젝트 섹션
                        VStack(alignment: .leading) {
                            Text("미래적인 잠자리").font(.system(size: 17, weight: .bold))
                            Text("2025.05.24 ~ 2025.07.02").font(.system(size: 11, weight: .regular))
                        }
                        Spacer()
                        Image(systemName: "ellipsis").foregroundColor(.gray).font(.system(size: 24))
                    }.padding(.vertical, 12)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ImageCard()
                            ImageCard()
                            ImageCard()
                        }
                    }
                }.padding(.horizontal, 20)
                    .padding(.bottom, 30)

                Divider()
                    .overlay(
                        Rectangle()
                            .fill(Color.gray)
                            .frame(height: 12)
                    )

                // 전체 프로젝트 섹션
                VStack {
                    HStack {
                        HStack {
                            Text("전체보기").font(.system(size: 17, weight: .semibold))
                            Image(systemName: "chevron.down")
                        }
                        Spacer()
                        HStack(spacing: 16) {
                            Image(systemName: "rectangle.grid.2x2.fill")
                            Image(systemName: "rectangle.grid.2x2.fill")
                            Image(systemName: "rectangle.grid.1x2.fill")
                        }
                    }.padding(.horizontal, 20)
                        .padding(.bottom, 16)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                        // MARK: 나중에 배열의 길이에 따라 반복문이 돌아갈 예정  지금은 여러개 보이게 15개로 고정

                        ForEach(0 ..< 15, id: \.self) { index in // 더 많은 아이템으로 변경
                            GridImageCard(index: index)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 20)
            }
        }
    }
}

#Preview {
    MainView()
}
