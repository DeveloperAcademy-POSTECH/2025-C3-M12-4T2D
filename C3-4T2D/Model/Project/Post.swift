//
//  Post.swift
//  C3-4T2D
//
//  Created by bishoe on 5/29/25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Post {
    @Attribute(.unique) var id: UUID
    var postImageUrl: String?
    var memo: String?
    // 사용자 지정 순서 -> 유저가 혹여나 순서를 잘못올렸을때 사용 (아직 활용 X )
    var order: Int
    var createdAt: Date
    var comments: [Comment] = []

    // Project와 연결된 부분
    var project: Project?

    init(postImageUrl: String? = nil, memo: String? = nil, order: Int = 0, project: Project? = nil, createdAt: Date = Date()) {
        self.id = UUID()
        self.postImageUrl = postImageUrl
        self.memo = memo
        self.order = order
        self.project = project
        self.createdAt = createdAt
    }

    // 포스트 삭제 시 프로젝트도 0개면 삭제
    static func delete(_ post: Post, context: ModelContext) {
        let project = post.project
        context.delete(post)
        if let project = project, project.postList.count <= 1 { // 삭제 전 1개면, 삭제 후 0개
            context.delete(project)
        }
    }
}
