//
//  User.swift
//  Facematch
//
//  Created by Abel Osorio on 3/8/21.
//

import Foundation

struct User: Identifiable, Decodable, Equatable {
    var id: UUID
    var imageURL: URL
    let name: String
    let firstName: String?
    let lastName: String?
    let slackId: String

    var shortName: String {
        guard let firstName = firstName else {
            return String(name.split(separator: " ").first ?? "")
        }
        
        return firstName
    }
}

// MARK: - UserWithPhoto
extension User: UserWithPhoto {
    var path: String {
        return slackId
    }

    var profileImageURL: URL {
       return imageURL
    }
}
