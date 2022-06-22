//
//  TimeChallengeView.swift
//  Facematch
//
//  Created by Jan Kaltoun on 03/07/2020.
//

import CoreData
import SwiftUI

struct TimeChallengeView: View {
    @StateObject var gameStore = TimeChallengeStore()

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
                GamePlayingView(
                    score: state.score,
                    lives: state.lives,
                    headerTitle: gameStore.state.formattedRemainingTime,
                    question: state.question,
                    answer: state.answer,
                    image: gameStore.photo(for: state.question.person),
                    isPracticeGame: false,
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

struct TimeChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        TimeChallengeView(game: .casual(mode: .facematch))
    }
}
