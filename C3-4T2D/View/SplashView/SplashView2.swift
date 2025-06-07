//
//  SplashView2.swift
//  C3-4T2D
//
//  Created by bishoe on 6/7/25.
//

import SwiftData
import SwiftUI

struct SplashView2: View {
    @Environment(Router.self) var router

    @Query private var users: [User]
    var currentUser: User { users.first! }

    var formattedTargetDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: currentUser.targetDate)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .white.opacity(0.3), location: 0.0),
                    .init(color: .white.opacity(0.3), location: 0.3806),
                    .init(color: .prime1.opacity(0.3), location: 0.9351),
                    .init(color: .prime1.opacity(0.3), location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Text(currentUser.nickname)
                                .font(.title)
                                .bold()
                                .foregroundColor(.prime1)
                            Text("님")
                                .font(.title)
                                .bold()
                        }

                        Text("망고에 오신 걸 환영합니다!")
                            .font(.title)
                            .bold()
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(formattedTargetDate)까지")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.gray3)
                        Text("\(currentUser.userGoal)")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.gray3)
                        Text("목표까지 망고가 함께할게요")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.gray3)
                    }
                }
                .padding(.horizontal, 30)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 50)

                Spacer()
            }
            .zIndex(1)

            Image("splash2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height * 0.74
                )
                .position(
                    x: UIScreen.main.bounds.width * 1.1/2,
                    y: UIScreen.main.bounds.height - (UIScreen.main.bounds.height * 0.7) * 1.7/4
                )
                .ignoresSafeArea(edges: .bottom)
                .zIndex(0)

            VStack {
                Spacer()
                Button(action: {
                    // MainView로 이동 -> Root로하면 후진 애니메이션됨
                    router.navigate(to: .mainView)
                }) {
                    Text("시작하기")
                        .font(.headline)
                        .foregroundColor(.orange)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(.white)
                        .cornerRadius(15)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
            .zIndex(2)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SplashView2()
        .modelContainer(for: [User.self, Project.self, Post.self], inMemory: true)
        .environment(Router())
}
