//
//  ActionButton.swift
//  C3-4T2D
//
//  Created by bishoe on 6/5/25.
//

import SwiftUI

struct ActionButton: View {
    let isFormValid: Bool
    let textOfButton: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(textOfButton)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isFormValid ? .prime1 : .prime4)
                .cornerRadius(10)
        }
        .disabled(!isFormValid)
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
}
