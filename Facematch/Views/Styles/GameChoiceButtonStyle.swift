//
//  GameChoiceButtonStyle.swift
//  Facematch
//
//  Created by Abel Osorio on 9/14/20.
//

import SwiftUI

struct GameChoiceButtonStyle: ButtonStyle {
    let backgroundColor: Color

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(backgroundColor)
            .cornerRadius(16)
            .frame(maxWidth: .infinity)
    }
}
