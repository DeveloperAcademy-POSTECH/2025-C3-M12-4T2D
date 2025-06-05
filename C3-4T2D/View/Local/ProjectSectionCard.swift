//
//  ProjectSectionCard.swift
//  C3-4T2D
//
//  Created by bishoe on 5/31/25.
//

import SwiftUI

struct ProjectSectionCard: View {
    @Environment(Router.self) var router
    let project: Project

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
                Button {
                    router.navigate(to: .ProjectListView(project))
                } label: {
                    HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(project.projectTitle)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)

                        HStack {
                            Text(DateFormatter.projectDateRange(
                                startDate: project.postList.compactMap { $0.createdAt }.min() ?? Date(),
                                endDate: project.finishedAt
                            ))
                            .font(.system(size: 11, weight: .regular))
                            .foregroundColor(.gray)

                            Text(project.finishedAt == nil ? "진행중" : "완료")
                                .font(.system(size: 11, weight: .medium))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(project.finishedAt == nil ? Color.green.opacity(0.2) : Color.gray.opacity(0.2))
                                .foregroundColor(project.finishedAt == nil ? .green : .gray)
                                .cornerRadius(4)
                        }
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                        .font(.system(size: 20, weight: .semibold))
                    }
                    .padding(.horizontal, 20)
                }


            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    Spacer(minLength: 8)
                    ForEach(project.postList) { _ in
                        Image("tmpImage")
                            .resizable()
                            .frame(width: 140, height: 100)
                            .cornerRadius(8)
                    }
                    if project.postList.count > 4 {
                        ZStack {
                            Color.gray.opacity(0.1)
                                .frame(width: 80, height: 80)
                                .cornerRadius(8)

                            Text("+\(project.postList.count - 4)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
    }
}
