//
//  OnboardingFormState.swift
//  C3-4T2D
//
//  Created by bishoe on 6/6/25.
//

import Foundation

struct OnboardingFormState {
    var nickname: String = ""
    var goal: String = ""
    var targetDate: Date = .init()
    var isDateSelected: Bool = false

    var isValid: Bool {
        nickname.isValidText(maxLength: 10) &&
            goal.isValidText(maxLength: 20) &&
            isDateSelected &&
            targetDate.isValidTargetDate()
    }
}
