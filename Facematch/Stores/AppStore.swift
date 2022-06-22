//
//  AppStore.swift
//  Facematch
//
//  Created by IFANG LEE on 2020/12/11.
//

import Foundation

class AppStore: ObservableObject {
    @Injected private var userDefaults: UserDefaults
    
    var hasSeenOnboarding: Bool {
        get {
            userDefaults.hasSeenOnboarding
        }
        
        set {
            userDefaults.hasSeenOnboarding = newValue
        }
    }
}
