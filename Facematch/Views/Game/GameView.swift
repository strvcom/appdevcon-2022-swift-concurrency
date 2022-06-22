//
//  GameView.swift
//  Facematch
//
//  Created by Abel Osorio on 9/9/20.
//

import SwiftUI

struct GameView: View {
    @StateObject private var scoreStore = ScoreStore()

    var game: Game
    var gameMode: GameMode {
        switch game {
        case let .casual(mode):
            return mode
        case let .league(game):
            return game.gameType
        }
    }

    var body: some View {
        ZStack {
            Color.appBackground
                .edgesIgnoringSafeArea(.all)


            gameViewForGame(
                game: game,
                gameMode: gameMode
            )
            .environmentObject(scoreStore)
        }
    }

    @ViewBuilder
    func gameViewForGame(game: Game, gameMode: GameMode) -> some View {
        switch gameMode {
        case .timeChallenge:
            TimeChallengeView(game: game)
        case .training:
            TrainingView(game: game)
        case .makeNoMistake:
            NoMistakesView(game: game)
        case .typingIsHarder:
            TypingIsHarderView(game: game)
        case .reverseFacematch:
            ReverseFacematchView(game: game)
        case .facematch:
            FacematchView(game: game)
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: .casual(mode: .facematch))
    }
}
