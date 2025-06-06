//
//  ProfileSettingView.swift
//  C3-4T2D
//
//  Created by 서연 on 6/5/25.
//


import SwiftUI
import UIKit

struct ProfileSettingView: View {
    
    @State private var nickname: String = ""
    @State private var goal: String = ""
    @State private var targetDate: Date = Date()
    @State private var isSheetPresented = false
    @State private var isPhotoActionSheetPresented = false
    @State private var profileImage: UIImage? = nil
    @State private var isDateSelected = false
    @FocusState private var focusedField: Field?
    
    @Environment(\.dismiss) var dismiss //헤더
    
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
    private var formattedDate: String {
        DateFormatter.koreanDate.string(from: targetDate)
    }
    
    private var mainContent: some View {
        ZStack(alignment: .top) {
            
            VStack(alignment: .leading, spacing: 20) {
                
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 120, height: 120)
                    
                    if let image = profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                    } else {
                        Image("profile")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    }
                }
                .background(
                    Circle()
                        .fill(Color.prime1)
                        .frame(width: 125, height: 125)
                )
                .overlay(
                    Button(action: {
                        isPhotoActionSheetPresented = true
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
                .frame(maxWidth: .infinity, alignment: .center)
                
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
                            HStack {
                                Text(formattedDate)
                                    .font(.system(size: 17))
                                    .foregroundColor(isDateSelected ? .black : Color(hex: "C7C7C9"))
                                Spacer()
                                if isDateSelected {
                                    Image(systemName: "checkmark.circle")
                                        .foregroundColor(.prime1)
                                }
                            }
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(isDateSelected ? .prime1 : Color.prime3)
                        }
                    }
                }
                
                Spacer().frame(height: 200)
            }
            .padding(.horizontal, 20)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .onTapGesture { hideKeyboard () }
            .onChange(of: nickname) { newValue in
                if newValue.count > 10 && !hasTriggeredNicknameHaptic {
                    triggerHaptic()
                    hasTriggeredNicknameHaptic = true
                } else if newValue.count <= 10 {
                    hasTriggeredNicknameHaptic = false
                }
            }
            .onChange(of: goal) { newValue in
                if newValue.count > 20 && !hasTriggeredGoalHaptic {
                    triggerHaptic()
                    hasTriggeredGoalHaptic = true
                } else if newValue.count <= 20 {
                    hasTriggeredGoalHaptic = false
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
    
    var body: some View {
        NavigationStack {
            mainContent
                .navigationTitle("프로필 수정")
                .navigationBarTitleDisplayMode(.inline)
                .font(.system(size: 17, weight: .bold))
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                                .bold()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("저장하기") {
                            // 저장 액션 구현 예정
                        }
                        .foregroundColor(.prime1)
                        .font(.system(size: 17, weight: .semibold))
                    }
                }
        }
        .padding(.top, 0)
        .ignoresSafeArea(.container, edges: .top)
        .confirmationDialog("프로필 사진 편집", isPresented: $isPhotoActionSheetPresented, titleVisibility: .visible) {
            Button("사진 삭제", role: .destructive) {
                profileImage = nil
            }
            Button("사진 변경") {
                // 추후 포토피커 연결 필요
            }
            Button("취소", role: .cancel) { }
        }
    }
}

#Preview {
    ProfileSettingView()
}
