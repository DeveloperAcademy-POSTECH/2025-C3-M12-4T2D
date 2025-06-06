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
    @State private var profileImage: UIImage? = nil
    @State private var isDateSelected = false
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var showPhotoPicker = false

    @State private var showImageSourcePicker = false
    
    @State private var isLoadingImage = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
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
    
    private func saveUserInfo() {
        guard let user = users.first else { return }
        
        guard isFormValid else {
            print("유효성 검사 실패")
            return
        }
        
        let remainingDays = targetDate.remainingDaysFromToday
        
        var profileImageData: Data? = nil
        if let image = profileImage {
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
    
    private func loadUserInfo() {
        guard let user = users.first else { return }
        
        nickname = user.nickname
        goal = user.userGoal
        
        if let imageData = user.profileImageData {
            profileImage = UIImage(data: imageData)
        }
        
        // remainingDays를 기반 -> targetDate 계산
        let calendar = Calendar.current
        targetDate = calendar.date(byAdding: .day, value: user.remainingDays, to: Date()) ?? Date()
        isDateSelected = true
    }
    
    private func processSelectedPhoto() {
        Task {
            DispatchQueue.main.async {
                isLoadingImage = true
            }
            
            do {
                if let selectedPhotoItem,
                   let data = try await selectedPhotoItem.loadTransferable(type: Data.self),
                   let image = UIImage(data: data)
                {
                    DispatchQueue.main.async {
                        // 정사각형 크롭
                        let croppedImage = self.cropToSquare(image: image)
                        self.profileImage = croppedImage
                        
                        if let user = users.first,
                           let imageData = croppedImage.jpegData(compressionQuality: 0.8)
                        {
                            SwiftDataManager.updateUserProfileImage(
                                context: modelContext,
                                user: user,
                                profileImageData: imageData
                            )
                        }
                        
                        self.isLoadingImage = false
                        // 선택된 아이템 초기화 (재선택 가능하도록)
                        self.selectedPhotoItem = nil
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = "이미지를 불러올 수 없습니다. 다른이미지를 선택해주세요"
                        self.showErrorAlert = true
                        self.isLoadingImage = false
                        self.selectedPhotoItem = nil
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "이미지 처리 오류 \(error.localizedDescription)"
                    self.showErrorAlert = true
                    self.isLoadingImage = false
                    self.selectedPhotoItem = nil
                }
            }
        }
    }
    
    private func cropToSquare(image: UIImage) -> UIImage {
        let size = min(image.size.width, image.size.height)
        let x = (image.size.width - size) / 2
        let y = (image.size.height - size) / 2
        
        let cropRect = CGRect(x: x, y: y, width: size, height: size)
        
        guard let cgImage = image.cgImage?.cropping(to: cropRect) else {
            return image
        }
        
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }
    
    private func deleteProfileImage() {
        profileImage = nil
        
        if let user = users.first {
            SwiftDataManager.updateUserProfileImage(
                context: modelContext,
                user: user,
                profileImageData: nil
            )
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                profileImageSection
                
                userInfoFields
                
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
            if profileImage != nil {
                Button("사진 삭제", role: .destructive) {
                    deleteProfileImage()
                }
            }
            Button("사진 변경") {
                showPhotoPicker = true
            }
            Button("취소", role: .cancel) {}
        }

        .photosPicker(
            isPresented: $showPhotoPicker,
            selection: $selectedPhotoItem,
            matching: .images
        )
        
        .alert("오류", isPresented: $showErrorAlert) {
            Buㄴtton("확인") {}
        } message: {
            Text(errorMessage)
        }
        .onChange(of: selectedPhotoItem) { newValue in
            if newValue != nil {
                processSelectedPhoto()
            }
        }
    }
    
    private var profileImageSection: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 120, height: 120)
            
            profileImageContent
        }
        .background(
            Circle()
                .fill(.prime1)
                .frame(width: 125, height: 125)
        )
        .overlay(
            cameraButton,
            alignment: .bottomTrailing
        )
        .frame(maxWidth: .infinity, alignment: .center)
        .onTapGesture {
            isPhotoActionSheetPresented = true
        }
    }
    
    @ViewBuilder
    private var profileImageContent: some View {
        if isLoadingImage {
            ProgressView()
                .scaleEffect(1.5)
                .frame(width: 110, height: 110)
        } else if let image = profileImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 110, height: 110)
                .clipShape(Circle())
        } else {
            Image("profile")
                .resizable()
                .scaledToFill()
                .frame(width: 110, height: 110)
                .clipShape(Circle())
        }
    }
    
    private var cameraButton: some View {
        Button(action: {
            if !isLoadingImage {
                isPhotoActionSheetPresented = true
            }
        }) {
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: 30, height: 30)
                
                Image(systemName: isLoadingImage ? "hourglass" : "camera")
                    .foregroundColor(.white)
                    .scaledToFill()
                    .padding(5)
                    .background(Circle().fill(isLoadingImage ? .gray : .prime2))
            }
        }
        .disabled(isLoadingImage)
    }
    
    private var userInfoFields: some View {
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
    ProfileSettingView()
}
