//
//  CropViewModel.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 6/5/25.
//

import SwiftUI

class CropViewModel: ObservableObject {
    private let maskRadius: CGFloat
    private let maxMagnificationScale: CGFloat // 이미지 확대를 위한 최대 허용 배율입니다.
//    private let maskShape: MaskShape // 크롭에 사용되는 마스크의 모양입니다.
    private let rectAspectRatio: CGFloat // 직사각형 마스크의 가로 세로 비율입니다. 기본값은 5:4입니다.
    
    var imageSizeInView: CGSize = .zero // 뷰에 표시되는 이미지의 크기입니다.
    @Published var maskSize: CGSize = .zero // 크롭에 사용되는 마스크의 크기입니다. 마스크 모양과 사용 가능한 공간에 따라 업데이트됩니다.
    @Published var scale: CGFloat = 1.0 // 이미지의 현재 확대 배율입니다.
    @Published var lastScale: CGFloat = 1.0 // 이미지의 이전 확대 배율입니다.
    @Published var offset: CGSize = .zero // 이미지의 현재 위치 오프셋입니다.
    @Published var lastOffset: CGSize = .zero // 이미지의 이전 위치 오프셋입니다.
    @Published var angle: Angle = Angle(degrees: 0) // 이미지의 현재 회전 각도입니다.
    @Published var lastAngle: Angle = Angle(degrees: 0) // 이미지의 이전 회전 각도입니다.
    
    init(
        maskRadius: CGFloat,
        maxMagnificationScale: CGFloat,
//        maskShape: MaskShape,
        rectAspectRatio: CGFloat = 5.0 / 4.0
    ) {
        self.maskRadius = maskRadius
        self.maxMagnificationScale = maxMagnificationScale
//        self.maskShape = maskShape
        self.rectAspectRatio = rectAspectRatio
    }
    
    /**
     주어진 크기와 마스크 모양에 따라 마스크 크기를 업데이트합니다.
     - Parameter size: 마스크 크기 계산의 기준이 되는 크기입니다.
     */
    private func updateMaskSize(for size: CGSize) {
        // Only rectangle mask type is supported now.
        let availableWidth = size.width * 0.9
        let width = availableWidth
        let height = width / rectAspectRatio
        maskSize = CGSize(width: width, height: height)
    }
    
    /**
     뷰에 표시되는 이미지 크기에 따라 마스크의 크기를 업데이트합니다.
     - Parameter imageSizeInView: 뷰에 표시되는 이미지의 크기입니다.
     */
    func updateMaskDimensions(for imageSizeInView: CGSize) {
        self.imageSizeInView = imageSizeInView
        updateMaskSize(for: imageSizeInView)
    }
    
    /**
     이미지 드래그 시 허용되는 최대 오프셋 값을 계산합니다.
     - Returns: 최대 x, y 오프셋 값을 CGPoint로 반환합니다.
     */
    func calculateDragGestureMax() -> CGPoint {
        let xLimit = max(0, ((imageSizeInView.width / 2) * scale) - (maskSize.width / 2))
        let yLimit = max(0, ((imageSizeInView.height / 2) * scale) - (maskSize.height / 2))
        return CGPoint(x: xLimit, y: yLimit)
    }
    
    /**
     이미지 확대 시 허용되는 최소 및 최대 배율 값을 계산합니다.
     - Returns: 최소 및 최대 배율 값을 튜플로 반환합니다.
     */
    func calculateMagnificationGestureMaxValues() -> (CGFloat, CGFloat) {
        let minScale = max(maskSize.width / imageSizeInView.width, maskSize.height / imageSizeInView.height)
        return (minScale, maxMagnificationScale)
    }
    
    /**
     현재 마스크 크기와 위치를 기준으로 이미지를 직사각형으로 크롭합니다.
     - Parameter image: 크롭할 UIImage입니다.
     - Returns: 크롭된 UIImage 또는 실패 시 nil을 반환합니다.
     */
    func cropToRectangle(_ image: UIImage, displayedImageSize: CGSize) -> UIImage? {
        let imageSize = image.size

        // 이미지가 화면에 표시된 영역의 크기 대비 실제 픽셀 크기 비율
        let factor = min(
            imageSize.width / displayedImageSize.width,
            imageSize.height / displayedImageSize.height
        )

        // 마스크의 크기를 이미지 픽셀 기준으로 변환
        let centerX = imageSize.width / 2
        let centerY = imageSize.height / 2

        // 이미지 중앙에서 offset을 반영해 crop center 위치 결정
        let cropWidth = (maskSize.width * factor) / scale
        let cropHeight = (maskSize.height * factor) / scale
        
        let offsetX = offset.width * factor / scale
        let offsetY = offset.height * factor / scale


        let cropRect = CGRect(
            x: centerX - cropWidth / 2 - offsetX,
            y: centerY - cropHeight / 2 - offsetY,
            width: cropWidth,
            height: cropHeight
        )

        guard let cgImage = image.cgImage?.cropping(to: cropRect) else { return nil }
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }
    
    
    /**
     지정한 각도로 이미지를 회전합니다.
     - Parameter image: 회전할 UIImage입니다.
     - Parameter angle: 회전할 각도입니다.
     - Returns: 회전된 UIImage 또는 실패 시 nil을 반환합니다.
     */
    func rotate(_ image: UIImage, _ angle: Angle) -> UIImage? {
        guard let orientedImage = image.correctlyOriented,
              let cgImage = orientedImage.cgImage else { return nil }
        
        let ciImage = CIImage(cgImage: cgImage)
        
        guard let filter = CIFilter.straightenFilter(image: ciImage, radians: angle.radians),
              let output = filter.outputImage else { return nil }
        
        let context = CIContext()
        guard let result = context.createCGImage(output, from: output.extent) else { return nil }
        
        return UIImage(cgImage: result)
    }
    
    /**
     현재 마스크 크기, 확대 배율, 오프셋을 기반으로 원본 이미지에서 크롭할 영역을 계산합니다.
     - Parameter orientedImage: 올바른 방향으로 정렬된 UIImage입니다.
     - Returns: 원본 이미지에서 크롭할 CGRect 영역입니다.
     */
    private func calculateCropRect(_ orientedImage: UIImage) -> CGRect {
        let factor = min(
            (orientedImage.size.width / imageSizeInView.width),
            (orientedImage.size.height / imageSizeInView.height)
        )
        let centerInOriginalImage = CGPoint(
            x: orientedImage.size.width / 2,
            y: orientedImage.size.height / 2
        )
        
        let cropSizeInOriginalImage = CGSize(
            width: (maskSize.width * factor) / scale,
            height: (maskSize.height * factor) / scale
        )
        
        let offsetX = offset.width * factor / scale
        let offsetY = offset.height * factor / scale
        
        let cropRectX = (centerInOriginalImage.x - cropSizeInOriginalImage.width / 2) - offsetX
        let cropRectY = (centerInOriginalImage.y - cropSizeInOriginalImage.height / 2) - offsetY
        
        return CGRect(
            origin: CGPoint(x: cropRectX, y: cropRectY),
            size: cropSizeInOriginalImage
        )
    }
}

private extension UIImage {
    /**
     이미지의 방향을 보정한 UIImage 인스턴스입니다.
     만약 이미지 방향이 이미 `.up`이라면 원본을 반환합니다.
     - Returns: 올바른 방향으로 정렬된 UIImage 또는 nil입니다.
     */
    var correctlyOriented: UIImage? {
        if imageOrientation == .up { return self }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
}

private extension CIFilter {
    /**
     CIStraightenFilter를 생성합니다.
     - Parameters:
       - image: 입력으로 사용할 CIImage입니다.
       - radians: 회전할 각도(라디안)입니다.
     - Returns: 생성된 CIFilter 또는 nil입니다.
     */
    static func straightenFilter(image: CIImage, radians: Double) -> CIFilter? {
        let angle: Double = radians != 0 ? -radians : 0
        guard let filter = CIFilter(name: "CIStraightenFilter") else {
            return nil
        }
        filter.setDefaults()
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(angle, forKey: kCIInputAngleKey)
        return filter
    }
}
