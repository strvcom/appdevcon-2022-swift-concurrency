//
//  LivesIndicator.swift
//  Facematch
//
//  Created by Abel Osorio on 12/28/20.
//

import SwiftUI

struct LivesIndicator: View {
    let image: Image
    let lives: Int?
    
    var accessibilityString: String {
        if let lives = lives {
            return "Number of lives remaining: \(lives)."
        } else {
            return "Number of lives: infinite."
        }
    }

    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            image

            if let lives = lives {
                Text("\(lives)".uppercased())
                    .font(.appGameDescription)
                    .foregroundColor(.appAnswerIncorrect)
                    .frame(width: 20)
            } else {
                Image("infinity")
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.accentColor)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibility(label: Text(accessibilityString))
    }
}

struct LivesButton_Previews: PreviewProvider {
    static var previews: some View {
        LivesIndicator(image: Image("heart"), lives: 1)
        LivesIndicator(image: Image("broken"), lives: 1)
    }
}
