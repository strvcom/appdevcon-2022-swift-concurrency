//
//  TypingGameStore.swift
//  Facematch
//
//  Created by Abel Osorio on 9/17/20.
//

import Combine
import CoreData
import SwiftUI

protocol TypingGameStore: AnyObject {
    associatedtype State: TypingPlayState

    var coreDataManager: CoreDataManaging { get }
    var questions: [SimpleQuestion] { get set }
    var state: GameState<State> { get set }
    var lives: Int { get set }

    func startGame()
    func endGame()
    func nextQuestion()
    func answer(with answer: String)
}

extension TypingGameStore {
    func startGame() {
        prepareGame()
        nextQuestion()
    }

    func prepareGame() {
        let context = coreDataManager.viewContext

        let personFetchRequest: NSFetchRequest<Person> = Person.fetchRequest()

        guard let result = try? context.fetch(personFetchRequest) else {
            return
        }

        let people = result.shuffled().unique()

        questions = people
            .map { person in
                let answer = person.firstName ?? person.realName
                return SimpleQuestion(
                    id: UUID(),
                    person: person,
                    // swiftlint:disable:next force_unwrapping
                    correctAnswer: answer!
                )
            }

        state = .initial
    }

    func endGame() {
        guard case let .playing(playingState) = state else {
            return
        }

        state = .finished(score: playingState.score)
    }
}
