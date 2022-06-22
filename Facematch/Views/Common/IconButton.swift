//
//  IconButton.swift
//  Facematch
//
//  Created by IFANG LEE on 2020/11/25.
//

import SwiftUI

struct IconButton: View {
    typealias Action = () -> Void

    let imageName: String
    let title: String
    let action: Action

    init(imageName: String, title: String, action: @escaping Action) {
        self.imageName = imageName
        self.title = title
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 12) {
                Image(imageName)
                Text(title.uppercased())
            }
        }
        .buttonStyle(PrimaryButtonStyle())
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        IconButton(imageName: "Login/Slack-icon", title: "Button with icon") {
            print("Did tap button")
        }
    }
}
