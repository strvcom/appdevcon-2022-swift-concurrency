//
//  ShareDataManager.swift
//  FacematchTV
//
//  Created by Jan Zimandl on 15/09/2020.
//

import Foundation
import MultipeerConnectivity

enum SharingConnectionState {
    case ready
    case advertising
    case browsing
    case connecting
    case connected
}

protocol ShareDataManagerDelegate: AnyObject {
    func didChangeState(state: SharingConnectionState)
    func didReceiveData(string: String)
}

protocol ShareDataManaging {
    func startAdvertising(serviceType: String, delegate: ShareDataManagerDelegate)
    func stopAdvertising()
    func startBrowsing(serviceType: String, delegate: ShareDataManagerDelegate)
    func stopBrowsing()
    func disconnect()
    func sendData(string: String)
}

class ShareDataManager: NSObject, ShareDataManaging {
    private weak var delegate: ShareDataManagerDelegate?

    private(set) var connectionState: SharingConnectionState = .ready {
        didSet {
            guard oldValue != connectionState else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }

                print("[SDM]: didChangeState: \(self.connectionState)")

                self.delegate?.didChangeState(state: self.connectionState)
            }
        }
    }

    private lazy var peerID: MCPeerID = {
        let peerId = MCPeerID(displayName: UIDevice.current.name)

        return peerId
    }()

    private lazy var mySession: MCSession = {
        let session = MCSession(peer: peerID)
        session.delegate = self

        return session
    }()

    private var advertiser: MCNearbyServiceAdvertiser?
    private var browser: MCNearbyServiceBrowser?

    func startAdvertising(serviceType: String, delegate: ShareDataManagerDelegate) {
        self.delegate = delegate

        advertiser = createAdvertiser(serviceType: serviceType)
        advertiser?.startAdvertisingPeer()

        connectionState = .advertising
    }

    func stopAdvertising() {
        advertiser?.stopAdvertisingPeer()
        connectionState = .ready
    }

    func startBrowsing(serviceType: String, delegate: ShareDataManagerDelegate) {
        self.delegate = delegate

        browser = createBrowser(serviceType: serviceType)
        browser?.startBrowsingForPeers()

        connectionState = .browsing
    }

    func stopBrowsing() {
        browser?.stopBrowsingForPeers()

        connectionState = .ready
    }

    func sendData(string: String) {
        guard let data = string.data(using: .utf8) else {
            return
        }
        do {
            print("[MC_SES]: SENDING data")
            try mySession.send(data, toPeers: mySession.connectedPeers, with: .reliable)
        } catch {
            print("[MC_SES]: SEND ERROR: \(error)")
        }
    }

    func disconnect() {
        mySession.disconnect()
    }

    private func createAdvertiser(serviceType: String) -> MCNearbyServiceAdvertiser {
        let infoDict = [
            "device.model": UIDevice.current.model,
            "device.localizedModel": UIDevice.current.localizedModel
        ]

        let advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: infoDict, serviceType: serviceType)
        advertiser.delegate = self

        return advertiser
    }

    private func createBrowser(serviceType: String) -> MCNearbyServiceBrowser {
        let browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        browser.delegate = self

        return browser
    }
}

// MARK: - MCNearbyServiceBrowser Delegate

extension ShareDataManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        print("[MC_BRW]: foundPeer: \(peerID) info: \(info ?? [:])")

        // invite first peer that appear
        if mySession.connectedPeers.isEmpty {
            browser.invitePeer(peerID, to: mySession, withContext: nil, timeout: 10)
        }
    }

    func browser(_: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("[MC_BRW]: lostPeer: \(peerID)")

        mySession.cancelConnectPeer(peerID)
    }

    func browser(_: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("[MC_BRW]: ERROR: \(error)")

        connectionState = .ready
    }
}

// MARK: - MCNearbyServiceAdvertiserDelegate

extension ShareDataManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("[MC_ADV]: didNotStartAdvertisingPeer: \(error)")
    }

    func advertiser(_: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext _: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("[MC_ADV]: didReceiveInvitationFromPeer \(peerID)")

        // accept all invitations if there is no connection
        if mySession.connectedPeers.isEmpty {
            invitationHandler(true, mySession)
        } else {
            invitationHandler(false, nil)
        }
    }
}

// MARK: - MCSessionDelegate

extension ShareDataManager: MCSessionDelegate {
    func session(_: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("[MC_SES]: Session did change for peer: \(peerID.displayName) to: \(state)")

        switch state {
        case .notConnected:
            if browser != nil {
                connectionState = .browsing
            } else if advertiser != nil {
                connectionState = .advertising
            } else {
                connectionState = .ready
            }
        case .connecting:
            connectionState = .connecting
        case .connected:
            connectionState = .connected
        @unknown default:
            break
        }
    }

    func session(_: MCSession, didReceive data: Data, fromPeer _: MCPeerID) {
        guard let str = String(data: data, encoding: String.Encoding.utf8) else {
            return
        }

        print("[MC_SES]: REECIVED msg: \(str)")

        DispatchQueue.main.async { [weak self] in
            self?.delegate?.didReceiveData(string: str)
        }
    }

    func session(_: MCSession, didReceive _: InputStream, withName _: String, fromPeer _: MCPeerID) {}

    func session(_: MCSession, didStartReceivingResourceWithName _: String, fromPeer _: MCPeerID, with _: Progress) {}

    func session(_: MCSession, didFinishReceivingResourceWithName _: String, fromPeer _: MCPeerID, at _: URL?, withError _: Error?) {}

    func session(_: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer _: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        print("[MC_SES]: didReceiveCertificate: \(certificate ?? [])")

        certificateHandler(true)
    }
}

// MARK: - MCSessionState CustomStringConvertible

extension MCSessionState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .connecting:
            return "connecting"
        case .connected:
            return "connected"
        case .notConnected:
            return "notConnected"
        @unknown default:
            return "unknown"
        }
    }
}
