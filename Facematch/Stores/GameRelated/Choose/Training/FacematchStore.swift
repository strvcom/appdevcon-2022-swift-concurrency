//
//  FacematchStore.swift
//  Facematch
//
//  Created by Gaston Mazzeo on 1/20/21.
//

import Combine
import CoreData
import SwiftUI

class FacematchStore: ObservableObject, NoTimeLimitGameStore {
    var cancellables = [AnyCancellable]()
    var uniquePeople = [Person]()
    var questions = [Question]()
    var lives: Int? = 3
    
    @Published var state: GameState<NoTimePlayingState> = .initial
    @Injected var coreDataManager: CoreDataManaging
    @Injected var apiManager: APIManaging
}
