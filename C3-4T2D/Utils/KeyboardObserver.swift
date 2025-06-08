import SwiftUI

class KeyboardObserver: ObservableObject {
    @Published var isKeyboardVisible: Bool = false
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc private func keyboardWillShow() { isKeyboardVisible = true }
    @objc private func keyboardWillHide() { isKeyboardVisible = false }
} 