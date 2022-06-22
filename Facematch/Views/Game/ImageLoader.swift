//
//  ImageLoader.swift
//  Facematch
//
//  Created by Abel Osorio on 3/9/21.
//

import Combine
import Foundation

class ImageLoader: ObservableObject {
    @Published var data = Data()

    init(url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                return
            }

            DispatchQueue.main.async {
                self.data = data
            }
        }
        .resume()
    }
}
