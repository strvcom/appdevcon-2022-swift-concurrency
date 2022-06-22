//
//  GradientButtonStyle.swift
//  Facematch
//
//  Created by Jan Kaltoun on 21.08.2020.
//

import SwiftUI

struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .foregroundColor(.appGradientText)
            .padding(16)
            .background(AnimatedGradient())
            .cornerRadius(16)
            .shadow(color: .appShadow, radius: 4, y: 4)
    }
}
