//
//  APIError.swift
//  Facematch
//
//  Created by Jan Kaltoun on 04/07/2020.
//

import Foundation

enum APIError: Error, LocalizedError {
    case unknown, apiError(reason: String)

    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case let .apiError(reason):
            return reason
        }
    }
}
