//
//  Project.swift
//  C3-4T2D
//
//  Created by bishoe on 5/29/25.
//

import Foundation
import SwiftData

@Model
final class Project {
    @Attribute(.unique) var id: UUID
    var projectTitle: String // 카테고리처럼 활용될 예정

    // Project 삭제 -> Project삭제되면 해당프로젝트에 포함되어있던 post들이 삭제됨 -> inverse로 양방향 연결되어있어서 해당 프로젝트에 해당하는 포스트만 날라감 !!
    @Relationship(deleteRule: .cascade, inverse: \Post.project)
    var postList: [Post] = []

    var finishedAt: Date?
    var createdAt: Date

    init(projectTitle: String, finishedAt: Date? = nil) {
        self.id = UUID()
        self.projectTitle = projectTitle
        self.finishedAt = finishedAt
        self.createdAt = Date()
    }
}
