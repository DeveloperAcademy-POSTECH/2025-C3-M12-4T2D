//
//  OnboardingView.swift
//  C3-4T2D
//
//  Created by 서연 on 6/2/25.
//

import SwiftData
import SwiftUI

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Router.self) private var router

    @State private var formState = OnboardingFormState()
    @State private var isSheetPresented = false
    @FocusState private var focusedField: TextFieldType?

    /// swiftdata 회원가입 로직
    private func completeOnboarding() {
        let remainingDays = formState.targetDate.remainingDaysFromToday
        let user = SwiftDataManager.createUser(
            context: modelContext,
            nickname: formState.nickname,
            goal: formState.goal,
            remainingDays: remainingDays
        )
        do {
            try modelContext.save()
        } catch {
            print("Error saving user: \(error)")
        }
    }

    private func handleDateFieldTap() {
        hideKeyboard()
        isSheetPresented = true
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    OnboardingBanner()

                    OnboardingTextField(
                        title: "닉네임",
                        placeholder: "닉네임을 적어주세요",
                        text: $formState.nickname,
                        maxLength: 10,
                        focusField: .nickname,
                        focusedField: $focusedField
                    ) {
                        focusedField = .goal
                    }

                    OnboardingTextField(
                        title: "입시 목표",
                        placeholder: "가고 싶은 학교나 원하는 입시 목표를 적어주세요",
                        text: $formState.goal,
                        maxLength: 20,
                        focusField: .goal,
                        focusedField: $focusedField
                    ) {
                        hideKeyboard()
                    }

                    OnboardingDateField(
                        targetDate: $formState.targetDate,
                        isDateSelected: $formState.isDateSelected,
                        isSheetPresented: $isSheetPresented,
                        onTap: handleDateFieldTap
                    )

                    Spacer().frame(height: 140)
                }
                .padding(.horizontal, 20)
            }

            ActionButton(
                isFormValid: formState.isValid, textOfButton: "작성 완료",
                action: completeOnboarding
            )
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onTapGesture { hideKeyboard() }
    }
}

#Preview {
    OnboardingView()
}
