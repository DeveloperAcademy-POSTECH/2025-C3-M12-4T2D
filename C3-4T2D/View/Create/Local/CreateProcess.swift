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
                HStack(spacing: 8) {
                    ForEach(ProcessStage.allCases) { stage in
                        Button(action: {
                            selectedStage = stage
                        }) {
                            Text(stage.rawValue)
                                .font(.system(size: 15))
                                .foregroundColor(selectedStage == stage ? .white : Color("Gray_3"))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(
                                    selectedStage == stage ? Color("Prime 1") : Color(.tertiarySystemFill)
                                )
                                .fixedSize()
                                .clipShape(Capsule())
                        }
                    }
                    Spacer()
                }
        }
    }
}
