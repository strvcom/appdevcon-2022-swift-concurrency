//
//  LeaderboardEntry.swift
//  Facematch
//
//  Created by Abel Osorio on 3/8/21.
//

import Foundation

struct LeaderboardEntry: Identifiable, Decodable, Equatable {
    enum CodingKeys: String, CodingKey {
        case user
        case totalPoints
        case position = "rowNum"
    }

    var id: UUID {
        return user.id
    }

    let totalPoints: Int
    let user: User
    let position: Int
}
