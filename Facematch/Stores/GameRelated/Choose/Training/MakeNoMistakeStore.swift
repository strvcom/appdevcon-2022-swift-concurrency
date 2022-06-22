//
//  MakeNoMistakeStore.swift
//  Facematch
//
//  Created by Abel Osorio on 9/8/20.
//

import Combine
import CoreData
import SwiftUI

class MakeNoMistakeStore: ObservableObject, NoTimeLimitGameStore {
    var cancellables = [AnyCancellable]()
    var uniquePeople = [Person]()
    var questions = [Question]()
    var lives: Int? = 1

    @Published var state: GameState<NoTimePlayingState> = .initial
    @Injected var coreDataManager: CoreDataManaging
    @Injected var apiManager: APIManaging
}
