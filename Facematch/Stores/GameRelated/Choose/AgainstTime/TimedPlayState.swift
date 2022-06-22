//
//  TimedPlayState.swift
//  Facematch
//
//  Created by Abel Osorio on 9/17/20.
//

import Foundation

struct TimedPlayState: PlayState {
    var index: Int
    var question: Question
    var answer: Person?
    var score: Score
    var remainingTime: TimeInterval
    var lives: Int?
}

extension GameState where T == TimedPlayState {
    var remainingTime: TimeInterval {
        switch self {
        case .initial:
            return 60
        case let .playing(state):
            return state.remainingTime
        case .finished:
            return 0
        }
    }

    var formattedRemainingTime: String {
        let formatter = DateComponentsFormatter()

        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad

        guard let formattedRemainingTime = formatter.string(from: remainingTime) else {
            fatalError("Game time is somehow messed up.")
        }

        return formattedRemainingTime
    }
}
