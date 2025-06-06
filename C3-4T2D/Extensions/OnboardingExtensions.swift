//
//  OnboardingExtensions.swift
//  C3-4T2D
//
//  Created by bishoe on 6/5/25.
//

import Foundation
import SwiftUI

extension String {
    func isValidText(maxLength: Int) -> Bool {
        !isEmpty && count <= maxLength
    }

    func textFieldErrorColor(maxLength: Int) -> Color {
        if isEmpty { return .prime3 }
        return count > maxLength ? .alert : .prime1
    }

    func isOverMaxLength(maxLength: Int) -> Bool {
        count > maxLength
    }
}
