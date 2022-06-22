//
//  SimpleQuestion.swift
//  Facematch
//
//  Created by Abel Osorio on 9/17/20.
//

import Foundation

struct SimpleQuestion {
    let id: UUID
    let person: Person
    let correctAnswer: String
}

extension SimpleQuestion: Identifiable {}
