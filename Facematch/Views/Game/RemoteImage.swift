//
//  RemoteImage.swift
//  Facematch
//
//  Created by Abel Osorio on 3/9/21.
//

import SwiftUI
import Combine

struct RemoteImage: View {
    @ObservedObject var imageLoader: ImageLoader

    let size: CGFloat

    init(withURL url: URL, size: CGFloat) {
        self.size = size
        imageLoader = ImageLoader(url: url)
    }

    var body: some View {
        Image(uiImage: UIImage(data: imageLoader.data) ?? UIImage())
            .leaderboardStyled(with: size)
    }
}
