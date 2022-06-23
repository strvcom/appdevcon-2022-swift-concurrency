//
//  NetworkManager.swift
//  Facematch
//
//  Created by Gaston Mazzeo on 2/15/21.
//

import Combine
import Network

protocol NetworkManaging {
//    var networkType: AnyPublisher<NetworkType, Never> { get }
    var networkType: AsyncStream<NetworkType> { get }
    
    func startMonitoring()
    func stopMonitoring()
}

class NetworkManager: NetworkManaging {
    private var monitor: NWPathMonitor?
    
    lazy var networkType: AsyncStream<NetworkType> = makeMonitoringStream()
    
    func makeMonitoringStream() -> AsyncStream<NetworkType> {
        .init { [weak self] continuation in
            self?.monitor?.pathUpdateHandler = {
                var networkType = NetworkType.other
                
                if $0.usesInterfaceType(.cellular) {
                    networkType = .mobile
                }
                
                if $0.usesInterfaceType(.wifi) {
                    networkType = .wifi
                }
                
                continuation.yield(networkType)
            }
        }
    }

    func startMonitoring() {
        monitor = NWPathMonitor()
        monitor?.start(queue: DispatchQueue.main)
    }
    
    func stopMonitoring() {
        monitor?.cancel()
        monitor = nil
    }
}
