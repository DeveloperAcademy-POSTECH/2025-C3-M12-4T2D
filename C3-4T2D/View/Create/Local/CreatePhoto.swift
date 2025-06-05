//
//  CreatePhoto.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 5/30/25.
//
import SwiftUI

struct CreatePhoto: View {
    @Binding var isPresentingCamera: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("진행 과정")
                .font(.title3.weight(.bold))
                .foregroundColor(.black)
                .padding(.bottom, 8)

            VStack(spacing: 0) {
                Button(action: {
                    isPresentingCamera = true
                }) {
                    VStack {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 64, height: 64)
                            .background(Color.prime3)
                            .clipShape(Circle())
                    }
                }
                .padding(.top, 8)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
