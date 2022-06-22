//
//  ReverseFacematchView.swift
//  Facematch
//
//  Created by Abel Osorio on 9/15/20.
//

import SwiftUI

struct ReverseFacematchView: View {
    @StateObject var gameStore = FacematchStore()

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
                    game: game,
                    onContinue: { presentationMode.wrappedValue.dismiss() },
                    onShareToSlack: { () }
                )
            case let .playing(state):
                ReverseFacematchPlayingView(
                    score: state.score,
                    lives: state.lives,
                    headerTitle: "",
                    question: state.question,
                    possibleAnswers: state.question.answers,
                    images: gameStore.photos(for: state.question),
                    answer: state.answer,
                    onSurrender: { gameStore.endGame() },
                    onAnswer: { person in gameStore.answer(with: person) },
                    getAnswerState: { person in gameStore.state.answerState(for: person) }
                )
                .background(Color.appBackground)
            }
        }
        .onAppear {
            if case .initial = gameStore.state {
                gameStore.startGame()
            }
        }
    }
}

struct ReverseFacematchView_Previews: PreviewProvider {
    static var previews: some View {
        ReverseFacematchView(game: .casual(mode: .reverseFacematch))
    }
}
