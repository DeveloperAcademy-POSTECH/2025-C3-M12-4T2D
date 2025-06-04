import SwiftData
import SwiftUI

struct MainView: View {
    @Environment(Router.self) private var router
    @Environment(\.modelContext) private var modelContext

    @Query private var allProjects: [Project]
    @Query private var users: [User]
    // 현재 진행중인 프로젝트, 어처피 0 or 1 (있거나 없거나지 여러개가 아님)
    @Query(SwiftDataManager.currentProject) private var getCurrentProject: [Project]

    @State private var selectedTabIndex: Int = 0
    @State private var sortOrder: SortOrder = .newest

    var sortedProjects: [Project] {
        sortOrder.sort(projects: allProjects)
    }

    var currentProject: Project? { getCurrentProject.first }
    var currentUser: User? { users.first }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                MainHeader(user: currentUser)
                Divider()
                // BANNER
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("진행중인 과정").font(.system(size: 22, weight: .bold))

                            if let current = currentProject {
                                Text(current.projectTitle).font(.system(size: 19, weight: .bold))
                                HStack {
                                    Text(DateFormatter.projectDateRange(
                                        startDate: current.postList.compactMap { $0.createdAt }.min() ?? Date(),
                                        endDate: current.finishedAt
                                    ))
                                    .font(.system(size: 11, weight: .regular))
                                    .foregroundColor(.gray)

                                    Text(current.finishedAt == nil ? "진행중" : "완료")
                                        .font(.system(size: 11, weight: .medium))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 2)
                                        .background(current.finishedAt == nil ? Color.green.opacity(0.2) : Color.gray.opacity(0.2))
                                        .foregroundColor(current.finishedAt == nil ? .green : .gray)
                                        .cornerRadius(4)
                                }
                            } else {
                                Text("진행중인 프로젝트가 없습니다")
                                    .font(.system(size: 19, weight: .bold))
                                    .foregroundColor(.gray)
                            }
                        }
                        Spacer()
                        Image(systemName: "plus").foregroundColor(.gray).font(.system(size: 24))
                    }.padding(.vertical, 15)
                        .padding(.trailing, 20)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            if let current = currentProject {
                                ForEach(current.postList) { post in
                                    ImageCard(image: post.postImageUrl ?? "")
                                }
                            } else {
                                Text("진행중인 프로젝트를 생성해주세요")
                                    .foregroundColor(.gray)
                                    .padding()
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
                                Text(sortOrder.rawValue).font(.system(size: 22, weight: .semibold))

                                Image(systemName: "chevron.down").font(.system(size: 22, weight: .semibold))
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
        .onAppear {
            // MARK: 한번만 실행시키고 주석처리해주시면 됩니다 !

//            DummyDataManager.createDummyData(context: modelContext, projects: allProjects)
//            이거는 테스트할때만! swiftData초기화를 위해서 사용합니다.
//            SwiftDataManager.deleteAllData(context: modelContext)
        }
    }
}

#Preview {
    ContentView()
}
