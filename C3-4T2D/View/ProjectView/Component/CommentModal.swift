//
//  CommentModal.swift
//  C3-4T2D
//
//  Edited by Jimin Hwnag on 6/4/25.
//

import SwiftUI



struct CommentModal: View {
    
    @State private var isAddingComment = false
    @State private var commentText = ""
    @State private var comments: [String] = []
    @State private var commentTimeStamp: Date? = nil
    @State private var commentsToDelete: String? = nil
    @State private var showDeleteConfirmation = false
    
    
    var body: some View {
        VStack(){
            HStack(){
                Text("코멘트")
                    .font(.title3).fontWeight(.bold)
                    
            }
            Spacer()
            
            List {
                ForEach(comments, id: \.self) { comment in
                    Text(comment)
                }
                .onDelete { indexSet in
                    comments.remove(atOffsets: indexSet)
                }
            }
            .listStyle(.plain)
            .frame(maxWidth: .infinity)
            
            Spacer()
            
            HStack {
                TextField("댓글을 입력하세요", text: $commentText)
                    .padding(.vertical, 13)
                    .padding(.horizontal, 21)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(23.5)
                    .foregroundColor(.white)
                    .padding(.trailing, 8)
                
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
            .padding(.top, 16)
            
            
            
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 16)
        .onTapGesture { hideKeyboard() }
        .background(.grayWhite)
    }
    
    //공백인 경우 코멘트 추가 불가
    private func addCommentIfValid() {
        let trimmedName = commentText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        comments.append(trimmedName)
        commentText = ""
    }

    private func deleteComments(_ project: String) {
        comments.removeAll { $0 == project }
    }
}


#Preview {
    ProjectList()
}
       
