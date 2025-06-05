import Foundation

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
