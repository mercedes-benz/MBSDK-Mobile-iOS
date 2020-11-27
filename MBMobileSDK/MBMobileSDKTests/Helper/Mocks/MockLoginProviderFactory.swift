//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

@testable import MBMobileSDK
import MBCommonKit
import MBNetworkKit

class MockLoginProviderFactory: LoginProviderBuilding {
    
    var inputAuthenticationProviders: [AuthenticationProviding]?
    var providers: [LoginProvider]
    
    init(providers: [LoginProvider]) {
        self.providers = providers
    }
    
    func buildProviders(authenticationProviders: [AuthenticationProviding], tokenStore: TokenStore) -> [LoginProvider] {
        self.inputAuthenticationProviders = authenticationProviders
        return providers
    }
}
