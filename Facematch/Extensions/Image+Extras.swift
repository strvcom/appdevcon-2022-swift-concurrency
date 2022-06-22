//
//  Image+Extras.swift
//  Facematch
//
//  Created by Nick Beresnev on 3/31/21.
//

import Foundation
import SwiftUI

extension Image {
    func leaderboardStyled(with size: CGFloat) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .clipShape(Circle())
    }
}
