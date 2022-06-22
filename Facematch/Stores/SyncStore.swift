//
//  SyncStore.swift
//  Facematch
//
//  Created by Jan Kaltoun on 04/07/2020.
//

import Combine
import CoreData
import Foundation
import SwiftUI
import UIKit

struct ProgressState {
    let syncedItems: Int
    let images: [URL]
    
    static let initial = ProgressState(syncedItems: 1, images: [])
}

class SyncStore: ObservableObject {
    static let lastSyncUserDefaultsKey = "last_sync"
    static let syncRefreshThreshold: TimeInterval = 60*60*24*7 // 7 days
    static let syncTimeDifferenceThreshold: TimeInterval = 3

    @Injected var apiManager: APIManaging
    @Injected var photoStorageManager: PhotoStorageManaging
    @Injected private var keychainManager: KeychainManaging
    @Injected private var coreDataManager: CoreDataManaging
    @Injected private var networkManager: NetworkManaging

    var syncCancellable: AnyCancellable?
    var networkCancellable: AnyCancellable?

    @Published var state = State.requiresSync

    init() {
        updateSyncState()
    }
    
    func resetSyncState() {
        UserDefaults.standard.removeObject(forKey: Self.lastSyncUserDefaultsKey)
        updateSyncState()
    }

    func updateSyncState() {
        guard
            let lastSync = UserDefaults.standard.object(
                forKey: Self.lastSyncUserDefaultsKey
            ) as? Date
        else {
            state = .requiresSync
            return
        }

        let dateDifference = Date().timeIntervalSince(lastSync)

        if dateDifference > Self.syncRefreshThreshold {
            state = .suggestsSync

            return
        }

        state = .synced(initial: true)
    }

    func sync() {
        do {
            try photoStorageManager.reset()
        } catch {
            state = .syncFailed(error: SyncError.filesystemStorageFailed)

            return
        }
        
        state = .syncing(
            progress: 0,
            description: "Downloading list of Slack members.",
            images: []
        )
        
        var lastStateUpdate = Date()
        var membersInfo: [(APIMember, Data)] = []
        
        syncCancellable = loadSlackMemberData()
            .flatMap(weak: self) { store, members -> AnyPublisher<[ProgressState], Error> in
                store.cleanLocalCache(in: store.coreDataManager.viewContext)
                
                return Publishers.MergeMany(
                    members.map { member in
                        store.downloadSmallSlackPhotoData(of: member)
                            .tryMap { imageData in
                                membersInfo.append((member, imageData))
                            }
                            .flatMap {
                                return store.downloadSlackPhoto(of: member)
                            }
                            .eraseToAnyPublisher()
                    }
                )
                .collect(1)
                .scan(ProgressState.initial) { progressState, url in
                    ProgressState(
                        syncedItems: progressState.syncedItems + 1,
                        images: progressState.images + url
                    )
                }
                .receive(on: DispatchQueue.main)
                .handleOutput(weak: self) { store, progressState in
                    let numberOfItemsToSync = members.count + 1
                    let syncProgress = Double(progressState.syncedItems) / Double(numberOfItemsToSync)

                    let timeDifference = Date().timeIntervalSince(lastStateUpdate)
                    
                    // Updating syncing state only if the difference is more than 1%
                    // and after 3 seconds after the last update at least
                    // to avoid re-rendering
                    if
                        syncProgress - store.state.syncProgress > 0.01,
                        timeDifference > Self.syncTimeDifferenceThreshold
                    {
                        lastStateUpdate = Date()
                        
                        store.state = .syncing(
                            progress: syncProgress,
                            description: "Downloading photo \(progressState.syncedItems) of \(numberOfItemsToSync).",
                            images: progressState.images
                        )
                    }
                }
                .collect()
                .eraseToAnyPublisher()
            }
            .map { [weak self] _ -> State in
                self?.save(membersInfo: membersInfo)

                UserDefaults.standard.setValue(Date(), forKey: Self.lastSyncUserDefaultsKey)

                try? self?.photoStorageManager.blessTemporaryDirectory()

                return .synced(initial: false)
            }
            .catch { error -> AnyPublisher<State, Never> in
                Just(.syncFailed(error: .unexpectedlyCancelled))
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.state, on: self)
    }

    func cancelSync() {
        guard case .syncing = state else {
            return
        }

        try? photoStorageManager.reset()
        
        syncCancellable?.cancel()

        updateSyncState()
    }
    
    func stopSync() {
        cancelSync()
        stopCheckingNetworkType()
    }

    func loadSlackMemberData() -> AnyPublisher<[APIMember], Error> {
        // swiftlint:disable:next force_unwrapping
        var components = URLComponents(string: "https://slack.com/api/users.list")!

        components.queryItems = [
            URLQueryItem(
                name: "token",
                value: keychainManager.get(key: KeychainKeys.keychainAccessTokenKey)
            )
        ]

        // swiftlint:disable:next force_unwrapping
        return apiManager.fetch(url: components.url!)
            .decode(type: APIMemberResponse.self, decoder: apiManager.decoder)
            .map(\.members)
            .eraseToAnyPublisher()
    }

    func cleanLocalCache(in context: NSManagedObjectContext) {
        let personFetchRequest: NSFetchRequest<Person> = Person.fetchRequest()

        guard let result = try? context.fetch(personFetchRequest) else {
            return
        }

        result.forEach {
            context.delete($0)
        }
        
        try? context.save()
    }
    
    func save(membersInfo: [(APIMember, Data)]) {
        coreDataManager.persistentContainer.performBackgroundTask { context in
            membersInfo.forEach { (member, image) in
                let person = Person(context: context)
                
                person.id = member.id
                person.firstName = member.firstName
                person.lastName = member.lastName
                person.realName = member.realName
                person.image = image
            }
            
            try? context.save()
        }
    }
    
    func startCheckingNetworkType() {
        networkManager.startMonitoring()
        
        networkCancellable = networkManager.networkType
            .sink { [weak self] in
                guard $0 == .wifi else {
                    self?.cancelSync()
                    return
                }
            }
    }
    
    func stopCheckingNetworkType() {
        networkCancellable?.cancel()
        networkManager.stopMonitoring()
    }
}

// MARK: - State

extension SyncStore {
    enum State: Equatable {
        case requiresSync
        case suggestsSync
        case syncing(progress: Double, description: String, images: [URL])
        case synced(initial: Bool)
        case syncFailed(error: SyncError)

        var isFailed: Bool {
            switch self {
            case .requiresSync, .suggestsSync, .syncing, .synced:
                return false
            case .syncFailed:
                return true
            }
        }

        var canPlayGame: Bool {
            !needsSync
        }

        var needsSync: Bool {
            switch self {
            case .requiresSync, .suggestsSync, .syncing, .syncFailed:
                return true
            case .synced:
                return false
            }
        }

        var syncProgress: Double {
            switch self {
            case let .syncing(progressPercentage, _, _):
                return progressPercentage
            case .requiresSync, .suggestsSync, .synced, .syncFailed:
                return 0
            }
        }

        var syncProgressDescription: String? {
            switch self {
            case let .syncing(_, description, _):
                return description
            case .requiresSync, .suggestsSync, .synced, .syncFailed:
                return nil
            }
        }
        
        var isSyncing: Bool {
            switch self {
            case .syncing:
                return true
            case .requiresSync, .suggestsSync, .synced, .syncFailed:
                return false
            }
        }
    }
}

extension SyncStore: SlackPhotoDownloader {}

// MARK: - Error

extension SyncStore {
    enum SyncError: Error, Equatable {
        case unexpectedlyCancelled
        case filesystemStorageFailed
        case unexpectedError
    }
}
