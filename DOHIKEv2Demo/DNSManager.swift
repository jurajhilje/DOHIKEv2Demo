//
//  DNSManager.swift
//  DOHIKEv2Demo
//
//  Created by Juraj Hilje on 19/02/2021.
//

import Foundation
import NetworkExtension

class DNSManager {
    
    // MARK: - Properties -
    
    static let shared = DNSManager()
    
    private let manager = NEDNSSettingsManager.shared()
    
    // MARK: - Methods -
    
    func saveProfile(completion: @escaping (Error?) -> ()) {
        manager.loadFromPreferences { error in
            self.manager.dnsSettings = self.getDnsSettings()
            self.manager.onDemandRules = [NEOnDemandRuleConnect()]
            self.manager.saveToPreferences { error in
                completion(error)
            }
        }
    }
    
    func removeProfile(completion: @escaping (Error?) -> ()) {
        manager.removeFromPreferences { error in
            completion(error)
        }
    }
    
    // MARK: - Private methods -
    
    private func getDnsSettings() -> NEDNSSettings {
        let settings = NEDNSOverHTTPSSettings(servers: [Config.dnsIpAddress])
        settings.serverURL = URL.init(string: Config.dnsServerURL)
        return settings
    }
    
}
