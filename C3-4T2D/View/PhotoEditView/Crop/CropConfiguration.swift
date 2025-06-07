//
//  CropConfiguration.swift
//  C3-4T2D
//
//  Created by Hwang Seyeon on 6/5/25.
//

import CoreGraphics
import SwiftUI

/// 자르기 동작을 구성하는 설정 구조체
public struct CropConfiguration {
    // MARK: - 기본 설정

    public let maxMagnificationScale: CGFloat // 이미지 최대 확대 배율
    public let maskRadius: CGFloat // 마스크 반경
    public let cropImageCircular: Bool // 원형 자르기 여부
    public let rotateImage: Bool // 이미지 회전 가능 여부
    public let zoomSensitivity: CGFloat // 줌 감도 (값이 작을수록 민감함)
    public let rectAspectRatio: CGFloat // 사각형 마스크 비율 (예: 5:4)

    // MARK: - 사용자 지정 UI

    public let texts: Texts
    public let fonts: Fonts
    public let colors: Colors

    // MARK: - 텍스트 설정

    public struct Texts {
        public let cancelButton: String? // 취소 버튼 텍스트
        public let interactionInstructions: String? // 안내 텍스트
        public let saveButton: String? // 저장 버튼 텍스트

        public init(
            cancelButton: String? = nil,
            interactionInstructions: String? = nil,
            saveButton: String? = nil
        ) {
            self.cancelButton = cancelButton
            self.interactionInstructions = interactionInstructions
            self.saveButton = saveButton
        }
    }

    // MARK: - 폰트 설정

    public struct Fonts {
        public let cancelButton: Font? // 취소 버튼 폰트
        public let interactionInstructions: Font // 안내 텍스트 폰트
        public let saveButton: Font? // 저장 버튼 폰트

        public init(
            cancelButton: Font? = nil,
            interactionInstructions: Font? = nil,
            saveButton: Font? = nil
        ) {
            self.cancelButton = cancelButton
            self.interactionInstructions = interactionInstructions ?? .system(size: 16, weight: .regular)
            self.saveButton = saveButton
        }
    }

    // MARK: - 색상 설정

    public struct Colors {
        public let cancelButton: Color // 취소 버튼 색상
        public let interactionInstructions: Color // 안내 텍스트 색상
        public let saveButton: Color // 저장 버튼 색상
        public let background: Color // 배경 색상

        public init(
            cancelButton: Color = .white,
            interactionInstructions: Color = .white,
            saveButton: Color = .white,
            background: Color = .black
        ) {
            self.cancelButton = cancelButton
            self.interactionInstructions = interactionInstructions
            self.saveButton = saveButton
            self.background = background
        }
    }

    // MARK: - 초기화

    public init(
        maxMagnificationScale: CGFloat = 4.0,
        maskRadius: CGFloat = 130,
        cropImageCircular: Bool = false,
        rotateImage: Bool = false,
        zoomSensitivity: CGFloat = 1,
        rectAspectRatio: CGFloat = 5.0 / 4.0,
        texts: Texts = Texts(),
        fonts: Fonts = Fonts(),
        colors: Colors = Colors()
    ) {
        self.maxMagnificationScale = maxMagnificationScale
        self.maskRadius = maskRadius
        self.cropImageCircular = cropImageCircular
        self.rotateImage = rotateImage
        self.zoomSensitivity = zoomSensitivity
        self.rectAspectRatio = rectAspectRatio
        self.texts = texts
        self.fonts = fonts
        self.colors = colors
    }
}
