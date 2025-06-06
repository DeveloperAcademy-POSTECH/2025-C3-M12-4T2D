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
    @State private var targetDate: Date = .init()
    @State private var isSheetPresented = false
    @State private var isPhotoActionSheetPresented = false
    @State private var profileImage: UIImage? = nil
    @State private var isDateSelected = false
    @FocusState private var focusedField: TextFieldType?
    @Environment(Router.self) var router
    @Environment(\.modelContext) private var modelContext

    private var mainContent: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 20) {
                ZStack {
                    Circle()
                        .fill(.white)
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
                        .fill(.prime1)
                        .frame(width: 125, height: 125)
                )
                .overlay(
                    Button(action: {
                        isPhotoActionSheetPresented = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 30, height: 30)
                            
                            Image(systemName: "camera")
                                .foregroundColor(.white)
                                .scaledToFill()
                                .padding(5)
                                .background(Circle().fill(.prime2))
                        }
                    },
                    alignment: .bottomTrailing
                )
                .frame(maxWidth: .infinity, alignment: .center)
                
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
                
                Spacer().frame(height: 200)
            }
            .padding(.horizontal, 20)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .onTapGesture { hideKeyboard() }
        }
    }
    
    var body: some View {
        mainContent
            .navigationTitle("프로필 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("저장하기") {
                        // 저장 액션 구현 예정
                    }
                    .foregroundColor(.prime1)
                    .font(.system(size: 17, weight: .semibold))
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
                Button("취소", role: .cancel) {}
            }
    }
}

#Preview {
    ProfileSettingView()
}
