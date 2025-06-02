//
//  DummyData.swift
//  C3-4T2D
//
//  Created by bishoe on 5/30/25.
//

import Foundation

class DummyData {
    private static func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        Calendar.current.date(from: DateComponents(year: year, month: month, day: day))!
    }

    private let postList1 = [
        Post(postImageUrl: "tmpImage", memo: "그림그리는 게 참 어렵다. 아이디어 구상에 시간을 너무 많이...", order: 1, projectId: UUID(), createdAt: date(2025, 3, 25)),
        Post(postImageUrl: "tmpImage", memo: "오늘은 색감 연습을 해보았다", order: 2, projectId: UUID(), createdAt: date(2025, 3, 28)),
        Post(postImageUrl: "tmpImage", memo: "드디어 완성! 만족스러운 결과", order: 3, projectId: UUID(), createdAt: date(2025, 4, 2))
    ]
    private let postList2 = [
        Post(postImageUrl: "tmpImage", memo: "사마귀의 역동적인 포즈를 잡는 게 생각보다 힘들었다. 참고 자료를 많이 찾아봤다.", order: 1, projectId: UUID(), createdAt: date(2025, 4, 5)),
        Post(postImageUrl: "tmpImage", memo: "무당벌레의 점 무늬를 자연스럽게 표현하는 게 어려웠다. 색 대비도 신경 썼다.", order: 2, projectId: UUID(), createdAt: date(2025, 4, 8))
    ]
    private let postList3 = [
        Post(postImageUrl: "tmpImage", memo: "스폰지밥 캐릭터를 내 스타일로 재해석하는 게 재밌으면서도 어려웠다.", order: 1, projectId: UUID(), createdAt: date(2025, 4, 12)),
        Post(postImageUrl: "tmpImage", memo: "콜라캔의 금속 질감을 표현하는 데 애를 먹었다. 반사광 연습이 많이 필요하다.", order: 2, projectId: UUID(), createdAt: date(2025, 4, 15)),
        Post(postImageUrl: "tmpImage", memo: "둘의 상호작용을 자연스럽게 연결하는 구도가 고민이었다. 여러 스케치를 해봤다.", order: 3, projectId: UUID(), createdAt: date(2025, 4, 18))
    ]
    private let postList4 = [
        Post(postImageUrl: "tmpImage", memo: "얼음의 차가운 느낌을 색으로 표현하는 게 쉽지 않았다. 파란색 계열을 많이 사용했다.", order: 1, projectId: UUID(), createdAt: date(2025, 4, 22)),
        Post(postImageUrl: "tmpImage", memo: "바람의 움직임을 선으로 나타내는 연습을 했다. 동세 표현이 아직 부족한 것 같다.", order: 2, projectId: UUID(), createdAt: date(2025, 4, 26))
    ]
    private let postList5 = [
        Post(postImageUrl: "tmpImage", memo: "분노라는 감정을 어떻게 시각적으로 표현할지 고민이 많았다. 강렬한 붉은색을 사용했다.", order: 1, projectId: UUID(), createdAt: date(2025, 5, 1)),
        Post(postImageUrl: "tmpImage", memo: "시계와 불꽃을 조합해서 시간과 분노를 동시에 나타내려 했다. 구도가 쉽지 않았다.", order: 2, projectId: UUID(), createdAt: date(2025, 5, 5)),
        Post(postImageUrl: "tmpImage", memo: "최종 결과물은 만족스럽지만, 감정 표현이 더 깊었으면 좋겠다.", order: 3, projectId: UUID(), createdAt: date(2025, 5, 8))
    ]
    private let postList6 = [
        Post(postImageUrl: "tmpImage", memo: "비닐의 투명함과 사과의 질감을 동시에 살리는 게 정말 어려웠다.", order: 1, projectId: UUID(), createdAt: date(2025, 5, 12)),
        Post(postImageUrl: "tmpImage", memo: "빛 반사와 그림자 표현에 집중했다. 사과의 색이 너무 튀지 않게 조절했다.", order: 2, projectId: UUID(), createdAt: date(2025, 5, 16))
    ]

    lazy var projects: [Project] = [
        Project(
            projectTitle: "미래적인 잠자리",
            postList: postList1,
            createdAt: postList1[0].createdAt,
            finishedAt: postList1.map { $0.createdAt }.max()
        ),
        Project(
            projectTitle: "사마귀와 무당벌레 폭주족",
            postList: postList2,
            createdAt: postList2[0].createdAt,
            finishedAt: postList2.map { $0.createdAt }.max()
        ),
        Project(
            projectTitle: "스폰지밥과 콜라캔의 행복한 사랑",
            postList: postList3,
            createdAt: postList3[0].createdAt,
            finishedAt: postList3.map { $0.createdAt }.max()
        ),
        Project(
            projectTitle: "매정한 얼음과 바람",
            postList: postList4,
            createdAt: postList4[0].createdAt,
            finishedAt: postList4.map { $0.createdAt }.max()
        ),
        Project(
            projectTitle: "시간을 초월한 분노",
            postList: postList5,
            createdAt: postList5[0].createdAt,
            finishedAt: postList5.map { $0.createdAt }.max()
        ),
        Project(
            projectTitle: "투명 비닐에 담긴 사과",
            postList: postList6,
            createdAt: postList6[0].createdAt,
            finishedAt: nil // 진행중
        )
    ]

    var currentProject: Project {
        projects.first { $0.finishedAt == nil } ?? projects[0]
    }

    var allProjects: [Project] {
        projects
    }

    var allPosts: [Post] {
        projects.flatMap { $0.postList }
    }

    var recentPosts: [Post] {
        Array(allPosts.prefix(10))
    }
}
