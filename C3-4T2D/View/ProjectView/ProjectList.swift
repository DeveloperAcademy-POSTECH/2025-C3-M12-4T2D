//
//  ProjectList.swift
//  C3-4T2D
//
//  Created by 차원준 on 5/29/25.
//

import SwiftData
import SwiftUI

struct ProjectList: View {
    let project: Project
    @Query private var posts: [Post]

    init(_ project: Project) {
        self.project = project
        // 입력받은 프로젝트 기반 포스트
        self._posts = Query(SwiftDataManager.getPostsForProject(project))
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 25) {
                ForEach(posts, id: \.id) { post in
                    PostView(post: post,project: project)
                }
            }
        }
    }
}

// #Preview {
//    MainView()
// }
