//
//  ChooseGameModeStore.swift
//  Facematch
//
//  Created by Abel Osorio on 12/29/20.
//

import Foundation
import Combine

class ChooseGameModeStore: ObservableObject {
    @Injected private var apiManager: APIManaging
    @Injected private var userDefaults: UserDefaults
    
    @Published var state: State = .initial

    let practiceModes = GameMode.practiceModes
    let watchPracticeModes = GameMode.watchPracticeModes

    private var cancellables = [AnyCancellable]()

    #if !os(watchOS)
    func fetchCurrentLeagueGame() {
        let currentGameURL = Configuration.default.apiBaseURL.appendingPathComponent("games/current")

        apiManager.fetch(url: currentGameURL)
            .decode(type: CurrentLeagueGame.self, decoder: apiManager.decoder)
            .receive(on: DispatchQueue.main)
            .map { [weak self] game -> State in
                return .success(
                    game: game,
                    canPlayAt: self?.canPlayAt
                )
            }
            .catch { error -> AnyPublisher<State, Never> in
                Just(.failed(error: ChooseGameError.unableToRetrieveLeagueGame))
                    .eraseToAnyPublisher()
            }
            .assign(to: \.state, on: self)
            .store(in: &cancellables)
    }
    #endif
}

// MARK: - League Game related
extension ChooseGameModeStore {
    var canPlayAt: Date? {
        guard
            let lastTimePlayingLeagueString = userDefaults.lastTimePlayingLeague,
            let lastTimePlayingLeagueDate = lastTimePlayingLeagueString.dateValueFromFormatter
        else {
            return nil
        }

        // swiftlint:disable:next force_unwrapping
        return Calendar.current.date(byAdding: .day, value: 1, to: lastTimePlayingLeagueDate)!
    }
}

// MARK: - State

extension ChooseGameModeStore {
    enum State: Equatable {
        case initial
        case inProgress
        #if !os(watchOS)
        case success(game: CurrentLeagueGame, canPlayAt: Date?)
        #endif
        case failed(error: ChooseGameError)

        var isFailed: Bool {
            switch self {
            case .initial, .inProgress:
                return false
            #if !os(watchOS)
            case .success:
                return false
            #endif
            case .failed:
                return true
            }
        }
    }
}

// MARK: - ProfileError

extension ChooseGameModeStore {
    enum ChooseGameError: Error {
        case unableToRetrieveLeagueGame
    }
}
