//
//  AnimatedSyncImageView.swift
//  Facematch
//
//  Created by Gaston Mazzeo on 2/4/21.
//

import SwiftUI

struct AnimatedSyncImageView: View {
    @State var horizontalOffset: CGFloat = -200
    @State var verticalOffset: CGFloat = 0
    @State var imageSize: CGFloat = 0
    @State var tempImage: Image?
    
    let url: URL
    let position: Position
    var onFinished: () -> Void
    
    init(url: URL, position: Position, onFinished: @escaping () -> Void) {
        self.url = url
        self.position = position
        self.onFinished = onFinished
    }
    
    var offsetAnimation: Animation {
        .linear(duration: 5)
    }
    
    var body: some View {
        GeometryReader { geometry in
            tempImage?
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(15)
                .frame(width: imageSize)
                .offset(x: horizontalOffset, y: verticalOffset)
                .onAnimationCompleted(for: horizontalOffset, perform: onFinished)
                .onAppear {
                    let height = geometry.size.height
                    let width = geometry.size.width

                    imageSize = CGFloat.random(in: height * 0.15...height * 0.2)
                    verticalOffset = position == .top ?
                        CGFloat.random(in: 0...height * 0.2) :
                        CGFloat.random(in: height * 0.6...height * 0.8)
                    
                    withAnimation(offsetAnimation) {
                        horizontalOffset = -horizontalOffset + width
                    }
                }
        }
        .onAppear {
            self.tempImage = temporaryPhoto(from: url)
        }
    }
}

extension AnimatedSyncImageView: ImageRetrieving {}

extension AnimatedSyncImageView {
    enum Position {
        case top
        case bottom
    }
}
