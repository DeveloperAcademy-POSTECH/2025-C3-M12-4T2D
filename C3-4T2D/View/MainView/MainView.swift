import SwiftUI

struct MainView: View {
    private let dummyData = DummyData()
    @State private var selectedTabIndex: Int = 0
    @State private var sortOrder: SortOrder = .newest

    enum SortOrder: String, CaseIterable {
        case newest = "최신순"
        case oldest = "오래된순"
    }

    // MARK: 최신순일때의 프로젝트는 항상 진행중이 맨위? 아니면 이전프로젝트 수정을 했으면 가장 마지막에 추가된 글을 기준으로 판단 ??

    var sortedProjects: [Project] {
        switch sortOrder {
        case .newest:
            return dummyData.allProjects.sorted { first, second in
                let firstLatest = first.postList.compactMap { $0.createdAt }.max() ?? Date.distantPast
                let secondLatest = second.postList.compactMap { $0.createdAt }.max() ?? Date.distantPast
                return firstLatest > secondLatest
            }
        case .oldest:
            return dummyData.allProjects.sorted { first, second in
                let firstEarliest = first.postList.compactMap { $0.createdAt }.min() ?? Date.distantFuture
                let secondEarliest = second.postList.compactMap { $0.createdAt }.min() ?? Date.distantFuture
                return firstEarliest < secondEarliest
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Header()

                // BANNER
                VStack {
                    HStack {
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
                            Button {
                                selectedTabIndex = 0
                            } label: {
                                Image(systemName: "rectangle.grid.1x2.fill")
                                    .tint(selectedTabIndex == 0 ? .yellow : .gray)
                            }
                            Button {
                                selectedTabIndex = 1
                            } label: {
                                Image(systemName: "rectangle.grid.2x2.fill")
                                    .tint(selectedTabIndex == 1 ? .yellow : .gray)
                            }
                            Button {
                                selectedTabIndex = 2
                            } label: {
                                Image(systemName: "rectangle.grid.3x3.fill")
                                    .tint(selectedTabIndex == 2 ? .yellow : .gray)
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

private func formatDateRange(startDate: Date, endDate: Date?) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM.dd"

    if let endDate = endDate {
        return "\(formatter.string(from: startDate)) ~ \(formatter.string(from: endDate))"
    } else {
        return "\(formatter.string(from: startDate)) ~"
    }
}

// 프로젝트 스크롤뷰
struct ProjectSectionCard: View {
    let project: Project

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(project.projectTitle)
                        .font(.system(size: 19, weight: .bold))

                    HStack {
                        Text(formatDateRange(
                            startDate: project.postList.compactMap { $0.createdAt }.min() ?? Date(),
                            endDate: project.finishedAt
                        ))
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.gray)

                        Text(project.finishedAt == nil ? "진행중" : "완료")
                            .font(.system(size: 11, weight: .medium))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(project.finishedAt == nil ? Color.green.opacity(0.2) : Color.gray.opacity(0.2))
                            .foregroundColor(project.finishedAt == nil ? .green : .gray)
                            .cornerRadius(4)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 20, weight: .bold))
            }.padding(.trailing, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(project.postList) { _ in
                        Image("tmpImage")
                            .resizable()
                            .frame(width: 140, height: 100)
                            .cornerRadius(8)
                    }
                    if project.postList.count > 4 {
                        ZStack {
                            Color.gray.opacity(0.1)
                                .frame(width: 80, height: 80)
                                .cornerRadius(8)

                            Text("+\(project.postList.count - 4)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.trailing, 20)
            }
        }
    }
}

// 리스트뷰
struct PostListCard: View {
    let project: Project

    var body: some View {
        HStack(spacing: 15) {
            Image("tmpImage")
                .resizable()
                .frame(width: 100, height: 70)
                .cornerRadius(5)

            VStack(alignment: .leading, spacing: 5) {
                Text(project.projectTitle)
                    .font(.system(size: 17, weight: .semibold))
                    .lineLimit(2)

                HStack {
                    Text(formatDateRange(
                        startDate: project.postList.compactMap { $0.createdAt }.min() ?? Date(),
                        endDate: project.finishedAt
                    ))
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.gray)

                    Text(project.finishedAt == nil ? "진행중" : "완료")
                        .font(.system(size: 10, weight: .medium))
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(project.finishedAt == nil ? Color.green.opacity(0.2) : Color.gray.opacity(0.2))
                        .foregroundColor(project.finishedAt == nil ? .green : .gray)
                        .cornerRadius(4)
                }

                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "folder.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 12))
                        Text("12")
                            .font(.system(size: 12, weight: .semibold))
                    }

                    HStack(spacing: 4) {
                        Image(systemName: "person.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 12, weight: .semibold))
                        Text("112")
                            .font(.system(size: 14, weight: .medium))
                    }
                }

                Spacer()
            }

            Spacer()
        }
        Divider()
    }
}

#Preview {
    MainView()
}
