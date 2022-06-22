//
//  MakeNoMistakeTypingStore.swift
//  Facematch
//
//  Created by Abel Osorio on 9/17/20.
//

import Combine
import CoreData
import SwiftUI

class MakeNoMistakeTypingStore: ObservableObject, UntimedTypingGameStore {
    var uniquePeople = [Person]()
    var questions = [SimpleQuestion]()
    var lives = 1

    @Published var state: GameState<UntimedTypingPlayState> = .initial
    @Injected var coreDataManager: CoreDataManaging
}
