//
//  ProfileView.swift
//  Facematch
//
//  Created by Abel Osorio on 12/28/20.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authenticationStore: AuthenticationStore
    @EnvironmentObject var syncStore: SyncStore
    
    @State var isSyncPresented: Bool = false

    private var positionFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter
    }

    var body: some View {
        VStack {
            switch authenticationStore.state {
            case .authorized(let user):
                VStack {
                    authenticationStore.photo(for: user)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 88, height: 88)
                        .clipShape(Circle())

                    Text(user.fullName.uppercased())
                        .font(.appMainTitle)
                }
                .accessibilityElement(children: .ignore)
                .accessibility(label: Text("Profile info for \(user.fullName), includes your image"))
            case .initial, .inProgress, .temporaryAuthorized, .failed, .checkingAuthenticatedUser:
                LoadingIndicator()
            }

            Spacer()
                .frame(height: 50)
            
            VStack(spacing: 20) {
                Button(action: presentSyncView ) {
                    HStack(alignment: .center, spacing: 12) {
                        Image(systemName: "arrow.down.doc")

                        Text("SYNC PLAYERS")
                            .font(.appButtonTitle)
                    }
                }
                .foregroundColor(.appButtonSecondaryText)
            }
        }
        .padding()
        .fullScreenCover(isPresented: $isSyncPresented) {
            SyncView()
                .environmentObject(syncStore)
        }
        .onChange(of: syncStore.state) {
            if $0.canPlayGame {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isSyncPresented.toggle()
                }
            }
        }
    }
}


extension ProfileView {
    func didTapLogoutButton() {
        authenticationStore.logout()
    }
    
    func presentSyncView() {
        syncStore.resetSyncState()
        isSyncPresented.toggle()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthenticationStore())
    }
}
