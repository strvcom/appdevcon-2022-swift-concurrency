//
//  DIContainer.swift
//  Facematch
//
//  Created by Jan Kaltoun on 20.08.2020.
//

import Foundation

class DIContainer {
    typealias Resolver = () -> Any

    private var resolvers = [String: Resolver]()
    private var cache = [String: Any]()

    static let shared = DIContainer()

    init() {
        registerDependencies()
    }

    func register<T, R>(_ type: T.Type, cached: Bool = false, service: @escaping () -> R) {
        let key = String(reflecting: type)
        resolvers[key] = service

        if cached {
            cache[key] = service()
        }
    }

    func resolve<T>() -> T {
        let key = String(reflecting: T.self)

        if let cachedService = cache[key] as? T {
            print("🥣 Resolving cached instance of \(T.self).")

            return cachedService
        }

        if let resolver = resolvers[key], let service = resolver() as? T {
            print("🥣 Resolving new instance of \(T.self).")

            return service
        }

        fatalError("🥣 \(key) has not been registered.")
    }
}

extension DIContainer {
    func registerDependencies() {
        register(KeychainManaging.self, cached: true) {
            KeychainManager()
        }

        register(PhotoStorageManaging.self, cached: true) { () -> PhotoStorageManager in
            do {
                return try PhotoStorageManager()
            } catch {
                fatalError("Could not instantiate PhotoStorageManager.")
            }
        }

        register(APIManaging.self, cached: true) {
            APIManager(keychainManager: KeychainManager())
        }

        register(CoreDataManaging.self, cached: true) {
            CoreDataManager()
        }

        #if !os(watchOS)
        register(ShareDataManaging.self, cached: true) {
            ShareDataManager()
        }
        #endif

        register(UserDefaults.self, cached: true) {
            UserDefaults.standard
        }
        
        register(ErrorReportingManaging.self, cached: true) {
            ErrorReportingManager()
        }
        
        register(NetworkManaging.self, cached: true) {
            NetworkManager()
        }
        
        register(WatchConnectivityManaging.self) {
            WatchConnectivityManager()
        }
    }
}
