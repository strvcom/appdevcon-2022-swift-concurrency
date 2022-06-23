//
//  SyncView.swift
//  Facematch
//
//  Created by Jan Kaltoun on 07/07/2020.
//

import SwiftUI

struct SyncView: View {
    @EnvironmentObject var syncStore: SyncStore
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 16) {
            switch syncStore.state {
            case let .synced(initial) where initial == false:
                SuccessfulSyncingView()
            case .synced, .requiresSync, .suggestsSync:
                RequireSyncView(
                    onDownload: {
                        syncStore.sync()
                    }, onLater: {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            case .syncing(let progress, _, let images):
                AnimatedSyncingView(progress: progress, syncedImageURLs: images)
            case .syncFailed:
                FailedSyncingView {
                    syncStore.sync()
                } onCancel: {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .onAppear {
//            syncStore.startCheckingNetworkType()
        }
        .onDisappear {
            syncStore.stopSync()
        }
    }
}

struct SyncView_Previews: PreviewProvider {
    static var previews: some View {
        SyncView()
    }
}
