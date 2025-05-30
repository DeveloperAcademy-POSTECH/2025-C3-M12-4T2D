import SwiftUI

struct MainView: View {
    private let dummyData = DummyData()
    @State private var selectedTabIndex: Int = 0

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
                        .padding(.bottom, 16)

                    // 탭에 따른 레이아웃
                    Group {
                        switch selectedTabIndex {
                        case 0: // 프로젝트별 리스트
                            LazyVStack(spacing: 20) {
                                ForEach(dummyData.allProjects) { project in
                                    ProjectSectionCard(project: project)
                                }
                            }.padding(.leading, 20)
                        case 1: // 2x2 그리드
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 10) {
                                ForEach(dummyData.allPosts) { post in
                                    GridImageCard(image: post.postImageUrl ?? "")
                                }
                            }.padding(.horizontal, 20)
                        case 2: // 3x3 그리드
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                                ForEach(dummyData.allPosts) { post in
                                    GridImageCard(image: post.postImageUrl ?? "")
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

// 프로젝트별 섹션 카드
struct ProjectSectionCard: View {
    let project: Project
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 프로젝트 헤더
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(project.projectTitle)
                        .font(.system(size: 19, weight: .bold))
                    
                    HStack {
                        Text(formatDateRange(project))
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
                    
                    // 더보기 표시
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
        .padding(.vertical, 12)
    }
    
    private func formatDateRange(_ project: Project) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        let startDate = project.postList.compactMap { $0.createdAt }.min() ?? Date()
        
        if project.finishedAt == nil {
            // 진행중인 프로젝트
            return "\(formatter.string(from: startDate)) ~"
        } else {
            // 완료된 프로젝트
            let endDate = project.finishedAt!
            return "\(formatter.string(from: startDate)) ~ \(formatter.string(from: endDate))"
        }
    }
}

#Preview {
    MainView()
}
