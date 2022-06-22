//
//  MainView.swift
//  Facematch
//
//  Created by Jan Kaltoun on 03/07/2020.
//

import CoreData
import SwiftUI
import CustomModalView

struct MainView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    @EnvironmentObject var authenticationStore: AuthenticationStore
    @EnvironmentObject var appStore: AppStore
    @State private var selectedTab = 0
    @State var modalIsDisplayed: Bool = false

    init() {
        UITabBar.appearance().barTintColor = UIColor.appBackground
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            ChooseGameModeView(modalIsDisplayed: $modalIsDisplayed)
                .tabItem {
                    selectedTab == 0 ? Image("gameTabSelected") : Image("gameTab")
                }
                .tag(0)
            
            ProfileView()
                .tabItem {
                    selectedTab == 2 ? Image("profileTabSelected") : Image("profileTab")
                }
                .tag(2)
        }
        .onChange(of: authenticationStore.state) { state in
            if state == .initial {
                selectedTab = 0
            }
        }
        .modal(isPresented: $modalIsDisplayed) {
            HowToPlayView(
                isDisplayed: $modalIsDisplayed,
                onLetsPlay: {
                    modalIsDisplayed.toggle()
                    // TODO - Notification is not ideal but it would make the trick for now (Refactor)
                    NotificationCenter.default.post(name: .startNewLeagueGame, object: nil)
                },
                onBack: {
                    modalIsDisplayed.toggle()
                }
            )
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
