//
//  ProfileSettingView.swift
//  C3-4T2D
//
//  Created by 서연 on 6/5/25.
//

import PhotosUI
import SwiftData
import SwiftUI
import UIKit

struct ProfileSettingView: View {
    @State private var nickname: String = ""
    @State private var goal: String = ""
    @State private var targetDate: Date = .init()
    @State private var isSheetPresented = false
    @State private var isPhotoActionSheetPresented = false
    @State private var isDateSelected = false
    @State private var showPhotoPicker = false
    
    @StateObject private var imageManager = ProfileImageManager()
    @FocusState private var focusedField: TextFieldType?
    
    @Environment(Router.self) var router
    @Environment(\.modelContext) private var modelContext
    @Query var users: [User]

    private var isFormValid: Bool {
        !nickname.isEmpty &&
            !nickname.isOverMaxLength(maxLength: 10) &&
            !goal.isEmpty &&
            !goal.isOverMaxLength(maxLength: 20) &&
            isDateSelected &&
            targetDate.isValidTargetDate()
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ProfileImageSection(
                    profileImage: imageManager.profileImage,
                    isLoadingImage: imageManager.isLoadingImage,
                    onTap: {
                        isPhotoActionSheetPresented = true
                    }
                )
                
                UserInfoFormSection(
                    nickname: $nickname,
                    goal: $goal,
                    targetDate: $targetDate,
                    isDateSelected: $isDateSelected,
                    isSheetPresented: $isSheetPresented,
                    focusedField: $focusedField,
                    hideKeyboard: hideKeyboard
                )
                
                Spacer().frame(height: 200)
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("프로필 수정")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("저장하기") {
                    saveUserInfo()
                }
                .foregroundColor(isFormValid ? .prime1 : .gray2)
                .font(.system(size: 17, weight: .semibold))
                .disabled(!isFormValid)
            }
        }
        .onAppear {
            loadUserInfo()
        }
        .onTapGesture {
            hideKeyboard()
        }
        .confirmationDialog("프로필 사진 편집", isPresented: $isPhotoActionSheetPresented, titleVisibility: .visible) {
            if imageManager.profileImage != nil {
                Button("사진 삭제", role: .destructive) {
                    imageManager.deleteProfileImage(users: users, modelContext: modelContext)
                }
            }
            Button("사진 변경") {
                showPhotoPicker = true
            }
            Button("취소", role: .cancel) {}
        }
        .photosPicker(
            isPresented: $showPhotoPicker,
            selection: $imageManager.selectedPhotoItem,
            matching: .images
        )
        .alert("오류", isPresented: $imageManager.showErrorAlert) {
            Button("확인") {}
        } message: {
            Text(imageManager.errorMessage)
        }
        .onChange(of: imageManager.selectedPhotoItem) { newValue in
            if newValue != nil {
                imageManager.processSelectedPhoto(users: users, modelContext: modelContext)
            }
        }
    }
}

private extension ProfileSettingView {
    func saveUserInfo() {
        guard let user = users.first else { return }
        
        guard isFormValid else {
            print("유효성 검사 실패")
            return
        }
        
        let remainingDays = targetDate.remainingDaysFromToday
        
        var profileImageData: Data?
        if let image = imageManager.profileImage {
            profileImageData = image.jpegData(compressionQuality: 0.8)
        }
        
        SwiftDataManager.updateUserInfo(
            context: modelContext,
            user: user,
            nickname: nickname,
            goal: goal,
            remainingDays: remainingDays,
            profileImageData: profileImageData
        )
        
        router.navigateBack()
    }
    
    func loadUserInfo() {
        guard let user = users.first else { return }
        
        nickname = user.nickname
        goal = user.userGoal
        
        imageManager.loadUserProfileImage(from: user)
        
        // remainingDays를 기반 -> targetDate 계산
        let calendar = Calendar.current
        targetDate = calendar.date(byAdding: .day, value: user.remainingDays, to: Date()) ?? Date()
        isDateSelected = true
    }
    
    func hideKeyboard() {
        focusedField = nil
    }
}

#Preview {
    ProfileSettingView()
}
