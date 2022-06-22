//
//  FailedSyncingView.swift
//  Facematch
//
//  Created by Abel Osorio on 1/7/21.
//

import SwiftUI

struct FailedSyncingView: View {
    typealias RetryHandler = () -> Void
    typealias CancelHandler = () -> Void

    var onRetry: RetryHandler
    var onCancel: CancelHandler

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                Text("Sync failed")
                    .font(.appLargeTitle)
                
                Text("Please try again.")
                    .font(.appLargeSubtitle)
            }

            
            VStack(spacing: 8) {
                Button(action: onRetry) {
                    Text("RETRY")
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Button(action: onCancel) {
                    Text("CANCEL")
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            .padding([.leading, .trailing])
        }
        .foregroundColor(.appTextFirst)
    }
}

struct FailedSyncingView_Previews: PreviewProvider {
    static var previews: some View {
        FailedSyncingView {
            print("Retry")
        } onCancel: {
            print("Cancel")
        }
    }
}
