//
//  LoginView.swift
//  Facematch
//
//  Created by IFANG LEE on 2020/11/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authenticationStore: AuthenticationStore
    
    var body: some View {
        ZStack {
            Color.appBackground
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading) {
                Spacer()

                ProfileAnimationView()

                Spacer()
                
                FacematchLogoView()
                
                Text("Meet faces behind STRV")
                    .font(.appTitle)
                    .foregroundColor(.appTextSecond)
                    .padding(.leading, 4)

                Spacer()

                IconButton(
                    imageName: "Login/Slack-icon",
                    title: "Sign in with Slack",
                    action: didTapLoginButton
                )
                .frame(height: 56)
                .disabled(
                    authenticationStore
                        .state
                        .isAuthenticationInProgress
                )

                Spacer()
            }
            .padding(16)
        }
    }

    // MARK: - Actions
    func didTapLoginButton() {
        authenticationStore.authenticate()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environment(\.colorScheme, .light)
        LoginView()
            .environment(\.colorScheme, .dark)
    }
}
