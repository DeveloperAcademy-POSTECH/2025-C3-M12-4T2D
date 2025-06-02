//
//  DatePickerSheet.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 5/29/25.
//

import SwiftUI

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            // 상단 여백 추가
            Spacer().frame(height: 40)

            DatePicker(
                "날짜 선택",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .accentColor(.yellow)
            .labelsHidden()
            .padding()
            .environment(\.locale, Locale(identifier: "ko_KR"))

            Button(action: {
                isPresented = false
            }) {
                Text("확인")
                    .font(.system(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .foregroundColor(.white)
                    .background(Color.yellow)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .padding(.bottom, 40)
        }
        .presentationDetents([.medium]) // 하단에 절반만 올라오게
    }
}
