//
//  SwiftDataManager.swift
//  C3-4T2D
//
//  Created by bishoe on 6/3/25.
//

import Foundation
import SwiftData
import SwiftUI

enum SwiftDataManager {
    /// 프로젝트 생성 함수
    static func createProject(context: ModelContext, title: String) -> Project {
        let project = Project(projectTitle: title)
        context.insert(project)
        return project
    }

    /// 프로젝트에 포스트 추가
    static func addPost(to project: Project, context: ModelContext, imageUrl: String? = nil, memo: String? = nil) {
        let post = Post(postImageUrl: imageUrl, memo: memo, project: project) // project 무조건 필수
        project.postList.append(post)
        context.insert(post)
    }

    /// 사용자 생성 함수
    static func createUser(context: ModelContext, goal: String, remainingDays: Int) -> User {
        let user = User(userGoal: goal, remainingDays: remainingDays)
        context.insert(user)
        return user
    }

    /// 현재 진행중인 프로젝트 가져오기 (한개 있거나 , 아예 없거나)
    static func getCurrentProject(context: ModelContext) -> Project? {
        do {
            let projects = try context.fetch(currentProject)

            return projects.first
        } catch {
            print("현재프로젝트 가져오기 에러 \(error)")
            return nil
        }
    }

    /// 새 프로젝트 시작 ( 진행중인 프로젝트가 있으면 바로 완료 처리! )
    static func startNewProject(context: ModelContext, title: String) -> Project {
        // 기존 진행중인 프로젝트 완료 처리
        if let currentProject = getCurrentProject(context: context) {
            // 바로 finished에 날짜 집어넣기 -> 이러면 완료처리임 `!= nil`
            currentProject.finishedAt = Date()
            print("현 \(currentProject.projectTitle)")
        }

        // 새로운 프로젝트 생성 ,title만 먼저 받음
        let newProject = Project(projectTitle: title)
        context.insert(newProject)

        do {
            try context.save()
            print("새로 만든 프로젝트 이름 : \(title)")
        } catch {
            print("프로젝트 새로만들기 에러 \(error)")
        }

        return newProject
    }

    /// 진행중인 프로젝트 완료 처리
    static func completeCurrentProject(context: ModelContext) {
        guard let currentProject = getCurrentProject(context: context) else {
            print("currentProject가 없음 , 아웃 ! ")
            return
        }
        // 완료 처리 -> DATE집어넣는거랑 동등
        currentProject.finishedAt = Date()

        do {
            try context.save()
            print("\(currentProject.projectTitle)프로젝트 완료")
        } catch {
            print("프로젝트 완료 에러 \(error)")
        }
    }

    /// 진행중인 프로젝트 가져오기
    static var currentProject: FetchDescriptor<Project> {
        var descriptor = FetchDescriptor<Project>(
            predicate: #Predicate { $0.finishedAt == nil }
        )
        return descriptor
    }

    /// 이전  프로젝트만 가져오기 ( 진행중 프로젝트 제외)
    static var completedProjects: FetchDescriptor<Project> {
        var descriptor = FetchDescriptor<Project>(
            predicate: #Predicate { $0.finishedAt != nil },
            sortBy: [SortDescriptor(\.finishedAt, order: .reverse)]
        )
        return descriptor
    }
}
