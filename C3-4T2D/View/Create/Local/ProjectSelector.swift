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
    @State private var showPostDeleteConfirmation = false
    @State private var postCountToDelete: Int = 0
    @State private var showEmptyProjectAlert = false

    var body: some View {
        VStack {
            // 상단 헤더
            HStack {
                Text("프로젝트")
                    .font(.title3.weight(.bold))
                    .foregroundColor(.black)

                Spacer()

                if isAddingProject {
                    Button("완료") {
                        addProjectIfValid()
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(!newProjectName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .prime1 : .gray1)
                    .disabled(newProjectName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                } else {
                    Button(action: {
                        // 가장 최신 프로젝트가 비어있는지 확인
                        if let latest = projects.sorted(by: { $0.createdAt > $1.createdAt }).first, latest.postList.isEmpty {
                            showEmptyProjectAlert = true
                        } else {
                            isAddingProject = true
                        }
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.prime1)
                            .contentShape(Rectangle())
                    }
                }
            }

            // 프로젝트 추가
            if isAddingProject {
                VStack(spacing: 4) {
                    TextField("새로운 프로젝트명을 입력해주세요", text: $newProjectName)
                        .focused($isTextFieldFocuesed)
                        .font(.system(size: 16))
                        .padding(.vertical, 8)
                        .background(
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 1)
                                .overlay(
                                    Rectangle()
                                        .fill(isTextFieldFocuesed ? Color.prime1 : Color.gray.opacity(0.3))
                                        .frame(height: 1)
                                        .offset(y: 20)
                                )
                        )
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                isTextFieldFocuesed = true
                            }
                        }
                        .onSubmit {
                            addProjectIfValid()
                        }
                }
                .padding(.top, 8)
            }

            // 프로젝트 리스트
            List {
                ForEach(projects.sorted { $0.createdAt > $1.createdAt }) { project in
                    HStack {
                        Text(project.projectTitle)
                            .font(.system(size: 16, weight: .medium))
                            .lineLimit(1)
                        Spacer()
                        Text(DateFormatter.projectDateRange(startDate: project.postList.compactMap { $0.createdAt }.min() ?? Date(), endDate: project.finishedAt))

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
                    if project.postList.isEmpty {
                        context.delete(project)
                        try? context.save()
                        projectToDelete = nil
                    } else {
                        postCountToDelete = project.postList.count
                        showPostDeleteConfirmation = true
                    }
                }
            }
            Button("취소", role: .cancel) {
                projectToDelete = nil
            }
        }
        .alert("이 프로젝트에는 포스트가 \(postCountToDelete)개 있습니다. 정말 모두 삭제하시겠습니까?", isPresented: $showPostDeleteConfirmation) {
            Button("취소", role: .cancel) {
                projectToDelete = nil
            }
            Button("삭제", role: .destructive) {
                if let project = projectToDelete {
                    let postsToDelete = Array(project.postList)
                    for post in postsToDelete {
                        context.delete(post)
                    }
                    context.delete(project)
                    try? context.save()
                    projectToDelete = nil
                }
            }
        }
        .alert("한 번에 한 프로젝트만 진행할 수 있어요.", isPresented: $showEmptyProjectAlert) {
            Button("확인", role: .cancel) {}
        } message: {
            Text("진행중인 프로젝트가 비어 있어서 새 프로젝트를 추가할 수 없어요")
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
}

#Preview {
    ProjectSelector(selectedProject: .constant(nil))
}
