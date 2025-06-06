//
//  ProjectSelector.swift
//  C3-4T2D
//
//  Edited by Hwnag Jimin on 6/3/25.
//

// MARK: TODO

// 우측 상단 '+' 버튼 항상 활성화, 버튼 선택시에만 TextField 노출

import SwiftUI
import SwiftData

struct ProjectSelector: View {
    @Environment(\.modelContext) private var context
    @Query private var projects: [Project]
    @Binding var selectedProject: Project?

    @State private var isAddingProject = false
    @State private var newProjectName = ""
    @FocusState private var isTextFieldFocuesed: Bool
    @State private var projectToDelete: Project? = nil
    @State private var showDeleteConfirmation = false

    var body: some View {
        VStack {
            // 상단 헤더
            HStack {
                Text("프로젝트")
                    .font(.title3.weight(.bold))
                    .foregroundColor(.black)

                Spacer()

                if isAddingProject {
                    Button("추가") {
                        addProjectIfValid()
                    }
                    .font(.subheadline.weight(.regular))
                    .foregroundColor(!newProjectName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .prime1 : .gray1)
                    .disabled(newProjectName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                } else {
                    Button(action: { isAddingProject = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(.prime1)
                    }
                }
            }

            // 프로젝트 추가
            if isAddingProject {
                TextField("새로운 프로젝트명을 입력해주세요", text: $newProjectName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isTextFieldFocuesed)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isTextFieldFocuesed = true
                        }
                    }
                    .onSubmit {
                        addProjectIfValid()
                    }
            }

            // 프로젝트 리스트
            List {
                ForEach(projects.sorted { $0.createdAt > $1.createdAt }) { project in
                    HStack {
                        Text(project.projectTitle)
                            .lineLimit(1)
                        Spacer()
                        Text("\(dateString(project.createdAt)) ~ \(project.finishedAt != nil ? dateString(project.finishedAt!) : "진행중")")
                            .font(.caption)
                            .foregroundColor(.gray)
                        if selectedProject?.id == project.id {
                            Image(systemName: "checkmark")
                                .foregroundColor(.prime1)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedProject = project
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            projectToDelete = project
                            showDeleteConfirmation = true
                        } label: {
                            Label("삭제", systemImage: "trash")
                        }
                        .tint(.red)
                    }.listRowInsets(EdgeInsets())
                }
            }
            .listStyle(.plain)
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 16)
        .onTapGesture {
            hideKeyboard()
        }
        .confirmationDialog("정말 삭제하시겠습니까?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
            Button("삭제", role: .destructive) {
                if let project = projectToDelete {
                    context.delete(project)
                    try? context.save()
                }
                projectToDelete = nil
            }
            Button("취소", role: .cancel) {
                projectToDelete = nil
            }
        }
    }

    private func addProjectIfValid() {
        let trimmedName = newProjectName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard isAddingProject, !trimmedName.isEmpty else { return }

        // 기존 진행중인 프로젝트 완료 및 새 프로젝트 생성 (헬퍼 함수 사용)
        let newProject = SwiftDataManager.startNewProject(context: context, title: trimmedName)
        selectedProject = newProject
        newProjectName = ""
        isAddingProject = false
    }

    private func dateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
}

#Preview {
    ProjectSelector(selectedProject: .constant(nil))
}
