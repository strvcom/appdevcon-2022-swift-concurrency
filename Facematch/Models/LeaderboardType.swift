//
//  LeaderboardType.swift
//  Facematch
//
//  Created by Abel Osorio on 3/8/21.
//

import Foundation

enum LeaderboardType: String, Identifiable, CaseIterable {
    case week
    case month
    case allTime

    var id: String {
        return self.rawValue
    }

    var title: String {
        switch self {
        case .week:
            return "THIS WEEK"
        case .month:
            return "THIS MONTH"
        case .allTime:
            return "ALL TIME"
        }
    }
}
