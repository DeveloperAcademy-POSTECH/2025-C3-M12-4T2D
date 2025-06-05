//
//  CreateView.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 5/29/25.
//

import SwiftUI

struct CreateView: View {
    @State private var showProjectSelector = false
    @State private var isPresentingCamera = false
    @State private var showDatePicker = false

    @State private var projTitle: String = ""
    @State private var descriptionText: String = ""

    @State private var selectedDate = Date()
    @State private var selectedStage: ProcessStage = .idea

    @State private var pickedImage: UIImage?

    var body: some View {
        VStack(spacing: 0) {
            CreateHeader()
                .padding(.bottom, 12)
                .padding(.horizontal, 20)

            ScrollView {
                VStack(spacing: 0) {
                    // 프로젝트명
                    CreateProjTitle(projTitle: $projTitle, showProjectSelector: $showProjectSelector)
                        .padding(.bottom, 20)
                    // 날짜 선택
                    CreateDate(selectedDate: $selectedDate, showDatePicker: $showDatePicker)
                        .padding(.bottom, 20)
                    // 진행 단계
                    CreateProcess(selectedStage: $selectedStage)
                        .padding(.bottom, 20)

                    // 사진 업로드
                    CreatePhoto(isPresentingCamera: $isPresentingCamera)

                    // 메모 입력
                    CreateMemo(descriptionText: $descriptionText)

                    // MARK: - 작성 완료 버튼 (fixed footer)

                    Button(action: {
                        // 작성 완료 동작
                    }) {
                        Text("작성 완료")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color.prime1)
                            .cornerRadius(8)
                    }
                    .padding(.top, 40)
                }
                .padding(.horizontal, 20)
            }
            .scrollDismissesKeyboard(.immediately)
        }
        .fullScreenCover(isPresented: $isPresentingCamera) {
            ZStack {
                Color.black.ignoresSafeArea() // 흰 여백 덮기
                CameraView { image in
                    pickedImage = image
                    isPresentingCamera = false
                }
            }
        }
        .sheet(isPresented: $showProjectSelector) {
            ProjectSelector()
                .presentationDetents([.medium, .large])
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

#Preview {
    CreateView()
}
