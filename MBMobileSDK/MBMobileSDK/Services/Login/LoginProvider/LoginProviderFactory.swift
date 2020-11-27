//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import MBNetworkKit
import MBCommonKit

protocol LoginProviderBuilding {
    func buildProviders(authenticationProviders: [AuthenticationProviding], tokenStore: TokenStore) -> [LoginProvider]
}

class LoginProviderFactory: LoginProviderBuilding {
    
    func buildProviders(authenticationProviders: [AuthenticationProviding], tokenStore: TokenStore) -> [LoginProvider] {
        return authenticationProviders.compactMap {
            guard let config = $0 as? ROPCAuthenticationProviding else {
                return nil
            }
            
            return ROPCLoginProvider(config: config, tokenStore: tokenStore)
        }
    }
}
