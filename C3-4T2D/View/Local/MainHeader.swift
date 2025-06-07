import SwiftUI

struct MainHeader: View {
    @Environment(Router.self) var router
    var user: User?
    var streakNum: Int
    var projectCount: Int
    var postCount: Int
    var body: some View {
        ZStack(alignment: .top) {
            Color(hex: "FFD55C")
                .ignoresSafeArea(edges: .top)
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center, spacing: 12) {
                    Button {
                        router.navigate(to: .profileSettingView)
                    } label: {
                        if let imageData = user?.profileImageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        } else {
                            Image("profile") // 기본 프로필 이미지
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        }
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Text(user?.userGoal ?? "목표를 입력하세요")
                                .font(.system(size: 16, weight: .semibold))
                            Text(user != nil ? "D-\(user!.remainingDays)" : "D-0")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.black)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.white)
                                .cornerRadius(5)
                        }
                        HStack(spacing: 16) {
                            HStack(spacing: 4) {
                                Image("fire")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text("\(streakNum)").font(.system(size: 15, weight: .semibold))
                            }
                            HStack(spacing: 4) {
                                Image("note")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text("\(projectCount)").font(.system(size: 15, weight: .semibold))
                            }
                            HStack(spacing: 4) {
                                Image("pallet")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text("\(postCount)").font(.system(size: 15, weight: .semibold))
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.top, 24)
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            }
            VStack {
                Spacer()
                Image("head")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .clipped()
                    .offset(y: 0)
            }
        }
        .frame(height: 130)
    }
}
