//
//  SecondaryButtonStyle.swift
//  Facematch
//
//  Created by Jan Kaltoun on 18.01.2021.
//

import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .font(.appButtonTitle)
            .foregroundColor(.appButtonSecondaryText)
            .frame(maxWidth: .infinity, minHeight: 56)
            .background(Color.appButtonSecondaryBackground)
            .cornerRadius(8)
    }
}
