import SwiftData
import SwiftUI

struct EditView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var showProjectSelector = false
    @State private var showCameraEdit = false  // 🔥 통합 카메라-편집 뷰
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
        _selectedStage = State(initialValue: editingPost.postStage)
        
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
            CreateHeader(showExitAlert: $showExitAlert, hasUnsavedChanges: hasUnsavedChanges)
                .padding(.bottom, 12)
                .padding(.horizontal, 20)

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

                    // 사진 업로드 - 단순화된 인터페이스
                    CreatePhoto(
                        isPresentingCamera: $showCameraEdit,
                        pickedImage: $pickedImage
                    )
                    .padding(.bottom, 20)

                    // 메모 입력
                    CreateMemo(descriptionText: $descriptionText)
                        .padding(.bottom, 24)

                    // 수정 완료 버튼
                    Button(action: updatePost) {
                        Text("수정 완료")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(isPostValid ? Color.prime1 : Color.gray)
                            .cornerRadius(8)
                    }
                    .disabled(!isPostValid)
                }
                .padding(.horizontal, 20)
            }
            .scrollDismissesKeyboard(.immediately)
        }
        // 🔥 핵심: 통합 카메라-편집 뷰
        .fullScreenCover(isPresented: $showCameraEdit) {
            CameraEditView { editedImage in
                // 편집 완료된 이미지 저장
                pickedImage = editedImage
                print("✅ 이미지 편집 완료: \(editedImage?.size.debugDescription ?? "nil")")
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
    
    // MARK: - Computed Properties
    private var isPostValid: Bool {
        selectedProject != nil && (!descriptionText.isEmpty || pickedImage != nil)
    }
    
    // MARK: - Private Methods
    private func updatePost() {
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
        
        // 기존 포스트 업데이트
        editingPost.memo = descriptionText
        editingPost.project = project
        editingPost.createdAt = selectedDate
        editingPost.postImageUrl = imageUrl
        editingPost.postStage = selectedStage
        
        do {
            try context.save()
            print("✅ 포스트 수정 성공")
            dismiss()
        } catch {
            print("❌ 수정 실패: \(error)")
        }
    }
}
