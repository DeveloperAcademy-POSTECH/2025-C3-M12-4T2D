//
//  CreateView.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 5/29/25.
//

import SwiftData
import SwiftUI

struct CreateView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var showProjectSelector = false
    @State private var showCameraEdit = false // 통합 카메라-편집 뷰
    @State private var showDatePicker = false
    @State private var showExitAlert = false

    @State private var selectedProject: Project?
    @State private var descriptionText: String
    @FocusState private var isFocused: Bool

    @State private var selectedDate: Date
    @State private var selectedStage: ProcessStage = .idea

    @Binding var createPickedImage: UIImage?
    var initialProject: Project? = nil
    var initialMemo: String = ""
    var initialDate: Date = .init()
    var editingPost: Post? = nil

    private var hasUnsavedChanges: Bool {
        selectedProject != nil || createPickedImage != nil || !descriptionText.isEmpty
    }

    init(
        createPickedImage: Binding<UIImage?>,
        initialProject: Project? = nil,
        initialMemo: String = "",
        initialDate: Date = Date(),
        editingPost: Post? = nil
    ) {
        self._createPickedImage = createPickedImage
        self.initialProject = initialProject
        self.initialMemo = initialMemo
        self.initialDate = initialDate
        self.editingPost = editingPost
        _selectedProject = State(initialValue: editingPost?.project ?? initialProject)
        _descriptionText = State(initialValue: editingPost?.memo ?? initialMemo)
        _selectedDate = State(initialValue: editingPost?.createdAt ?? initialDate)
        _selectedStage = State(initialValue: editingPost?.postStage ?? .idea)
    }

    var body: some View {
        VStack(spacing: 0) {
            CreateHeader(showExitAlert: $showExitAlert, hasUnsavedChanges: hasUnsavedChanges, isEditing: false)
                .padding(.bottom, 12)
                .padding(.horizontal, 20)

            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: 0) {
                        // 프로젝트명
                        CreateProjTitle(projTitle: .constant(selectedProject?.projectTitle ?? ""), showProjectSelector: $showProjectSelector)
                            .padding(.bottom, 20)
                        // 날짜 선택
                        CreateDate(selectedDate: $selectedDate, showDatePicker: $showDatePicker)
                            .padding(.bottom, 20)
                        // 진행 단계
                        CreateProcess(selectedStage: $selectedStage)
                            .padding(.bottom, 20)

                        //   사진 업로드 - 메뉴 기반 UI로 개선
                        CreatePhoto(
                            isPresentingCamera: $showCameraEdit,
                            pickedImage: $createPickedImage
                        )
                        .padding(.bottom, 20)

                        // 메모 입력
                        CreateMemo(descriptionText: $descriptionText)
                            .padding(.bottom, 24)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 80) // 버튼 공간 확보
                }
                .scrollDismissesKeyboard(.immediately)

                // 작성 완료 버튼
                VStack {
                    Button(action: savePost) {
                        Text("작성 완료")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background((selectedProject != nil && (!descriptionText.isEmpty || createPickedImage != nil)) ? Color.prime1 : Color.gray)
                            .cornerRadius(8)
                    }
                    .disabled(selectedProject == nil || (descriptionText.isEmpty && createPickedImage == nil))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color.white)
                }
            }
        }
        // 단순화된 카메라 뷰 - 오버레이 제거
        .fullScreenCover(isPresented: $showCameraEdit) {
            CameraEditView { editedImage in
                // 즉시 이미지 할당 (딜레이 제거)
                createPickedImage = editedImage
                print("CreateView 내부 촬영 완료: \(editedImage?.size.debugDescription ?? "nil")")
            }
        }
        .sheet(isPresented: $showProjectSelector) {
            ProjectSelector(selectedProject: $selectedProject)
                .presentationDetents([.medium, .large])
        }
        .onTapGesture {
            hideKeyboard()
        }
        // onDisappear에서 이미지 초기화 제거 (MainView에서 관리)
        .alert("작성 중인 내용이 있어요", isPresented: $showExitAlert) {
            Button("취소", role: .cancel) {}
            Button("종료", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("정말 종료하시겠어요?")
        }
        .onAppear {
            if selectedProject == nil {
                if let current = try? context.fetch(SwiftDataManager.currentProject).first {
                    selectedProject = current
                }
            }
        }
    }

    // MARK: - Computed Properties

    private var isPostValid: Bool {
        selectedProject != nil && (!descriptionText.isEmpty || createPickedImage != nil)
    }

    // MARK: - Private Methods

    private func savePost() {
        guard let project = selectedProject else { return }

        var imageUrl: String? = nil
        if let image = createPickedImage {
            if let data = image.jpegData(compressionQuality: 0.8) {
                let filename = UUID().uuidString + ".jpg"
                let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
                try? data.write(to: url)
                imageUrl = filename
            }
        }

        if let editingPost = editingPost {
            // 수정 모드: 기존 포스트 업데이트
            editingPost.memo = descriptionText
            editingPost.project = project
            editingPost.createdAt = selectedDate
            editingPost.postImageUrl = imageUrl
            editingPost.postStage = selectedStage
        } else {
            // 신규 작성
            let post = Post(
                postImageUrl: imageUrl,
                memo: descriptionText,
                project: project,
                createdAt: selectedDate,
                postStage: selectedStage
            )
            context.insert(post)
        }

        do {
            try context.save()

            //   저장 후 이미지 초기화 (MainView로 돌아갈 때)
            createPickedImage = nil
            dismiss()
        } catch {
            print("저장 실패 \(error)")
        }
    }
}
