import SwiftUI

struct MainView: View {
    private let dummyData = DummyData()
    @State private var selectedTabIndex: Int = 0
    @State private var sortOrder: SortOrder = .newest

    // MARK: 최신순일때의 프로젝트는 항상 진행중이 맨위? 아니면 이전프로젝트 수정을 했으면 가장 마지막에 추가된 글을 기준으로 판단 ??

    var sortedProjects: [Project] {
        sortOrder.sort(projects: dummyData.allProjects)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Header()

                // BANNER
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("진행중인 과정").font(.system(size: 22, weight: .bold)).padding(.bottom, 8)
                            Text(dummyData.currentProject.projectTitle).font(.system(size: 19, weight: .bold))
                            HStack {
                                Text(DateFormatter.projectDateRange(
                                    startDate: dummyData.currentProject.postList.compactMap { $0.createdAt }.min() ?? Date(),
                                    endDate: dummyData.currentProject.finishedAt
                                ))
                                .font(.system(size: 11, weight: .regular))
                                .foregroundColor(.gray)

                                Text(dummyData.currentProject.finishedAt == nil ? "진행중" : "완료")
                                    .font(.system(size: 11, weight: .medium))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(dummyData.currentProject.finishedAt == nil ? Color.green.opacity(0.2) : Color.gray.opacity(0.2))
                                    .foregroundColor(dummyData.currentProject.finishedAt == nil ? .green : .gray)
                                    .cornerRadius(4)
                            }
                        }
                        Spacer()
                        Image(systemName: "plus").foregroundColor(.gray).font(.system(size: 24))
                    }.padding(.vertical, 12)
                        .padding(.trailing, 20)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(dummyData.currentProject.postList) { post in
                                ImageCard(image: post.postImageUrl ?? "")
                            }
                        }
                        .padding(.trailing, 20)
                    }
                }.padding(.leading, 20)
                    .padding(.bottom, 30)

                Divider()
                    .overlay(
                        Rectangle()
                            .fill(Color.gray)
                            .frame(height: 12)
                    )

                // MARK: 전체 프로젝트 (탭 섹션)

                VStack {
                    HStack {
                        Menu {
                            ForEach(SortOrder.allCases, id: \.self) { order in
                                Button(order.rawValue) {
                                    sortOrder = order
                                }
                            }
                        } label: {
                            HStack {
                                Text(sortOrder.rawValue).font(.system(size: 17, weight: .semibold))
                                Image(systemName: "chevron.down")
                            }
                        }
                        .foregroundColor(.black)
                        Spacer()
                        HStack(spacing: 16) {
                            ForEach(TabType.allCases, id: \.self) { tab in
                                Button {
                                    selectedTabIndex = tab.rawValue
                                } label: {
                                    Image(tab.imageName(isSelected: selectedTabIndex == tab.rawValue))
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                }
                            }
                        }
                    }.padding(.horizontal, 20)
                        .padding(.bottom, 20)

                    // 탭에 따른 레이아웃 변화
                    Group {
                        switch selectedTabIndex {
                        case 0: // 프로젝트별 스크롤뷰
                            LazyVStack(spacing: 20) {
                                ForEach(sortedProjects) { project in
                                    ProjectSectionCard(project: project)
                                }
                            }.padding(.leading, 20)
                        case 1: // 리스트뷰
                            LazyVStack(spacing: 16) {
                                ForEach(sortedProjects) { project in
                                    PostListCard(project: project)
                                }
                            }
                            .padding(.horizontal, 20)
                        case 2: // 3x3 그리드뷰
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                                ForEach(sortedProjects) { project in
                                    GridImageCard(project: project)
                                }
                            }.padding(.horizontal, 20)
                        default:
                            EmptyView()
                        }
                    }
                }
                .padding(.vertical, 20)
            }
        }
    }
}

#Preview {
    MainView()
}
