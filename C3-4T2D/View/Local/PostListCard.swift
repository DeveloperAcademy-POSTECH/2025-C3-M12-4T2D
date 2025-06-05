//
//  PostListCard.swift
//  C3-4T2D
//
//  Created by bishoe on 5/31/25.
//

import SwiftUI

// 리스트뷰
struct PostListCard: View {
    let project: Project

    var body: some View {
        HStack(spacing: 15) {
            Image("tmpImage")
                .resizable()
                .frame(width: 100, height: 70)
                .cornerRadius(5)

            VStack(alignment: .leading, spacing: 5) {
                Text(project.projectTitle)
                    .font(.system(size: 16, weight: .bold))
                    .lineLimit(1)

                HStack {
                    Text(DateFormatter.projectDateRange(
                        startDate: project.postList.compactMap { $0.createdAt }.min() ?? Date(),
                        endDate: project.finishedAt
                    ))
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.gray)

                    Text(project.finishedAt == nil ? "진행중" : "완료")
                        .font(.system(size: 10, weight: .medium))
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(project.finishedAt == nil ? Color.green.opacity(0.2) : Color.gray.opacity(0.2))
                        .foregroundColor(project.finishedAt == nil ? .green : .gray)
                        .cornerRadius(4)
                }

                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image("note")
                            .resizable()
                            .frame(width: 14, height: 14)
                        Text("12")
                            .font(.system(size: 14, weight: .semibold))
                    }

                    HStack(spacing: 4) {
                        Image("pallet")
                            .resizable()
                            .frame(width: 14, height: 14)
                        Text("112")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
            }

            Spacer()
        }
        Divider()
    }
}
