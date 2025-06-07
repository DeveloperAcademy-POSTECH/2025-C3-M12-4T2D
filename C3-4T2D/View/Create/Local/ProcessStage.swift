//
//  ProcessStage.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 6/2/25.
//

enum ProcessStage: String, CaseIterable, Identifiable, Codable {
    case idea = "아이디어"
    case sketch = "스케치"
    case coloring = "채색"
    case completed = "완성"
    case etc = "기타"

    var id: String { self.rawValue } // ForEach에서 id 생략 가능하게 함
}
