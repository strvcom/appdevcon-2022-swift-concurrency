//
//  ImageRetrieving.swift
//  Facematch
//
//  Created by Abel Osorio on 9/17/20.
//

import SwiftUI

protocol ImageRetrieving {
    func photo(for person: SlackUser) -> Image
    func photos(for person: Question) -> [Image]
}

extension ImageRetrieving {
    func photo(for person: SlackUser) -> Image {
        guard let photo = try? PhotoStorageManager.getPhoto(forPersonId: person.id ?? "") else {
            fatalError("Could not load photo for person: \(person)")
        }

        return photo
    }

    func photos(for question: Question) -> [Image] {
        return question.answers.compactMap { self.photo(for: $0) }
    }
    
    func temporaryPhoto(from url: URL) -> Image? {
        guard let photo = try? PhotoStorageManager.getTemporaryImage(from: url) else {
            return nil
        }
        
        return photo
    }
}
