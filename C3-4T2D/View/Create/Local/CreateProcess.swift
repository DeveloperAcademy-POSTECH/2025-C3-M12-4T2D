//
//  CreateProcess.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 6/2/25.
//

import SwiftUI

struct CreateProcess: View {
    @Binding var selectedStage: ProcessStage

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("진행 단계")
                .font(.title3.weight(.bold))
                .padding(.bottom, 10)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(ProcessStage.allCases) { stage in
                        Button(action: {
                            selectedStage = stage
                        }) {
                            Text(stage.rawValue)
                                .font(.system(size: 15))
                                .foregroundColor(selectedStage == stage ? .white : .black)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 4)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 1000)
                                        .fill(selectedStage == stage ? Color.yellow : Color(.systemGray5))
                                )
                                .fixedSize()
                        }
                    }
                }
            }
        }
    }
}
