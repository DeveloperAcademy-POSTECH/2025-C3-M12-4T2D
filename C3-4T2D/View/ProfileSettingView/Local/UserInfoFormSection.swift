//
//  UserInfoFormSection.swift
//  C3-4T2D
//
//  Created by bishoe on 6/7/25.
//

import SwiftUI

struct UserInfoFormSection: View {
    @Binding var nickname: String
    @Binding var goal: String
    @Binding var targetDate: Date
    @Binding var isDateSelected: Bool
    @Binding var isSheetPresented: Bool
    @FocusState.Binding var focusedField: TextFieldType?
    let hideKeyboard: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            UserInfoTextField(
                title: "닉네임",
                placeholder: "닉네임을 적어주세요",
                text: $nickname,
                maxLength: 10,
                focusField: .nickname,
                focusedField: $focusedField
            ) {
                focusedField = .goal
            }
            
            UserInfoTextField(
                title: "입시 목표",
                placeholder: "가고 싶은 학교나 원하는 입시 목표를 적어주세요",
                text: $goal,
                maxLength: 20,
                focusField: .goal,
                focusedField: $focusedField
            ) {
                hideKeyboard()
            }
            
            UserGoalDateField(
                targetDate: $targetDate,
                isDateSelected: $isDateSelected,
                isSheetPresented: $isSheetPresented,
                onTap: {
                    hideKeyboard()
                    isSheetPresented = true
                }
            )
        }
    }
}

#Preview {
    UserInfoFormSection(
        nickname: .constant(""),
        goal: .constant(""),
        targetDate: .constant(Date()),
        isDateSelected: .constant(false),
        isSheetPresented: .constant(false),
        focusedField: FocusState<TextFieldType?>().projectedValue,
        hideKeyboard: {}
    )
}
