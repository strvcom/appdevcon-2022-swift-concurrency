//
//  TrainingView.swift
//  Facematch
//
//  Created by Abel Osorio on 9/7/20.
//

import CoreData
import SwiftUI

struct TrainingView: View {
    @StateObject var gameStore = TrainingStore()

    @Environment(\.presentationMode) var presentationMode

    let game: Game

    var body: some View {
        Group {
            switch gameStore.state {
            case .initial:
                LoadingIndicator()
            case let .finished(score):
                FinishedView(
                    score: score,
                    shouldShowIncorrectAnswers: true,
                    game: game,
                    onContinue: { presentationMode.wrappedValue.dismiss() },
                    onShareToSlack: { () }
                )
            case let .playing(state):
                GamePlayingView(
                    score: state.score,
                    lives: state.lives,
                    headerTitle: "",
                    question: state.question,
                    answer: state.answer,
                    image: gameStore.photo(for: state.question.person),
                    isPracticeGame: true,
                    onSurrender: { gameStore.endGame() },
                    onAnswer: { person in gameStore.answer(with: person) },
                    getState: { person in gameStore.state.answerState(for: person) }
                )
            }
        }
        .onAppear {
            if case .initial = gameStore.state {
                gameStore.startGame()
            }
        }
    }
}

struct PracticeView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingView(game: .casual(mode: .training))
    }
}
