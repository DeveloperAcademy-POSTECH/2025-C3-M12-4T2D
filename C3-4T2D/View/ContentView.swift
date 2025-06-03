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
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationStack(path: $router.path) {
            MainView().navigationDestination(for: Destination.self) { destination in
                switch destination {
                // Text()대신 해당하는 View 적용 필요
                case .mainView:
                    MainView()
                case .onBoardingView:
                    Text("onBoardingView")
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
        }.environment(router)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
