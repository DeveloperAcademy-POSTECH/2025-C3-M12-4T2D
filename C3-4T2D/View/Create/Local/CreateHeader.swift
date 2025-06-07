//
//  CreateHeader.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 5/29/25.
//

import SwiftUI

struct CreateHeader: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showExitAlert: Bool  // 추가: 종료 확인 알림 상태를 바인딩으로 받음
    let hasUnsavedChanges: Bool  // 추가: 작성 중인 내용이 있는지 여부
    let isEditing: Bool  // 추가: 수정 모드인지 여부

    var body: some View {
        HStack {
            Button(action: {
                if hasUnsavedChanges {
                    showExitAlert = true
                } else {
                    dismiss()
                }
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 60, alignment: .leading)
            }

            Spacer()

            Text(isEditing ? "과정 수정하기" : "과정 기록하기")
                .font(.title3.weight(.bold))
                .foregroundColor(.black)

            Spacer()

            Button(action: {
                // 임시저장 동작
            }) {
                Text("임시저장")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .frame(width: 60, alignment: .leading)
            }
        }
        .padding(.top, 16)
        .padding(.bottom, 12)
    }
}
