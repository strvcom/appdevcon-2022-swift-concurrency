//
//  GameState.swift
//  Facematch
//
//  Created by Abel Osorio on 9/8/20.
//

import Foundation

enum GameState<T> {
    case initial
    case playing(state: T)
    case finished(score: Score)
}

extension GameState where T: PlayState {
    var score: Score {
        switch self {
        case .initial:
            return .initial
        case let .finished(score):
            return score
        case let .playing(state):
            return state.score
        }
    }

    func answerState(for providedAnswer: Person) -> AnswerState {
        guard
            case let .playing(state) = self,
            let currentAnswer = state.answer
        else {
            return .neutral
        }

        if providedAnswer == state.question.correctAnswer {
            return .correct
        }

        if providedAnswer == currentAnswer {
            return .incorrect
        }

        return .neutral
    }
}
