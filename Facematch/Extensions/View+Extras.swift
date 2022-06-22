//
//  View+Extras.swift
//  Facematch
//
//  Created by Abel Osorio on 9/28/20.
//

import SwiftUI

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, content: (Self) -> Content) -> some View {
        if condition {
            content(self)
        } else {
            self
        }
    }
}
