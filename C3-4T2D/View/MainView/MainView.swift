import SwiftUI

struct MainView: View {
    private let dummyData = DummyData()

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Header()

                // BANNER
                VStack {
                    HStack { // 진행중 프로젝트 섹션
                        VStack(alignment: .leading) {
                            Text(dummyData.currentProject.projectTitle).font(.system(size: 17, weight: .bold))
                            Text("2025.05.24 ~ 2025.07.02").font(.system(size: 11, weight: .regular))
                        }
                        Spacer()
                        Image(systemName: "ellipsis").foregroundColor(.gray).font(.system(size: 24))
                    }.padding(.vertical, 12)
                        .padding(.trailing, 20)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(dummyData.currentProject.postList) { post in
                                ImageCard(image: post.postImageUrl ?? "")
                            }
                        }
                        .padding(.trailing, 20) // 마지막에만 오른쪽 여백 추가
                    }
                }.padding(.leading, 20)
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
                            Button {
                                print("전체보기")
                            } label: {
                                Image(systemName:
                                    "rectangle.grid.1x2.fill").tint(Color.gray)
                            }
                            Button {
                                print("전체보기")
                            } label: {
                                Image(systemName: "rectangle.grid.2x2.fill").tint(Color.gray)
                            }
                            Button {
                                print("전체보기")
                            } label: {
                                Image(systemName: "rectangle.grid.2x2.fill").tint(Color.yellow)
                            }
                        }
                    }.padding(.horizontal, 20)
                        .padding(.bottom, 16)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                        ForEach(dummyData.allPosts) { post in
                            GridImageCard(image: post.postImageUrl ?? "")
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
