//
//  OnboardingStoring.swift
//  Facematch
//
//  Created by Nick Beresnev on 4/5/21.
//

import Foundation

protocol OnboardingStoring {
    var coreDataManager: CoreDataManaging { get }
    
    func fetchLoggedUser() -> LoggedUser?
    func updateSteps()
}
