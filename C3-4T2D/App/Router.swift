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

enum Destination: Hashable {
    case onBoardingView
    case mainView
    case splashView2
    case ProjectListView(Project)

    /* projectDetailView(Project) 이런식으로 나중에 필요에따라 데이터 넘겨주기도 가능함 */
    case projectDetailView
    case postDetailView
    case createView
    case profileSettingView
}
