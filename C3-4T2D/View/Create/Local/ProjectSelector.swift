//
//  ProjectSelector.swift
//  C3-4T2D
//
//  Edited by Hwnag Jimin on 6/3/25.
//

//MARK: TODO
//'프로젝트 추가하기' 버튼 선택시에만 '완료' 버튼 활성화 (Prime3 -> Prime1)
//Swipe Action으로 수정 기능 선택 시 프로젝트명 수정 기능 추가


import SwiftUI

struct ProjectSelector: View {
    @State private var isAddingProject = false
    @State private var newProjectName = ""
    @State private var projects: [String] = []
    @FocusState private var isTextFieldFocuesed: Bool
    @State private var projectToDelete: String? = nil
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        VStack(spacing: 25) {
            // 상단 헤더
            HStack {
                Text("프로젝트")
                    .font(.title3.weight(.bold))
                    .foregroundColor(.black)

                Spacer()

                Button("완료") {
                    addProjectIfValid()
                }
                .font(.subheadline.weight(.regular))
                .foregroundColor(isAddingProject && !newProjectName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .prime1 : .prime2)
                .disabled(!isAddingProject || newProjectName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            
            // 프로젝트 추가
            if isAddingProject {
                TextField("새로운 프로젝트명을 입력해주세요", text: $newProjectName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 46)
                    .focused($isTextFieldFocuesed)
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isTextFieldFocuesed = true
                        }
                    }
                    .onSubmit {
                        addProjectIfValid()
                    }
            } else {
                Button("프로젝트 추가하기 +") {
                    isAddingProject = true
                }
                .font(.body.weight(.regular))
                .foregroundColor(.gray3)
                .frame(maxWidth: .infinity)
                .frame(height: 46)
            }
            
            // 프로젝트 리스트
            List {
                ForEach(projects, id: \.self) { project in
                    HStack {
                        Text(project)
                            .lineLimit(1)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            projectToDelete = project
                            showDeleteConfirmation = true
                        } label: {
                            Label("삭제", systemImage: "trash")
                        }
                        .tint(.red)
                        
                        Button {
                            // 편집 기능 구현
                        } label: {
                            Label("편집", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
                }
            }
            .listStyle(.plain)
            .listRowInsets(EdgeInsets())
            .frame(maxWidth: .infinity)
            .padding(.horizontal, -16)
            
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 16)
        .confirmationDialog("정말 삭제하시겠습니까?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
            Button("삭제", role: .destructive) {
                if let project = projectToDelete {
                    deleteProject(project)
                }
                projectToDelete = nil
            }
            Button("취소", role: .cancel) {
                projectToDelete = nil
            }
        }
    }
    
    
    //공백인 경우 프로젝트 추가 불가
    private func addProjectIfValid() {
        let trimmedName = newProjectName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard isAddingProject, !trimmedName.isEmpty else { return }
        
        projects.append(trimmedName)
        newProjectName = ""
        isAddingProject = false
    }
    
    private func deleteProject(_ project: String) {
        projects.removeAll { $0 == project }
    }
    
   
}

#Preview {
    ProjectSelector()
}
