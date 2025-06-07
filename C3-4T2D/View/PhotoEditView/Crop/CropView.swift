//
//  CropView.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 6/5/25.
//

import SwiftUI

struct CropView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: CropViewModel
    @State private var manualAngle: Angle = .zero

    private let image: UIImage
    private let configuration: CropConfiguration
    private let onComplete: (UIImage?) -> Void
    private let localizableTableName: String

    /// CropView의 초기화 메서드입니다.
    /// - Parameters:
    ///   - image: 자르기 대상 UIImage
    ///   - configuration: 자르기 동작에 대한 설정값을 담고 있는 CropConfiguration 객체
    ///   - onComplete: 자르기 작업이 끝났을 때 호출되는 클로저 (잘린 UIImage 또는 nil 반환)
    init(
        image: UIImage,
        configuration: CropConfiguration,
        onComplete: @escaping (UIImage?) -> Void
    ) {
        self.image = image
        self.configuration = configuration
        self.onComplete = onComplete
        // CropViewModel을 StateObject로 초기화합니다.
        _viewModel = StateObject(
            wrappedValue: CropViewModel(
                maskRadius: configuration.maskRadius,
                maxMagnificationScale: configuration.maxMagnificationScale,
//                maskShape: .rectangle,
                rectAspectRatio: configuration.rectAspectRatio
            )
        )
        localizableTableName = "Localizable"
    }

    var body: some View {
        // MARK: - 제스처 정의 (확대/축소, 드래그, 회전)

        // 확대/축소 제스처
        let magnificationGesture = MagnificationGesture()
            .onChanged { value in
                let sensitivity: CGFloat = 0.5 * configuration.zoomSensitivity
                let scaledValue = (value.magnitude - 1) * sensitivity + 1

                let maxScaleValues = viewModel.calculateMagnificationGestureMaxValues()
                viewModel.scale = min(max(scaledValue * viewModel.lastScale, maxScaleValues.0), maxScaleValues.1)

                updateOffset()
            }
            .onEnded { _ in
                viewModel.lastScale = viewModel.scale
                viewModel.lastOffset = viewModel.offset
            }

        // 드래그 제스처
        let dragGesture = DragGesture()
            .onChanged { value in
                let maxOffsetPoint = viewModel.calculateDragGestureMax()
                let newX = min(
                    max(value.translation.width + viewModel.lastOffset.width, -maxOffsetPoint.x),
                    maxOffsetPoint.x
                )
                let newY = min(
                    max(value.translation.height + viewModel.lastOffset.height, -maxOffsetPoint.y),
                    maxOffsetPoint.y
                )
                viewModel.offset = CGSize(width: newX, height: newY)
            }
            .onEnded { _ in
                viewModel.lastOffset = viewModel.offset
            }


        // MARK: - 뷰 레이아웃 구조

        VStack {
            HStack {
                // 취소 버튼
                Button {
                    dismiss()
                } label: {
                    Text(
                        configuration.texts.cancelButton ??
                            NSLocalizedString("cancel", tableName: localizableTableName, bundle: .main, comment: "")
                    )
                    .padding()
                    .font(configuration.fonts.cancelButton)
                    .foregroundColor(configuration.colors.cancelButton)
                }
                .padding()

                Spacer()

                // 저장(크롭) 버튼
                Button {
                    if let cropped = cropImage() {
                        // Save to user's photo library
                        UIImageWriteToSavedPhotosAlbum(cropped, nil, nil, nil)
                        onComplete(cropped)
                    } else {
                        onComplete(nil)
                    }
                    dismiss()
                } label: {
                    Text(
                        configuration.texts.saveButton ??
                            NSLocalizedString("완료", tableName: localizableTableName, bundle: .main, comment: "")
                    )
                    .padding()
                    .font(configuration.fonts.saveButton)
                    .foregroundColor(configuration.colors.saveButton)
                }
                .padding()
            }
            .frame(maxWidth: .infinity, alignment: .bottom)

            // 이미지와 마스크 오버레이, 버튼 영역
            ZStack {
                // MARK: - 이미지 표시 및 오버레이(마스크 영역 표시)

                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(viewModel.angle)
                    .scaleEffect(viewModel.scale)
                    .offset(viewModel.offset)
                    .opacity(0.5)
                    .overlay(
                        // GeometryReader를 통해 실제 이미지 표시 영역의 사이즈를 얻어 마스크 크기 업데이트
                        GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    viewModel.updateMaskDimensions(for: geometry.size)
                                }
                        }
                    )

                // 마스크 모양으로 실제 이미지 영역을 표시 (마스크 영역 외에는 가려짐)
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .rotationEffect(viewModel.angle)
                        .scaleEffect(viewModel.scale)
                        .offset(viewModel.offset)
                        .mask(
                            // 마스크 뷰를 오버레이로 적용
                            MaskShapeView()
                                .frame(width: viewModel.maskSize.width, height: viewModel.maskSize.height)
                        )

                    // White border overlay
                    MaskShapeView()
                        .stroke(Color.white, lineWidth: 2)
                        .frame(width: viewModel.maskSize.width, height: viewModel.maskSize.height)
                }

                // MARK: - 하단 버튼 영역 (취소/저장)

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            rotate90Degrees()
                        } label: {
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            // 이미지에 제스처(확대, 드래그) 동시 적용
            .simultaneousGesture(magnificationGesture)
            .simultaneousGesture(dragGesture)
        }
        .background(configuration.colors.background)
    }

    // MARK: - 오프셋 값 보정(최대/최소 범위 내로 제한)

    private func updateOffset() {
        let maxOffsetPoint = viewModel.calculateDragGestureMax()
        let newX = min(max(viewModel.offset.width, -maxOffsetPoint.x), maxOffsetPoint.x)
        let newY = min(max(viewModel.offset.height, -maxOffsetPoint.y), maxOffsetPoint.y)
        viewModel.offset = CGSize(width: newX, height: newY)
        viewModel.lastOffset = viewModel.offset
    }

    // MARK: - 실제 크롭(자르기) 로직

    /// 현재 상태(회전 포함)에서 이미지를 잘라 반환합니다.
    private func cropImage() -> UIImage? {
        var editedImage: UIImage = image
        // 회전 옵션이 활성화된 경우, 이미지를 현재 각도로 회전
        if configuration.rotateImage {
            if let rotatedImage: UIImage = viewModel.rotate(
                editedImage,
                viewModel.lastAngle
            ) {
                editedImage = rotatedImage
            }
        }
        // 마스크 영역 기준으로 이미지를 크롭
        return viewModel.cropToRectangle(editedImage, displayedImageSize: viewModel.imageSizeInView)
    }

    private func rotate90Degrees() {
        let ninetyDegrees = Angle.degrees(90)
        viewModel.angle += ninetyDegrees
        viewModel.lastAngle = viewModel.angle
    }

    // MARK: - 마스크 뷰 구조체

    /// 실제 마스크 모양을 그리는 뷰입니다. (현재는 사각형만 지원)
    private struct MaskShapeView: Shape {
        func path(in rect: CGRect) -> Path {
            return Path { path in
                path.addRect(rect)
            }
        }
    }
}

#if DEBUG
import SwiftUI

struct CropView_Previews: PreviewProvider {
    static var previews: some View {
        CropView(
            image: UIImage(named: "tmpImage") ?? UIImage(systemName: "photo") ?? UIImage(),
            configuration: CropConfiguration(
                maxMagnificationScale: 5,
                maskRadius: 150,
                cropImageCircular: false,
                rotateImage: true,
                zoomSensitivity: 1.0,
                rectAspectRatio: 5.0 / 4.0,
                texts: .init(),
                fonts: .init(),
                colors: .init()
            ),
            onComplete: { _ in }
        )
    }
}
#endif
