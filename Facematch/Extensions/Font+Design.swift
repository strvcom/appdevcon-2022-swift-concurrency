//
//  Font+Design.swift
//  Facematch
//
//  Created by IFANG LEE on 2020/12/2.
//

import SwiftUI

extension Font {
    static let appTitle = Font.customMaisonNeueMedium(ofSize: 17, relativeTo: .headline)
    static let appLargeTitle = Font.customMaisonNeueBold(ofSize: 24, relativeTo: .headline)
    static let appLargeSubtitle = Font.customMaisonNeueMedium(ofSize: 16, relativeTo: .headline)
    
    static let appButtonTitle = Font.customMaisonNeueBold(ofSize: 14, relativeTo: .body)
    static let appMainTitle = Font.customTrumpGothicEastBold(ofSize: 44, relativeTo: .headline)
    static let appGameTitle = Font.customMaisonNeueBold(ofSize: 16, relativeTo: .headline)
    static let appGameDescription = Font.customMaisonNeueBook(ofSize: 14, relativeTo: .subheadline)
    static let appProfileTitle = Font.customTrumpGothicEastBold(ofSize: 40, relativeTo: .headline)
    static let appPrizesDescription = Font.customTrumpGothicEastBold(ofSize: 24, relativeTo: .headline)
    static let appLeaderboardType = Font.customTrumpGothicEastBold(ofSize: 24, relativeTo: .headline)
    
    static let appBarTitle = Font.customMaisonNeueMedium(ofSize: 12, relativeTo: .headline)
    static let appBarSubtitle = Font.customMaisonNeueBold(ofSize: 18, relativeTo: .headline)

    static let appLeaderboardPosition = Font.customMaisonNeueMedium(ofSize: 14, relativeTo: .body)
    static let appLeaderboardTitle = Font.customMaisonNeueBold(ofSize: 16, relativeTo: .body)

    static let appHowToPlayTitle = Font.customTrumpGothicEastBold(ofSize: 32, relativeTo: .headline)

    static func customMaisonNeueMedium(ofSize size: CGFloat, relativeTo textStyle: TextStyle) -> Font {
        Font.custom("MaisonNeue-Medium", size: size, relativeTo: textStyle)
    }

    static func customMaisonNeueBold(ofSize size: CGFloat, relativeTo textStyle: TextStyle) -> Font {
        Font.custom("MaisonNeue-Bold", size: size, relativeTo: textStyle)
    }

    static func customMaisonNeueBook(ofSize size: CGFloat, relativeTo textStyle: TextStyle) -> Font {
        Font.custom("MaisonNeue-Medium", size: size, relativeTo: textStyle)
    }

    static func customTrumpGothicEastBold(ofSize size: CGFloat, relativeTo textStyle: TextStyle) -> Font {
        Font.custom("TrumpGothicEast-Bold", size: size, relativeTo: textStyle)
    }
}
