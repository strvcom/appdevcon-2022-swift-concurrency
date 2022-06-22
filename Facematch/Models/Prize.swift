//
//  Prize.swift
//  Facematch
//
//  Created by Abel Osorio on 1/4/21.
//

import Foundation
import SwiftUI

struct Prize: Identifiable {
    let id = UUID()
    let title: String
    let positionImage: Image
    let backgroundImage: Image
}
