//
//  AnswerTextField.swift
//  Facematch
//
//  Created by Abel Osorio on 9/12/20.
//

import SwiftUI
import UIKit

struct AnswerTextField: View {
    typealias OnCommitHandler = (String) -> Void
    typealias AnswerStateGetter = (String) -> AnswerState

    @State private var name: String = ""
    @State var state: AnswerState

    var getAnswerState: AnswerStateGetter
    var onCommit: OnCommitHandler

    var backgroundColor: Color {
        switch state {
        case .correct:
            return .appAnswerCorrect
        case .incorrect:
            return .appAnswerIncorrect
        case .neutral:
            return .clear
        }
    }

    var buttonBackgroundColor: Color {
        switch state {
        case .correct:
            return .appAnswerCorrect
        case .incorrect:
            return .appAnswerIncorrect
        case .neutral:
            return isButtonDisabled ? .appAnswerDisabled : .appButtonNextBackground
        }
    }

    var textColor: Color {
        switch state {
        case .correct, .incorrect:
            return .appTextFirstInverted
        case .neutral:
            return .appTextFirst
        }
    }

    var isButtonDisabled: Bool {
        return name.isEmpty || !isEditable
    }
    
    var isEditable: Bool {
        state == .neutral
    }

    func onCommitAnswer(text: String) {
        guard !text.isEmpty else {
            return
        }
        
        onCommit(text)
        state = getAnswerState(text)

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            name = ""
            self.state = getAnswerState(name)
        }
    }

    var body: some View {
        HStack {
            Spacer()

            CustomUIKitTextField(
                text: $name,
                placeholder: "My first name?",
                onCommit: { text in
                    onCommitAnswer(text: text)
                },
                isEditable: isEditable
            )
            .foregroundColor(textColor)

            Button {
                onCommitAnswer(text: name)
            } label: {
                Image("rightArrow")
                    .padding(12)
                    .cornerRadius(8)
                    .background(buttonBackgroundColor)
            }
            .disabled(isButtonDisabled)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(backgroundColor, lineWidth: 3)
        )
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(backgroundColor.opacity(0.2))
        )
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.appItemBackground)
        )
        .cornerRadius(8)
    }
}
