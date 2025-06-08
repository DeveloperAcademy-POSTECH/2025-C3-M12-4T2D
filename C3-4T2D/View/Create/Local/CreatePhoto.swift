//
//  CreatePhoto.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 5/30/25.
//
import SwiftUI

struct CreatePhoto: View {
    @Binding var isPresentingCamera: Bool
    @Binding var pickedImage: UIImage?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            //   헤더 라인 - 제목과 메뉴
            HStack {
            Text("진행 과정")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.black)
                .padding(.bottom, 8)
                
                Spacer()
                
                // 이미지가 있을 때만 메뉴 표시
                if pickedImage != nil {
                    Menu {
                        Button(action: {
                            isPresentingCamera = true
                        }) {
                            Label("다시 촬영", systemImage: "camera.fill")
                        }
                        
                        Button(role: .destructive, action: {
                            pickedImage = nil
                        }) {
                            Label("삭제", systemImage: "trash.fill")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                }
            }
            .padding(.bottom, 8)

            //   이미지 컨테이너 - 메뉴로 정리했으니 버튼 영역 제거
            VStack(spacing: 0) {
                if let image = pickedImage {
                    // 이미지가 있을 때 - 컨테이너 안에 완전히 맞춤
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.05))
                        .frame(height: 240)
                        .overlay(
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 220) // 컨테이너보다 약간 작게
                                .cornerRadius(6)
                                .clipped()
                        )
                } else {
                    // 이미지가 없을 때 - 촬영 버튼
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.05))
                        .frame(height: 240)
                        .overlay(
                            Button(action: {
                                isPresentingCamera = true
                            }) {
                                VStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.prime3)
                                            .frame(width: 64, height: 64)
                                        
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 24, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    
                                    Text("사진 촬영하기")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.gray)
                                }
                            }
                        )
                }
            }
            .frame(maxWidth: .infinity)
            //   높이 단순화 (버튼 영역 제거)
            .frame(height: 240)
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        // 이미지 없는 상태
        CreatePhoto(
            isPresentingCamera: .constant(false),
            pickedImage: .constant(nil)
        )
        
        // 이미지 있는 상태 (메뉴 표시됨)
        CreatePhoto(
            isPresentingCamera: .constant(false),
            pickedImage: .constant(UIImage(systemName: "photo.fill"))
        )
    }
    .padding()
}
