//
//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit

protocol ActiveLoginProviderFiltering {
    
    func update(bffResponseAuthType: AuthenticationType?)
    
    func activeLoginProvider(loginProviders: [LoginProvider],
                             preferredAuthenticationType: AuthenticationType?) -> LoginProvider?
}

class ActiveLoginProviderFilter: ActiveLoginProviderFiltering {
    
    private let tokenStore: TokenStore
    private var bffResponseAuthType: AuthenticationType?
    
    init(tokenStore: TokenStore) {
        self.tokenStore = tokenStore
    }
    
    func update(bffResponseAuthType: AuthenticationType?) {
        self.bffResponseAuthType = bffResponseAuthType
    }
    
    func activeLoginProvider(loginProviders: [LoginProvider],
                             preferredAuthenticationType: AuthenticationType?) -> LoginProvider? {
        
        return activeLoginProvider(loginProviders: loginProviders,
                                   token: self.tokenStore.get(),
                                   bffResponseAuthType: bffResponseAuthType,
                                   preferredAuthenticationType: preferredAuthenticationType)
        
    }
    
    private func activeLoginProvider(loginProviders: [LoginProvider],
                                     token: Token?,
                                     bffResponseAuthType: AuthenticationType?,
                                     preferredAuthenticationType: AuthenticationType?) -> LoginProvider? {
        
        LOG.D("Available Login Providers: \(loginProviders.map { $0.type.rawValue })")
        
        let authenticationType = token?.authenticationType ?? bffResponseAuthType ?? preferredAuthenticationType
        LOG.V("Token Authentication Type is: \(String(describing: token?.authenticationType?.rawValue))")
        LOG.V("BFF Response Authentication Type is: \(String(describing: bffResponseAuthType?.rawValue))")
        LOG.V("Preferred Authentication Type is: \(String(describing: preferredAuthenticationType?.rawValue))")
        
        guard let matchingProvider = loginProviders.first(where: { $0.type == authenticationType }) else {
            LOG.E("""
                  Failed trying to fetch provider for authType: \(String(describing: authenticationType)),
                  from available providers: \(loginProviders.map({$0.type.rawValue}))
                  """)
            return nil
        }
        
        LOG.D("Active Login Provider: \(matchingProvider.type.rawValue)")
        
        return matchingProvider
    }
}
