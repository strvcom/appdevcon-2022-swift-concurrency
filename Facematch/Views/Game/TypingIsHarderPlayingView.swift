//
//  TypingIsHarderPlayingView.swift
//  Facematch
//
//  Created by Abel Osorio on 9/12/20.
//

import SwiftUI

struct TypingIsHarderPlayingView: View {
    typealias OnSurrenderHandler = () -> Void
    typealias OnAnswerHandler = (String) -> Void

    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    let score: Score
    let lives: Int?
    let headerTitle: String
    let question: SimpleQuestion
    let answer: String?
    let image: Image

    var onSurrender: OnSurrenderHandler
    var onAnswer: OnAnswerHandler
    var getAnswerState: AnswerTextField.AnswerStateGetter
    
    var isIncorrectAnswer: Bool {
        answer != nil && answer?.caseInsensitiveCompare(question.correctAnswer) != .orderedSame
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                VStack(spacing: 20) {
                    HeaderView(
                        lives: lives,
                        hasLostLife: isIncorrectAnswer,
                        title: headerTitle,
                        isPracticeGame: true,
                        onSurrender: { onSurrender() }
                    )
                    .padding()

                    PhotoView(identifier: "question_image_\(question.id)", image: image)
                        .if(horizontalSizeClass == .regular) {
                            $0.frame(maxWidth: geometry.size.width / 2)
                        }
                    
                    FireworksContainerView {
                        AnswerTextField(
                            state: .neutral,
                            getAnswerState: getAnswerState,
                            onCommit: { text in
                                onAnswer(text)
                            }
                        )
                    } displayFireworksHandler: {
                        answer != nil
                    } stateHandler: {
                        getAnswerState(answer ?? "")
                    }
                }
                .padding([.trailing, .leading])
                
                CorrectAnswerBar(answer: question.correctAnswer)
                    .opacity(isIncorrectAnswer ? 1 : 0)
                    .offset(y: isIncorrectAnswer ? 0 : -geometry.size.height / 2)
            }
        }
    }
}
