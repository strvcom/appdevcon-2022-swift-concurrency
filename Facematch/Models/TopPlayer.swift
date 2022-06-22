//
//  TopPlayer.swift
//  Facematch
//
//  Created by Abel Osorio on 3/17/21.
//

import Foundation

struct TopPlayer: Hashable {
    let name: String
    let imageURL: URL
    let slackId: String
    let position: LeaderboardPosition
    let points: Int
}
