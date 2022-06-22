//
//  AnswerImageButton.swift
//  Facematch
//
//  Created by Abel Osorio on 9/16/20.
//

import SwiftUI

struct AnswerImageButton: View {
    typealias TapHandler = (Person) -> Void
    
    let person: Person
    let image: Image
    let state: AnswerState
    var onTap: TapHandler

    var borderColor: Color {
        switch state {
        case .correct:
            return .appAnswerCorrect
        case .incorrect:
            return .appAnswerIncorrect
        case .neutral:
            return .clear
        }
    }

    var body: some View {
        Button(action: {
            withAnimation {
                onTap(person)
            }
        }) {
            image.resizable()
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(borderColor, lineWidth: 5)
                )
                .padding(4)
                .id("question_image_\(person.fullName)")
        }
    }
}
