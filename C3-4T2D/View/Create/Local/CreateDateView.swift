//
//  CreateDateView.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 5/30/25.
//

import SwiftUI

struct CreateDateView: View {
    @Binding var selectedDate: Date
    @Binding var showDatePicker: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text("과정 기록일")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.black)
                .padding(.bottom, 8)

            Button {
                showDatePicker = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.system(size: 16))
                    Text(formattedDate(date: selectedDate))
                        .font(.system(size: 14))
                }
                .foregroundColor(.black)
            }

            Divider()
                .background(Color.gray)
        }
        .padding(.vertical, 16)
        .sheet(isPresented: $showDatePicker) {
            DatePickerSheetView(
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
