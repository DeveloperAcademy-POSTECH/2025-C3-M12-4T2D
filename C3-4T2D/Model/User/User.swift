//
//  User.swift
//  C3-4T2D
//
//  Created by bishoe on 5/29/25.
//

import Foundation
import SwiftData

@Model
final class User {
    @Attribute(.unique) var id: UUID
    var nickname: String
    var userGoal: String
    var remainingDays: Int // D-Day
    var profileImage: String?
    var streakNum: Int
    var createdAt: Date

    init(nickname: String, userGoal: String, remainingDays: Int, profileImage: String? = nil, streakNum: Int = 0) {
        self.id = UUID()
        self.nickname = nickname
        self.userGoal = userGoal
        self.remainingDays = remainingDays
        self.profileImage = profileImage
        self.streakNum = streakNum
        self.createdAt = Date()
    }
}
