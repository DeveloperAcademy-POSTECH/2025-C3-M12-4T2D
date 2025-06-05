//
//  ViewExtensions.swift
//  C3-4T2D
//
//  Created by Jimin on 6/5/25.
//
import Foundation
import SwiftUI

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
