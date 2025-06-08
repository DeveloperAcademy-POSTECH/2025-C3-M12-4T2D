//
//  CameraEditTestView.swift
//  C3-4T2D
//
//  Created by Assistant on 6/8/25.
//

import SwiftUI

/// 카메라-편집 기능 통합 테스트용 뷰
struct CameraEditTestView: View {
    @State private var showCameraEdit = false
    @State private var resultImage: UIImage?
    @State private var testLog: [String] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                headerSection
                imagePreviewSection
                controlButtonsSection
                logSection
                
                Spacer()
            }
            .padding()
            .navigationTitle("카메라 테스트")
            .navigationBarTitleDisplayMode(.inline)
        }
        .fullScreenCover(isPresented: $showCameraEdit) {
            CameraEditView { editedImage in
                handleImageResult(editedImage)
            }
        }
    }
    
    // MARK: - View Components
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("📷 ✂️ 통합 카메라-편집 테스트")
                .font(.title2.bold())
                .multilineTextAlignment(.center)
            
            Text("촬영 → 즉시 편집 → 완료")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
    
    private var imagePreviewSection: some View {
        VStack(spacing: 12) {
            if let image = resultImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.green, lineWidth: 2)
                    )
                
                Text("✅ 편집 완료!")
                    .foregroundColor(.green)
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(8)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 200)
                    .overlay(
                        VStack {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            Text("이미지 없음")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        }
                    )
            }
        }
    }
    
    private var controlButtonsSection: some View {
        VStack(spacing: 12) {
            Button(action: startCameraEdit) {
                HStack {
                    Image(systemName: "camera.fill")
                        .font(.headline)
                    Text("카메라 + 편집 시작")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    LinearGradient(
                        colors: [Color.blue, Color.blue.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
            }
            
            if resultImage != nil {
                Button(action: clearResult) {
                    HStack {
                        Image(systemName: "trash.fill")
                            .font(.headline)
                        Text("결과 삭제")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.red)
                    .cornerRadius(12)
                }
            }
        }
    }
    
    private var logSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("📝 테스트 로그")
                    .font(.headline)
                Spacer()
                if !testLog.isEmpty {
                    Button("클리어") {
                        testLog.removeAll()
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
            }
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 4) {
                    ForEach(Array(testLog.enumerated()), id: \.offset) { index, log in
                        HStack {
                            Text("[\(index + 1)]")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(log)
                                .font(.caption)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(6)
                    }
                }
            }
            .frame(maxHeight: 120)
            .background(Color.gray.opacity(0.05))
            .cornerRadius(8)
        }
    }
    
    // MARK: - Actions
    private func startCameraEdit() {
        addLog("🚀 카메라-편집 시작")
        showCameraEdit = true
    }
    
    private func clearResult() {
        resultImage = nil
        addLog("🗑 결과 이미지 삭제")
    }
    
    private func handleImageResult(_ image: UIImage?) {
        if let image = image {
            resultImage = image
            addLog("✅ 이미지 편집 완료 - 크기: \(image.size)")
        } else {
            addLog("❌ 편집 취소됨")
        }
    }
    
    private func addLog(_ message: String) {
        let timestamp = DateFormatter.logFormatter.string(from: Date())
        testLog.append("\(timestamp) \(message)")
    }
}

// MARK: - Extensions
private extension DateFormatter {
    static let logFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
}

#Preview {
    CameraEditTestView()
}
