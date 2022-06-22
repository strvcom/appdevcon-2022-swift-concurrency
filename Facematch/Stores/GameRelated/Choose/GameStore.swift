//
//  GameStore.swift
//  Facematch
//
//  Created by Abel Osorio on 9/8/20.
//

import Combine
import CoreData
import SwiftUI

protocol GameStore: AnyObject {
    associatedtype State: PlayState

    var coreDataManager: CoreDataManaging { get }
    var uniquePeople: [Person] { get set }
    var questions: [Question] { get set }
    var state: GameState<State> { get set }
    var lives: Int? { get set }
    var cancellables: [AnyCancellable] { get set }
    
    func startGame()
    func prepareGame()

    func endGame()
    func nextQuestion()
    func answer(with answer: Person)
}

extension GameStore {
    func startGame() {
        prepareGame()
        
        #if os(watchOS)
        // If questions are empty start listening for CK notifications
        if questions.isEmpty {
            NotificationCenter.default.publisher(for: NSPersistentCloudKitContainer.eventChangedNotification)
                .sink(receiveValue: { [weak self] notification in
                    if let cloudEvent = notification.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey]
                        as? NSPersistentCloudKitContainer.Event {
                        if cloudEvent.succeeded {
                            // if cloud sync succeeds prepare questions
                            self?.prepareGame()
                            self?.nextQuestion()
                        }
                    }
                })
                .store(in: &cancellables)
        } else {
            nextQuestion()
        }
        #endif
        
        nextQuestion()
    }

    func prepareGame() {
        let context = coreDataManager.viewContext

        let personFetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        
        guard let result = try? context.fetch(personFetchRequest) else {
            return
        }

        let people = result.shuffled()

        uniquePeople = result.unique()

        questions = people
            .map { person in
                var answers = uniquePeople
                    .filter { $0 != person }
                    .random(3)
                    .map { $0 }

                let answer = person

                answers.append(answer)
                answers.shuffle()

                return Question(
                    id: UUID(),
                    person: person,
                    answers: answers,
                    correctAnswer: answer
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
