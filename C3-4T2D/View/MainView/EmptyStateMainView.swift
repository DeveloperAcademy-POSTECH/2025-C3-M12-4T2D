import SwiftData
import SwiftUI

struct EmptyStateMainView: View {
    @Environment(Router.self) private var router
    @Environment(\.modelContext) private var modelContext

    @Query private var users: [User]
    @State private var showCameraEdit: Bool = false
    @State private var showCreate: Bool = false
    @State private var showActionSheet: Bool = false
    @State private var showProfileSetting: Bool = false
    @State private var mainPickedImage: UIImage?
    @State private var offset: CGFloat = 0

    var currentUser: User? { users.first }
    var streakNum: Int { currentUser?.streakNum ?? 0 }

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Color(hex: "FFD55C")
                    .frame(height: UIScreen.main.bounds.height * 0.4)
                Color.white
            }
            .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            offset = geo.frame(in: .global).minY
                        }
                        .onChange(of: geo.frame(in: .global).minY) { _, newValue in
                            withAnimation(.easeInOut(duration: 0.2)) {
                                offset = newValue
                            }
                        }
                }
                .frame(height: 0)

                VStack(spacing: 0) {
                    MainHeader(
                        user: currentUser, 
                        streakNum: streakNum, 
                        projectCount: 0, 
                        postCount: 0, 
                        showProfileSetting: $showProfileSetting
                    )

                    VStack(spacing: 0) {
                        HStack {
                            Text("첫 번째 작품 만들기")
                                .font(.system(size: 22, weight: .bold))
                                .padding(.leading, 20)
                            Spacer()
                        }
                        .padding(.top, 15)
                        .padding(.bottom, 25)

                        // 첫 프로젝트 생성을 위한 특별한 UI
                        VStack(spacing: 32) {
                            // 메인 버튼
                            Button(action: { showActionSheet = true }) {
                                VStack(spacing: 20) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(hex: "FFD55C").opacity(0.15))
                                            .frame(width: 140, height: 140)
                                        
                                        Circle()
                                            .fill(Color(hex: "FFD55C").opacity(0.3))
                                            .frame(width: 110, height: 110)
                                        
                                        Image(systemName: "plus")
                                            .font(.system(size: 45, weight: .medium))
                                            .foregroundColor(Color(hex: "FFD55C"))
                                    }
                                    
                                    VStack(spacing: 12) {
                                        Text("첫 번째 작품 과정을 기록해보세요!")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(.black)
                                        
                                        Text("아이디어부터 완성까지, 모든 과정을 담아보세요")
                                            .font(.system(size: 16))
                                            .foregroundColor(.gray)
                                            .multilineTextAlignment(.center)
                                            .lineSpacing(3)
                                    }
                                }
                            }
                            
                            // 기능 소개 카드들
                            HStack(spacing: 16) {
                                Button(action: {
                                    showCameraEdit = true
                                }) {
                                    FeatureCard(
                                        icon: "camera.fill",
                                        title: "바로 촬영",
                                        description: "카메라로 작업 과정 캡처"
                                    )
                                }
                                
                                Button(action: {
                                    mainPickedImage = nil
                                    showCreate = true
                                }) {
                                    FeatureCard(
                                        icon: "square.and.pencil",
                                        title: "과정 기록",
                                        description: "메모와 함께 단계별 기록"
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 80)
                        
                        Spacer(minLength: 0)
                    }
                    .background(Color.white)
                    .cornerRadius(15, corners: [.topLeft, .topRight])
                    .padding(.top, -16)
                    .frame(minHeight: UIScreen.main.bounds.height * 0.75)
                }
            }
            .coordinateSpace(name: "scroll")

            // SafeArea 상단 색상
            Color(backgroundColor(for: offset))
                .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top ?? 44)
                .edgesIgnoringSafeArea(.top)
        }
        .fullScreenCover(isPresented: $showCameraEdit) {
            CameraEditView { editedImage in
                handleCameraEditResult(editedImage)
            }
        }
        .fullScreenCover(isPresented: $showCreate) {
            CreateView(
                createPickedImage: $mainPickedImage,
                initialProject: nil
            )
        }
        .confirmationDialog("첫 번째 작품 시작하기", isPresented: $showActionSheet, titleVisibility: .visible) {
            Button("바로 촬영하기") {
                showCameraEdit = true
            }
            Button("과정 기록하기") {
                mainPickedImage = nil
                showCreate = true
            }
            Button("취소", role: .cancel) {}
        }
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $showProfileSetting) {
            ProfileSettingView()
        }
    }
    
    // MARK: - 카메라 편집 결과 처리 함수
    private func handleCameraEditResult(_ editedImage: UIImage?) {
        if let editedImage = editedImage {
            mainPickedImage = editedImage
            DispatchQueue.main.async {
                if mainPickedImage != nil {
                    showCreate = true
                }
            }
        }
    }
    
    // 스크롤 위치에 따라 색상 변경
    func backgroundColor(for offset: CGFloat) -> Color {
        switch offset {
        case ..<(-40):
            return .white
        default:
            return Color(hex: "FFD55C")
        }
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.03))
                    .frame(height: 90)
                
                VStack(spacing: 8) {
                    Image(systemName: icon)
                        .font(.system(size: 26))
                        .foregroundColor(Color(hex: "FFD55C"))
                    
                    Text(title)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
            
            Text(description)
                .font(.system(size: 12))
                .foregroundColor(.gray.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
    }
}


#Preview {
    EmptyStateMainView()
}