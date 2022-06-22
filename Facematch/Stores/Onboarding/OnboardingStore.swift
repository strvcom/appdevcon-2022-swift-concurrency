//
//  OnboardingStore.swift
//  Facematch
//
//  Created by Nick Beresnev on 4/5/21.
//

import Combine
import CoreData
import Foundation

class OnboardingStore: ObservableObject, OnboardingStoring {
    @Injected var coreDataManager: CoreDataManaging
    
    @Published var steps: [OnboardingStep] = OnboardingStep.allCases
    
    func fetchLoggedUser() -> LoggedUser? {
        let context = coreDataManager.viewContext
        let fetchRequest: NSFetchRequest<LoggedUser> = LoggedUser.fetchRequest()

        return try? context.fetch(fetchRequest).first
    }
    
    func updateSteps() {
        let loggedUser = fetchLoggedUser()
        
        steps = [
            .step1(loggedUser?.firstName ?? ""),
            .step2,
            .step3,
            .step4
        ]
    }
}
