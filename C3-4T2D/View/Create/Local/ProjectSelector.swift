//
//  ProjectSelector.swift
//  C3-4T2D
//
//  Edited by Hwnag Jimin on 6/3/25.
//

import SwiftData
import SwiftUI

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

    // 스와이프 관련 상태
    @State private var swipeOffset: [String: CGFloat] = [:]
    @State private var isSwipeActionVisible: [String: Bool] = [:]

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

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(Array(projects.sorted { $0.createdAt > $1.createdAt }.enumerated()), id: \.element.id) { index, project in
                        ProjectRowView(
                            project: project,
                            isSelected: selectedProject?.id == project.id,
                            onTap: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedProject = project
                                }
                            },
                            onDelete: {
                                projectToDelete = project
                                showDeleteConfirmation = true
                            }
                        )

                        if index < projects.sorted(by: { $0.createdAt > $1.createdAt }).count - 1 {
                            Divider()
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 16)
        .onTapGesture {
            if isTextFieldFocuesed {
                hideKeyboard()
                isTextFieldFocuesed = false
            }
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

        let newProject = SwiftDataManager.startNewProject(context: context, title: trimmedName)
        selectedProject = newProject
        newProjectName = ""
        isAddingProject = false
    }
}

// MARK: - Custom Project Row View

struct ProjectRowView: View {
    let project: Project
    let isSelected: Bool
    let onTap: () -> Void
    let onDelete: () -> Void

    @State private var swipeOffset: CGFloat = 0
    @State private var isSwipeActive = false

    private let deleteButtonWidth: CGFloat = 60

    var body: some View {
        ZStack(alignment: .trailing) {
            Rectangle()
                .fill(Color.red)
                .frame(width: deleteButtonWidth)
                .overlay(
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .medium))
                    }
                )
                .opacity(isSwipeActive ? 1 : 0)

            HStack {
                Text(project.projectTitle)
                    .font(.system(size: 16, weight: .medium))
                    .lineLimit(1)
                    .foregroundColor(.black)
                Spacer()
                Text(DateFormatter.projectDateRange(startDate: project.postList.compactMap { $0.createdAt }.min() ?? Date(), endDate: project.finishedAt))
                    .font(.caption)
                    .foregroundColor(.gray)
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.prime1)
                        .font(.system(size: 16, weight: .medium))
                }
            }
            .padding(.vertical, 16)
            .background(.clear)
            .contentShape(Rectangle())
            .offset(x: swipeOffset)
            .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.7), value: swipeOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let translation = value.translation.width
                        if translation < 0 {
                            swipeOffset = max(translation, -deleteButtonWidth)
                        } else if swipeOffset < 0 {
                            // 오른쪽으로 드래그 -> 바로 0
                            swipeOffset = min(0, swipeOffset + translation)
                        }
                        isSwipeActive = swipeOffset < -10
                    }
                    .onEnded { value in
                        let predictedTranslation = value.predictedEndTranslation.width
                        if swipeOffset < -deleteButtonWidth / 2 || predictedTranslation < -40 {
                            swipeOffset = -deleteButtonWidth
                            isSwipeActive = true
                        } else {
                            swipeOffset = 0
                            isSwipeActive = false
                        }
                    }
            )
            .simultaneousGesture(
                TapGesture()
                    .onEnded { _ in
                        if isSwipeActive {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                swipeOffset = 0
                                isSwipeActive = false
                            }
                        } else {
                            onTap()
                        }
                    }
            )
        }
        .clipped()
    }
}

#Preview {
    ProjectSelector(selectedProject: .constant(nil))
}
