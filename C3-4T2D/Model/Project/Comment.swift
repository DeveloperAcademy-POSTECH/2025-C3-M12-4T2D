import Foundation
import SwiftData

@Model
final class Comment {
    @Attribute(.unique) var id: UUID
    var text: String
    var timestamp: Date
    init(text: String, timestamp: Date = Date()) {
        self.id = UUID()
        self.text = text
        self.timestamp = timestamp
    }
} 