//
//  HowToPlayView.swift
//  Facematch
//
//  Created by Abel Osorio on 3/10/21.
//

import SwiftUI

struct HowToPlayView: View {
    typealias LetsPlayHandler = () -> Void
    typealias BackHandler = () -> Void

    @Binding var isDisplayed: Bool

    var onLetsPlay: LetsPlayHandler
    var onBack: BackHandler

    var body: some View {
        ScrollView {
            ZStack {
                Color.appModalBackground
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 32) {
                    VStack(spacing: 16) {
                        Text("HOW TO PLAY")
                            .font(.appHowToPlayTitle)

                        Text("League mixes all modes to make it more challenging and fun to play.")
                            .font(.appLargeSubtitle)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.appTextThird)
                    }
                    .accessibilityElement(children: .combine)

                    VStack(spacing: 16) {
                        Image("oneTimeIcon")

                        Text("Play once a day")
                            .font(.appLargeSubtitle)
                            .foregroundColor(.appTextThird)
                    }
                    .accessibilityElement(children: .combine)

                    // TODO: Make this dynamic based on the current league game
                    VStack(spacing: 16) {
                        Image("liveHeartIcon")

                        Text("Different modes have different rules")
                            .font(.appLargeSubtitle)
                            .foregroundColor(.appTextThird)
                    }
                    .accessibilityElement(children: .combine)
                    
                    Spacer()

                    VStack(spacing: 16) {
                        Button(action: onLetsPlay) {
                            Text("LET'S PLAY")
                        }
                        .buttonStyle(PrimaryButtonStyle())

                        Button(action: onBack) {
                            Text("BACK")
                        }
                        .buttonStyle(SecondaryButtonStyle())

                    }
                }
                .padding()
            }
            .padding(.horizontal)
        }
        // TODO: Use relative size instead of explicit
        .frame(maxWidth: 343, maxHeight: 555)
    }
}

struct HowToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        HowToPlayView(
            isDisplayed: .constant(false),
            onLetsPlay: { },
            onBack: { }
        )
        .preferredColorScheme(.light)
    }
}
