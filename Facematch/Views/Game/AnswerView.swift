//
//  AnswerView.swift
//  Facematch
//
//  Created by Jan Kaltoun on 03/07/2020.
//

import SwiftUI

struct AnswerView: View {
    let text: String
    let state: AnswerState

    var backgroundColor: Color {
        switch state {
        case .correct:
            return .appAnswerCorrect
        case .incorrect:
            return .appAnswerIncorrect
        case .neutral:
            return .appAnswerNeutral
        }
    }

    var textColor: Color {
        switch state {
        case .correct, .incorrect:
            return .appTextFirst
        case .neutral:
            return .appTextFirst
        }
    }

    var body: some View {
        Text(text)
            .font(Font.customMaisonNeueBold(ofSize: 16, relativeTo: .headline))
            .padding(16)
            .frame(maxWidth: .infinity)
            .foregroundColor(textColor)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(backgroundColor, lineWidth: 2)
            )
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(backgroundColor.opacity(0.2))
            )
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.appAnswerNeutral)
            )
    }
}

struct AnswerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AnswerView(text: "Keanu Reeves", state: .correct)
            AnswerView(text: "Angelina Jolie", state: .incorrect)
            AnswerView(text: "Tom Hanks", state: .neutral)
        }
    }
}
