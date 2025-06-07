import SwiftUI

struct MainHeader: View {
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
                    Image("profile") // 프로필 이미지 에셋명에 맞게 수정
                        .resizable()
                        .frame(width: 55, height: 55)
                        .clipShape(Circle())
                    VStack(alignment: .leading, spacing: 8) {
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
                        HStack(spacing: 10) {
                            HStack(spacing: 3) {
                                Image("fire")
                                    .resizable()
                                    .frame(width: 19, height: 19)
                                Text("\(streakNum)").font(.system(size: 14, weight: .semibold))
                            }
                            HStack(spacing: 3) {
                                Image("note")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                Text("\(projectCount)").font(.system(size: 14, weight: .semibold))
                            }
                            HStack(spacing: 3) {
                                Image("pallet")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                Text("\(postCount)").font(.system(size: 14, weight: .semibold))
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
