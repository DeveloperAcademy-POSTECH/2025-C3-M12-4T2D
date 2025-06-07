import SwiftData
import SwiftUI

struct EditView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var showProjectSelector = false
    @State private var isPresentingCamera = false
    @State private var showDatePicker = false
    @State private var showExitAlert = false

    @State private var selectedProject: Project?
    @State private var descriptionText: String
    @FocusState private var isFocused: Bool

    @State private var selectedDate: Date
    @State private var selectedStage: ProcessStage = .idea

    @State private var pickedImage: UIImage?
    var editingPost: Post

    private var hasUnsavedChanges: Bool {
        selectedProject != editingPost.project ||
        pickedImage != nil ||
        descriptionText != (editingPost.memo ?? "")
    }

    init(editingPost: Post) {
        self.editingPost = editingPost
        _selectedProject = State(initialValue: editingPost.project)
        _descriptionText = State(initialValue: editingPost.memo ?? "")
        _selectedDate = State(initialValue: editingPost.createdAt)
        if let imageUrl = editingPost.postImageUrl, !imageUrl.isEmpty {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(imageUrl)
            if let data = try? Data(contentsOf: url), let uiImage = UIImage(data: data) {
                _pickedImage = State(initialValue: uiImage)
            } else {
                _pickedImage = State(initialValue: nil)
            }
        } else {
            _pickedImage = State(initialValue: nil)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            CreateHeader(showExitAlert: $showExitAlert, hasUnsavedChanges: hasUnsavedChanges, isEditing: true)
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

                        // 사진 업로드
                        CreatePhoto(isPresentingCamera: $isPresentingCamera, pickedImage: $pickedImage)
                            .padding(.bottom, 20)

                        // 메모 입력
                        CreateMemo(descriptionText: $descriptionText)
                            .padding(.bottom, 24)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 80) // 버튼 공간 확보
                }
                .scrollDismissesKeyboard(.immediately)

                // 수정 완료 버튼
                VStack {
                    Button(action: {
                        guard let project = selectedProject else { return }
                        var imageUrl: String? = editingPost.postImageUrl
                        if let image = pickedImage {
                            if let data = image.jpegData(compressionQuality: 0.8) {
                                let filename = UUID().uuidString + ".jpg"
                                let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
                                try? data.write(to: url)
                                imageUrl = filename
                            }
                        }
                        // 수정 모드: 기존 포스트 덮어쓰기
                        editingPost.memo = descriptionText
                        editingPost.project = project
                        editingPost.createdAt = selectedDate
                        editingPost.postImageUrl = imageUrl
                        do {
                            try context.save()
                            print("포스트 수정 성공")
                            dismiss()
                        } catch {
                            print("수정 실패: \(error)")
                        }
                    }) {
                        Text("수정 완료")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background((selectedProject != nil && (!descriptionText.isEmpty || pickedImage != nil)) ? Color.prime1 : Color.gray)
                            .cornerRadius(8)
                    }
                    .disabled(selectedProject == nil || (descriptionText.isEmpty && pickedImage == nil))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color.white)
                }
            }
        }
        .fullScreenCover(isPresented: $isPresentingCamera) {
            ZStack {
                Color.black.ignoresSafeArea()
                CameraView { image in
                    pickedImage = image
                    isPresentingCamera = false
                }
            }
        }
        .sheet(isPresented: $showProjectSelector) {
            ProjectSelector(selectedProject: $selectedProject)
                .presentationDetents([.medium, .large])
        }
        .onTapGesture {
            hideKeyboard()
        }
        .alert("작성 중인 내용이 있어요", isPresented: $showExitAlert) {
            Button("취소", role: .cancel) { }
            Button("종료", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("정말 종료하시겠어요?")
        }
    }
} 