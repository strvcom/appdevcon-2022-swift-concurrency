//
//  PhotoView.swift
//  Facematch
//
//  Created by Abel Osorio on 9/9/20.
//

import SwiftUI

struct PhotoView: View {
    let identifier: String
    let image: Image

    init(identifier: String = UUID().uuidString, image: Image) {
        self.identifier = identifier
        self.image = image
    }

    var body: some View {
        image.resizable()
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(12)
            .frame(maxWidth: .infinity)
            .transition(.opacity.animation(.easeInOut))
            .id("question_image_\(identifier)")
            .padding(.horizontal)
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView(image: Image("logo"))
    }
}
