//
//  EmojiDropView.swift
//  Facematch
//
//  Created by Gaston Mazzeo on 1/28/21.
//

import SwiftUI

struct EmojiDropView: View {
    let emojis = ["😎", "❤️", "💪", "🤙", "🤓"]
    
    @State private var rotationDegree = 0.0
    @State private var verticalOffset: CGFloat = -200
    
    let emoji: String
    let finalVerticalOffset: CGFloat
    
    let delay: Double = Double.random(in: 0...3)
    let rotationDuration: Double = Double.random(in: 2...4)
    let traslationDuration: Double = Double.random(in: 2...4)
    
    private var rotationAnimation: Animation {
        Animation
            .linear(duration: rotationDuration)
            .repeatForever(autoreverses: false)
    }
    
    private var offsetAnimation: Animation {
        Animation
            .linear(duration: traslationDuration)
            .delay(delay)
            .repeatForever(autoreverses: false)
    }
    
    init(finalVerticalOffset: CGFloat) {
        self.finalVerticalOffset = finalVerticalOffset
        
        // swiftlint:disable:next force_unwrapping
        emoji = emojis.randomElement()!
    }

    var body: some View {
        Text(emoji)
            .font(.system(size: 25))
            .rotationEffect(.degrees(rotationDegree))
            .offset(y: verticalOffset)
            .onAppear {
                withAnimation(rotationAnimation) {
                    rotationDegree = 360
                }
                
                withAnimation(offsetAnimation) {
                    verticalOffset = finalVerticalOffset
                }
            }
    }
}

struct EmojiDropView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiDropView(
            finalVerticalOffset: 100
        )
    }
}
