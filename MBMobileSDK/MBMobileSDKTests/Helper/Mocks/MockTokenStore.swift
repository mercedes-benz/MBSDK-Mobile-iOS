//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

@testable import MBMobileSDK

class MockTokenStore: TokenStore {
    
    var saveSucceeds = true
    var savedToken: Token?
    
    func save(_ token: Token?) -> Bool {
        guard saveSucceeds else {
            return false
        }
        
        savedToken = token
        return true
    }
    
    func get() -> Token? {
        return savedToken
    }
}
