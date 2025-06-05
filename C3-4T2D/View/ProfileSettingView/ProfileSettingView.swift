//
//  ProfileSettingView.swift
//  C3-4T2D
//
//  Created by 서연 on 6/4/25.
//

import SwiftUI
import UIKit

struct ProfileSettingView: View {
    
    @State private var nickname: String = ""
    @State private var goal: String = ""
    @State private var targetDate: Date = Date()
    @State private var isSheetPresented = false
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case nickname
        case goal
    }
    
    @State private var hasTriggeredNicknameHaptic = false
    @State private var hasTriggeredGoalHaptic = false
    
    private func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
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
    
    var body: some View {
        let _ = {
            if nickname.count > 10 && !hasTriggeredNicknameHaptic {
                triggerHaptic()
                hasTriggeredNicknameHaptic = true
            } else if nickname.count <= 10 {
                hasTriggeredNicknameHaptic = false
            }
            
            if goal.count > 20 && !hasTriggeredGoalHaptic {
                triggerHaptic()
                hasTriggeredGoalHaptic = true
            } else if goal.count <= 20 {
                hasTriggeredGoalHaptic = false
            }
        }()
        
        ZStack(alignment: .top) {
//            ProfileSettingHeader(
//                onBack: { /* 뒤로 가기 로직 */ },
//                onSave: { /* 저장 로직 */ },
//                isSaveEnabled: !nickname.isEmpty && !goal.isEmpty && !nicknameIsOverLimit && !goalIsOverLimit
//            )
            VStack(alignment: .leading, spacing: 20) {
                Spacer().frame(height: 60)
                
                ZStack {
                    // 프로필 이미지 배경 및 이미지
                    Circle()
                        .fill(Color.white)
                        .frame(width: 120, height: 120)
                        .overlay(
                            Image("profile")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 70, height: 70)
                        )
                        .background(
                            ZStack {
                                
                                Circle()
                                    .fill(Color.prime1)
                                    .frame(width: 125, height: 125)
                            }
                        )
                        .overlay(
                            Button(action: {
                                // 프로필 이미지 변경 액션
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 30, height: 30)
                                    
                                    Image(systemName: "camera")
                                        .foregroundColor(.white)
                                        .scaledToFill()
                                        .padding(5)
                                        .background(Circle().fill(Color.prime2))
                                }
                            },
                            alignment: .bottomTrailing
                        )
                    
                }
                .frame(maxWidth: .infinity)
                
                
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
                                .foregroundColor(nicknameIsOverLimit ? Color("Alert_red01") : .prime1)
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
                                .foregroundColor(goalIsOverLimit ? Color("Alert_red01") : .prime1)
                        }
                        .padding(.top, 2)
                    }
                }
                
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("목표 달성 예정일")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray4)
                    
                    Button(action: {
                        hideKeyboard()
                        isSheetPresented = true
                    }) {
                        VStack(spacing: 5){
                            Text("\(targetDate, formatter: dateFormatter)")
                                .font(.system(size: 17))
                                .foregroundColor(Color(hex : "C7C7C9"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(.prime3)
                        }
                    }
                }
                
                Spacer().frame(height: 200)
            }
            .padding(.horizontal, 20)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .onTapGesture { hideKeyboard() }
            .sheet(isPresented: $isSheetPresented) {
                VStack {
                    Text("세나야 너의 멋진 노란 데이트 피커를 넣어주렴.")
                        .font(.headline)
                        .padding()
                    Spacer()
                }
                .presentationDetents([.medium])
            }
            .padding(.top, 0)
        }
        .ignoresSafeArea(.container, edges: .top)
        
    }
}
    
    
    #Preview {
        ProfileSettingView()
    }

