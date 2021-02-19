//
//  VPNManager.swift
//  DOHIKEv2Demo
//
//  Created by Juraj Hilje on 19/02/2021.
//

import Foundation
import NetworkExtension

class VPNManager {
    
    // MARK: - Properties -
    
    static let shared = VPNManager()
    
    private let manager = NEVPNManager.shared()
    
    // MARK: - Methods -
    
    func connect() {
        setupVPNManager { error in
            guard error == nil else {
                print("Error saving VPN configuration")
                return
            }
            
            self.manager.loadFromPreferences { _ in
                do {
                    try self.manager.connection.startVPNTunnel()
                } catch let error as NSError {
                    print("Error connecting to VPN: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func disconnect() {
        manager.connection.stopVPNTunnel()
        removeOnDemandRule()
    }
    
    func removeProfile() {
        manager.removeFromPreferences { _ in }
    }
    
    // MARK: - Private methods -
    
    private func setupVPNConfiguration() {
        let configuration = NEVPNProtocolIKEv2()
        configuration.remoteIdentifier = Config.vpnGateway
        configuration.serverAddress = Config.vpnGateway
        configuration.localIdentifier = KeyChain.vpnUsername
        configuration.username = KeyChain.vpnUsername
        configuration.passwordReference = KeyChain.vpnPasswordRef
        configuration.authenticationMethod = .none
        configuration.useExtendedAuthentication = true
        configuration.disconnectOnSleep = false
        
        // Child IPSec security associations to be negotiated for each IKEv2 policy
        configuration.childSecurityAssociationParameters.encryptionAlgorithm = .algorithmAES256 // AES_CBC_256
        configuration.childSecurityAssociationParameters.diffieHellmanGroup = .group14 // MODP_2048
        configuration.childSecurityAssociationParameters.integrityAlgorithm = .SHA256 // HMAC_SHA2_256_128
        
        // Initial IKE security association to be negotiated with the IKEv2 server
        configuration.ikeSecurityAssociationParameters.encryptionAlgorithm = .algorithmAES256 // AES_CBC_256
        configuration.ikeSecurityAssociationParameters.diffieHellmanGroup = .group14 // MODP_2048
        configuration.ikeSecurityAssociationParameters.integrityAlgorithm = .SHA256 // HMAC_SHA2_256_128
        
        manager.localizedDescription = "DOHIKEv2"
        manager.protocolConfiguration = configuration
        manager.onDemandRules = [NEOnDemandRuleConnect()]
        manager.isOnDemandEnabled = true
        manager.isEnabled = true
    }
    
    private func setupVPNManager(completion: @escaping (Error?) -> Void) {
        manager.loadFromPreferences { _ in
            self.setupVPNConfiguration()
            self.manager.saveToPreferences { error in
                completion(error)
            }
        }
    }
    
    private func removeOnDemandRule() {
        manager.loadFromPreferences { _ in
            self.manager.onDemandRules = []
            self.manager.isOnDemandEnabled = false
            self.manager.saveToPreferences { _ in }
        }
    }
    
}
