//
//  DummyDataManager.swift
//  C3-4T2D
//
//  Created by bishoe on 6/3/25.
//

// MARK: 하단 내용들은 더미데이터 만들때만 활용됩니다 ! 실제 DATA관리는 SwiftDataManger.swift 참고하시면 됩니다 !

import Foundation
import SwiftData

enum DummyDataManager {
    /// createdAt, finishedAt에 들어갈 날짜 헬퍼
    private static func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        Calendar.current.date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
    }
    
    // 더미 데이터 구조체 Project,Post
    
    private struct DummyProject {
        let title: String
        let createdAt: Date
        let finishedAt: Date?
        let posts: [DummyPost]
    }
    
    private struct DummyPost {
        let memo: String
        let createdAt: Date
        let imageUrl: String = "tmpImage"
    }
    
    // MARK: - 샘플 데이터 정의
    
    private static let dummyData: [DummyProject] = [
        DummyProject(
            title: "투명 비닐에 담긴 사과",
            createdAt: date(2025, 5, 12),
            finishedAt: nil, // 진행중인 프로젝트라서 nil
            posts: [
                DummyPost(
                    memo: "비닐의 투명함과 사과의 질감을 동시에 살리는 게 정말 어려웠다.",
                    createdAt: date(2025, 5, 12)
                ),
                DummyPost(
                    memo: "빛 반사와 그림자 표현에 집중했다. 사과의 색이 너무 튀지 않게 조절했다.",
                    createdAt: date(2025, 5, 16)
                )
            ]
        ),
        
        DummyProject(
            title: "미래적인 잠자리",
            createdAt: date(2025, 3, 25),
            finishedAt: date(2025, 4, 2), // 완료된 프로젝트
            posts: [
                DummyPost(
                    memo: "그림그리는 게 참 어렵다. 아이디어 구상에 시간을 너무 많이...",
                    createdAt: date(2025, 3, 25)
                ),
                DummyPost(
                    memo: "오늘은 색감 연습을 해보았다",
                    createdAt: date(2025, 3, 28)
                ),
                DummyPost(
                    memo: "드디어 완성! 만족스러운 결과",
                    createdAt: date(2025, 4, 2)
                )
            ]
        ),
        
        DummyProject(
            title: "사마귀와 무당벌레 폭주족",
            createdAt: date(2025, 4, 5),
            finishedAt: date(2025, 4, 8),
            posts: [
                DummyPost(
                    memo: "사마귀의 역동적인 포즈를 잡는 게 생각보다 힘들었다. 참고 자료를 많이 찾아봤다.",
                    createdAt: date(2025, 4, 5)
                ),
                DummyPost(
                    memo: "무당벌레의 점 무늬를 자연스럽게 표현하는 게 어려웠다. 색 대비도 신경 썼다.",
                    createdAt: date(2025, 4, 8)
                )
            ]
        ),
        
        DummyProject(
            title: "스폰지밥과 콜라캔의 행복한 사랑",
            createdAt: date(2025, 4, 12),
            finishedAt: date(2025, 4, 18),
            posts: [
                DummyPost(
                    memo: "스폰지밥 캐릭터를 내 스타일로 재해석하는 게 재밌으면서도 어려웠다.",
                    createdAt: date(2025, 4, 12)
                ),
                DummyPost(
                    memo: "콜라캔의 금속 질감을 표현하는 데 애를 먹었다. 반사광 연습이 많이 필요하다.",
                    createdAt: date(2025, 4, 15)
                ),
                DummyPost(
                    memo: "둘의 상호작용을 자연스럽게 연결하는 구도가 고민이었다. 여러 스케치를 해봤다.",
                    createdAt: date(2025, 4, 18)
                )
            ]
        )
    ]
    
    // MARK: 더미 데이터들
    
    /// 샘플 더미 데이터 넣는 함수
    static func createDummyData(context: ModelContext, projects: [Project]) {
        // 이미 데이터가 있으면 또 생성하지 않음
        guard projects.isEmpty else { return }
        
        // 샘플 데이터를 순회하며 생성
        for (index, dummyProject) in dummyData.enumerated() {
            // 프로젝트 생성
            let project = Project(
                projectTitle: dummyProject.title,
                finishedAt: dummyProject.finishedAt
            )
            project.createdAt = dummyProject.createdAt
            context.insert(project)
            
            createPosts(for: project, dummyPosts: dummyProject.posts, context: context)
        }
        do {
            try context.save()
            print("더미 데이터 생성")
        } catch {
            print("더미데이터 에러 \(error)")
        }
    }
    
    /// 프로젝트에 새로운 글(포스트) 생성 함수
    private static func createPosts(for project: Project, dummyPosts: [DummyPost], context: ModelContext) {
        for (index, dummyPost) in dummyPosts.enumerated() {
            let post = Post(
                postImageUrl: dummyPost.imageUrl,
                memo: dummyPost.memo,
                order: index + 1,
                project: project
            )
            post.createdAt = dummyPost.createdAt
            
            project.postList.append(post)
            context.insert(post)
        }
    }
}
