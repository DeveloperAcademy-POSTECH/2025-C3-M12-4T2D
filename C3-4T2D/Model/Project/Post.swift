//
//  Post.swift
//  C3-4T2D
//
//  Created by bishoe on 5/29/25.
//

import Foundation

struct Post: Identifiable {
    let id: UUID = .init()
    var postImageUrl: String?
    var memo: String?
    var order: Int // 사용자 지정 순서
    var projectId: UUID
    var createdAt: Date

    init(postImageUrl: String? = nil, memo: String? = nil, order: Int = 0, projectId: UUID, createdAt: Date = Date()) {
        self.postImageUrl = postImageUrl
        self.memo = memo
        self.order = order
        self.projectId = projectId
        self.createdAt = createdAt
    }
}
