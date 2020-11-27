//
// Copyright (c) 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit

final class DefaultKeycloakProvider: ROPCAuthenticationProviding {

    private var clientIdentifier: String
    private var sdkVersion: String

    var type: AuthenticationType = .keycloak
    
    // MARK: - Init

	public init(clientIdentifier: String, sdkVersion: String) {
		
        self.clientIdentifier = clientIdentifier
		self.sdkVersion = sdkVersion
    }

    // MARK: - ROPCAuthenticationProviding
    public var clientId: String {
        return self.clientIdentifier
    }

	var headerParamProvider: HeaderParamProviding {
		return DefaultHeaderParamProvider(sdkVersion: self.sdkVersion)
	}
	
    public var stageName: String {

        guard let stage = MBMobileSDKEndpoint.modifiedStage else {
            return ""
        }

        switch stage {
        case .mock: return "int"
        case .prod: return "prod"
        }
    }

    public var urlProvider: UrlProviding {
        return KeycloackUrlProvider()
    }
    
    public var scopes: String {
        "offline_access"
    }
}

// MARK: - KeycloackUrlProvider

final class KeycloackUrlProvider {
    init() {
    }
}

extension KeycloackUrlProvider: UrlProviding {

    var baseUrl: String {
        return "https://keycloak.risingstars\(EndpointHelper.urlRegionString).daimler.com/auth/realms/Daimler"
    }
}
