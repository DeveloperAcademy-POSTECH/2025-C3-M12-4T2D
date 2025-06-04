//
//  SortOrder.swift
//  C3-4T2D
//
//  Created by bishoe on 5/31/25.
//

import Foundation

enum SortOrder: String, CaseIterable {
    case newest = "최신순"
    case oldest = "오래된순"

    func sort(projects: [Project]) -> [Project] {
        switch self {
        case .newest:
            return projects.sorted { $0.createdAt > $1.createdAt }
        case .oldest:
            return projects.sorted { $0.createdAt < $1.createdAt }
        }
    }
}
