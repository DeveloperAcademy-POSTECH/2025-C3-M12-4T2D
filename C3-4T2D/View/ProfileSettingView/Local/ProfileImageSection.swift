//
//  ProfileImageSection.swift
//  C3-4T2D
//
//  Created by bishoe on 6/7/25.
//

import SwiftUI

struct ProfileImageSection: View {
    let profileImage: UIImage?
    let isLoadingImage: Bool
    let onTap: () -> Void
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 120, height: 120)
            
            profileImageContent
        }
        .background(
            Circle()
                .fill(.prime1)
                .frame(width: 130, height: 130)
        )
        .overlay(
            cameraButton,
            alignment: .bottomTrailing
        )
        .frame(maxWidth: .infinity, alignment: .center)
        .onTapGesture {
            onTap()
        }
    }
    
    @ViewBuilder
    private var profileImageContent: some View {
        if isLoadingImage {
            ProgressView()
                .scaleEffect(1.5)
                .frame(width: 120, height: 120)
        } else if let image = profileImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
        } else {
            Image("profile")
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
        }
    }
    
    private var cameraButton: some View {
        Button(action: {
            if !isLoadingImage {
                onTap()
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
                    .background(Circle().fill(isLoadingImage ? .gray1 : .prime2))
            }
        }
        .disabled(isLoadingImage)
    }
}

#Preview {
    ProfileImageSection(
        profileImage: nil,
        isLoadingImage: false,
        onTap: {}
    )
}
