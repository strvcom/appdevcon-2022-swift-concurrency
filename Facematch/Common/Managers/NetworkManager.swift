//
//  NetworkManager.swift
//  Facematch
//
//  Created by Gaston Mazzeo on 2/15/21.
//

import Combine
import Network

protocol NetworkManaging {
    var networkType: AnyPublisher<NetworkType, Never> { get }
    
    func startMonitoring()
    func stopMonitoring()
}

class NetworkManager: NetworkManaging {
    private var monitor: NWPathMonitor?
    
    private let networkTypeSubject = PassthroughSubject<NetworkType, Never>()
    lazy var networkType = networkTypeSubject.eraseToAnyPublisher()

    func startMonitoring() {
        monitor = NWPathMonitor()
        monitor?.start(queue: DispatchQueue.main)
        
        monitor?.pathUpdateHandler = { [weak self] in
            var networkType = NetworkType.other
            
            if $0.usesInterfaceType(.cellular) {
                networkType = .mobile
            }
            
            if $0.usesInterfaceType(.wifi) {
                networkType = .wifi
            }
            
            self?.networkTypeSubject.send(networkType)
        }
    }
    
    func stopMonitoring() {
        monitor?.cancel()
        monitor = nil
    }
}
