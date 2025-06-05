//
//  CropConfiguration.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 6/5/25.
//

import CoreGraphics
import SwiftUI

/// `CropConfiguration`는 자르기 동작에 대한 구성을 정의하는 구조체입니다.
public struct CropConfiguration {
    /// 이미지 확대 최대 배율
    public let maxMagnificationScale: CGFloat
    /// 마스크 반경
    public let maskRadius: CGFloat
    /// 원형 자르기 옵션
    public let cropImageCircular: Bool
    /// 이미지 회전 가능 여부
    public let rotateImage: Bool
    /// 줌 감도
    public let zoomSensitivity: CGFloat
    /// 사각형 마스크를 사용할 때의 가로 세로 비율
    public let rectAspectRatio: CGFloat
    /// 텍스트 설정
    public let texts: Texts
    /// 폰트 설정
    public let fonts: Fonts
    /// 색상 설정
    public let colors: Colors

    /// 텍스트 관련 설정 구조체
    public struct Texts {
        /// 초기화 메서드
        /// - Parameters:
        ///   - cancelButton: 취소 버튼 텍스트 (기본값: nil)
        ///   - interactionInstructions: 상호작용 안내 텍스트 (기본값: nil)
        ///   - saveButton: 저장 버튼 텍스트 (기본값: nil)
        public init(
            // We cannot use the localized values here because module access is not given in init
            cancelButton: String? = nil,
            interactionInstructions: String? = nil,
            saveButton: String? = nil
        ) {
            self.cancelButton = cancelButton
            self.interactionInstructions = interactionInstructions
            self.saveButton = saveButton
        }

        /// 취소 버튼 텍스트
        public let cancelButton: String?
        /// 상호작용 안내 텍스트
        public let interactionInstructions: String?
        /// 저장 버튼 텍스트
        public let saveButton: String?
    }

    /// 폰트 관련 설정 구조체
    public struct Fonts {
        /// 초기화 메서드
        /// - Parameters:
        ///   - cancelButton: 취소 버튼 폰트 (기본값: nil)
        ///   - interactionInstructions: 상호작용 안내 폰트 (기본값: 시스템 16pt 정규)
        ///   - saveButton: 저장 버튼 폰트 (기본값: nil)
        public init(
            cancelButton: Font? = nil,
            interactionInstructions: Font? = nil,
            saveButton: Font? = nil
        ) {
            self.cancelButton = cancelButton
            self.interactionInstructions = interactionInstructions ?? .system(size: 16, weight: .regular)
            self.saveButton = saveButton
        }

        /// 취소 버튼 폰트
        public let cancelButton: Font?
        /// 상호작용 안내 폰트
        public let interactionInstructions: Font
        /// 저장 버튼 폰트
        public let saveButton: Font?
    }

    /// 색상 관련 설정 구조체
    public struct Colors {
        /// 초기화 메서드
        /// - Parameters:
        ///   - cancelButton: 취소 버튼 색상 (기본값: 흰색)
        ///   - interactionInstructions: 상호작용 안내 색상 (기본값: 흰색)
        ///   - saveButton: 저장 버튼 색상 (기본값: 흰색)
        ///   - background: 배경 색상 (기본값: 검은색)
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

        /// 취소 버튼 색상
        public let cancelButton: Color
        /// 상호작용 안내 색상
        public let interactionInstructions: Color
        /// 저장 버튼 색상
        public let saveButton: Color
        /// 배경 색상
        public let background: Color
    }

    /// `CropConfiguration`의 새 인스턴스를 생성합니다.
    ///
    /// - Parameters:
    ///   - maxMagnificationScale: 자르는 동안 이미지가 확대될 수 있는 최대 배율입니다.
    ///                            기본값은 `4.0`입니다.
    ///   - maskRadius: 자르기에 사용되는 마스크의 반경입니다.
    ///                            기본값은 `130`입니다.
    ///   - cropImageCircular: 원형 자르기 옵션을 활성화합니다.
    ///                            기본값은 `false`입니다.
    ///   - rotateImage: 이미지 회전 옵션을 활성화합니다.
    ///                            기본값은 `false`입니다.
    ///   - zoomSensitivity: 줌 감도입니다. 기본값은 `1.0`이며, 값을 줄이면 감도가 증가합니다.
    ///
    ///   - rectAspectRatio: `.rectangle` 마스크 모양을 사용할 때의 가로 세로 비율입니다. 기본값은 `5:4`입니다.
    ///
    ///   - texts: 자르기 뷰에 사용자 정의 텍스트를 사용할 때의 `Texts` 객체입니다.
    ///
    ///   - fonts: 자르기 뷰에 사용자 정의 폰트를 사용할 때의 `Fonts` 객체입니다. 기본값은 시스템 폰트입니다.
    ///
    ///   - colors: 자르기 뷰에 사용자 정의 색상을 사용할 때의 `Colors` 객체입니다. 기본값은 흰색 텍스트와 검은색 배경입니다.
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
