//
//  CurrentLeagueGame.swift
//  Facematch
//
//  Created by Abel Osorio on 3/10/21.
//

import Foundation

struct CurrentLeagueGame: Identifiable, Decodable, Equatable {
    enum CodingKeys: String, CodingKey {
        case id
        case gameType
        case startsAt
        case endsAt
    }

    let id: UUID
    let gameType: GameMode
    let startsAt: Date
    let endsAt: Date
}
