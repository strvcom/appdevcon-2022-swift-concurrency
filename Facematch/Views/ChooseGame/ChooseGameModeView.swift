//
//  ChooseGameModeView.swift
//  Facematch
//
//  Created by Abel Osorio on 9/11/20.
//

import SwiftUI

struct ChooseGameModeView: View {
    enum Presentation: Identifiable, Equatable {
        case game(game: Game)
        case sync(game: Game)

        var id: String {
            switch self {
            case .game: return "game"
            case .sync: return "sync"
            }
        }
    }

    @State var presentation: Presentation?
    @Binding var modalIsDisplayed: Bool
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var chooseGameModeStore: ChooseGameModeStore
    @EnvironmentObject var authenticationStore: AuthenticationStore
    @EnvironmentObject var syncStore: SyncStore

    var body: some View {
        ZStack {
            Color.appBackground
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                Text("FACE MATCH")
                    .font(.appMainTitle)
                    .padding()

                switch chooseGameModeStore.state {
                case .initial, .inProgress, .failed:
                    LoadingIndicator()
                case let .success(game, canPlayAt):
                    // TODO: - Investigate why cannot press with VoiceOver turned on
                    LeagueGameItemView(
                        canPlayAt: canPlayAt,
                        gameEndsAt: game.endsAt,
                        onTap: { modalIsDisplayed.toggle() }
                    )
                    .padding()
                }

                Text("PRACTICE")
                    .font(.appButtonTitle)

                VStack(spacing: 16) {
                    ForEach(chooseGameModeStore.practiceModes) { gameMode in
                        ChooseGameItemView(
                            gameMode: gameMode,
                            onTap: { startNewGame(game: .casual(mode: gameMode)) }
                        )
                    }
                }
                .padding()
            }
        }
        .fullScreenCover(item: $presentation) { presentation in
            switch presentation {
            case .sync:
                SyncView()
                    .environmentObject(syncStore)
            case let .game(game):
                GameView(game: game)
            }
        }
        .onChange(of: syncStore.state) {
            if $0.canPlayGame, case let .sync(game) = presentation {
                // Setting the presentation as nil prevents to have
                // a weird transition between the sync view and the game mode
                // for a moment.
                DispatchQueue.main.async {
                    presentation = nil
                }
                                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    presentation = .game(game: game)
                }

            }
        }
        // TODO - Notification is not ideal but it would make the trick for now (Refactor)
        .onReceive(NotificationCenter.default.publisher(for: .startNewLeagueGame), perform: { _ in
            guard case let .success(game, _) = chooseGameModeStore.state else {
                return
            }
            
            startNewGame(game: .league(game: game))
        })
        .onAppear {
            refreshCurrentLeagueGame()
        }
        .onChange(of: presentation) { presentation in
            if presentation == nil {
                refreshCurrentLeagueGame()
            }
        }
        // TODO: This should not be necessary but without it after signing out and back in again, the `onAppear` is sometimes not called
        .onChange(of: authenticationStore.state) { state in
            if case .authorized = state {
                refreshCurrentLeagueGame()
            }
        }
    }
}

extension ChooseGameModeView {
    func startNewGame(game newGame: Game) {
        guard authenticationStore.state.isAuthenticated else {
            authenticationStore.authenticate()

            return
        }

        guard syncStore.state.canPlayGame else {
            presentation = .sync(game: newGame)

            return
        }

        presentation = .game(game: newGame)
    }
    
    func refreshCurrentLeagueGame() {
        chooseGameModeStore.fetchCurrentLeagueGame()
    }
}

struct ChooseGameModeView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseGameModeView(modalIsDisplayed: .constant(false))
    }
}
