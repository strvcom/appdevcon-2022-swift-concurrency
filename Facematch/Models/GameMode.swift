//
//  GameMode.swift
//  Facematch
//
//  Created by Abel Osorio on 9/9/20.
//

import Foundation
import SwiftUI

enum GameMode: String, Identifiable, CaseIterable, Decodable, Equatable {
    case timeChallenge
    case training
    case makeNoMistake
    case typingIsHarder
    case reverseFacematch
    case facematch

    static let practiceModes: [GameMode] = [.training, .facematch, .reverseFacematch, .typingIsHarder, .makeNoMistake, .timeChallenge]
    static let watchPracticeModes: [GameMode] = [.training, .facematch, .makeNoMistake, .timeChallenge, .reverseFacematch]

    var id: String {
        switch self {
        case .timeChallenge: return "time_challenge"
        case .training: return "training"
        case .makeNoMistake: return "make_no_mistake"
        case .typingIsHarder: return "typing_is_harder"
        case .reverseFacematch: return "reverse_facematch"
        case .facematch: return "facematch"
        }
    }

    var title: String {
        switch self {
        case .timeChallenge: return "Time Challenge"
        case .training: return "Training"
        case .makeNoMistake: return "Make no Mistake"
        case .typingIsHarder: return "Typing is Harder"
        case .reverseFacematch: return "Reverse Facematch"
        case .facematch: return "Facematch"
        }
    }

    var description: String {
        switch self {
        case .timeChallenge: return "90 seconds to match them all"
        case .training: return "No time limit"
        case .makeNoMistake: return "Only one chance"
        case .typingIsHarder: return "Typing challenge"
        case .reverseFacematch: return "Pick a face to a name"
        case .facematch: return "Pick a name to a face"
        }
    }

    var iconName: String {
        switch self {
        case .timeChallenge: return "noLimitIcon"
        case .training: return "noLimitIcon"
        case .makeNoMistake: return "noMistakeIcon"
        case .typingIsHarder: return "typingIsHarderIcon"
        case .reverseFacematch: return "reverseIcon"
        case .facematch: return "facematchIcon"
        }
    }
}
