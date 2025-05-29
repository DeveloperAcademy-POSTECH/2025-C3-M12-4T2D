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
            LazyVStack(spacing: 25) {
                ForEach(0 ..< 20) { _ in
                    Project()
                        .frame(width: UIScreen.main.bounds.width)
//                        .border(Color.gray)
                }
            }
        }
    }
}

#Preview {
    ProjectList()
}
