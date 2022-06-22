//
//  LoadingIndicator.swift
//  Facematch
//
//  Created by Abel Osorio on 1/7/21.
//

import SwiftUI

struct LoadingIndicator: View {
    @State private var shouldAnimate = false
    
    static let opacities = [0.8, 0.6, 0.4, 0.4]
    static let sizes: [CGFloat] = [10, 10, 10, 10]
    static let delays = [0, 0.3, 0.6, 0.9]

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<4) { index in
                let size = Self.sizes[index]
                
                Circle()
                    .fill(Color.appLoadingIndicatorBackground.opacity(Self.opacities[index]))
                    .frame(height: size)
                    .frame(width: Self.sizes[index])
                    .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                    .animation(
                        .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Self.delays[index]),
                        value: shouldAnimate
                    )
            }
        }
        .onAppear {
            self.shouldAnimate = true
        }
    }
}

struct LoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoadingIndicator()
            LoadingIndicator()
                .preferredColorScheme(.dark)
        }
    }
}
