//
//  TypingStore.swift
//  Facematch
//
//  Created by Abel Osorio on 1/4/21.
//

import Foundation

class TypingStore: ObservableObject, UntimedTypingGameStore {
    var uniquePeople = [Person]()
    var questions = [SimpleQuestion]()
    var lives = 3

    @Published var state: GameState<UntimedTypingPlayState> = .initial
    @Injected var coreDataManager: CoreDataManaging
}
