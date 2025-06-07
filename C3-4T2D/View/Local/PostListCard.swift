//
//  PostListCard.swift
//  C3-4T2D
//
//  Created by bishoe on 5/31/25.
//

import SwiftUI

// 리스트뷰
struct PostListCard: View {
    @Environment(Router.self) var router
    let project: Project
    
    private var latestPost: Post? {
        project.postList.sorted { $0.createdAt > $1.createdAt }.first
    }
    
    private var imagePostCount: Int {
        project.postList.filter { $0.postImageUrl != nil && !$0.postImageUrl!.isEmpty }.count
    }
    
    private var memoPostCount: Int {
        project.postList.filter { $0.memo != nil && !$0.memo!.isEmpty }.count
    }

    var body: some View {
        HStack(spacing: 15) {
            Group {
                if let post = latestPost, let imageUrl = post.postImageUrl, !imageUrl.isEmpty {
                    let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(imageUrl)
                    if let data = try? Data(contentsOf: url), let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 70)
                            .clipped()
                            .cornerRadius(5)
                    } else {
                        placeholderView
                    }
                } else if let post = latestPost, let memo = post.memo, !memo.isEmpty {
                    Text(memo)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.black)
                        .frame(width: 100, height: 70)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(5)
                } else {
                    placeholderView
                }
            }
            .onTapGesture {
                router.navigate(to: .ProjectListView(project))
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(project.projectTitle)
                    .font(.system(size: 17, weight: .bold))
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
                        Text("\(memoPostCount)")
                            .font(.system(size: 14, weight: .semibold))
                    }

                    HStack(spacing: 4) {
                        Image("pallet")
                            .resizable()
                            .frame(width: 14, height: 14)
                        Text("\(imagePostCount)")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
            }

            Spacer()
        }
        Divider()
    }
    
    private var placeholderView: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 100, height: 70)
            .cornerRadius(5)
    }
}
