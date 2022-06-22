//
//  Color+Design.swift
//  Facematch
//
//  Created by Jan Kaltoun on 04/07/2020.
//

import SwiftUI

extension Color {
    static let appBackground = Color("Colors/Background")
    static let appItemBackground = Color("Colors/Item Background")
    
    static let appTextFirst = Color("Colors/Text - 1")
    static let appTextFirstInverted = Color("Colors/Text - 1 - Inverted")
    static let appTextSecond = Color("Colors/Text - 2")
    static let appTextThird = Color("Colors/Text - 3")
    static let appShadow = Color("Colors/Shadow")
    
    static let appGradientFirst = Color("Colors/Gradient - 1")
    static let appGradientSecond = Color("Colors/Gradient - 2")
    static let appGradientThird = Color("Colors/Gradient - 3")
    static let appGradientFourth = Color("Colors/Gradient - 4")
    static let appGradientText = Color("Colors/Gradient - Text")
    
    static let appAnswerCorrect = Color("Colors/Answer - Correct")
    static let appAnswerIncorrect = Color("Colors/Answer - Incorrect")
    static let appAnswerNeutral = Color("Colors/Answer - Neutral")
    static let appAnswerDisabled = Color("Colors/Answer - Disabled")

    static let appButtonPrimaryBackground = Color("Colors/Button Primary - Background")
    static let appButtonPrimaryText = Color("Colors/Button Primary - Text")
    static let appButtonSecondaryBackground = Color("Colors/Button Secondary - Background")
    static let appButtonSecondaryText = Color("Colors/Button Secondary - Text")
    static let appButtonNextBackground = Color("Colors/Button Next - Background")
    
    static let appLoadingIndicatorBackground = Color("Colors/Loading Indicator Background")
    static let appModalBackground = Color("Colors/Modal Background")
    
    #if os(watchOS)
    static let defaultButtonBackground = Color("Default Button Background")
    #endif
}

extension UIColor {
    static let appBackground = UIColor(named: "Colors/Background")
    static let accentColor = UIColor(named: "Colors/AccentColor")
}
