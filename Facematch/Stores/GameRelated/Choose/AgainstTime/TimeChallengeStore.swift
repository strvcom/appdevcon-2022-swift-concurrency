//
//  TimeChallengeStore.swift
//  Facematch
//
//  Created by Jan Kaltoun on 03/07/2020.
//

import Combine
import CoreData
import SwiftUI

class TimeChallengeStore: ObservableObject, TimeLimitedGameStore {
    var uniquePeople = [Person]()
    var questions = [Question]()
    var lives: Int? = 3

    @Published var state: GameState<TimedPlayState> = .initial
    @Injected var coreDataManager: CoreDataManaging
    @Injected var apiManager: APIManaging

    var cancellables = [AnyCancellable]()

    lazy var dateComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()

        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad

        return formatter
    }()

    init() {
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: tick)
            .store(in: &cancellables)
    }
}
