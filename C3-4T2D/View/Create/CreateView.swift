//
//  CreateView.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 5/29/25.
//

import SwiftData
import SwiftUI
// 이미지 저장은 swiftdata 연결 아직 전
struct CreateView: View {
    @Environment(\.modelContext) private var context

    @State private var showProjectSelector = false
    @State private var isPresentingCamera = false
    @State private var showDatePicker = false

    @State private var projTitle: String = ""
    @State private var descriptionText: String = ""
    @FocusState private var isFocused: Bool

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
//                    CreatePhoto(isPresentingCamera: $isPresentingCamera)
                    CreatePhoto(isPresentingCamera: $isPresentingCamera)
                        .padding(.bottom, 20)

                    // 메모 입력
                    CreateMemo(descriptionText: $descriptionText)     .padding(.bottom, 24)

                    // 작성 완료 동작
                    Button(action: {
                        let project = Project(projectTitle: projTitle, finishedAt: selectedDate)
                        context.insert(project)

                        let post = Post(
                            postImageUrl: nil,
                            memo: descriptionText,
                            project: project
                        )
                        context.insert(post)

                        do {
                            try context.save()
                            print("프로젝트 및 포스트 저장 성공")
                        } catch {
                            print("저장 실패: \(error)")
                        }
                    }) {
                        Text("작성 완료")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color.prime1)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 20)
            }
            .scrollDismissesKeyboard(.interactively)
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
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    CreateView()
}


