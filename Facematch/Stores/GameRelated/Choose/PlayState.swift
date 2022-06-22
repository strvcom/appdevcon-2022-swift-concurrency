//
//  PlayState.swift
//  Facematch
//
//  Created by Abel Osorio on 9/21/20.
//

import Foundation

protocol PlayState {
    var index: Int { get set }
    var question: Question { get set }
    var answer: Person? { get set }
    var score: Score { get set }
    var lives: Int? { get set }
}
