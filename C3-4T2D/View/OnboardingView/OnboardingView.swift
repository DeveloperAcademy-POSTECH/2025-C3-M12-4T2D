//
//  OnboardingView.swift
//  C3-4T2D
//
//  Created by 서연 on 6/2/25.
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Router.self) private var router
    
    @State private var nickname: String = ""
    @State private var goal: String = ""
    @State private var targetDate: Date = Date()
    @State private var isSheetPresented = false
    @State private var isDateSelected = false

    @FocusState private var focusedField: Field?

    enum Field {
        case nickname
        case goal
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }

    var nicknameIsOverLimit: Bool { nickname.count > 10 }
    var goalIsOverLimit: Bool { goal.count > 20 }

    var nicknameLineColor: Color {
        if nickname.isEmpty { return .prime3 }
        return nicknameIsOverLimit ? Color("Alert_red01") : .prime1
    }

    var goalLineColor: Color {
        if goal.isEmpty { return .prime3 }
        return goalIsOverLimit ? Color("Alert_red01") : .prime1
    }
    
    var dateLineColor: Color {
        isDateSelected ? .prime1 : .prime3
    }
    
    var isFormValid: Bool {
        !nickname.isEmpty && !goal.isEmpty && !nicknameIsOverLimit && !goalIsOverLimit && isDateSelected
    }

    private func calculateRemainingDays() -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let target = calendar.startOfDay(for: targetDate)
        let components = calendar.dateComponents([.day], from: today, to: target)
        return components.day ?? 0
    }

    private func completeOnboarding() {
        let remainingDays = calculateRemainingDays()
        let user = SwiftDataManager.createUser(
            context: modelContext,
            nickname: nickname,
            goal: goal,
            remainingDays: remainingDays
        )
        do {
            try modelContext.save()
            router.navigateToRoot()
        } catch {
            print("Error saving user: \(error)")
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // 헤더 텍스트
                    VStack(alignment: .leading, spacing: 4) {
                        Text("당신의 성장 타임라인,")
                            .font(.system(size: 28))
                            .fontWeight(.bold)

                        HStack(spacing: 0) {
                            Text("망고")
                                .font(.system(size: 28))
                                .foregroundColor(.prime1)
                                .fontWeight(.bold)
                            Text("가 함께해요")
                                .font(.system(size: 28))
                                .fontWeight(.bold)
                        }
                    }
                    .padding(.top, 70)
                    .padding(.bottom, 45)

                    // 닉네임
                    VStack(alignment: .leading, spacing: 5) {
                        Text("닉네임")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray4)

                        VStack(spacing: 5) {
                            HStack {
                                TextField("닉네임을 적어주세요", text: $nickname)
                                    .font(.system(size: 17))
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(.black)
                                    .focused($focusedField, equals: .nickname)
                                    .submitLabel(.next)
                                    .onSubmit {
                                        focusedField = .goal
                                    }

                                if !nickname.isEmpty {
                                    if nicknameIsOverLimit {
                                        Button(action: { nickname = "" }) {
                                            Image(systemName: "x.circle")
                                                .foregroundColor(Color("Alert_red01"))
                                        }
                                    } else {
                                        Image(systemName: "checkmark.circle")
                                            .foregroundColor(.prime1)
                                    }
                                }
                            }

                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(nicknameLineColor)

                            HStack {
                                Spacer()
                                Text("\(nickname.count)/10")
                                    .font(.caption2)
                                    .foregroundColor(nicknameIsOverLimit ? Color("Alert_red01") : .clear)
                            }
                            .padding(.top, 2)
                        }
                    }

                    // 입시 목표
                    VStack(alignment: .leading, spacing: 5) {
                        Text("입시 목표")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray4)

                        VStack(spacing: 5) {
                            HStack {
                                TextField("가고 싶은 학교나 원하는 입시 목표를 적어주세요", text: $goal)
                                    .font(.system(size: 17))
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(.black)
                                    .focused($focusedField, equals: .goal)
                                    .submitLabel(.done)
                                    .onSubmit {
                                        hideKeyboard()
                                    }

                                if !goal.isEmpty {
                                    if goalIsOverLimit {
                                        Button(action: { goal = "" }) {
                                            Image(systemName: "x.circle")
                                                .foregroundColor(Color("Alert_red01"))
                                        }
                                    } else {
                                        Image(systemName: "checkmark.circle")
                                            .foregroundColor(.prime1)
                                    }
                                }
                            }

                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(goalLineColor)

                            HStack {
                                Spacer()
                                Text("\(goal.count)/20")
                                    .font(.caption2)
                                    .foregroundColor(goalIsOverLimit ? Color("Alert_red01") : .clear)
                            }
                            .padding(.top, 2)
                        }
                    }

                    // 목표 달성 예정일
                    VStack(alignment: .leading, spacing: 5) {
                        Text("목표 달성 예정일")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray4)

                        VStack(spacing: 5) {
                            HStack {
                                Button(action: {
                                    hideKeyboard()
                                    isSheetPresented = true
                                }) {
                                    Text("\(targetDate, formatter: dateFormatter)")
                                        .font(.system(size: 17))
                                        .foregroundColor(isDateSelected ? .black : Color(hex: "C7C7C9"))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                if isDateSelected {
                                    Image(systemName: "checkmark.circle")
                                        .foregroundColor(.prime1)
                                }
                            }

                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(dateLineColor)
                        }
                    }

                    Spacer().frame(height: 140)
                }
                .padding(.horizontal, 20)
            }
            
            // 바닥 고정 버튼
            Button(action: completeOnboarding) {
                Text("작성 완료")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isFormValid ? .prime1 : .prime4)
                    .cornerRadius(10)
            }
            .disabled(!isFormValid)
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onTapGesture { hideKeyboard() }
        .sheet(isPresented: $isSheetPresented) {
            DatePickerSheet(
                selectedDate: $targetDate,
                isPresented: $isSheetPresented,
            )
            .presentationDetents([.medium])
            .onDisappear {
                isDateSelected = true
            }
        }
    }
}

// MARK: - Helpers

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Preview

#Preview {
    OnboardingView()
}
