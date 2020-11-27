//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

protocol TokenStore {
    /// save a Token to a secure store
    /// - Parameters:
    ///   - state: the OIDAuthState
    /// - Returns:
    ///     success of the save
    @discardableResult
    func save(_ token: Token?) -> Bool
    
    /// Fetches the current Token from a secure storage if available
    /// - Returns:
    ///   the current token
    func get() -> Token?
}

struct KeychainTokenStoreFactory {
    
    private static let serviceName = "RISAppfamily"
    
    func build() -> KeychainTokenStore {
        return KeychainTokenStore(keychainWrapper: KeychainWrapper(serviceName: KeychainTokenStoreFactory.serviceName))
    }
}

class KeychainTokenStore: TokenStore {
    
    private struct Keys {
        static let jwtTokenKey = "jwtTokenKey"
    }
    
    private let keychainWrapper: KeychainWrapper
    
    fileprivate init(keychainWrapper: KeychainWrapper) {
        self.keychainWrapper = keychainWrapper
    }
    
    @discardableResult
    func save(_ token: Token?) -> Bool {
        guard let token = token,
              let encodeToken = try? JSONEncoder().encode(token) else {
                self.keychainWrapper.removeObject(forKey: Keys.jwtTokenKey)
                LOG.E("Removing JWT from keychain, because setter is nil")
                return true
            }
        
        let data = NSKeyedArchiver.archivedData(withRootObject: encodeToken)
        let saved = self.keychainWrapper.set(data, forKey: Keys.jwtTokenKey)
        
        saved ? LOG.D("Saving JWT to keychain succeeded") : LOG.E("Saving JWT to keychain failed")
        return saved
    }
    
    func get() -> Token? {
        guard let data = self.keychainWrapper.object(forKey: Keys.jwtTokenKey) as? Data else {
            LOG.E("Return empty (nullable) JWT from keychain")
            return nil
        }
        
        do {
            return try JSONDecoder().decode(Token.self, from: data)
        } catch {
            LOG.E("Found token data, but failed to decode it with error: \(error)")
            return nil
        }
    }
}
