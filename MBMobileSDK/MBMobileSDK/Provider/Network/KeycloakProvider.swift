//
// Copyright (c) 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit

final class KeycloakProvider {

    private var clientIdentifier: String


    // MARK: - Init

    public init(clientIdentifier: String) {
        self.clientIdentifier = clientIdentifier
    }
}

extension KeycloakProvider: KeycloakProviding {

    public var clientId: String {
        return self.clientIdentifier
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
