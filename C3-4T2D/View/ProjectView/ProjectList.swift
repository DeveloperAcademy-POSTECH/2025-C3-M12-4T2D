//
//  ProjectList.swift
//  C3-4T2D
//
//  Created by 차원준 on 5/29/25.
//

import SwiftUI

struct ProjectList: View {
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(0 ..< 20) { _ in
                    Project()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
//                        .border(Color.gray)
                }
            }
        }
    }
}

#Preview {
    ProjectList()
}
