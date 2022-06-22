//
//  LeagueGameItemView.swift
//  Facematch
//
//  Created by Abel Osorio on 3/18/21.
//

import SwiftUI

struct LeagueGameItemView: View {
    typealias TapHandler = () -> Void

    @State private var timeRemaining = ""

    let canPlayAt: Date?
    let gameEndsAt: Date
    var onTap: TapHandler
    var canUserPlay: Bool {
        return canPlayAt == nil
    }

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var formatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter
    }
    
    private var accessibilityText: String {
        let firstPart = canUserPlay ? "Play League" : "Wait for your next opportunity"
        let secondPart = canUserPlay ? "Ends in:" : "Come after:"

        return "\(firstPart) \(secondPart) \(timeRemaining)"
    }

    var body: some View {
        Button(action: onTap) {
            HStack {
                Image("cupIcon")
                    .padding(.trailing, 8)

                VStack(alignment: .leading, spacing: 8) {
                    Text(canUserPlay ? "Play League" : "Wait for your next opportunity")
                        .font(.appGameTitle)
                        .foregroundColor(.appButtonPrimaryText)
                        .fontWeight(.bold)

                    HStack(spacing: 4) {
                        Text(canUserPlay ? "Ends in:" : "Come after:")
                            .font(.appGameDescription)
                            .foregroundColor(Color.appButtonPrimaryText.opacity(0.8))

                        Text(timeRemaining)
                            .font(.appGameDescription)
                            .foregroundColor(Color.appButtonPrimaryText.opacity(0.8))
                    }
                }
                .padding()

                Spacer()

                Image("chevron")
                    .foregroundColor(Color.appTextFirst.opacity(0.8))
            }
            .padding()
        }
        .disabled(!canUserPlay)
        .onReceive(timer) { _ in
            let playAt = canPlayAt ?? Date()
            let date = playAt <= Date() ? gameEndsAt : playAt
            timeRemaining = "\(formatter.string(from: Date(), to: date) ?? "00:00:00")"
        }
        .buttonStyle(
            GameChoiceButtonStyle(
                backgroundColor: .appButtonPrimaryBackground
            )
        )
        .accessibilityElement(children: .ignore)
        .accessibility(label: Text(accessibilityText))
    }
}

struct LeagueGameItemView_Previews: PreviewProvider {
    static var previews: some View {
        LeagueGameItemView(
            canPlayAt: Date(),
            gameEndsAt: Date(),
            onTap: { }
        )
    }
}
