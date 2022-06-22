//
//  APIManager.swift
//  Facematch
//
//  Created by Jan Kaltoun on 04/07/2020.
//

import Combine
import Foundation

protocol APIManaging {
    var decoder: JSONDecoder { get }

    func fetch(url: URL) -> AnyPublisher<Data, Error>
    func download(url: URL) -> AnyPublisher<URL, Error>
    func post(url: URL, params: [String: Any]) -> AnyPublisher<Data, Error>
}

class APIManager: APIManaging {
    private var keychainManager: KeychainManaging
    
    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 300
        config.timeoutIntervalForResource = 300
        
        return URLSession(configuration: config)
    }()

    init(keychainManager: KeychainManaging) {
        self.keychainManager = keychainManager
    }

    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()

        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        return decoder
    }()

    func fetch(url: URL) -> AnyPublisher<Data, Error> {
        var request = URLRequest(url: url)

        if
            url.absoluteString.contains(Configuration.default.apiBaseURL.absoluteString),
            let token = keychainManager.get(key: KeychainKeys.keychainBackendAccessTokenKey)
        {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw APIError.unknown
                }
                
                return data
            }
            .eraseToAnyPublisher()
    }

    func post(url: URL, params: [String: Any]) -> AnyPublisher<Data, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        request.httpBody = jsonData

        if
            url.absoluteString.contains(Configuration.default.apiBaseURL.absoluteString),
            let token = keychainManager.get(key: KeychainKeys.keychainBackendAccessTokenKey)
        {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw APIError.unknown
                }

                return data
            }
            .eraseToAnyPublisher()
    }

    func download(url: URL) -> AnyPublisher<URL, Error> {
        return URLSession.shared.downloadTaskPublisher(for: url)
            .tryMap { url, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw APIError.unknown
                }

                return url
            }
            .eraseToAnyPublisher()
    }
}
