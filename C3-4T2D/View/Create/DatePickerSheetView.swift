//
//  DatePickerSheetView.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 5/29/25.
//

import SwiftUI

struct DatePickerSheetView: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            DatePicker(
                "날짜 선택",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .labelsHidden()
            .padding()

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
            .padding(.bottom, 20)
        }
        .presentationDetents([.height(400)]) // 하단에 절반만 올라오게
    }
}

//#Preview {
//    DatePickerSheetView()
//}
