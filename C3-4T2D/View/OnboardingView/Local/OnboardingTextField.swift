//
//  OnboardingTextField.swift
//  C3-4T2D
//
//  Created by bishoe on 6/5/25.
//

import SwiftUI

struct OnboardingTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let maxLength: Int
    let focusField: TextFieldType
    @FocusState.Binding var focusedField: TextFieldType?
    let onSubmit: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundColor(.gray4)
            
            VStack(spacing: 5) {
                HStack {
                    TextField(placeholder, text: $text)
                        .font(.system(size: 17))
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(.black)
                        .focused($focusedField, equals: focusField)
                        .submitLabel(focusField == .nickname ? .next : .done)
                        .onSubmit(onSubmit)
                    
                    if !text.isEmpty {
                        if text.isOverMaxLength(maxLength: maxLength) {
                            Button(action: { text = "" }) {
                                Image(systemName: "x.circle")
                                    .foregroundColor(.alert)
                            }
                        } else {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.prime1)
                        }
                    }
                }
                
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(text.textFieldErrorColor(maxLength: maxLength))
                
                HStack {
                    Spacer()
                    Text("\(text.count)/\(maxLength)")
                        .font(.caption2)
                        .foregroundColor(text.textFieldErrorColor(maxLength: maxLength))
                }
                .padding(.top, 2)
            }
        }
    }
}
