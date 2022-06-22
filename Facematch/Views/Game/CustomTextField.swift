//
//  CustomTextField.swift
//  Facematch
//
//  Created by Abel Osorio on 9/12/20.
//

import SwiftUI
import UIKit

struct CustomUIKitTextField: UIViewRepresentable {
    typealias OnCommitHandler = (String) -> Void

    @Binding var text: String

    var placeholder: String
    var onCommit: OnCommitHandler
    var isEditable: Bool

    func makeUIView(context: UIViewRepresentableContext<CustomUIKitTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)

        textField.becomeFirstResponder()
        textField.delegate = context.coordinator
        textField.placeholder = placeholder
        textField.autocapitalizationType = .words
        textField.autocorrectionType = .no
        textField.returnKeyType = .next
        textField.tintColor = UIColor.accentColor

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomUIKitTextField>) {
        uiView.text = text
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentCompressionResistancePriority(.required, for: .vertical)
        
        context.coordinator.isEditable = isEditable
    }

    func makeCoordinator() -> CustomUIKitTextField.Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomUIKitTextField
        var isEditable: Bool = true
        
        init(parent: CustomUIKitTextField) {
            self.parent = parent
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            guard isEditable else {
                return false
            }
            
            let sanitizedText = textField.text?.diacriticInsensitive
                .trimmingCharacters(in: .whitespacesAndNewlines)

            parent.onCommit(sanitizedText ?? "")

            return true
        }
        
        func textField(
            _ textField: UITextField,
            shouldChangeCharactersIn range: NSRange,
            replacementString string: String
        ) -> Bool {
            guard let currentText = textField.text, isEditable else {
                return false
            }

            let textFieldRange = NSRange(location: 0, length: currentText.count)
            let textfieldIsEmpty = NSEqualRanges(range, textFieldRange) && string.isEmpty

            parent.text = textfieldIsEmpty ? "" : currentText + string

            return true
        }
    }
}
