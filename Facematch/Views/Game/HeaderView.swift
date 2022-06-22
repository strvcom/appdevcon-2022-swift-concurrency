//
//  HeaderView.swift
//  Facematch
//
//  Created by Abel Osorio on 9/8/20.
//

import SwiftUI

struct HeaderView: View {
    let lives: Int?
    let hasLostLife: Bool
    let title: String
    let isPracticeGame: Bool
    var onSurrender: (() -> Void)?

    var body: some View {
        ZStack {
            HStack(alignment: .center) {
                Button(action: {
                    onSurrender?()
                }) {
                    Image("closeIcon")
                        .renderingMode(.template)
                        .foregroundColor(.appButtonSecondaryText)
                }
                .accessibility(label: Text("Close game"))

                Spacer()

                LivesIndicator(image: hasLostLife ? Image("broken") : Image("heart"), lives: lives)
            }

            if isPracticeGame {
                Image("infinity")
                    .renderingMode(.template)
                    .foregroundColor(.appButtonSecondaryText)
                    .accessibility(label: Text("No time limit "))
            } else {
                Text(title)
                    .font(.appGameTitle)
                    .accessibility(label: Text("Time remaining: \(title)"))
            }
        }
    }
}

struct TimedHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(lives: 0, hasLostLife: false, title: "Title", isPracticeGame: true)
    }
}
