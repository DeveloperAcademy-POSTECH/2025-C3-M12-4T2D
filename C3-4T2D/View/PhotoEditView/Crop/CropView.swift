//
//  CropView.swift
//  C3-4T2D
//
//  Created by Hwang Seyeon on 6/5/25.
//

import SwiftUI

/// 이미지 크롭, 회전, 확대/축소가 가능한 편집 뷰
struct CropView: View {
    // MARK: - 상태 변수
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: CropViewModel
    
    // MARK: - 전달받은 인자
    private let image: UIImage
    private let configuration: CropConfiguration
    private let onComplete: (UIImage?) -> Void

    // MARK: - 초기화
    init(
        image: UIImage,
        configuration: CropConfiguration,
        onComplete: @escaping (UIImage?) -> Void
    ) {
        self.image = image
        self.configuration = configuration
        self.onComplete = onComplete
        _viewModel = StateObject(
            wrappedValue: CropViewModel(
                maskRadius: configuration.maskRadius,
                maxMagnificationScale: configuration.maxMagnificationScale,
                rectAspectRatio: configuration.rectAspectRatio
            )
        )
    }

    // MARK: - 메인 뷰
    var body: some View {
        ZStack {
            configuration.colors.background.ignoresSafeArea()
            
            // 배경 이미지 편집 영역
            imageEditingArea
            
            //   상단 버튼들을 최상위 레이어로 분리
            VStack {
                topControlBar
                    .zIndex(1000)  // 최상위 레이어로 설정
                
                Spacer()
                
                bottomControlBar
                    .zIndex(1000)  // 최상위 레이어로 설정
            }
        }
        .onAppear {
            print("  CropView 표시됨")
        }
    }

    // MARK: - 상단 컨트롤 바
    private var topControlBar: some View {
        HStack {
            // 취소/다시 촬영 버튼
            Button(action: {
                print("  다시 촬영/취소 버튼 클릭")
                onComplete(nil)
            }) {
                HStack(spacing: 6) {
                    if configuration.texts.cancelButton != "취소" {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 14, weight: .medium))
                    }
                    Text(configuration.texts.cancelButton ?? "다시 촬영")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.black.opacity(0.7))
                .cornerRadius(20)
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
            
            // 완료 버튼
            Button(action: {
                print("💾 완료 버튼 클릭")
                saveCroppedImage()
            }) {
                HStack(spacing: 6) {
                    Text(configuration.texts.saveButton ?? "완료")
                        .font(.system(size: 16, weight: .bold))
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                }
                .foregroundColor(.black)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.white)
                .cornerRadius(25)
            }
            .buttonStyle(PlainButtonStyle())  //   버튼 스타일 명시적 설정
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .background(Color.clear)  // 배경 명시적 설정
    }

    // MARK: - 이미지 편집 영역
    private var imageEditingArea: some View {
        ZStack {
            // 배경 이미지 (반투명)
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .rotationEffect(viewModel.angle)
                .scaleEffect(viewModel.scale)
                .offset(viewModel.offset)
                .opacity(0.3)
                .overlay(
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                viewModel.updateMaskDimensions(for: geometry.size)
                            }
                    }
                )
            
            // 크롭 마스크가 적용된 이미지
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .rotationEffect(viewModel.angle)
                .scaleEffect(viewModel.scale)
                .offset(viewModel.offset)
                .mask(
                    Rectangle()
                        .frame(width: viewModel.maskSize.width, height: viewModel.maskSize.height)
                )
            
            // 크롭 영역 테두리
            Rectangle()
                .stroke(Color.white, lineWidth: 2)
                .frame(width: viewModel.maskSize.width, height: viewModel.maskSize.height)
                .overlay(
                    // 3x3 그리드 가이드라인
                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(Color.white.opacity(0.3))
                            .frame(height: 1)
                        Spacer()
                        Rectangle()
                            .fill(Color.white.opacity(0.3))
                            .frame(height: 1)
                        Spacer()
                    }
                    .overlay(
                        HStack {
                            Spacer()
                            Rectangle()
                                .fill(Color.white.opacity(0.3))
                                .frame(width: 1)
                            Spacer()
                            Rectangle()
                                .fill(Color.white.opacity(0.3))
                                .frame(width: 1)
                            Spacer()
                        }
                    )
                )
        }
        .simultaneousGesture(magnificationGesture)
        .simultaneousGesture(dragGesture)
        .padding(.top, 80)  //   상단 버튼 공간 확보
        .padding(.bottom, 100)  //   하단 버튼 공간 확보
    }

    // MARK: - 하단 컨트롤 바
    private var bottomControlBar: some View {
        HStack {
            Spacer()
            
            // 회전 버튼
            Button(action: rotate90Degrees) {
                VStack(spacing: 4) {
                    Image(systemName: "rotate.right")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text("회전")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding()
            }
            .buttonStyle(PlainButtonStyle())  //   버튼 스타일 명시적 설정
            
            Spacer()
        }
        .padding(.bottom, 30)
        .background(Color.clear)  // 배경 명시적 설정
    }

    // MARK: - 제스처 (상단/하단 버튼 영역 제외)
    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let sensitivity = 0.5 * configuration.zoomSensitivity
                let scaled = (value.magnitude - 1) * sensitivity + 1
                let bounds = viewModel.calculateMagnificationGestureMaxValues()
                viewModel.scale = min(max(scaled * viewModel.lastScale, bounds.0), bounds.1)
                updateOffset()
            }
            .onEnded { _ in
                viewModel.lastScale = viewModel.scale
                viewModel.lastOffset = viewModel.offset
            }
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let bounds = viewModel.calculateDragGestureMax()
                let newX = min(max(value.translation.width + viewModel.lastOffset.width, -bounds.x), bounds.x)
                let newY = min(max(value.translation.height + viewModel.lastOffset.height, -bounds.y), bounds.y)
                viewModel.offset = CGSize(width: newX, height: newY)
            }
            .onEnded { _ in
                viewModel.lastOffset = viewModel.offset
            }
    }

    // MARK: - Helper Methods
    private func updateOffset() {
        let bounds = viewModel.calculateDragGestureMax()
        let newX = min(max(viewModel.offset.width, -bounds.x), bounds.x)
        let newY = min(max(viewModel.offset.height, -bounds.y), bounds.y)
        viewModel.offset = CGSize(width: newX, height: newY)
        viewModel.lastOffset = viewModel.offset
    }

    private func cropImage() -> UIImage? {
        var editedImage = image
        
        // 회전 적용
        if configuration.rotateImage,
           let rotated = viewModel.rotate(editedImage, viewModel.lastAngle) {
            editedImage = rotated
        }
        
        // 크롭 적용
        return viewModel.cropToRectangle(editedImage, displayedImageSize: viewModel.imageSizeInView)
    }

    private func saveCroppedImage() {
        print("💾 편집 완료 처리 시작")
        let croppedImage = cropImage()
        
        if let croppedImage = croppedImage {
            print("   크롭 성공: \(croppedImage.size)")
        } else {
            print("    크롭 실패")
        }
        
        onComplete(croppedImage)
    }

    private func rotate90Degrees() {
        withAnimation(.easeInOut(duration: 0.3)) {
            let ninety = Angle.degrees(90)
            viewModel.angle += ninety
            viewModel.lastAngle = viewModel.angle
        }
        print("🔄 이미지 90도 회전")
    }
}

#if DEBUG
struct CropView_Previews: PreviewProvider {
    static var previews: some View {
        CropView(
            image: UIImage(named: "tmpImage") ?? UIImage(systemName: "photo") ?? UIImage(),
            configuration: CropConfiguration(rotateImage: true),
            onComplete: { _ in }
        )
    }
}
#endif
