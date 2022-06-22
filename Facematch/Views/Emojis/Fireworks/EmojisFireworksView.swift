//
//  EmojisFireworksView.swift
//  Facematch
//
//  Created by Gaston Mazzeo on 1/27/21.
//

import SwiftUI

struct EmojisFireworksView: View {
    let emojis: [String]
    let powerMultiplier: CGFloat
    
    init(state: State, powerMultiplier: CGFloat) {
        self.emojis = state.emojis
        self.powerMultiplier = powerMultiplier
    }
    
    func createEmojiSpark(index: Int, width: CGFloat) -> some View {
        let power = width * powerMultiplier
        let directionMultiplier = index % 2 == 0 ? -1 : 1
        let horizontalOffset = CGFloat(directionMultiplier) * CGFloat.random(in: power / 4...power / 2)
        let position = width / 2 - horizontalOffset
        let rotation = Double(directionMultiplier) * Double.random(in: -200...(-180))
        
        return EmojiSparkView(
            // swiftlint:disable:next force_unwrapping
            emoji: emojis.randomElement()!,
            horizontalOffset: horizontalOffset,
            finalRotation: rotation
        )
        .position(x: position)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<15) {
                createEmojiSpark(index: $0, width: geometry.size.width)
            }
        }
        .frame(height: 1, alignment: .center)
    }
}

extension EmojisFireworksView {
    enum State {
        case correct
        case incorrect
        
        var emojis: [String] {
            switch self {
            case .correct:
                return ["😎", "❤️", "💪", "🥳", "🔥"]
            case .incorrect:
                return ["👿", "🥵", "👹", "😡", "☠️"]
            }
            
        }
    }
}

struct EmojisFireworksView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmojisFireworksView(state: .correct, powerMultiplier: 1)
        }
    }
}
