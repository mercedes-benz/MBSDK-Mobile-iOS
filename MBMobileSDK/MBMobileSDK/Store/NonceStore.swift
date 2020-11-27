//
//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

public protocol NonceRepository {
    func nonce() -> String?
    func save(nonce: String?)
}

public class NonceStore: NonceRepository {
    
    private let defaults: UserDefaults
    
    private enum NonceStoreDefaultKey: String {
        case nonceStoreNonce
    }
    
    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    public func nonce() -> String? {
        return self.defaults.string(forKey: NonceStoreDefaultKey.nonceStoreNonce.rawValue)
    }
    
    public func save(nonce: String?) {
        self.defaults.set(nonce, forKey: NonceStoreDefaultKey.nonceStoreNonce.rawValue)
    }
    
}
