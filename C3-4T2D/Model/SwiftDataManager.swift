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
    static func addPost(to project: Project, context: ModelContext, imageUrl: String? = nil, memo: String? = nil, postStage: ProcessStage = .idea) {
        let post = Post(postImageUrl: imageUrl, memo: memo, project: project, postStage: postStage) // project 무조건 필수
        project.postList.append(post)
        context.insert(post)
    }

    /// 유저 생성
    static func createUser(context: ModelContext, nickname: String, goal: String, remainingDays: Int, targetDate: Date, profileImageData: Data? = nil) -> User {
        let user = User(nickname: nickname, userGoal: goal, remainingDays: remainingDays, targetDate: targetDate, profileImageData: profileImageData)
        context.insert(user)
        return user
    }

    /// 유저 정보 업뎃
    static func updateUserInfo(context: ModelContext, user: User, nickname: String, goal: String, remainingDays: Int, profileImageData: Data? = nil) {
        user.nickname = nickname
        user.userGoal = goal
        user.remainingDays = remainingDays

        if let imageData = profileImageData {
            user.profileImageData = imageData
        }

        do {
            try context.save()
            print("\(nickname), \(goal), D-\(remainingDays)")
        } catch {
            print("유저 업데이트 에러: \(error)")
        }
    }

    /// 프로필 이미지만 업데이트
    static func updateUserProfileImage(context: ModelContext, user: User, profileImageData: Data?) {
        user.profileImageData = profileImageData

        do {
            try context.save()
        } catch {
            print("profileImage 업뎃오류: \(error)")
        }
    }

    /// 현재 진행중인 프로젝트 가져오기 (한개 있거나 , 아예 없거나)
    static func getCurrentProject(context: ModelContext) -> Project? {
        do {
            let projects = try context.fetch(currentProject)

            return projects.first
        } catch {
            print("현재프로젝트 에러 \(error)")
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
        let descriptor = FetchDescriptor<Project>(
            predicate: #Predicate { $0.finishedAt == nil }
        )
        return descriptor
    }

    /// 이전  프로젝트만 가져오기 ( 진행중 프로젝트 제외)
    static var completedProjects: FetchDescriptor<Project> {
        let descriptor = FetchDescriptor<Project>(
            predicate: #Predicate { $0.finishedAt != nil },
            sortBy: [SortDescriptor(\.finishedAt, order: .reverse)]
        )
        return descriptor
    }

    /// 특정 프로젝트에 해당하는 포스트들 가져오기
    static func getPostsForProject(_ project: Project) -> FetchDescriptor<Post> {
        let projectId = project.id // 값을 미리 추출함 (비교할때project.id는 불가능)
        let descriptor = FetchDescriptor<Post>(
            predicate: #Predicate<Post> { $0.project?.id == projectId },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return descriptor
    }
}
