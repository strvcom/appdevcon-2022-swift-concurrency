//
//  AnswerButton.swift
//  Facematch
//
//  Created by Abel Osorio on 9/9/20.
//

import SwiftUI

struct AnswerButton: View {
    typealias TapHandler = () -> Void
    
    let title: String
    let state: AnswerState
    var onTap: TapHandler
    
    var body: some View {
        Button(action: {
            withAnimation {
                onTap()
            }
        }) {
            AnswerView(text: title, state: state)
        }
    }
}

struct AnswerButton_Previews: PreviewProvider {
    static var previews: some View {
        AnswerButton(title: "John Doe", state: .correct, onTap: { () })
    }
}
