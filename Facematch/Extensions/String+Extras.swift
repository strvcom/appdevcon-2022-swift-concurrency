//
//  String+Extras.swift
//  Facematch
//
//  Created by Abel Osorio on 9/14/20.
//

import Foundation

extension String {
    var diacriticInsensitive: String {
        folding(options: .diacriticInsensitive, locale: .current)
    }
}
