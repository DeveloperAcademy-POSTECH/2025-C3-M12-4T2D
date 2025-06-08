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
            Text("진행 과정")
                .font(.title3.weight(.bold))
                .foregroundColor(.black)
                .padding(.bottom, 8)

            // 🔥 고정 높이 컨테이너로 레이아웃 밀림 방지
            VStack(spacing: 0) {
                // 🔥 이미지 영역 - 고정 높이 240px
                ZStack {
                    // 배경 (항상 표시)
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.05))
                        .frame(height: 240)
                    
                    if let image = pickedImage {
                        // 이미지가 있을 때
                        VStack(spacing: 12) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(8)
                                .clipped()
                            
                            // 🔥 버튼들을 별도 영역으로 분리
                            Spacer()
                        }
                    } else {
                        // 이미지가 없을 때
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
                    }
                }
                
                // 🔥 버튼 영역 - 이미지가 있을 때만 표시, 고정 높이
                if pickedImage != nil {
                    HStack(spacing: 12) {
                        // 이미지 변경 버튼
                        Button(action: {
                            isPresentingCamera = true
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 14, weight: .medium))
                                Text("다시 촬영")
                                    .font(.system(size: 14, weight: .medium))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.prime3)
                            .cornerRadius(6)
                        }
                        
                        // 이미지 삭제 버튼
                        Button(action: {
                            pickedImage = nil
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "trash.fill")
                                    .font(.system(size: 14, weight: .medium))
                                Text("삭제")
                                    .font(.system(size: 14, weight: .medium))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.red)
                            .cornerRadius(6)
                        }
                        
                        Spacer()
                    }
                    .frame(height: 40)  // 🔥 버튼 영역 고정 높이
                    .padding(.top, 8)
                } else {
                    // 이미지가 없을 때도 같은 높이 유지
                    Spacer()
                        .frame(height: 48)  // 버튼 영역과 동일한 높이
                }
            }
            .frame(maxWidth: .infinity)
            // 🔥 전체 높이 고정으로 레이아웃 안정성 확보
            .frame(height: 300)  // 고정 높이 설정
        }
    }
}

#Preview {
    VStack {
        CreatePhoto(
            isPresentingCamera: .constant(false),
            pickedImage: .constant(nil)
        )
        
        CreatePhoto(
            isPresentingCamera: .constant(false),
            pickedImage: .constant(UIImage(systemName: "photo"))
        )
    }
    .padding()
}
