//
//  FinishedView.swift
//  Facematch
//
//  Created by Abel Osorio on 9/8/20.
//

import SwiftUI

struct FinishedView: View {
    typealias ContinueHandler = () -> Void
    typealias ShareToSlackHandler = () -> Void

    @EnvironmentObject var scoreStore: ScoreStore
    @State var shouldShowEmojisRain = false

    let score: Score
    var shouldShowIncorrectAnswers = false
    var game: Game
    var onContinue: ContinueHandler
    var onShareToSlack: ShareToSlackHandler
    var answersText: String {
        guard shouldShowIncorrectAnswers else {
            return "\(score.correct) correct answers"
        }
        
        return "\(score.correct) correct and \(score.incorrect) incorrect answers."
    }

    var body: some View {
        VStack {
            Spacer()

            // TODO: - We need to show different messages when we play league games
            // and we need to get from BE the position after submitting the score
//            if isLeagueGame, let leaderboardPosition = leaderboardPosition {
//                Text("\(leaderboardPosition.ordinalValue) PLACE")
//                    .font(Font.customTrumpGothicEastBold(ofSize: 88, relativeTo: .headline))
//                    .padding()
//            } else {
//                Text("Good Job 💪")
//                    .font(Font.customTrumpGothicEastBold(ofSize: 88, relativeTo: .headline))
//                    .padding()
//            }


            Text("GOOD JOB")
                .font(Font.customTrumpGothicEastBold(ofSize: 88, relativeTo: .headline))
                .padding()

            Text(answersText)
                .multilineTextAlignment(.center)
                .padding(.bottom)

            // TODO: - We need to show different messages when we play league games
//            if isLeagueGame {
//                Text("Wohoo, good job! You just made it to the leaderboard. Congratz!")
//                    .multilineTextAlignment(.center)
//            }

            Spacer()

            VStack(spacing: 16) {
                Button(action: continuePressed) {
                    Text("CONTINUE")
                }
                .buttonStyle(PrimaryButtonStyle())

                // TODO: - Uncomment when it's ready
//                Button(action: shareToSlackPressed) {
//                    Image(systemName: "square.and.arrow.up")
//                        .renderingMode(.template)
//
//                    Text("SHARE TO SLACK")
//                }
//                .buttonStyle(SecondaryButtonStyle())
            }
            .padding()
        }
        .overlay(shouldShowEmojisRain ? EmojisRainView() : nil)
        .onAppear {
            UIApplication.shared.endEditing()
            shouldShowEmojisRain = true
            guard case let .league(game) = game else {
                return
            }

            scoreStore.submitScore(score.correct, forGameID: game.id.uuidString)
        }
    }

    func continuePressed() {
        shouldShowEmojisRain = false
        onContinue()
    }

    func shareToSlackPressed() {}
}

struct FinishedView_Previews: PreviewProvider {
    static var previews: some View {
        FinishedView(
            score: Score(correct: 42, incorrect: 69),
            game: .casual(mode: .facematch),
            onContinue: { () },
            onShareToSlack: { () }
        )
        
        FinishedView(
            score: Score(correct: 42, incorrect: 69),
            shouldShowIncorrectAnswers: false,
            game: .casual(mode: .facematch),
            onContinue: { () },
            onShareToSlack: { () }
        )
    }
}
