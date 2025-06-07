//
//  SplashView.swift
//  C3-4T2D
//
//  Created by 서연 on 6/6/25.
//

import SwiftUI

struct SplashView: View {
    @State private var animate = false

    var body: some View {
        VStack {
            Spacer().frame(height: 300)
            
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .scaleEffect(animate ? 1.0 : 0.5)
                .opacity(animate ? 1.0 : 0.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0), value: animate)
            
            Image("mango")
                .resizable()
                .scaledToFit()
                .frame(width: 91, height: 22)
                .scaleEffect(animate ? 1.0 : 0.5)
                .opacity(animate ? 1.0 : 0.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0).delay(0.1), value: animate)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .ignoresSafeArea()
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    SplashView()
}
