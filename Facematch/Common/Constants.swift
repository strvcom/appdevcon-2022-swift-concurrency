//
//  Constants.swift
//  Facematch
//
//  Created by Jan Zimandl on 18/09/2020.
//

import Foundation

enum Constants {
    static let shareTokenServiceType = "FMShareToken" // Networking protocol name up to 15 characters long and valid characters include ASCII lowercase letters, numbers, and the hyphen
    static let watchLoginResultKey = "login"
}

extension Notification.Name {
    static let startNewLeagueGame: Notification.Name = Notification.Name("startNewLeagueGame")
}
