//
//  ScoreStore.swift
//  Facematch
//
//  Created by Abel Osorio on 3/10/21.
//

import Foundation
import Combine

protocol ScoreStoring {
    func submitScore(_ score: Int, forGameID gameID: String)
}

class ScoreStore: ObservableObject, ScoreStoring {
    @Injected private var apiManager: APIManaging
    @Injected private var userDefaults: UserDefaults

    // TODO: - To be used when we have an endpoint to know the result of the score
    let leaderboardPosition: Int? = nil

    private var cancellables = [AnyCancellable]()

    func submitScore(_ score: Int, forGameID gameID: String) {
        let resultURL = Configuration.default.apiBaseURL.appendingPathComponent("games/result")
        let params: [String: Any] = [
            "gameId": gameID,
            "points": score
        ]

        apiManager.post(url: resultURL, params: params)
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in
                self.userDefaults.lastTimePlayingLeague = Date().stringValue
            })
            .store(in: &cancellables)
    }
}
