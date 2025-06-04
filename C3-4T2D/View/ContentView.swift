//
//  ContentView.swift
//  C3-4T2D
//
//  Created by bishoe on 5/28/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var path = NavigationPath()
    @Query var users: [User]
    @Environment(Router.self) private var router

    var body: some View {
        NavigationStack(path: $path) {
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
                case .ProjectView:
                    ProjectView()
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
    }
}

#Preview {
    ContentView()
}
