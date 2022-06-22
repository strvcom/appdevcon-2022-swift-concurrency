//
//  SlackUser.swift
//  Facematch
//
//  Created by Jan Kaltoun on 04/07/2020.
//

import Foundation
import SwiftUI

protocol SlackUser {
    var id: String? { get }
    var firstName: String? { get }
    var lastName: String? { get }
    var realName: String? { get }
}

extension SlackUser {
    var fullName: String {
        let fullName = [firstName, lastName].compactMap { $0 }

        if !fullName.isEmpty {
            return fullName.joined(separator: " ")
        } else {
            return realName ?? ""
        }
    }

    var fullNameInTwoLines: String {
        let fullName = [firstName, lastName].compactMap { $0 }
        
        if !fullName.isEmpty {
            return fullName.joined(separator: "\n").uppercased()
        } else {
            return (realName ?? "").uppercased()
        }
    }
}

extension Person: SlackUser {}
extension LoggedUser: SlackUser {}
