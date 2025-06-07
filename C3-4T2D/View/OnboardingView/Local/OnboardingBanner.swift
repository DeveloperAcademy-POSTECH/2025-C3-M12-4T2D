//
//  OnboardingBanner.swift
//  C3-4T2D
//
//  Created by bishoe on 6/5/25.
//

import SwiftUI

struct OnboardingBanner: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("당신의 성장 타임라인,")
                .font(.system(size: 28))
                .fontWeight(.bold)
            
            HStack(spacing: 0) {
                Text("망고")
                    .font(.system(size: 28))
                    .foregroundColor(.prime1)
                    .fontWeight(.bold)
                Text("가 함께해요")
                    .font(.system(size: 28))
                    .fontWeight(.bold)
            }
        }
        .padding(.top, 70)
        .padding(.bottom, 45)
    }
}

#Preview {
    OnboardingBanner()
}
