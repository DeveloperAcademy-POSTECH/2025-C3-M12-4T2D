//
//  ProjectSelector.swift
//  C3-4T2D
//
//  Edited by Hwnag Jimin on 6/3/25.
//

import SwiftUI

struct ProjectSelector: View {
    @State private var isAddingProject = false
    @State private var newProjectName = ""
    @State private var projects: [String] = []
    
    var body: some View {
        VStack(spacing: 25) {
            // 상단 헤더
            HStack {
                Text("과정 기록하기")
                    .font(.title3.weight(.bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Button("완료") {
                    addProjectIfValid()
                }
                .font(.subheadline.weight(.regular))
                .foregroundColor(.prime1)
            }
            
            // 프로젝트 추가
            if isAddingProject {
                TextField("새로운 프로젝트명을 입력해주세요", text: $newProjectName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 46)
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
                            // deleteProject(project)
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
            
            Spacer()
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 16)
    }
    
    private func addProjectIfValid() {
        let trimmedName = newProjectName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard isAddingProject, !trimmedName.isEmpty else { return }
        
        projects.append(trimmedName)
        newProjectName = ""
        isAddingProject = false
    }
    
   /* private func deleteProject(_ project: String) {
        projects.removeAll { $0 == project }
    }
    
    //삭제는 논의 후 추가
   */
}

#Preview {
    ProjectSelector()
}
