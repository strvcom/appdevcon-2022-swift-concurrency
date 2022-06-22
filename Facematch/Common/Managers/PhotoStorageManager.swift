//
//  PhotoStorageManager.swift
//  Facematch
//
//  Created by Jan Kaltoun on 04/07/2020.
//

import Foundation
import SwiftUI

protocol PhotoStorageManaging {
    var temporaryDirectory: URL { get }

    func reset() throws
    func blessTemporaryDirectory() throws

    static func createTempDirectory() throws -> URL
    static func getPhotosDirectory() throws -> URL
    static func deleteCachedPhotos() throws
    static func getPhoto(forPersonId personId: String) throws -> Image
    func getPhoto(forPersonId id: String) throws -> Image
}

class PhotoStorageManager: PhotoStorageManaging {
    enum PhotoStorageError: Error {
        case couldNotInitializeCachedPhoto
    }

    static let photosDirectoryName = "Photos"

    var temporaryDirectory: URL

    init() throws {
        temporaryDirectory = try Self.createTempDirectory()
    }

    func reset() throws {
        temporaryDirectory = try Self.createTempDirectory()
    }

    func blessTemporaryDirectory() throws {
        try Self.deleteCachedPhotos()

        let photosDirectory = try Self.getPhotosDirectory()

        try FileManager.default.moveItem(
            at: temporaryDirectory,
            to: photosDirectory
        )
    }

    static func createTempDirectory() throws -> URL {
        let userTempDirectory = FileManager.default.temporaryDirectory
        let photosTempDirectory = userTempDirectory.appendingPathComponent(UUID().uuidString)

        try FileManager.default.createDirectory(
            at: photosTempDirectory,
            withIntermediateDirectories: true
        )

        return photosTempDirectory
    }

    static func getPhotosDirectory() throws -> URL {
        let documentsDirectory = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )

        return documentsDirectory.appendingPathComponent(Self.photosDirectoryName)
    }

    static func deleteCachedPhotos() throws {
        
        let photosDirectory = try getPhotosDirectory()

        guard FileManager.default.fileExists(atPath: photosDirectory.path) else {
            return
        }

        try FileManager.default.removeItem(at: photosDirectory)
    }

    static func getPhoto(forPersonId personId: String) throws -> Image {
        let photosDirectory = try Self.getPhotosDirectory()

        let photoURL = photosDirectory.appendingPathComponent(personId)
        let photoPath = photoURL.path

        guard let image = UIImage(contentsOfFile: photoPath) else {
            throw PhotoStorageError.couldNotInitializeCachedPhoto
        }

        return Image(uiImage: image)
    }
    
    func getPhoto(forPersonId id: String) throws -> Image {
        try Self.getPhoto(forPersonId: id)
    }
    
    static func getTemporaryImage(from url: URL) throws -> Image? {
        guard let image = UIImage(contentsOfFile: url.path) else {
            throw PhotoStorageError.couldNotInitializeCachedPhoto
        }

        return Image(uiImage: image)
    }
}
