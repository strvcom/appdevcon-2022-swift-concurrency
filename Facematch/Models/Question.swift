//
//  GameQuestion.swift
//  Facematch
//
//  Created by Jan Kaltoun on 03/07/2020.
//

import Foundation

struct Question {
    let id: UUID
    let person: Person
    let answers: [Person]
    let correctAnswer: Person
}

extension Question: Identifiable {}
