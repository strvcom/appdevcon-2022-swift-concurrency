//
//  ChooseGameItemView.swift
//  Facematch
//
//  Created by Abel Osorio on 9/11/20.
//

import SwiftUI

struct ChooseGameItemView: View {
    typealias TapHandler = () -> Void

    let gameMode: GameMode
    var onTap: TapHandler

    var body: some View {
        Button(action: onTap) {
            HStack {
                Image(gameMode.iconName)
                    .padding(.trailing, 8)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(gameMode.title)
                        .font(.appGameTitle)
                        .foregroundColor(.appButtonSecondaryText)
                        .fontWeight(.bold)

                    Text(gameMode.description)
                        .font(.appGameDescription)
                        .foregroundColor(Color.appButtonSecondaryText.opacity(0.8))
                }
                .padding()
                .accessibility(label: Text("\(gameMode.title) game mode"))
                .accessibility(hint: Text("Description of the game mode: \(gameMode.description)"))

                Spacer()

                Image("chevron")
                    .foregroundColor(Color.appTextFirst.opacity(0.8))
            }
            .padding([.leading, .trailing])
        }
        .buttonStyle(
            GameChoiceButtonStyle(
                backgroundColor: .appButtonSecondaryBackground
            )
        )
        .accessibilityElement(children: .combine)
    }
}

struct ChooseGameItemView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseGameItemView(gameMode: .training, onTap: { () })
    }
}
