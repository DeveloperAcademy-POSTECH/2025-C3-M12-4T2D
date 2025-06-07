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
    @Environment(\.dismiss) var dismiss

    init(_ project: Project) {
        self.project = project
        // 입력받은 프로젝트 기반 포스트
        self._posts = Query(SwiftDataManager.getPostsForProject(project))
    }

    var body: some View {
        ScrollView {
            if posts.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "tray")
                        .font(.system(size: 50))
                        .foregroundStyle(.gray)
                    Text("아직 작성된 포스트가 없어요")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                .padding(.top, 100)
            } else {
                LazyVStack(spacing: 25) {
                    ForEach(posts, id: \.id) { post in
                        PostView(post: post, project: project)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundStyle(.black)
        })
    }
}

// #Preview {
//    MainView()
// }
