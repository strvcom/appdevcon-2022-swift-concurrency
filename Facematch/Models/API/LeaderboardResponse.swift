//
//  LeaderboardResponse.swift
//  Facematch
//
//  Created by Abel Osorio on 3/8/21.
//

import Foundation

struct LeaderboardResponse: Decodable, Equatable {
    enum CodingKeys: String, CodingKey {
        case allTime = "allTimeUsers"
        case monthly = "monthUsers"
        case weekly = "weekUsers"

    }

    let weekly: [LeaderboardEntry]
    let monthly: [LeaderboardEntry]
    let allTime: [LeaderboardEntry]
}
