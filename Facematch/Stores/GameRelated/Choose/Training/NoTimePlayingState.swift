//
//  NoTimePlayingState.swift
//  Facematch
//
//  Created by Abel Osorio on 9/17/20.
//

import Foundation

struct NoTimePlayingState: PlayState {
    var index: Int
    var question: Question
    var answer: Person?
    var score: Score
    var remainingItems: Int
    var lives: Int?
}
