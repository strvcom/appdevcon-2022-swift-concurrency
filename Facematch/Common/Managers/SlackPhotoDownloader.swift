//
//  SlackPhotoDownloader.swift
//  Facematch
//
//  Created by Gaston Mazzeo on 1/20/21.
//

import Combine
import Foundation

protocol UserWithPhoto {
    var path: String { get }
    var profileImageURL: URL { get }
}

enum SlackPhotoDownloadError: Error {
    case noLocalURL
}

protocol SlackPhotoDownloader: AnyObject {
    var apiManager: APIManaging { get }
    var photoStorageManager: PhotoStorageManaging { get }
}

extension SlackPhotoDownloader {
    func downloadSmallSlackPhotoData(of member: APIMember) -> AnyPublisher<Data, Error> {
        apiManager.fetch(url: member.smallPhotoUrl)
    }
    
    func downloadSlackPhoto<T: UserWithPhoto>(of user: T) -> AnyPublisher<URL, Error> {
        apiManager.download(url: user.profileImageURL)
            .tryMap(weak: self) { downloader, downloadedFileURL in
                let localURL = downloader.photoStorageManager.temporaryDirectory.appendingPathComponent(user.path)
                
                try FileManager.default.moveItem(at: downloadedFileURL, to: localURL)

                return localURL
            }
            .eraseToAnyPublisher()
    }
}
