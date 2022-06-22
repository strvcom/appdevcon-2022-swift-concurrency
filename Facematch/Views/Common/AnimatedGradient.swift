//
//  AnimatedGradient.swift
//  Facematch
//
//  Created by Jan Kaltoun on 04/07/2020.
//

import SwiftUI

struct AnimatedGradient: View {
    let colors = [
        Color.appGradientFirst,
        Color.appGradientSecond,
        Color.appGradientThird,
        Color.appGradientFourth
    ]

    @State private var start = UnitPoint(x: 0, y: -2)
    @State private var end = UnitPoint(x: 3, y: 0)

    var body: some View {
        LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 5).repeatForever()) {
                    self.start = UnitPoint(x: 4, y: 0)
                    self.end = UnitPoint(x: 0, y: 2)
                    self.start = UnitPoint(x: -4, y: 20)
                    self.end = UnitPoint(x: 4, y: 0)
                }
            }
    }
}
