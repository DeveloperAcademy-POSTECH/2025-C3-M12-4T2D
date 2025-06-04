//
//  SwiftDataExtensions.swift
//  C3-4T2D
//
//  Created by bishoe on 6/3/25.
//

import SwiftData
import SwiftUI

extension SwiftDataManager {
    /// 지금은 테스트를 위해 해당 함수만 사용 중 -> ( 모든 데이터 삭제 )
    // mainView 하단 onAppear에서만 쓰고 있음 한번 실행되면 주석처리 해주시면됨
    static func deleteAllData(context: ModelContext) {
        do {
            try context.delete(model: Project.self)
            try context.delete(model: Post.self)
            try context.delete(model: User.self)
            try context.save()
            print("모든 데이터 초기화")
        } catch {
            print("error AllData: \(error)")
        }
    }

    /// 모든 프로젝트 삭제 (나중에 쓸일이 있을수도)
    static func deleteAllProjects(context: ModelContext) {
        do {
            try context.delete(model: Project.self)
            try context.save()
            print("프로젝트 삭제됨!")
        } catch {
            print("모든 프로젝트 삭제 \(error)") // RelationShip걸려있어서 프로젝트 삭제하면 포스트도 같이 날라갑니다
        }
    }

    /// 모든 포스트 삭제 ( UI View 확정되면 사용 가능)
    static func deleteAllPosts(context: ModelContext) {
        do {
            try context.delete(model: Post.self)
            try context.save()
            print("포스트 삭제됨!")
        } catch {
            print("모든 포스트 삭제 \(error)")
        }
    }
    // TODO: 여러개 체크해서 삭제 -> 선택한 포스트들을 order값을 배열로 받아서 처리해주는 것도 괜찮을듯
    // TODO: order swap 기능 필요
}
