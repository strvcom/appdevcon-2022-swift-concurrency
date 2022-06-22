//
//  OnboardingStep.swift
//  Facematch
//
//  Created by Nick Beresnev on 4/2/21.
//

import Foundation
import SwiftUI

enum OnboardingStep: Equatable, Hashable, Identifiable {
    case step1(String)
    case step2
    case step3
    case step4
    
    var image: Image {
        switch self {
        case .step1:
            return Image("Onboarding/step1")
        case .step2:
            return Image("Onboarding/step2")
        case .step3:
            return Image("Onboarding/step3")
        case .step4:
            return Image("Onboarding/step4")
        }
    }
    
    var title: String {
        switch self {
        case let .step1(name):
            return "Hi, \(name)"
        case .step2:
            return "Know the people"
        case .step3:
            return "Play the league"
        case .step4:
            return "Win prizes"
        }
    }
    
    var description: String {
        switch self {
        case .step1:
            return "We‘re thrilled to have you in STRV!"
        case .step2:
            return "Meeting new people in short time can be tough. We made app to ease the pain."
        case .step3:
            return "Make your way through the leaderboard and show who knows the most people"
        case .step4:
            return "Every week the top three players earn great prizes while learning."
        }
    }
    
    var id: Int {
        switch self {
        case .step1:
            return 0
        case .step2:
            return 1
        case .step3:
            return 2
        case .step4:
            return 3
        }
    }
}

extension OnboardingStep: CaseIterable {
    static var allCases: [OnboardingStep] {
        return [
            .step1(""),
            .step2,
            .step3,
            .step4
        ]
    }
}
