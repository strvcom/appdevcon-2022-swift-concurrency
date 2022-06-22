//
//  Configuration.swift
//  Facematch
//
//  Created by Gaston Mazzeo on 1/26/21.
//

import Foundation

public struct Configuration: Decodable {
    private enum CodingKeys: String, CodingKey {
        case sentryDSN = "SENTRY_DSN"
        case apiBaseURL = "API_BASE_URL"
        case keychainGroup = "KEYCHAIN_GROUP"
    }

    public let keychainGroup: String
    public let sentryDSN: String?
    public let apiBaseURL: URL
}

// MARK: Static properties
public extension Configuration {
    static let `default`: Configuration = {
        guard let propertyList = Bundle.main.infoDictionary else {
            fatalError("Unable to get property list.")
        }

        guard let data = try? JSONSerialization.data(withJSONObject: propertyList, options: []) else {
            fatalError("Unable to instantiate data from property list.")
        }

        let decoder = JSONDecoder()

        guard let configuration = try? decoder.decode(Configuration.self, from: data) else {
            fatalError("Unable to decode the Environment configuration file.")
        }

        return configuration
    }()
}
