//
//  WatchConnectivityManager.swift
//  Facematch
//
//  Created by Nick Beresnev on 3/2/21.
//

import Combine
import Foundation
import WatchConnectivity

enum WatchLoginResult: String {
    case success
    case failure

    var message: [String: String] {
        [Constants.watchLoginResultKey: rawValue]
    }
}

enum Event {
  case authorize
  case logout
}

protocol WatchConnectivityManaging: WCSessionDelegate {
    #if os(watchOS)
    var connectivityPublisher: AnyPublisher<Event, Never> { get }
    #endif
    
    #if os(iOS)
    func sendAuthUpdate(isLogged: Bool)
    #endif
}

final class WatchConnectivityManager: NSObject, WatchConnectivityManaging {
    var connectivityPublisher: AnyPublisher<Event, Never> {
        connectivitySubject.eraseToAnyPublisher()
    }
    
    var connectivitySubject = PassthroughSubject<Event, Never>()
    
    override init() {
        super.init()
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}
    
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    #endif
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        handle(message: message)
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        handle(message: applicationContext)
    }
    
    func handle(message: [String: Any]) {
        let typedMessage = message as? [String: String]
        
        if typedMessage == WatchLoginResult.success.message {
            connectivitySubject.send(.authorize)
        } else if typedMessage == WatchLoginResult.failure.message {
            connectivitySubject.send(.logout)
        }
    }

    #if os(iOS)
    func sendAuthUpdate(isLogged: Bool) {
        let message = isLogged ? WatchLoginResult.success.message : WatchLoginResult.failure.message
        
        let session = WCSession.default
        
        if session.isReachable {
            session.sendMessage(message, replyHandler: nil)
        } else {
            // if watch is unreachable handle it via app context, it gets added to the queue
            try? session.updateApplicationContext(message)
        }
    }
    #endif
}
