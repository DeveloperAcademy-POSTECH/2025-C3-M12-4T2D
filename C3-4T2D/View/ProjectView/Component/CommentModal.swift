//
//  CommentModal.swift
//  C3-4T2D
//
//  Edited by Jimin Hwnag on 6/4/25.
//

import SwiftUI

struct CommentModal: View {
    
    @State private var commentText = ""
    @State private var comments: [String] = []
    @State private var commentTimestamps: [String: Date] = [:]

    
    var body: some View {
        VStack(){
            HStack(){
                Text("코멘트")
                    .font(.title3).fontWeight(.bold)
            }
            Spacer()
            
            List {
                ForEach(comments, id: \.self) { comment in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(comment)
                            .font(.body)
                            .foregroundColor(.grayBlack)
                        
                        if let timestamp = commentTimestamps[comment] {
                            Text(DateFormatter.timestampFormatter.string(from: timestamp))
                                .font(.caption2).fontWeight(.regular)
                                .foregroundColor(.gray2)
                        }
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

        comments.append(trimmedText)
        commentTimestamps[trimmedText] = Date()
        commentText = ""
    }

    private func deleteComment(_ comment: String) {
        comments.removeAll { $0 == comment }
        commentTimestamps.removeValue(forKey: comment)
    }
}



#Preview {
    CommentModal()
}
