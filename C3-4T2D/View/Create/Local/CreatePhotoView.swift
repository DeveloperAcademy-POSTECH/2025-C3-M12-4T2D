//
//  CreatePhotoView.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 5/30/25.
//
import SwiftUI

struct CreatePhotoView: View {
    @Binding var isPresentingCamera: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text("진행 과정")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.black)
                .padding(.bottom, 8)

            VStack(spacing: 28) {
                Button(action: {
                    isPresentingCamera = true
                }) {
                    VStack {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 64, height: 64)
                            .background(Color.yellow)
                            .clipShape(Circle())
                            .padding(.bottom, 16)

                        Text("과정의 기록을 보여줄 수 있는 사진을 올려주세요")
                            .font(.system(size: 13))
                            .foregroundColor(Color.gray)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.vertical, 56)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
