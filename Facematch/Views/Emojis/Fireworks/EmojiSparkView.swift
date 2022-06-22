//
//  EmojiSparkView.swift
//  Facematch
//
//  Created by Gaston Mazzeo on 1/28/21.
//

import SwiftUI

struct EmojiSparkView: View {
    @State private var rotationDegree = 0.0
    @State private var opacity = 1.0

    let emoji: String
    let horizontalOffset: CGFloat
    let finalRotation: Double

    let delay = Double.random(in: 0...0.5)
    
    private var rotationAnimation: Animation {
        Animation
            .easeOut(duration: Double.random(in: 1...2.5))
            .delay(delay)
            .repeatForever(autoreverses: false)
    }
    
    private var opacityAnimation: Animation {
        Animation
            .easeInOut(duration: 2)
            .delay(delay)
            .repeatForever(autoreverses: false)
    }

    var body: some View {
        Text(emoji)
            .font(.system(size: 25))
            .offset(x: horizontalOffset)
            .rotationEffect(.degrees(rotationDegree))
            .opacity(opacity)
            .onAppear {
                withAnimation(rotationAnimation) {
                    rotationDegree = finalRotation
                }
                
                withAnimation(opacityAnimation) {
                    opacity = 0
                }
            }
    }
}

struct EmojiSparkView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiSparkView(
            emoji: "❤️",
            horizontalOffset: 10,
            finalRotation: 180
        )
    }
}
