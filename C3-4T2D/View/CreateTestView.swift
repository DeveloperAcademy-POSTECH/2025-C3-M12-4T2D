//
//  CreateTestView.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 6/2/25.
//

import SwiftUI

struct CreateTestView: View {
    @State private var isPresentingCreate = false

    var body: some View {
        VStack {
            Button(action: {
                isPresentingCreate = true
            }) {
                Text("Create 작성 페이지")
            }
        }

            .fullScreenCover(isPresented: $isPresentingCreate) {
                CreateView()
            }
    }
}

#Preview {
    CreateTestView()
}
