//
//  FireworksContainerView.swift
//  Facematch
//
//  Created by Gaston Mazzeo on 2/3/21.
//

import SwiftUI

struct FireworksContainerView<Children: View>: View {
    let powerMultiplier: CGFloat
    let children: Children
    let shouldDisplayFireworks: () -> Bool
    let stateHandler: () -> AnswerState
    
    init(
        powerMultiplier: CGFloat = 1,
        @ViewBuilder children: @escaping () -> Children,
        displayFireworksHandler: @escaping () -> Bool,
        stateHandler: @escaping () -> AnswerState
    ) {
        self.powerMultiplier = powerMultiplier
        self.children = children()
        self.shouldDisplayFireworks = displayFireworksHandler
        self.stateHandler = stateHandler
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            if shouldDisplayFireworks() {
                fireworks(
                    for: stateHandler(),
                    powerMultiplier: powerMultiplier
                )?
                .offset(y: 12.5)
            }
            
            children
        }
    }
}

extension FireworksContainerView {
    func fireworks(for state: AnswerState, powerMultiplier: CGFloat) -> EmojisFireworksView? {
        switch state {
        case .correct:
            return EmojisFireworksView(state: .correct, powerMultiplier: powerMultiplier)
        case .incorrect:
            return EmojisFireworksView(state: .incorrect, powerMultiplier: powerMultiplier)
        case .neutral:
            return nil
        }
    }
}

struct FireworksContainerView_Previews: PreviewProvider {
    static var previews: some View {
        FireworksContainerView(powerMultiplier: 200) {
            Text("Fireworks")
        } displayFireworksHandler: { () -> Bool in
            true
        } stateHandler: { () -> AnswerState in
            .correct
        }

    }
}
