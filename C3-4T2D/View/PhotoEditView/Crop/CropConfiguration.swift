//
//  CropConfiguration.swift
//  C3-4T2D
//
//  Created by Hwang Seyeon on 6/5/25.
//

import CoreGraphics
import SwiftUI

/// 이미지 크롭 뷰의 동작과 스타일을 구성하는 설정
public struct CropConfiguration {
    // MARK: - 기본 설정
    public let maxMagnificationScale: CGFloat // 최대 확대 배율
    public let maskRadius: CGFloat // 마스크 반경 (원형 크롭용)
    public let cropImageCircular: Bool // 원형 크롭 여부
    public let rotateImage: Bool // 회전 기능 활성화
    public let zoomSensitivity: CGFloat // 줌 감도
    public let rectAspectRatio: CGFloat // 크롭 영역 비율

    // MARK: - UI 커스터마이징
    public let texts: Texts
    public let fonts: Fonts
    public let colors: Colors

    // MARK: - 텍스트 설정
    public struct Texts {
        public let cancelButton: String?
        public let interactionInstructions: String?
        public let saveButton: String?

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
        public let cancelButton: Font?
        public let interactionInstructions: Font
        public let saveButton: Font?

        public init(
            cancelButton: Font? = nil,
            interactionInstructions: Font? = nil,
            saveButton: Font? = nil
        ) {
            self.cancelButton = cancelButton ?? .system(size: 16, weight: .medium)
            self.interactionInstructions = interactionInstructions ?? .system(size: 16, weight: .regular)
            self.saveButton = saveButton ?? .system(size: 16, weight: .bold)
        }
    }

    // MARK: - 색상 설정
    public struct Colors {
        public let cancelButton: Color
        public let interactionInstructions: Color
        public let saveButton: Color
        public let background: Color

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
        rotateImage: Bool = true,
        zoomSensitivity: CGFloat = 1.0,
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

// MARK: - 편의 생성자들
public extension CropConfiguration {
    /// 기본 설정으로 빠른 생성
    static var `default`: CropConfiguration {
        CropConfiguration()
    }
    
    /// 정사각형 크롭용 설정
    static var square: CropConfiguration {
        CropConfiguration(rectAspectRatio: 1.0)
    }
    
    /// 16:9 비율 크롭용 설정
    static var widescreen: CropConfiguration {
        CropConfiguration(rectAspectRatio: 16.0 / 9.0)
    }
}
