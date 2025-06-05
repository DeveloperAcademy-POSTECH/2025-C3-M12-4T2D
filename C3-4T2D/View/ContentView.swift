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

    var body: some View {
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
                case .ProjectListView(let project):
                    ProjectList(project)
                case .projectDetailView:
                    Text("projectDetailView")
                case .postDetailView:
                    Text("postDetailView")
                case .createView:
                    Text("createView")
                case .settingsView:
                    Text("settingsView")
                }
            }
        }
        .environment(router)
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
