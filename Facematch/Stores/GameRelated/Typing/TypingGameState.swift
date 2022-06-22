//
//  TypingGameState.swift
//  Facematch
//
//  Created by Abel Osorio on 9/17/20.
//

import Foundation

protocol TypingPlayState {
    var index: Int { get set }
    var question: SimpleQuestion { get set }
    var answer: String? { get set }
    var score: Score { get set }
    var lives: Int? { get set }
}

extension GameState where T: TypingPlayState {
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

    func answerState(for providedAnswer: String) -> AnswerState {
        guard
            case let .playing(state) = self,
            let currentAnswer = state.answer
        else {
            return .neutral
        }

        if providedAnswer.caseInsensitiveCompare(state.question.correctAnswer) == .orderedSame {
            return .correct
        }

        if providedAnswer == currentAnswer {
            return .incorrect
        }

        return .neutral
    }
}
