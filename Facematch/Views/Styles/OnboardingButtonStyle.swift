//
//  OnboardingButtonStyle.swift
//  Facematch
//
//  Created by Nick Beresnev on 4/2/21.
//

import SwiftUI

struct OnboardingButtonStyle: ButtonStyle {
    let isLastStep: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.appButtonTitle)
            .foregroundColor(isLastStep ? .appButtonPrimaryText : .appButtonSecondaryText)
            .frame(maxWidth: .infinity, maxHeight: 56)
            .background(isLastStep ? Color.appButtonPrimaryBackground : Color.appButtonSecondaryBackground)
            .cornerRadius(8)
    }
}
