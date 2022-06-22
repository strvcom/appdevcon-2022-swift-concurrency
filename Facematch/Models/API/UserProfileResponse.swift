//
//  UserProfileResponse.swift
//  Facematch
//
//  Created by Abel Osorio on 3/4/21.
//

import Foundation

struct UserProfileResponse: Decodable, Equatable {
    let user: User
    let gamesWon: Int
    let totalPoints: Int
    let dayStreak: Int
    let position: Int
}
