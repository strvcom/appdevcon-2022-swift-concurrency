//
//  APIMember.swift
//  Facematch
//
//  Created by Jan Kaltoun on 03/07/2020.
//

import Foundation

struct APIMember {
    enum ExpectedDecodingError: Error {
        case requiredDataNotPresent
        case unwantedMember
        case photoMissing
    }

    enum CodingKeys: String, CodingKey {
        case isDeleted = "deleted"
        case isBot
        case isRestricted
        case isUltraRestricted
        case id
        case name
        case profile
        case teamId
    }

    enum ProfileCodingKeys: String, CodingKey {
        case firstName
        case lastName
        case imageOriginal
        case image512
        case realName
        case displayName
        case realNameNormalized
        case image192
        case isCustomImage
    }

    let id: String
    let firstName: String?
    let lastName: String?
    let userName: String
    let remotePhotoURL: URL
    let realName: String
    let displayName: String
    let realNameNormalized: String
    let teamId: String
    let smallPhotoUrl: URL
    
    var fullName: String {
        let fullName = [firstName, lastName].compactMap { $0 }
        
        if fullName.isEmpty {
            return fullName.joined(separator: " ")
        } else {
            return realName
        }
    }
}

extension APIMember: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)
        userName = try values.decode(String.self, forKey: .name)
        teamId = try values.decode(String.self, forKey: .teamId)

        let isDeleted = try values.decodeIfPresent(Bool.self, forKey: .isDeleted)
        let isBot = try values.decodeIfPresent(Bool.self, forKey: .isBot)
        let isRestricted = try values.decodeIfPresent(Bool.self, forKey: .isRestricted)
        let isUltraRestricted = try values.decodeIfPresent(Bool.self, forKey: .isUltraRestricted)

        if isDeleted == true || isBot == true || isRestricted == true || isUltraRestricted == true {
            throw ExpectedDecodingError.unwantedMember
        }

        // Profile

        let additionalInfo = try values.nestedContainer(keyedBy: ProfileCodingKeys.self, forKey: .profile)

        do {
            firstName = try additionalInfo.decodeIfPresent(String.self, forKey: .firstName)
            lastName = try additionalInfo.decodeIfPresent(String.self, forKey: .lastName)
            realName = try additionalInfo.decode(String.self, forKey: .realName)
            displayName = try additionalInfo.decode(String.self, forKey: .displayName)
            realNameNormalized = try additionalInfo.decode(String.self, forKey: .realNameNormalized)
            
            let isCustomImage = try additionalInfo.decode(Bool.self, forKey: .isCustomImage)

            guard isCustomImage else {
                throw ExpectedDecodingError.requiredDataNotPresent
            }
            
            let imageOriginalValue = try additionalInfo.decodeIfPresent(String.self, forKey: .imageOriginal)
            let imageBig = try additionalInfo.decode(String.self, forKey: .image512)
            let smallImage = try additionalInfo.decode(String.self, forKey: .image192)

            if let imageOriginal = imageOriginalValue, let remoteURL = URL(string: imageOriginal) {
                remotePhotoURL = remoteURL
            } else if let remoteURL = URL(string: imageBig) {
                remotePhotoURL = remoteURL
            } else {
                throw ExpectedDecodingError.requiredDataNotPresent
            }
            
            guard let smallImageUrl = URL(string: smallImage) else {
                throw ExpectedDecodingError.requiredDataNotPresent
            }
            
            smallPhotoUrl = smallImageUrl
        } catch {
            throw ExpectedDecodingError.requiredDataNotPresent
        }
    }
}

// MARK: - UserWithPhoto
extension APIMember: UserWithPhoto {
    var path: String {
        return id
    }

    var profileImageURL: URL {
       return remotePhotoURL
    }
}
