//
//  Int+Ordinal.swift
//  Facematch
//
//  Created by Abel Osorio on 3/10/21.
//

import Foundation

extension Int {
    var ordinalValue: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
