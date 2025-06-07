import Foundation
import SwiftUI

extension DateFormatter {
    static func projectDateRange(startDate: Date, endDate: Date?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"

        if let endDate = endDate {
            return "\(formatter.string(from: startDate)) ~ \(formatter.string(from: endDate))"
        } else {
            return "\(formatter.string(from: startDate)) ~"
        }
    }

    static let timestampFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd. HH:mm"
        return formatter
    }()

    static var koreanDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}

extension Date {
    var remainingDaysFromToday: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let target = calendar.startOfDay(for: self)
        let components = calendar.dateComponents([.day], from: today, to: target)
        return components.day ?? 0
    }

    var onboardingDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: self)
    }

    /// 오늘날짜 이후로 캘린더 선택하게끔 변경
    func isValidTargetDate() -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        let selected = Calendar.current.startOfDay(for: self)
        return selected > today
    }

    func dateFieldErrorColor(isSelected: Bool) -> Color {
        if !isSelected { return .prime3 }
        return !isValidTargetDate() ? .alert : .prime1
    }
}
