//
//  ProfileImageManager.swift
//  C3-4T2D
//
//  Created by bishoe on 6/7/25.
//

import SwiftUI
import PhotosUI
import SwiftData

class ProfileImageManager: ObservableObject {
    @Published var profileImage: UIImage? = nil
    @Published var isLoadingImage = false
    @Published var showErrorAlert = false
    @Published var errorMessage = ""
    @Published var selectedPhotoItem: PhotosPickerItem? = nil
    @Published var hasImageChanged = false
    
    private var originalImageData: Data? = nil
    
    func processSelectedPhoto() {
        Task {
            DispatchQueue.main.async {
                self.isLoadingImage = true
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
                        self.hasImageChanged = true
                        
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
    
    func deleteProfileImage() {
        profileImage = nil
        hasImageChanged = true
    }
    
    func loadUserProfileImage(from user: User) {
        originalImageData = user.profileImageData
        if let imageData = user.profileImageData {
            profileImage = UIImage(data: imageData)
        } else {
            profileImage = nil
        }
        hasImageChanged = false
    }
    
    func resetToOriginal(from user: User) {
        loadUserProfileImage(from: user)
    }
    
    func saveImageChanges(users: [User], modelContext: ModelContext) {
        guard hasImageChanged, let user = users.first else { return }
        
        var imageData: Data? = nil
        if let image = profileImage {
            imageData = image.jpegData(compressionQuality: 0.8)
        }
        
        SwiftDataManager.updateUserProfileImage(
            context: modelContext,
            user: user,
            profileImageData: imageData
        )
        
        originalImageData = imageData
        hasImageChanged = false
    }
}
