//
//  CropView.swift
//  C3-4T2D
//
//  Created by Hwang Seyeon on 6/5/25.
//

import SwiftUI

/// 사용자가 이미지를 회전, 확대, 이동, 크롭할 수 있는 뷰입니다.
/// CropConfiguration을 기반으로 동작과 스타일이 구성됩니다.
struct CropView: View {
    // MARK: - 환경 및 상태 변수
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: CropViewModel
    @State private var manualAngle: Angle = .zero

    // MARK: - 전달받은 인자
    private let image: UIImage
    private let configuration: CropConfiguration
    private let onComplete: (UIImage?) -> Void
    private let localizableTableName = "Localizable"

    // MARK: - 초기화 메서드
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

    // MARK: - 바디 뷰
    var body: some View {
        VStack {
            topBar    // 상단 취소/완료 버튼 영역
            cropArea  // 이미지 조작 및 마스크 영역
        }
        .background(configuration.colors.background)
    }

    // MARK: - 상단 바 (취소 / 완료)
    private var topBar: some View {
        HStack {
            // 취소 버튼
            Button(action: { dismiss() }) {
                Text(configuration.texts.cancelButton ??
                     NSLocalizedString("cancel", tableName: localizableTableName, bundle: .main, comment: ""))
                    .padding()
                    .font(configuration.fonts.cancelButton)
                    .foregroundColor(configuration.colors.cancelButton)
            }
            Spacer()
            // 완료(저장) 버튼
            Button(action: saveCroppedImage) {
                Text(configuration.texts.saveButton ??
                     NSLocalizedString("완료", tableName: localizableTableName, bundle: .main, comment: ""))
                    .padding()
                    .font(configuration.fonts.saveButton)
                    .foregroundColor(configuration.colors.saveButton)
            }
        }
        .padding()
    }

    // MARK: - 메인 크롭 영역
    private var cropArea: some View {
        ZStack {
            imageLayer     // 반투명 이미지 표시
            maskOverlay    // 마스크를 씌운 실제 자를 이미지 영역
            rotateButton   // 하단 회전 버튼
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .simultaneousGesture(magnificationGesture)
        .simultaneousGesture(dragGesture)
    }

    /// 확대/회전/오프셋이 적용된 이미지 배경
    private var imageLayer: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .rotationEffect(viewModel.angle)
            .scaleEffect(viewModel.scale)
            .offset(viewModel.offset)
            .opacity(0.5)
            .overlay(
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            viewModel.updateMaskDimensions(for: geometry.size)
                        }
                }
            )
    }

    /// 마스크를 적용해 실제 잘리는 영역만 보이게 하는 오버레이
    private var maskOverlay: some View {
        ZStack {
            // 마스크 적용된 이미지
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .rotationEffect(viewModel.angle)
                .scaleEffect(viewModel.scale)
                .offset(viewModel.offset)
                .mask(
                    MaskShapeView()
                        .frame(width: viewModel.maskSize.width, height: viewModel.maskSize.height)
                )
            // 마스크 외곽선 표시
            MaskShapeView()
                .stroke(Color.white, lineWidth: 2)
                .frame(width: viewModel.maskSize.width, height: viewModel.maskSize.height)
        }
    }

    /// 이미지 회전 버튼
    private var rotateButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: rotate90Degrees) {
                    Image(systemName: "rotate.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .padding()
                }
                Spacer()
            }
        }
    }

    // MARK: - 제스처 정의

    /// 핀치 줌 제스처 - 이미지 확대/축소
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

    /// 드래그 제스처 - 이미지 위치 이동
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

    // MARK: - 내부 로직 함수

    /// 오프셋 값을 이동 가능한 최대 범위로 제한함
    private func updateOffset() {
        let bounds = viewModel.calculateDragGestureMax()
        let newX = min(max(viewModel.offset.width, -bounds.x), bounds.x)
        let newY = min(max(viewModel.offset.height, -bounds.y), bounds.y)
        viewModel.offset = CGSize(width: newX, height: newY)
        viewModel.lastOffset = viewModel.offset
    }

    /// 자르기 및 회전 적용 후 결과 이미지 반환
    private func cropImage() -> UIImage? {
        var edited = image
        if configuration.rotateImage,
           let rotated = viewModel.rotate(edited, viewModel.lastAngle) {
            edited = rotated
        }
        return viewModel.cropToRectangle(edited, displayedImageSize: viewModel.imageSizeInView)
    }

    /// 크롭된 이미지를 저장하고 클로저로 전달
    private func saveCroppedImage() {
        if let cropped = cropImage() {
            UIImageWriteToSavedPhotosAlbum(cropped, nil, nil, nil)
            onComplete(cropped)
        } else {
            onComplete(nil)
        }
        dismiss()
    }

    /// 이미지를 90도 회전
    private func rotate90Degrees() {
        let ninety = Angle.degrees(90)
        viewModel.angle += ninety
        viewModel.lastAngle = viewModel.angle
    }

    // MARK: - 마스크 뷰

    /// 마스크로 사용될 도형(현재는 사각형만 지원)
    private struct MaskShapeView: Shape {
        func path(in rect: CGRect) -> Path {
            Path { $0.addRect(rect) }
        }
    }
}

#if DEBUG
/// 미리보기용 CropView 샘플
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
