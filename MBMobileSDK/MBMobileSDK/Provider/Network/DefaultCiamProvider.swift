//
// Copyright (c) 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit

final class DefaultCiamProvider: ROPCAuthenticationProviding {
    
    private var clientIdentifier: String
    private var sdkVersion: String
    
    var type: AuthenticationType = .ciam
    
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
        return CiamUrlProvider()
    }
    
    public var scopes: String {
        "openid email phone profile offline_access ciam-uid"
    }
}

// MARK: - CiamUrlProvider

final class CiamUrlProvider {
    init() {
    }
}

extension CiamUrlProvider: UrlProviding {

    /// https://id.mercedes-benz.com
    /// https://id-int.mercedes-benz.com
    var baseUrl: String {
        return "https://id\(urlComponentForRegionAndStage()).mercedes-benz.com"
    }
    
    /// Url component for the specific region and Stage.
    private func urlComponentForRegionAndStage() -> String {
        
        guard let stage = MBMobileSDKEndpoint.modifiedStage else {
            return ""
        }
        
        switch stage {
        case .mock: return "-int"
        case .prod: return ""
        }
    }
}
