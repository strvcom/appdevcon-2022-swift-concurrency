//
//  TrainingStore.swift
//  Facematch
//
//  Created by Abel Osorio on 9/7/20.
//

import Combine
import CoreData
import SwiftUI

class TrainingStore: ObservableObject, NoTimeLimitGameStore {
    var cancellables = [AnyCancellable]()
    var uniquePeople = [Person]()
    var questions = [Question]()
    var lives: Int?

    @Published var state: GameState<NoTimePlayingState> = .initial
    @Injected var coreDataManager: CoreDataManaging
    @Injected var apiManager: APIManaging
}
