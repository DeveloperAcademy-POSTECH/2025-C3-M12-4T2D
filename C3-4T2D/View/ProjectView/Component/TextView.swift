//
//  TextView.swift
//  C3-4T2D
//
//  Created by 차원준 on 5/30/25.
//
import SwiftUI

struct TextView: View {
    var text: String = ""
    var date: String = "05.21 14:32"
    var body: some View {
        // 실제 메모 내용 표시
        Text(text)
            .lineLimit(nil)
        // 날짜
        Text(date)
            .font(.caption2)
            .foregroundColor(Color.gray)
    }
}
