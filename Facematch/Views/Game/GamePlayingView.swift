//
//  GamePlayingView.swift
//  Facematch
//
//  Created by Abel Osorio on 9/9/20.
//

import SwiftUI

struct GamePlayingView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    typealias OnSurrenderHandler = () -> Void
    typealias OnAnswerHandler = (Person) -> Void
    typealias AnswerStateGetter = (Person) -> AnswerState

    let score: Score
    let lives: Int?
    let headerTitle: String
    let question: Question
    let answer: Person?
    let image: Image
    let isPracticeGame: Bool

    var onSurrender: OnSurrenderHandler
    var onAnswer: OnAnswerHandler
    var getState: AnswerStateGetter
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    HeaderView(
                        lives: lives,
                        hasLostLife: answer != nil && question.correctAnswer != answer,
                        title: headerTitle,
                        isPracticeGame: isPracticeGame,
                        onSurrender: { onSurrender() }
                    )
                    .padding()
                    
                    PhotoView(identifier: "question_image_\(question.id)", image: image)
                        .if(horizontalSizeClass == .regular) {
                            $0.frame(maxWidth: geometry.size.width / 2)
                        }
                    
                    VStack(spacing: 16) {
                        Spacer()
                        
                        ForEach(question.answers, id: \.self) { person in
                            FireworksContainerView {
                                AnswerButton(
                                    title: person.fullName,
                                    state: getState(person),
                                    onTap: { onAnswer(person) }
                                )
                                .disabled(answer != nil)
                            } displayFireworksHandler: {
                                answer != nil && person == answer
                            } stateHandler: {
                                getState(person)
                            }
                        }
                        
                        if horizontalSizeClass == .regular {
                            Spacer()
                        }
                    }
                    .padding()
                    .if(horizontalSizeClass == .regular) {
                        $0.padding(.horizontal, 120)
                    }
                }
            }
        }
    }
}
