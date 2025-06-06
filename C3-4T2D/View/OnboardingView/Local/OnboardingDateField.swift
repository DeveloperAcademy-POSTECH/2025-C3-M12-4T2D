//
//  OnboardingDateField.swift
//  C3-4T2D
//
//  Created by bishoe on 6/5/25.
//

import SwiftUI

struct OnboardingDateField: View {
    @Binding var targetDate: Date
    @Binding var isDateSelected: Bool
    @Binding var isSheetPresented: Bool
    let onTap: () -> Void
    
    private var dateLineColor: Color {
        targetDate.dateFieldErrorColor(isSelected: isDateSelected)
    }
    
    private var textColor: Color {
        if !isDateSelected { return .gray2 }
        return targetDate.isValidTargetDate ? .black : .alert
    }
    
    private var showError: Bool {
        isDateSelected && !targetDate.isValidTargetDate
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("목표 달성 예정일")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundColor(.gray4)
            
            VStack(spacing: 5) {
                HStack {
                    Button(action: onTap) {
                        Text(targetDate.onboardingDateString)
                            .font(.system(size: 17))
                            .foregroundColor(textColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    if isDateSelected {
                        if !targetDate.isValidTargetDate {
                            Button(action: {
                                targetDate = Date()
                                isDateSelected = false
                            }) {
                                Image(systemName: "x.circle")
                                    .foregroundColor(.alert)
                            }
                        } else {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.prime1)
                        }
                    }
                }
                
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(dateLineColor)
                
                HStack {
                    Spacer()
                    if showError {
                        Text("미래 날짜를 선택해주세요")
                            .font(.caption2)
                            .foregroundColor(.alert)
                    } else {
                        Text("")
                            .font(.caption2)
                            .padding(.top, 2)
                    }
                }
            }
        }
        .sheet(isPresented: $isSheetPresented) {
            DatePickerSheet(
                selectedDate: $targetDate,
                isPresented: $isSheetPresented
            )
            .presentationDetents([.medium])
            .onDisappear {
                isDateSelected = true
            }
        }
    }
}
