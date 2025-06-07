//
//  ContentView.swift
//  C3-4T2D
//
//  Created by bishoe on 5/28/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var router = Router()
    @Query var users: [User]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase

    @State private var showingSplash = true
    @AppStorage("splashCompleted") private var splashCompleted = false

    var body: some View {
        ZStack {
            NavigationStack(path: $router.path) {
                Group {
                    if users.isEmpty {
                        OnboardingView()
                    } else {
                        MainView()
                    }
                }
                .navigationDestination(for: Destination.self) { destination in
                    switch destination {
                    case .mainView:
                        MainView()
                    case .onBoardingView:
                        OnboardingView()
                    case .splashView2:
                        SplashView2()
                    case .ProjectListView(let project):
                        ProjectList(project)
                    case .projectDetailView:
                        Text("projectDetailView")
                    case .postDetailView:
                        Text("postDetailView")
                    case .createView:
                        Text("createView")
                    case .profileSettingView:
                        ProfileSettingView()
                    }
                }
            }
            .environment(router)

            // 앱 최초 실행시 ? 매번 실행시 ?
            if showingSplash && !splashCompleted {
                SplashView()
                    .zIndex(999)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.easeOut(duration: 0.5)) {
                                showingSplash = false
                            }
                            splashCompleted = true
                        }
                    }
            }
        }
        .onAppear {
            if !splashCompleted {
                showingSplash = true
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if let user = users.first {
                    let now = Date()
                    if let last = user.lastVisitAt {
                        if now.timeIntervalSince(last) >= 3600 {
                            user.streakNum += 1
                            user.lastVisitAt = now
                            try? modelContext.save()
                        }
                    } else {
                        user.streakNum += 1
                        user.lastVisitAt = now
                        try? modelContext.save()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
