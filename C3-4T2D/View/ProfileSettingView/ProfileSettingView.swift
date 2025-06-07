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

struct ProfileSettingHeader: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showCancelAlert: Bool
    let hasChanges: Bool
    let isFormValid: Bool
    let onSave: () -> Void

    var body: some View {
        HStack {
            Button(action: {
                if hasChanges {
                    showCancelAlert = true
                } else {
                    dismiss()
                }
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 60, alignment: .leading)
            }
            Spacer()
            Text("프로필 수정")
                .font(.title3.weight(.bold))
                .foregroundColor(.black)
            Spacer()
            Button(action: {
                onSave()
            }) {
                Text("완료")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isFormValid ? Color.prime1 : Color.gray2)
            }
            .disabled(!isFormValid)
            .frame(width: 60, alignment: .trailing)
        }
        .padding(.top, 16)
        .padding(.bottom, 12)
    }
}

struct ProfileSettingView: View {
    // 편집 데이터
    @State private var nickname: String = ""
    @State private var goal: String = ""
    @State private var targetDate: Date = .init()
    @State private var isSheetPresented = false
    @State private var isPhotoActionSheetPresented = false
    @State private var isDateSelected = false
    @State private var showPhotoPicker = false
    @State private var showCancelAlert = false
    
    // 편집 전 데이터 (취소 시 복원용)
    @State private var originalNickname: String = ""
    @State private var originalGoal: String = ""
    @State private var originalTargetDate: Date = .init()
    @State private var originalIsDateSelected = false
    
    @StateObject private var imageManager = ProfileImageManager()
    @FocusState private var focusedField: TextFieldType?
    
    @Environment(Router.self) var router
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query var users: [User]

    private var isFormValid: Bool {
        !nickname.isEmpty &&
            !nickname.isOverMaxLength(maxLength: 10) &&
            !goal.isEmpty &&
            !goal.isOverMaxLength(maxLength: 20) &&
            isDateSelected &&
            targetDate.isValidTargetDate()
    }
    
    private var hasChanges: Bool {
        nickname != originalNickname ||
            goal != originalGoal ||
            targetDate != originalTargetDate ||
            imageManager.hasImageChanged
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ProfileSettingHeader(
                    showCancelAlert: $showCancelAlert,
                    hasChanges: hasChanges,
                    isFormValid: isFormValid,
                    onSave: saveUserInfo
                )
                .padding(.bottom, 12)
                .padding(.horizontal, 20)
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
                .padding(.horizontal, 20)
                
                Spacer().frame(height: 200)
            }
        }
        .navigationTitle("프로필 수정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    if hasChanges {
                        showCancelAlert = true
                    } else {
                        router.navigateBack()
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.blue)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("완료") {
                    saveUserInfo()
                }
                .foregroundColor(isFormValid ? .prime1 : .gray2)
                .font(.system(size: 16, weight: .semibold))
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
                    imageManager.deleteProfileImage()
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
                imageManager.processSelectedPhoto()
            }
        }
        .alert("변경사항이 있습니다", isPresented: $showCancelAlert) {
            Button("저장하지 않고 나가기", role: .destructive) {
                cancelEditing()
            }
            Button("이어서 작성하기", role: .cancel) {}
        } message: {
            Text("저장되지 않은 변경사항이 있습니다.")
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
        
        // 이미지 변경사항 저장
        imageManager.saveImageChanges(users: users, modelContext: modelContext)
        
        // 사용자 정보 업데이트 (이미지 제외)
        SwiftDataManager.updateUserInfo(
            context: modelContext,
            user: user,
            nickname: nickname,
            goal: goal,
            remainingDays: remainingDays,
            profileImageData: nil
        )
        
        dismiss()
    }
    
    func loadUserInfo() {
        guard let user = users.first else { return }
        
        // 편집 전 데이터 백업
        originalNickname = user.nickname
        originalGoal = user.userGoal
        originalIsDateSelected = true
        
        // 편집중 데이터 초기화
        nickname = user.nickname
        goal = user.userGoal
        
        imageManager.loadUserProfileImage(from: user)
        
        // remainingDays를 기반 -> targetDate 계산
        let calendar = Calendar.current
        let calculatedDate = calendar.date(byAdding: .day, value: user.remainingDays, to: Date()) ?? Date()
        originalTargetDate = calculatedDate
        targetDate = calculatedDate
        isDateSelected = true
    }

    /// 편집전 데이터로 돌려놓기
    func cancelEditing() {
        nickname = originalNickname
        goal = originalGoal
        targetDate = originalTargetDate
        isDateSelected = originalIsDateSelected
        
        if let user = users.first {
            imageManager.resetToOriginal(from: user)
        }
        
        dismiss()
    }
    
    func hideKeyboard() {
        focusedField = nil
    }
}

#Preview {
    ProfileSettingView()
}
