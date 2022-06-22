//
//  LeaderboardPosition.swift
//  Facematch
//
//  Created by Abel Osorio on 3/17/21.
//

import SwiftUI

enum LeaderboardPosition: Int {
    case first = 1
    case second = 2
    case third = 3
    case other = 4

    var image: Image? {
        switch self {
        case .first:
            return Image("goldMedal")
        case .second:
            return Image("silverMedal")
        case .third:
            return Image("bronzeMedal")
        case .other:
            return nil
        }
    }
}
