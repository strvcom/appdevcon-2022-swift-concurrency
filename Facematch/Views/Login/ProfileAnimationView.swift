//
//  ProfileAnimationView.swift
//  Facematch
//
//  Created by IFANG LEE on 2020/12/10.
//

import Combine
import SwiftUI

struct ProfileAnimationView: View {
    static let images = [
        "adam",
        "barbora-zacharova",
        "barbora-martinkova",
        "frantisek",
        "gabriel",
        "ilay",
        "jan-hybl",
        "jan-kaltoun",
        "kate",
        "lenka",
        "rodolfo",
        "roman",
        "ruan",
        "tomas",
        "vaclav"
    ].shuffled()
    
    @State var horizontalOffset: CGFloat = 0
    
    var offsetAnimation: Animation {
        Animation
            .linear(duration: Double(Self.images.count) * 2)
            .repeatForever(autoreverses: false)
    }

    var body: some View {
        GeometryReader { geometry in
            ForEach(Self.images.indices, id: \.self) {
                image(for: $0, availableHeight: geometry.size.height)
            }
            .offset(x: horizontalOffset)
            .onAppear {
                withAnimation(offsetAnimation) {
                    horizontalOffset = CGFloat(Self.images.count + 1) * geometry.size.height / 2 + geometry.size.width
                }
            }
        }
        .frame(height: 300)
    }
}

extension ProfileAnimationView {
    func image(for index: Int, availableHeight: CGFloat) -> some View {
        let minImageSize: CGFloat = availableHeight / 2.5
        let maxImageSize = availableHeight / 2
        let imageSize = CGFloat.random(in: minImageSize...maxImageSize)

        let verticalPosition = index % 2 == 0 ?
            CGFloat.random(in: 0...availableHeight * 0.4) :
            CGFloat.random(in: availableHeight * 0.6...availableHeight - imageSize / 2)
        
        let horizontalPosition: CGFloat = CGFloat(index + 1) * (-maxImageSize)
        
        return Image("Login/\(Self.images[index])")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(15)
            .frame(width: imageSize, height: imageSize)
            .position(x: horizontalPosition, y: verticalPosition)
    }
}

struct ProfileAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileAnimationView()
            .environment(\.colorScheme, .light)
        ProfileAnimationView()
            .environment(\.colorScheme, .dark)
    }
}
