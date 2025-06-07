//
//  CommentModal.swift
//  C3-4T2D
//
//  Edited by Jimin Hwnag on 6/4/25.
//

import SwiftUI

struct CommentModal: View {
    @Binding var comments: [Comment]
    @State private var commentText = ""
    @State private var commentTimestamps: [UUID: Date] = [:]

    var body: some View {
        VStack(){
            HStack(){
                Text("코멘트")
                    .font(.title3).fontWeight(.bold)
            }
            Spacer()
            List {
                ForEach(comments) { comment in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(comment.text)
                            .font(.body)
                            .foregroundColor(.grayBlack)
                        Text(DateFormatter.timestampFormatter.string(from: comment.timestamp))
                            .font(.caption2).fontWeight(.regular)
                            .foregroundColor(.gray2)
                    }
                    .listRowInsets(EdgeInsets())
                    .padding(.vertical, 10)
                    .padding(.horizontal, 4)
                    .contextMenu {
                        Button(role: .destructive, action: {
                            deleteComment(comment)
                        }) {
                            Label("삭제", systemImage: "trash")
                        }
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .frame(maxWidth: .infinity)
            Spacer()
            HStack {
                TextField("", text: $commentText, prompt: Text("댓글을 입력하세요").foregroundColor(.white), axis: .vertical)
                    .padding(.vertical, 13)
                    .padding(.horizontal, 21)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(23.5)
                    .foregroundColor(.white)
                    .padding(.trailing, 8)
                    .onSubmit {
                        addCommentIfValid()
                    }
                Button(action: {
                    addCommentIfValid()
                }) {
                    Image(systemName: "arrow.up")
                        .padding(14)
                        .background(.prime1)
                        .foregroundColor(.white)
                        .cornerRadius(23.5)
                }
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .onTapGesture { hideKeyboard() }
        .background(.grayWhite)
    }
    // 공백인 경우 코멘트 추가 불가
    private func addCommentIfValid() {
        let trimmedText = commentText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        let newComment = Comment(text: trimmedText, timestamp: Date())
        comments.append(newComment)
        commentText = ""
    }
    private func deleteComment(_ comment: Comment) {
        comments.removeAll { $0.id == comment.id }
    }
}

#Preview {
    CommentModal(comments: .constant([]))
}
