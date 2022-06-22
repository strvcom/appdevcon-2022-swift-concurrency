//
//  FacematchApp.swift
//  Facematch
//
//  Created by Jan Kaltoun on 03/07/2020.
//

import CoreData
import SwiftUI

@main
struct FacematchApp: App {
    @Environment(\.scenePhase) private var scenePhase

    @Injected private var coreDataManager: CoreDataManaging
    @Injected private var errorReportingManager: ErrorReportingManaging

    private let container = DIContainer()

    @StateObject private var authenticationStore = AuthenticationStore()
    @StateObject private var syncStore = SyncStore()
    @StateObject private var appStore = AppStore()
    @StateObject private var chooseGameStore = ChooseGameModeStore()
    @StateObject private var onboardingStore = OnboardingStore()
    
    @State private var shouldShowOnboarding = false
    
    init() {
        errorReportingManager.start()
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch authenticationStore.state {
                case .authorized:
                    MainView()
                case .checkingAuthenticatedUser:
                    LoadingIndicator()
                default:
                    LoginView()
                }
            }
            .environmentObject(authenticationStore)
            .environmentObject(syncStore)
            .environmentObject(appStore)
            .environmentObject(chooseGameStore)
            .onAppear {
                authenticationStore.checkAuthorizedUser()
            }
            .onChange(of: authenticationStore.state, perform: { state in
                authenticationStore.notifyWatch()
                
                if state == .initial {
                    syncStore.resetSyncState()
                }
                
                if case .authorized = state, !appStore.hasSeenOnboarding {
                    shouldShowOnboarding.toggle()
                }
            })
            .fullScreenCover(isPresented: $shouldShowOnboarding) {
                OnboardingView()
                    .environmentObject(appStore)
                    .environmentObject(onboardingStore)
            }
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active, .inactive:
                break
            case .background:
                coreDataManager.saveContext()
            @unknown default:
                break
                // Who knows what the future holds!
            }
        }
    }
}
