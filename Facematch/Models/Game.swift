//
//  Game.swift
//  Facematch
//
//  Created by Abel Osorio on 3/18/21.
//

import Foundation

enum Game {
    case league(game: CurrentLeagueGame)
    case casual(mode: GameMode)

    var isCasual: Bool {
        switch self {
        case .casual:
            return true
        case .league:
            return false
        }
    }

    var isLeagueGame: Bool {
        return !isCasual
    }
}

extension Game: Equatable {}
