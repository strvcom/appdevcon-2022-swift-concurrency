//
//  PrimaryButtonStyle.swift
//  Facematch
//
//  Created by Jan Kaltoun on 18.01.2021.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .font(.appButtonTitle)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 56)
            .background(Color.appButtonPrimaryBackground)
            .cornerRadius(8)
    }
}
