//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import MBCommonKit

public protocol AuthenticationProviderBuilding {
    
    func buildProviders(configurations: [AuthenticationConfig], sdkVersion: String) -> [AuthenticationProviding]
}

public class AuthenticationProviderFactory: AuthenticationProviderBuilding {
    
    public init() {}
    
    open func buildProviders(configurations: [AuthenticationConfig], sdkVersion: String) -> [AuthenticationProviding] {
        return configurations.compactMap { buildProvider(configuration: $0, sdkVersion: sdkVersion) }
    }

    private func buildProvider(configuration: AuthenticationConfig, sdkVersion: String) -> AuthenticationProviding? {
        
        switch configuration.type {
        case .keycloak:
            guard let keycloakConfig = configuration as? ROPCAuthenticationConfig else {
                LOG.E("Trying to build DefaultKeycloakProvider, but the given configuration is not a ROPCAuthenticationConfig: \(configuration)")
                return nil
            }
            return DefaultKeycloakProvider(clientIdentifier: keycloakConfig.clientId, sdkVersion: sdkVersion)
            
        case .ciam:
           guard let ciamConfig = configuration as? ROPCAuthenticationConfig else {
               LOG.E("Trying to build DefaultCiamProvider, but the given configuration is not a ROPCAuthenticationConfig: \(configuration)")
               return nil
           }
           return DefaultCiamProvider(clientIdentifier: ciamConfig.clientId, sdkVersion: sdkVersion)
        }
    }
}
