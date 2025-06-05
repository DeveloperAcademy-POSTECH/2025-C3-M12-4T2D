//
//  Router.swift
//  C3-4T2D
//
//  Created by bishoe on 6/2/25.
//

import SwiftUI

@Observable
class Router {
    var path = NavigationPath()

    func navigate(to destination: Destination) {
        path.append(destination)
    }

    func navigateBack() {
        path.removeLast()
    }

    func navigateToRoot() {
        path.removeLast(path.count)
    }
}

// 일단은 들어가게 될 ProjectView들을 임시로 선언해주었는데, 얼마든지 유동적으로 변경이 가능함
enum Destination: Hashable {
    case onBoardingView
    case mainView
    case ProjectListView(Project)

    /* projectDetailView(Project) 이런식으로 나중에 필요에따라 데이터 넘겨주기도 가능함 */
    case projectDetailView
    case postDetailView
    case createView
    case settingsView
}
