//
//  InitialSyncingView.swift
//  Facematch
//
//  Created by Abel Osorio on 1/7/21.
//

import SwiftUI

struct SuccessfulSyncingView: View {
    var body: some View {
        Group {
            VStack(spacing: 24) {
                Image("checkmark")

                Text("Done")
                    .font(.appTitle)
                    .foregroundColor(.appTextFirst)
            }
        }
    }
}

struct SuccessfulSyncingView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessfulSyncingView()
    }
}
