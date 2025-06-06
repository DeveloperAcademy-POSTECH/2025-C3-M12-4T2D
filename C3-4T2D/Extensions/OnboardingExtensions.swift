//
//  OnboardingExtensions.swift
//  C3-4T2D
//
//  Created by bishoe on 6/5/25.
//

import Foundation
import SwiftUI

extension String {
    var isValidNickname: Bool {
        !isEmpty && count <= 10
    }

    var isValidGoal: Bool {
        !isEmpty && count <= 20
    }

    var nicknameErrorColor: Color {
        if isEmpty { return .prime3 }
        return count > 10 ? .alert : .prime1
    }

    var goalErrorColor: Color {
        if isEmpty { return .prime3 }
        return count > 20 ? .alert : .prime1
    }
}
