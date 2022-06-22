//
//  UserDefaults.swift
//  Facematch
//
//  Created by IFANG LEE on 2020/12/3.
//

import Foundation

extension UserDefaults {
    var hasSeenOnboarding: Bool {
        get {
            bool(forKey: #function)
        }

        set {
            set(newValue, forKey: #function)
            synchronize()
        }
    }

    var lastTimePlayingLeague: String? {
        get {
            string(forKey: #function)
        }

        set {
            set(newValue, forKey: #function)
            synchronize()
        }
    }
}
