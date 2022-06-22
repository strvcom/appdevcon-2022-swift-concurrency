//
//  Collection+LeaderboardEntry.swift
//  Facematch
//
//  Created by Abel Osorio on 3/18/21.
//

import Foundation

extension Collection where Self.Element == LeaderboardEntry {
    var topThreePlayersInPodiumOrder: [TopPlayer?] {
        var topThree: [LeaderboardEntry?] = Array(self.prefix(3))
        if topThree.count == 3 {
            topThree.swapAt(0, 1)
        } else if topThree.count == 2 {
            topThree.reverse()
            topThree.append(nil)
        } else {
            topThree.insert(nil, at: 0)
            topThree.append(nil)
        }

        let topThreePlayers = topThree.enumerated().map { index, entry -> TopPlayer? in
            guard let entry = entry else {
                return nil
            }

            var position: LeaderboardPosition
            switch index {
            case 0:
                position = .second
            case 1:
                position = .first
            case 2:
                position = .third
            default:
                return nil
            }

            return TopPlayer(
                name: entry.user.shortName,
                imageURL: entry.user.imageURL,
                slackId: entry.user.slackId,
                position: position,
                points: entry.totalPoints
            )
        }

        return topThreePlayers
    }

    var restOfThePlayers: [LeaderboardEntry] {
        guard
          self.count > 3,
          let fourthIndex = 3 as? Self.Index
        else {
            return []
        }

        return Array(self.suffix(from: fourthIndex))
    }
}
