//
//  ProfileSummary.swift
//  Facematch
//
//  Created by Abel Osorio on 12/30/20.
//

import SwiftUI

struct ProfileSummary: View {
    let image: String
    let title: String
    let value: String?

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Image(image)
                    .frame(width: 14, height: 14)

                Text(title)
                    .font(.appButtonTitle)
            }
            .padding()

            Spacer()

            Text(value ?? "-")
                .font(.appProfileTitle)
                .padding()
        }
        .frame(maxWidth: .infinity, idealHeight: 88)
        .background(Color.appItemBackground)
        .cornerRadius(12)
        .accessibilityElement(children: .ignore)
        .accessibility(label: Text("\(title) \(value ?? "")"))
    }
}

struct ProfileSummary_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSummary(image: "flame", title: "Nick", value: "2nd")
    }
}
