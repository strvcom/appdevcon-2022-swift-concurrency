//
//  EmojisRainView.swift
//  Facematch
//
//  Created by Gaston Mazzeo on 1/27/21.
//

import SwiftUI

struct EmojisRainView: View {
    let emojis = ["😎", "❤️", "💪", "🤙", "🤓"]
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<50) { _ in
                EmojiDropView(
                    finalVerticalOffset: geometry.size.height * 1.2
                )
                .position(x: CGFloat.random(in: -geometry.size.width * 0.1...geometry.size.width * 1.1))
            }
        }
        .accessibility(hidden: true)
    }
}

struct EmojisRainView_Previews: PreviewProvider {
    static var previews: some View {
        EmojisRainView()
    }
}
