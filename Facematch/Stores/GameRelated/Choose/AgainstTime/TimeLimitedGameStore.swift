//
//  TimeLimitedGameStore.swift
//  Facematch
//
//  Created by Abel Osorio on 9/9/20.
//

import Combine
import CoreData
import SwiftUI

protocol TimeLimitedGameStore: ImageRetrieving, GameStore {}

// MARK: - Default implementation
extension GameStore where State == TimedPlayState {
    func nextQuestion() {
        switch state {
        case .initial:
            state = .playing(
                state: TimedPlayState(
                    index: 0,
                    // swiftlint:disable:next force_unwrapping
                    question: questions.first!,
                    answer: nil,
                    score: .initial,
                    remainingTime: 90,
                    lives: lives
                )
            )
        case let .playing(playingState) where playingState.remainingTime <= 0:
            state = .finished(score: playingState.score)
        case let .playing(playingState):
            let potentialNextQuestionIndex = playingState.index + 1

            let nextQuestionIndex = potentialNextQuestionIndex > questions.endIndex ?
                questions.startIndex :
                potentialNextQuestionIndex

            let newPlayingState = TimedPlayState(
                index: nextQuestionIndex,
                question: questions[nextQuestionIndex],
                answer: nil,
                score: playingState.score,
                remainingTime: playingState.remainingTime,
                lives: playingState.lives
            )

            state = .playing(state: newPlayingState)
        case .finished:
            break
        }
    }

    func answer(with answer: Person) {
        guard case let .playing(playingState) = state else {
            return
        }

        var finished = false
        var score = playingState.score
        var lives = playingState.lives

        if answer == playingState.question.correctAnswer {
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

        let newPlayingState = TimedPlayState(
            index: playingState.index,
            question: playingState.question,
            answer: answer,
            score: score,
            remainingTime: playingState.remainingTime - 1,
            lives: lives
        )

        state = .playing(state: newPlayingState)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            finished ? self?.state = .finished(score: score) : self?.nextQuestion()
        }
    }

    func tick(_: Date) {
        switch state {
        case let .playing(playingState) where playingState.remainingTime <= 0:
            state = .finished(score: playingState.score)
        case let .playing(playingState):
            let newPlayingState = TimedPlayState(
                index: playingState.index,
                question: playingState.question,
                answer: playingState.answer,
                score: playingState.score,
                remainingTime: playingState.remainingTime - 1,
                lives: playingState.lives
            )

            state = .playing(state: newPlayingState)
        case .initial, .finished:
            break
        }
    }
}
