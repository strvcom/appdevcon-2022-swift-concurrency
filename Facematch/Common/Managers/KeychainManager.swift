//
//  KeychainManager.swift
//  Facematch
//
//  Created by Jan Kaltoun on 11.08.2020.
//

import Foundation

protocol KeychainManaging {
    func get(key: String) -> String?
    func set(key: String, value: String)
    func has(key: String) -> Bool
    func remove(key: String)
}

class KeychainManager: KeychainManaging {
    private static var accessGroup: String {
        guard let appIdentifierPrefix = Bundle.main.infoDictionary?["AppIdentifierPrefix"] as? String else {
            return ""
        }
        
        return "\(appIdentifierPrefix)\(Configuration.default.keychainGroup)"
    }
    
    func has(key: String) -> Bool {
        get(key: key) == nil ?
            false :
            true
    }

    func get(key: String) -> String? {
        let rawData: Data? = Self.load(key: key)

        guard let data = rawData else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func set(key: String, value: String) {
        guard let data = value.data(using: .utf8) else {
            return
        }

        Self.save(key: key, data: data)
    }

    func remove(key: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            // swiftlint:disable:next force_unwrapping
            kSecAttrSynchronizable: kCFBooleanTrue!,
            kSecAttrAccessGroup: Self.accessGroup
        ] as [String: Any]

        SecItemDelete(query as CFDictionary)
    }

    private static func save(key: String, data: Data) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data,
            // swiftlint:disable:next force_unwrapping
            kSecAttrSynchronizable: kCFBooleanTrue!,
            kSecAttrAccessGroup: Self.accessGroup
        ] as [String: Any]

        SecItemDelete(query as CFDictionary)

        SecItemAdd(query as CFDictionary, nil)
    }

    private static func load(key: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            // swiftlint:disable:next force_unwrapping
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne,
            // swiftlint:disable:next force_unwrapping
            kSecAttrSynchronizable: kCFBooleanTrue!,
            kSecAttrAccessGroup: Self.accessGroup
        ] as [String: Any]

        var dataTypeRef: AnyObject?

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        return status == noErr ?
            // swiftlint:disable:next force_cast
            dataTypeRef as! Data? :
            nil
    }
}
