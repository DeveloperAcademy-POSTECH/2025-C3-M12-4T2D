import SwiftData
import SwiftUI

struct MainView: View {
    @Environment(Router.self) private var router
    @Environment(\.modelContext) private var modelContext

    @Query private var allProjects: [Project]
    @Query private var users: [User]
    @Query private var allPosts: [Post]
    // 현재 진행중인 프로젝트, 어처피 0 or 1 (있거나 없거나지 여러개가 아님)
    @Query(SwiftDataManager.currentProject) private var getCurrentProject: [Project]

    @State private var selectedTabIndex: Int = 0
    @State private var sortOrder: SortOrder = .newest
    @State private var showCameraEdit: Bool = false  // CameraEditView 사용
    @State private var showCreate: Bool = false
    @State private var showActionSheet: Bool = false
    @State private var showSortSheet: Bool = false
    @State private var showProfileSetting: Bool = false

    @State private var mainPickedImage: UIImage? // MainView의 pickedImage

    var sortedProjects: [Project] {
        sortOrder.sort(projects: allProjects)
    }

    var completedProjects: [Project] {
        sortedProjects.filter { $0.finishedAt != nil }
    }

    var allPostForGrid: [Post] {
        let posts = sortedProjects.flatMap { $0.postList }
        switch sortOrder {
        case .newest:
            return posts.sorted { $0.createdAt > $1.createdAt }
        case .oldest:
            return posts.sorted { $0.createdAt < $1.createdAt }
        }
    }

    var currentProject: Project? { getCurrentProject.first }
    var currentUser: User? { users.first }
    var projectCount: Int { allProjects.count }
    var postCount: Int { allPosts.count }
    var streakNum: Int { currentUser?.streakNum ?? 0 }

    // 진행중인 최신 프로젝트 (finishedAt == nil 중 createdAt이 가장 최신)
    var latestActiveProject: Project? {
        allProjects.filter { $0.finishedAt == nil }.sorted { $0.createdAt > $1.createdAt }.first
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.white.ignoresSafeArea()
            MainHeader(user: currentUser, streakNum: streakNum, projectCount: projectCount, postCount: postCount, showProfileSetting: $showProfileSetting)
                .zIndex(1)
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    Spacer().frame(height: 100)
                    VStack(spacing: 0) {
                        HStack {
                            Text("진행중인 과정")
                                .font(.system(size: 22, weight: .bold))
                                .padding(.leading, 20)
                            Spacer()
                            if currentProject != nil {
                                Menu {
                                    Button {
                                        showCameraEdit = true  // CameraEditView 사용
                                    } label: {
                                        HStack(spacing: 2) {
                                            Image(systemName: "camera")
                                            Text("바로 촬영하기")
                                        }
                                    }
                                    Button {
                                        //   과정 기록하기는 이미지 초기화하고 시작
                                        mainPickedImage = nil
                                        showCreate = true
                                    } label: {
                                        HStack(spacing: 2) {
                                            Image(systemName: "square.and.pencil")
                                            Text("과정 기록하기")
                                        }
                                    }
                                } label: {
                                    Image(systemName: "plus")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 24))
                                        .padding(.trailing, 20)
                                }
                            }
                        }
                        .padding(.top, 15)
                        .padding(.bottom, 16)

                        if currentProject == nil {
                            VStack(spacing: 16) {
                                Button(action: { showActionSheet = true }) {
                                    Image("button")
                                        .resizable()
                                        .frame(width: 120, height: 120)
                                }
                                Text("진행중인 과정을 추가해주세요.")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 28)
                            .padding(.bottom, 8)
                        } else {
                            ActiveProjectCard(project: currentProject!)
                        }
                        Rectangle()
                            .foregroundColor(.gray.opacity(0.2))
                            .frame(height: 12)

                        VStack {
                            HStack {
                                Button(action: { showSortSheet = true }) {
                                    HStack {
                                        Text(sortOrder.rawValue).font(.system(size: 22, weight: .bold))
                                        Image(systemName: "chevron.down").font(.system(size: 22, weight: .semibold))
                                    }
                                }.foregroundColor(.black)
                                Spacer()
                                HStack(spacing: 12) {
                                    ForEach(TabType.allCases, id: \.self) { tab in
                                        Button {
                                            selectedTabIndex = tab.rawValue
                                        } label: {
                                            Image(tab.imageName(isSelected: selectedTabIndex == tab.rawValue))
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                        }
                                    }
                                }
                            }.padding(.horizontal, 20)
                                .padding(.bottom, 8)

                            // 탭에 따른 레이아웃 변화
                            Group {
                                switch selectedTabIndex {
                                case 0: // 프로젝트별 스크롤뷰
                                    LazyVStack(spacing: 20) {
                                        ForEach(completedProjects) { project in
                                            ProjectSectionCard(project: project)
                                        }
                                    }
                                case 1: // 리스트뷰
                                    LazyVStack(spacing: 20) {
                                        ForEach(completedProjects) { project in
                                            PostListCard(project: project)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                case 2: // 3x3 그리드뷰
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 3), spacing: 4) {
                                        ForEach(allPostForGrid) { post in
                                            GridImageCard(post: post)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                default:
                                    EmptyView()
                                }
                            }
                            Spacer(minLength: 0)
                        }
                        .padding(.vertical, 20)
                    }
                    .background(Color.white)
                    .cornerRadius(15, corners: [.topLeft, .topRight])
                    .padding(.top, -16)
                    .frame(minHeight: UIScreen.main.bounds.height)
                }
            }
        }
        //   CameraEditView - 바로 촬영하기용
        .fullScreenCover(isPresented: $showCameraEdit) {
            CameraEditView { editedImage in
                handleCameraEditResult(editedImage)
            }
        }
        //   CreateView - 이미지와 프로젝트 전달
        .fullScreenCover(isPresented: $showCreate) {
            CreateView(
                createPickedImage: $mainPickedImage,
                initialProject: currentProject
            )
        }
        .confirmationDialog("진행중인 과정", isPresented: $showActionSheet, titleVisibility: .visible) {
            Button("바로 촬영하기") { 
                showCameraEdit = true
            }
            Button("과정 기록하기") { 
                //   과정 기록하기는 이미지 초기화하고 시작
                mainPickedImage = nil
                showCreate = true 
            }
            Button("취소", role: .cancel) {}
        }
        .confirmationDialog("프로젝트 정렬", isPresented: $showSortSheet, titleVisibility: .visible) {
            ForEach(SortOrder.allCases, id: \.self) { order in
                Button(order.rawValue) { sortOrder = order }
            }
            Button("취소", role: .cancel) {}
        }
        .navigationBarBackButtonHidden(true)

        .fullScreenCover(isPresented: $showProfileSetting) {
            ProfileSettingView()
        }
    }
    
    // MARK: -   카메라 편집 결과 처리 함수
    private func handleCameraEditResult(_ editedImage: UIImage?) {
        if let editedImage = editedImage {
            print("   MainView 바로 촬영 완료: \(editedImage.size)")
            print("🔄 이미지를 mainPickedImage에 할당")
            
            //   이미지 즉시 할당
            mainPickedImage = editedImage
            
            //   이미지 할당 확인 후 CreateView 표시
            DispatchQueue.main.async {
                if mainPickedImage != nil {
                    print("   mainPickedImage 할당 성공: \(mainPickedImage!.size)")
                    print("  CreateView 표시 준비")
                    showCreate = true
                } else {
                    print("    mainPickedImage 할당 실패")
                }
            }
        } else {
            print("    MainView 바로 촬영 취소")
        }
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
