//
//  ProjectSelector.swift
//  C3-4T2D
//
//  Edited by Hwnag Jimin on 6/3/25.
//

//MARK: TODO
// 우측 상단 '+' 버튼 항상 활성화, 버튼 선택시에만 TextField 노출


import SwiftUI

struct ProjectSelector: View {
    @State private var isAddingProject = false
    @State private var newProjectName = ""
    @State private var projects: [String] = []
    @FocusState private var isTextFieldFocuesed: Bool
    @State private var projectToDelete: String? = nil
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        VStack() {
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
                    Button(action: {isAddingProject = true}) {
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
                    .onAppear{
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
