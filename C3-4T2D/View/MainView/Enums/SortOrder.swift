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
            return projects.sorted { first, second in
                let firstLatest = first.postList.compactMap { $0.createdAt }.max() ?? Date.distantPast
                let secondLatest = second.postList.compactMap { $0.createdAt }.max() ?? Date.distantPast
                return firstLatest > secondLatest
            }
        case .oldest:
            return projects.sorted { first, second in
                let firstEarliest = first.postList.compactMap { $0.createdAt }.min() ?? Date.distantFuture
                let secondEarliest = second.postList.compactMap { $0.createdAt }.min() ?? Date.distantFuture
                return firstEarliest < secondEarliest
            }
        }
    }
}
