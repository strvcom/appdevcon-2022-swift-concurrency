//
//  TypingIsHarderView.swift
//  Facematch
//
//  Created by Abel Osorio on 9/12/20.
//

import SwiftUI

struct TypingIsHarderView: View {
    @StateObject var gameStore = TypingStore()

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
            case let .playing(playingState):
                TypingIsHarderPlayingView(
                    score: playingState.score,
                    lives: playingState.lives,
                    headerTitle: "",
                    question: playingState.question,
                    answer: playingState.answer,
                    image: gameStore.photo(for: playingState.question.person),
                    onSurrender: { gameStore.endGame() },
                    onAnswer: { name in gameStore.answer(with: name) },
                    getAnswerState: { name in gameStore.state.answerState(for: name) }
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

struct TypingIsHarderView_Previews: PreviewProvider {
    static var previews: some View {
        TypingIsHarderView(game: .casual(mode: .typingIsHarder))
    }
}
