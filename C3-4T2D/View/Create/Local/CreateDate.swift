//
//  CreateDate.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 5/30/25.
//

import SwiftUI

struct CreateDate: View {
    @Binding var selectedDate: Date
    @Binding var showDatePicker: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("과정 기록일")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.black)

            Button {
                showDatePicker = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.system(size: 15, weight: .semibold))

                    Text(formattedDate(date: selectedDate))
                        .font(.system(size: 15, weight: .semibold))

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundColor(.black)
                        .padding(.trailing, 8)
                }
                .foregroundColor(.black)
            }

            Divider()
                .background(Color.gray)
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerSheet(
                selectedDate: $selectedDate,
                isPresented: $showDatePicker
            )
        }
    }

    private func formattedDate(date: Date) -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")

        if calendar.isDateInToday(date) {
            formatter.dateFormat = "M월 d일 (E)"
            let today = formatter.string(from: date)
            return "오늘, \(today)"
        } else {
            formatter.dateFormat = "M월 d일 (E)"
            return formatter.string(from: date)
        }
    }
}
