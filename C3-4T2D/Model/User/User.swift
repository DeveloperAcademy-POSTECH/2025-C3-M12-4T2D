//
//  User.swift
//  C3-4T2D
//
//  Created by bishoe on 5/29/25.
//

import Foundation

struct User: Identifiable {
    let id: UUID = .init()
    var userGoal: String
    var remainingDays: Int // D-Day
    var profileImage: String?
    var streakNum: Int
    let createdAt: Date

    init(userGoal: String, remainingDays: Int, profileImage: String? = nil, streakNum: Int = 0) {
        self.userGoal = userGoal
        self.remainingDays = remainingDays
        self.profileImage = profileImage
        self.streakNum = streakNum
        self.createdAt = Date()
    }
}
