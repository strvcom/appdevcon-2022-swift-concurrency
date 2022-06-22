//
//  ReverseFacematchPlayingView.swift
//  Facematch
//
//  Created by Abel Osorio on 9/15/20.
//

import SwiftUI

struct ReverseFacematchPlayingView: View {
    typealias OnSurrenderHandler = () -> Void
    typealias OnAnswerHandler = (Person) -> Void
    typealias AnswerStateGetter = (Person) -> AnswerState

    let score: Score
    let lives: Int?
    let headerTitle: String
    let question: Question
    let possibleAnswers: [Person]
    let images: [Image]
    let answer: Person?

    var enumeratedPossibleAnswers: [(Int, Person)] {
        Array(zip(possibleAnswers.indices, possibleAnswers))
    }

    var onSurrender: OnSurrenderHandler
    var onAnswer: OnAnswerHandler
    var getAnswerState: AnswerStateGetter
    var gridItemLayout = Array(repeating: GridItem(.flexible(minimum: 100, maximum: 250)), count: 2)

    var body: some View {
        VStack {
            HeaderView(
                lives: lives,
                hasLostLife: answer != nil && question.correctAnswer != answer,
                title: headerTitle,
                isPracticeGame: true,
                onSurrender: { onSurrender() }
            )
            .padding()

            Spacer()

            Text(question.person.fullNameInTwoLines.diacriticInsensitive)
                .font(.appMainTitle)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()

            LazyVGrid(columns: gridItemLayout, spacing: 2) {
                ForEach(enumeratedPossibleAnswers, id: \.1.id) { index, person in
                    FireworksContainerView(powerMultiplier: 2) {
                        AnswerImageButton(
                            person: person,
                            image: images[index],
                            state: getAnswerState(person),
                            onTap: onAnswer
                        )
                    } displayFireworksHandler: {
                        answer != nil && person == answer
                    } stateHandler: {
                        getAnswerState(person)
                    }
                }
            }
            .padding()
        }
    }
}
