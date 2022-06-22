//
//  UntimedTypingPlayState.swift
//  Facematch
//
//  Created by Abel Osorio on 9/17/20.
//

import Foundation

struct UntimedTypingPlayState: TypingPlayState {
    var index: Int
    var question: SimpleQuestion
    var answer: String?
    var score: Score
    var remainingItems: Int
    var lives: Int?
}
