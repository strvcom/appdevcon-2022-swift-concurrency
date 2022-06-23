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

@MainActor class SyncStore: ObservableObject {
    static let lastSyncUserDefaultsKey = "last_sync"
    static let syncRefreshThreshold: TimeInterval = 60*60*24*7 // 7 days
    static let syncTimeDifferenceThreshold: TimeInterval = 3

    @Injected var apiManager: APIManaging
    @Injected var photoStorageManager: PhotoStorageManaging
    @Injected private var keychainManager: KeychainManaging
    @Injected private var coreDataManager: CoreDataManaging
    @Injected private var networkManager: NetworkManaging

    var syncTask: Task<Void, Never>?
    var networkTask: Task<Void, Never>?

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
        syncTask = Task {
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
            var numberOfSyncedItems = 0
            var downloadedImageURLs: [URL] = .init()
            
            do {
                let members = try await loadSlackMemberData()
                
                let numberOfItemsToSync = members.count + 1
                
                try await cleanLocalCache()
                
                try await withThrowingTaskGroup(
                    of: (
                        member: APIMember,
                        smallPhotoData: Data,
                        largePhotoURL: URL
                    ).self
                ) { group in
                    for member in members {
                        group.addTask {
                            print("[SYNC] Downloading data for: \(member)")
                            
                            async let smallPhotoData = self.downloadSmallSlackPhotoData(of: member)
                            
                            async let largePhotoLocalURL =  self.downloadSlackPhoto(of: member)
                            
                            return try await (
                                member: member,
                                smallPhotoData: smallPhotoData,
                                largePhotoURL: largePhotoLocalURL
                            )
                        }
                    }
                    
                    for try await memberInfo in group {
                        print("[SYNC] Downloaded data for: \(memberInfo)")
                        
                        membersInfo.append(
                            (memberInfo.member, memberInfo.smallPhotoData)
                        )
                        
                        numberOfSyncedItems += 1
                        downloadedImageURLs.append(memberInfo.largePhotoURL)
                        
                        let syncProgress = Double(numberOfSyncedItems) / Double(numberOfItemsToSync)

                        let timeDifference = Date().timeIntervalSince(lastStateUpdate)
                        
                        // Updating syncing state only if the difference is more than 1%
                        // and after 3 seconds after the last update at least
                        // to avoid re-rendering
                        if
                            syncProgress - state.syncProgress > 0.01,
                            timeDifference > Self.syncTimeDifferenceThreshold
                        {
                            lastStateUpdate = Date()
                            
                            print("[SYNC] Downloading photo \(numberOfSyncedItems) of \(numberOfItemsToSync).")
                            
                            state = .syncing(
                                progress: syncProgress,
                                description: "Downloading photo \(numberOfSyncedItems) of \(numberOfItemsToSync).",
                                images: downloadedImageURLs
                            )
                        }
                    }
                }
                
                try await save(membersInfo: membersInfo)

                UserDefaults.standard.setValue(Date(), forKey: Self.lastSyncUserDefaultsKey)

                try? photoStorageManager.blessTemporaryDirectory()
                
                state = .synced(initial: false)
            } catch {
                state = .syncFailed(error: .unexpectedlyCancelled)
            }
        }
    }

    func cancelSync() {
        guard case .syncing = state else {
            return
        }

        try? photoStorageManager.reset()
        
        syncTask?.cancel()

        updateSyncState()
    }
    
    func stopSync() {
        cancelSync()
        stopCheckingNetworkType()
    }

    func loadSlackMemberData() async throws -> [APIMember] {
        // swiftlint:disable:next force_unwrapping
        var components = URLComponents(string: "https://slack.com/api/users.list")!

        components.queryItems = [
            URLQueryItem(
                name: "token",
                value: keychainManager.get(key: KeychainKeys.keychainAccessTokenKey)
            )
        ]
        
        // swiftlint:disable:next force_unwrapping
        let data = try await apiManager.fetch(url: components.url!)
        
        let apiMemberResponse = try apiManager.decoder.decode(
            APIMemberResponse.self,
            from: data
        )
        
        return apiMemberResponse.members
    }

    func cleanLocalCache() async throws {
        let context = coreDataManager.persistentContainer.newBackgroundContext()
        
        try await context.perform {
            let personFetchRequest: NSFetchRequest<Person> = Person.fetchRequest()

            let result = try context.fetch(personFetchRequest)

            result.forEach {
                context.delete($0)
            }
            
            try context.save()
        }
    }
    
    func save(membersInfo: [(APIMember, Data)]) async throws {
        let context = coreDataManager.persistentContainer.newBackgroundContext()
        
        try await context.perform {
            membersInfo.forEach { (member, image) in
                let person = Person(context: context)
                
                person.id = member.id
                person.firstName = member.firstName
                person.lastName = member.lastName
                person.realName = member.realName
                person.image = image
            }
            
            try context.save()
        }
    }
    
    func startCheckingNetworkType() {
        networkManager.startMonitoring()
        
        networkTask = Task {
            for await networkType in networkManager.networkType where networkType != .wifi {
                cancelSync()
            }
        }
    }
    
    func stopCheckingNetworkType() {
        networkTask?.cancel()
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
