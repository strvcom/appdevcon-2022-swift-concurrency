//
//  AuthenticationStore.swift
//  Facematch
//
//  Created by Jan Kaltoun on 03/07/2020.
//

import AuthenticationServices
import Combine
import CoreData
import SwiftUI

@MainActor class AuthenticationStore: NSObject, ObservableObject {
    static let oauthURL: URL = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "slack.com"
        components.path = "/oauth/authorize"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: "2163636450.11784079301"),
            URLQueryItem(name: "scope", value: "users:read")
        ]

        // swiftlint:disable:next force_unwrapping
        return components.url!
    }()

    @Published var state: State = .initial

    @Injected var keychainManager: KeychainManaging
    @Injected var apiManager: APIManaging
    @Injected var photoStorageManager: PhotoStorageManaging
    @Injected var userDefaults: UserDefaults
    @Injected var coreDataManager: CoreDataManaging
    @Injected var errorReportingManager: ErrorReportingManaging
    @Injected var watchConnectivityManager: WatchConnectivityManaging

    var finishAuthenticationCancellable: AnyCancellable?
    var webAuthSession: ASWebAuthenticationSession?
    
    var logoutCancellable: AnyCancellable?
    
    func authenticate() {
        state = .inProgress
        
        let callbackUrlScheme = "facematch"

        webAuthSession = ASWebAuthenticationSession(
            url: Self.oauthURL,
            callbackURLScheme: callbackUrlScheme,
            completionHandler: { [weak self] callbackURL, error in
                guard
                    let store = self,
                    error == nil,
                    let url = callbackURL,
                    let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                    let codeQueryItem = components.queryItems?.first(where: { $0.name == "code" }),
                    let temporaryCode = codeQueryItem.value
                else {
                    self?.state = .initial
                    return
                }

                store.state = .temporaryAuthorized(code: temporaryCode)

                Task {
                    await store.finishAuthentication(code: temporaryCode)
                }
            }
        )

        webAuthSession?.presentationContextProvider = self

        webAuthSession?.start()
    }

    func finishAuthentication(code: String) async {
        do {
            let accessTokenResponse = try await exchangeCodeForAccessToken(code: code)
            let user = try await authenticateUserWithBackend(accessTokenResponse: accessTokenResponse)
            
            state = .authorized(user: user)
        } catch {
            state = .failed(error: AuthenticationError.unexpectedError)
        }
    }

    func exchangeCodeForAccessToken(code: String) async throws -> SlackTokenExchangeResponse {
        // swiftlint:disable:next force_unwrapping
        var components = URLComponents(string: "https://slack.com/api/oauth.access")!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: "2163636450.11784079301"),
            URLQueryItem(name: "client_secret", value: "b65da68bfc3979c0785d813ddecbcfcc"),
            URLQueryItem(name: "code", value: code)
        ]
        
        // swiftlint:disable:next force_unwrapping
        let data = try await apiManager.fetch(url: components.url!)
        
        let slackTokenExchangeResponse = try apiManager.decoder.decode(
            SlackTokenExchangeResponse.self,
            from: data
        )
        
        keychainManager.set(
            key: KeychainKeys.keychainAccessTokenKey,
            value: slackTokenExchangeResponse.accessToken
        )
        
        return slackTokenExchangeResponse
    }

    func authenticateUserWithBackend(accessTokenResponse: SlackTokenExchangeResponse) async throws -> LoggedUser {
        let url = Configuration.default.apiBaseURL.appendingPathComponent("user/login")
        let params: [String: Any] = [
            "slackUserID": accessTokenResponse.userId,
            "accessToken": accessTokenResponse.accessToken
        ]

        let data = try await apiManager.post(url: url, params: params)
        
        let loginResponse = try apiManager.decoder.decode(
            LoginResponse.self,
            from: data
        )
        
        // Reset temp directory in case user logs out and logs in again
        keychainManager.set(key: KeychainKeys.keychainBackendAccessTokenKey, value: loginResponse.accessToken)
        try photoStorageManager.reset()
        
        try await downloadSlackPhoto(of: loginResponse.user)
        
        try await saveLoggedUser(user: loginResponse.user)
        
        let user = try fetchLoggedUser()
        
        errorReportingManager.setUser(loggedUser: user)
        
        try photoStorageManager.blessTemporaryDirectory()
        
        return user
    }
    
    func checkAuthorizedUser() {
        state = .checkingAuthenticatedUser

        guard
            keychainManager.has(key: KeychainKeys.keychainAccessTokenKey),
            let user = try? fetchLoggedUser()
        else {
            state = .initial
            return
        }
        
        state = .authorized(user: user)
    }
    
    func logout() {
        logoutCancellable = deleteLoggedUser()
            .handleOutput(weak: self) { store, _ in
                store.keychainManager.remove(key: KeychainKeys.keychainAccessTokenKey)
                store.keychainManager.remove(key: KeychainKeys.keychainBackendAccessTokenKey)
                store.userDefaults.lastTimePlayingLeague = nil
            }
            .map { State.initial }
            .catch { error -> AnyPublisher<State, Never> in
                Just(.failed(error: AuthenticationError.unexpectedError))
                    .eraseToAnyPublisher()
            }
            .assign(to: \.state, on: self)
    }
    
    func notifyWatch() {
        switch state {
        case .initial:
            watchConnectivityManager.sendAuthUpdate(isLogged: false)
        case .authorized:
            watchConnectivityManager.sendAuthUpdate(isLogged: true)
        default:
            break
        }
    }
}

// MARK: - CRUD LoggedUser

extension AuthenticationStore {
    func fetchLoggedUser() throws -> LoggedUser {
        let context = coreDataManager.viewContext
        let fetchRequest: NSFetchRequest<LoggedUser> = LoggedUser.fetchRequest()

        guard let user = try context.fetch(fetchRequest).first else {
            throw AuthenticationError.userNotFound
        }
        
        return user
    }
    
    @discardableResult func saveLoggedUser(user: User) async throws -> LoggedUser {
        let context = coreDataManager.persistentContainer.newBackgroundContext()
        
        return try await context.perform {
            let loggedUser = LoggedUser(context: context)
            loggedUser.id = user.slackId
            loggedUser.firstName = user.firstName
            loggedUser.lastName = user.lastName
            loggedUser.realName = user.name

            try context.save()
            
            return loggedUser
        }
    }
    
    func deleteLoggedUser() -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            self?.coreDataManager.persistentContainer.performBackgroundTask { context in
                let fetchRequest: NSFetchRequest<LoggedUser> = LoggedUser.fetchRequest()

                guard let result = try? context.fetch(fetchRequest) else {
                    promise(.success(()))
                    return
                }
                
                result.forEach {
                    context.delete($0)
                }
                
                do {
                    try context.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(AuthenticationError.unableToDeleteUser))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

// MARK: - ASWebAuthenticationPresentationContextProviding

extension AuthenticationStore: ASWebAuthenticationPresentationContextProviding {
    // In pure SwiftUI it does not seem to be possible to get the current window
    // When the new app lifecycle API is used
    // Let's just say that I'm not proud of this
    func presentationAnchor(for _: ASWebAuthenticationSession) -> ASPresentationAnchor {
        for scene in UIApplication.shared.connectedScenes where scene.activationState == .foregroundActive {
            // swiftlint:disable:next force_unwrapping force_cast
            return ((scene as? UIWindowScene)!.delegate as! UIWindowSceneDelegate).window!!
        }

        fatalError("No window?!")
    }
}

extension AuthenticationStore: SlackPhotoDownloader, ImageRetrieving {}

// MARK: - State

extension AuthenticationStore {
    enum State: Equatable {
        case initial
        case inProgress
        case temporaryAuthorized(code: String)
        case authorized(user: LoggedUser)
        case failed(error: AuthenticationError)
        case checkingAuthenticatedUser

        var isFailed: Bool {
            switch self {
            case .initial, .inProgress, .temporaryAuthorized, .authorized, .checkingAuthenticatedUser:
                return false
            case .failed:
                return true
            }
        }

        var isAuthenticationInProgress: Bool {
            switch self {
            case .inProgress, .temporaryAuthorized:
                return true
            case .initial, .authorized, .failed, .checkingAuthenticatedUser:
                return false
            }
        }

        var isAuthenticated: Bool {
            switch self {
            case .initial, .inProgress, .temporaryAuthorized, .failed, .checkingAuthenticatedUser:
                return false
            case .authorized:
                return true
            }
        }
    }
}

// MARK: - AuthenticationError

extension AuthenticationStore {
    enum AuthenticationError: Error {
        case unableToDeleteUser
        case unexpectedError
        case userNotFound
    }
}
