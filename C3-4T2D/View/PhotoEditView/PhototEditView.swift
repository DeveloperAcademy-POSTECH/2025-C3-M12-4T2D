//
//  PhototEditView.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 6/3/25.
//

import SwiftUI

/// `PhotoEditView`는 이미지를 자르기 위한 SwiftUI 뷰입니다.
///
/// 이 뷰는 사용자가 이미지를 원하는 비율로 자를 수 있도록 도와줍니다.
/// `CropConfiguration` 인스턴스를 통해 자르기 동작을 세밀하게 설정할 수 있으며,
/// 작업이 완료되면 결과 이미지를 반환하는 클로저를 통해 결과를 전달받을 수 있습니다.
///
/// - 목적:
///   이미지를 지정한 마스크 모양(기본: 사각형)과 비율로 자를 수 있도록 UI를 제공합니다.
///
/// - 초기화 파라미터 설명:
///   - imageToCrop: 자르기 대상이 되는 UIImage 객체입니다.
///   - configuration: 자르기 동작에 대한 설정값을 담고 있는 CropConfiguration 객체입니다. (지정하지 않으면 기본값 사용)
///   - onComplete: 자르기 작업이 끝났을 때 호출되는 클로저입니다. 잘린 UIImage를 반환하며, 오류가 발생하면 nil을 반환합니다.
///
/// - body 내용 설명:
///   CropView를 사용하여 실제 자르기 UI를 구현합니다. 내부적으로 전달받은 이미지, 마스크 모양, 설정값, 완료 클로저를 CropView에 전달합니다.
public struct PhotoEditView: View {
    public let imageToCrop: UIImage
//    private let maskShape: MaskShape = .rectangle
    private let configuration: CropConfiguration
    private let onComplete: (UIImage?) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var manualAngle: Angle = .zero

    public init(
        imageToCrop: UIImage,
        configuration: CropConfiguration = CropConfiguration(rectAspectRatio: 5.0 / 4.0),
        onComplete: @escaping (UIImage?) -> Void
    ) {
        self.imageToCrop = imageToCrop
        self.configuration = configuration
        self.onComplete = onComplete
        
        print("🖼 imageToCrop size: \(imageToCrop.size)")
    }

    private func rotate90Degrees() {
        // Assuming CropView has a viewModel with angle and lastAngle properties that can be updated
        // Since we don't have direct access here, this function would ideally communicate with CropView's viewModel.
        // Here is a placeholder for the logic:
        // viewModel.angle += .degrees(90)
        // viewModel.lastAngle += .degrees(90)
    }

    public var body: some View {
        VStack {
            // Fallback visual check for debugging
            if imageToCrop.size != .zero {
                Image(uiImage: imageToCrop)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Text("❌ 유효하지 않은 이미지입니다.")
                    .foregroundColor(.red)
            }

            CropView(
                image: imageToCrop,
//                maskShape: maskShape,
                configuration: configuration,
                onComplete: onComplete
            )
            HStack {
                Spacer()
                Button(action: {
                    rotate90Degrees()
                }) {
                    Image(systemName: "rotate.right")
                        .font(.title)
                        .padding()
                }
                Spacer()
            }
            // The cancel/save buttons would presumably be below this HStack in the actual UI
        }
    }
}
