//
//  CreateProjTitle.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 5/30/25.
//

import SwiftUI

struct CreateProjTitle: View {
    @Binding var projectName: String
    @Binding var showProjectSelector: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                showProjectSelector = true
            }) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("프로젝트명")
                        .font(.title3.weight(.bold))
                        .foregroundColor(.black)

                    HStack {
                        Text(projectName.isEmpty ? "프로젝트명을 선택해주세요" : projectName)
                            .font(.system(size: 15))
                            .foregroundColor(projectName.isEmpty ? .gray : .black)

                        Spacer()

                        Image(systemName: "chevron.right")
                            .foregroundColor(.black)
                            .padding(.trailing, 8)
                            
                    }

                    Divider()
                        .background(Color.gray)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

#Preview {
    StatefulPreviewWrapper("") { binding in
        CreateProjTitle(projectName: binding, showProjectSelector: .constant(false))
//            .padding()
    }
}

struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    var content: (Binding<Value>) -> Content

    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: value)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}
