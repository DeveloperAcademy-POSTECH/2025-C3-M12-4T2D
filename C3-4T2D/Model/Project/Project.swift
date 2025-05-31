//
//  Project.swift
//  C3-4T2D
//
//  Created by bishoe on 5/29/25.
//

import Foundation

struct Project: Identifiable {
    let id: UUID = .init()
    var projectTitle: String // 카테고리처럼 활용될 예정
    var postList: [Post]
    var finishedAt: Date?
    let createdAt: Date

    init(projectTitle: String, postList: [Post] = [], createdAt: Date = Date(), finishedAt: Date? = nil) {
        self.projectTitle = projectTitle
        self.postList = postList
        self.finishedAt = finishedAt
        self.createdAt = Date()
    }
}
