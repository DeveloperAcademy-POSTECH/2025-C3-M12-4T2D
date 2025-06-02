//
//  CameraTestView.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 6/2/25.
//

import SwiftUI

struct CameraTestView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack{
            Button(action: {
                dismiss() // 창 닫기
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                    .frame(width: 60, alignment: .leading)
            }
            
            
            Text("카메라 View 위 엑스 버튼 누르면 돌아감")
        }
    }
}

#Preview {
    CameraTestView()
}
