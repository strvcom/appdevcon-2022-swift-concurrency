//
//  UntimedTypingGameStore.swift
//  Facematch
//
//  Created by Abel Osorio on 9/17/20.
//

import Combine
import CoreData
import SwiftUI

protocol UntimedTypingGameStore: ImageRetrieving, TypingGameStore {}

// MARK: - Default implementation
extension TypingGameStore where State == UntimedTypingPlayState {
    func nextQuestion() {
        switch state {
        case .initial:
            state = .playing(
                state: UntimedTypingPlayState(
                    index: 0,
                    // swiftlint:disable:next force_unwrapping
                    question: questions.first!,
                    answer: nil,
                    score: .initial,
                    remainingItems: questions.count,
                    lives: lives
                )
            )
        case let .playing(playingState) where playingState.remainingItems <= 0:
            state = .finished(score: playingState.score)
        case let .playing(playingState):
            let potentialNextQuestionIndex = playingState.index + 1

            let nextQuestionIndex = potentialNextQuestionIndex > questions.endIndex ?
                questions.startIndex :
                potentialNextQuestionIndex

            let newPlayingState = UntimedTypingPlayState(
                index: nextQuestionIndex,
                question: questions[nextQuestionIndex],
                answer: nil,
                score: playingState.score,
                remainingItems: playingState.remainingItems,
                lives: playingState.lives
            )

            state = .playing(state: newPlayingState)
        case .finished:
            break
        }
    }

    func answer(with answer: String) {
        guard case let .playing(playingState) = state else {
            return
        }

        var finished = false
        var score = playingState.score
        var lives = playingState.lives

        if answer.caseInsensitiveCompare(playingState.question.correctAnswer) == .orderedSame {
            score.correct += 1
        } else {
            score.incorrect += 1
            
            if let currentLives = lives {
                if currentLives <= 1 {
                    finished = true
                }
                
                lives = currentLives - 1
            }
        }

        let newPlayingState = UntimedTypingPlayState(
            index: playingState.index,
            question: playingState.question,
            answer: answer,
            score: score,
            remainingItems: playingState.remainingItems - 1,
            lives: lives
        )

        state = .playing(state: newPlayingState)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            finished ?
                self?.state = .finished(score: score) :
                self?.nextQuestion()
        }
    }
}
