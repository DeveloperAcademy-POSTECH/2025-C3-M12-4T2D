//
//  TextView.swift
//  C3-4T2D
//
//  Created by 차원준 on 5/30/25.
//
import SwiftUI

struct TextView: View {
    var date: String = "05.21 14:32"
    var body: some View {
        // 피드백 내용
        Text("함께 걷고, 함께 웃고, 때론 아무 말 없이 시간을 보내는 그 순간들이 쌓여 지금의 우리를 만들었다는 생각이 든다.")
            .lineLimit(nil)
        // 날짜
        Text(date)
            .font(.caption2)
            .foregroundColor(Color.gray)
    }
}
