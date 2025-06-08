//
//  ProjectSectionCard.swift
//  C3-4T2D
//
//  Created by bishoe on 5/31/25.
//

import SwiftUI

struct ActiveProjectCard: View {
    @Environment(Router.self) var router
    let project: Project

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            VStack(alignment: .leading, spacing: 4) {
                Button {
                    router.navigate(to: .ProjectListView(project))
                } label: {
                    HStack(spacing: 4) {
                        Text(project.projectTitle)
                            .foregroundColor(.black)
                            .font(.system(size: 17, weight: .bold))
//                        Image(systemName: "chevron.right")
//                            .foregroundColor(.black)
//                            .font(.system(size: 17, weight: .semibold))
                    }
                }
                HStack(spacing: 8) {
                    Text(project.createdAt, formatter: dateFormatter)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.gray)
                    Text("~")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.gray)
                    Text("진행중")
                        .font(.system(size: 11, weight: .medium))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(project.finishedAt == nil ? Color.yellow.opacity(0.2) : Color.gray.opacity(0.2))
                        .foregroundColor(project.finishedAt == nil ? .black : .gray)
                        .cornerRadius(4)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 15)


            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    Spacer(minLength: 8)

                    ForEach(project.postList.sorted(by: { $0.createdAt > $1.createdAt })) { post in
                        ZStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 200, height: 143)
                                .cornerRadius(8)
                            if let url = post.postImageUrl, !url.isEmpty {
                                let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(url)
                                if let data = try? Data(contentsOf: fileUrl), let uiImage = UIImage(data: data) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 200, height: 143)
                                        .clipped()
                                        .cornerRadius(8)
                                }
                            } else {
                                Text(post.memo ?? "")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .padding(8)
                            }
                        }
                        .onTapGesture {
                            router.navigate(to: .ProjectListView(project))
                        }
                    }

                }
            }
        }
        .padding(.bottom, 12)
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }
}
