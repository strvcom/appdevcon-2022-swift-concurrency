//
//  RequireSyncView.swift
//  Facematch
//
//  Created by Abel Osorio on 1/7/21.
//

import SwiftUI

struct RequireSyncView: View {
    typealias DownloadHandler = () -> Void
    typealias LaterHandler = () -> Void

    var onDownload: DownloadHandler
    var onLater: LaterHandler

    var body: some View {
        VStack {
            Spacer()

            Image("simcard")

            Text("Download game data")
                .foregroundColor(.appTextFirst)
                .font(.appLargeTitle)
                .padding()

            Text("Game has to download faces to play.\nDo you want to download on data?")
                .font(.appLargeSubtitle)
                .foregroundColor(.appTextSecond)
                .lineSpacing(10.0)
                .multilineTextAlignment(.center)

            Spacer()

            VStack(spacing: 8) {
                Button(action: onDownload) {
                    Text("CONTINUE")
                }
                .buttonStyle(PrimaryButtonStyle())

                Button(action: onLater) {
                    Text("LATER")
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            .padding([.leading, .trailing])
        }
    }
}

struct RequireSyncView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RequireSyncView {
                print("Download")
            } onLater: {
                print("Later")
            }
            
            RequireSyncView {
                print("Download")
            } onLater: {
                print("Later")
            }
            .preferredColorScheme(.dark)
        }
    }
}
