//
//  URLSession+DownloadTaskPublisher.swift
//  Facematch
//
//  Created by Jan Kaltoun on 04/07/2020.
//

import Combine
import Foundation

// See: https://theswiftdev.com/how-to-download-files-with-urlsession-using-combine-publishers-and-subscribers/

// swiftlint:disable:next extension_access_modifier
extension URLSession {
    public func downloadTaskPublisher(for url: URL) -> URLSession.DownloadTaskPublisher {
        downloadTaskPublisher(for: .init(url: url))
    }

    public func downloadTaskPublisher(for request: URLRequest) -> URLSession.DownloadTaskPublisher {
        .init(request: request, session: self)
    }

    public struct DownloadTaskPublisher: Publisher {
        // swiftlint:disable:next nesting
        public typealias Output = (url: URL, response: URLResponse)
        // swiftlint:disable:next nesting
        public typealias Failure = URLError

        public let request: URLRequest
        public let session: URLSession

        public init(request: URLRequest, session: URLSession) {
            self.request = request
            self.session = session
        }

        public func receive<S>(subscriber: S) where S: Subscriber,
            DownloadTaskPublisher.Failure == S.Failure,
            DownloadTaskPublisher.Output == S.Input
        {
            // swiftlint:disable:previous opening_brace
            let subscription = DownloadTaskSubscription(subscriber: subscriber, session: session, request: request)
            subscriber.receive(subscription: subscription)
        }
    }
}

extension URLSession {
    final class DownloadTaskSubscription<SubscriberType: Subscriber>: Subscription where
        SubscriberType.Input == (url: URL, response: URLResponse),
        SubscriberType.Failure == URLError
    {
        // swiftlint:disable:previous opening_brace
        private var subscriber: SubscriberType?
        // swiftlint:disable:next implicitly_unwrapped_optional
        private weak var session: URLSession!
        // swiftlint:disable:next implicitly_unwrapped_optional
        private var request: URLRequest!
        // swiftlint:disable:next implicitly_unwrapped_optional
        private var task: URLSessionDownloadTask!

        init(subscriber: SubscriberType, session: URLSession, request: URLRequest) {
            self.subscriber = subscriber
            self.session = session
            self.request = request
        }

        func request(_ demand: Subscribers.Demand) {
            guard demand > 0 else {
                return
            }
            task = session.downloadTask(with: request) { [weak self] url, response, error in
                if let error = error as? URLError {
                    self?.subscriber?.receive(completion: .failure(error))
                    return
                }
                guard let response = response else {
                    self?.subscriber?.receive(completion: .failure(URLError(.badServerResponse)))
                    return
                }
                guard let url = url else {
                    self?.subscriber?.receive(completion: .failure(URLError(.badURL)))
                    return
                }
                do {
                    // swiftlint:disable:next force_unwrapping
                    let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
                    let fileUrl = cacheDir.appendingPathComponent(UUID().uuidString)
                    try FileManager.default.moveItem(atPath: url.path, toPath: fileUrl.path)
                    _ = self?.subscriber?.receive((url: fileUrl, response: response))
                    self?.subscriber?.receive(completion: .finished)
                } catch {
                    self?.subscriber?.receive(completion: .failure(URLError(.cannotCreateFile)))
                }
            }
            task.resume()
        }

        func cancel() {
            task.cancel()
        }
    }
}
