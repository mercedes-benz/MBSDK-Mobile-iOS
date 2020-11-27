//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit

/// Configuration object for MBMobileSDK initialization
open class MBMobileSDKConfiguration {

    // MARK: - Properties

    /// The identifier for your AppFamily-app
    ///
    /// Identifier will be provided by the SDK-team
    public internal(set) var applicationIdentifier: String

    /// Available backend regions (ece)
    public internal(set) var endpointRegion: String
    
    /// Available backend stages (mock, prod)
    public internal(set) var endpointStage: String
    
	public internal(set) var authenticationConfigs: [AuthenticationConfig]
    public internal(set) var preferredAuthMethod: AuthenticationType
	
	
	// MARK: - Init

    public convenience init(
		applicationIdentifier: String,
		authenticationConfigs: [AuthenticationConfig],
		endpoint: MBMobileSDKEndpoint,
		preferredAuthMethod: AuthenticationType) {
		
		self.init(applicationIdentifier: applicationIdentifier,
				  authenticationConfigs: authenticationConfigs,
                  endpointRegion: endpoint.region.rawValue,
                  endpointStage: endpoint.stage.rawValue,
                  preferredAuthMethod: preferredAuthMethod)
    }
    
    public init(
		applicationIdentifier: String,
		authenticationConfigs: [AuthenticationConfig],
		endpointRegion: String,
		endpointStage: String,
		preferredAuthMethod: AuthenticationType) {

        self.applicationIdentifier = applicationIdentifier
        self.endpointRegion        = endpointRegion
        self.endpointStage         = endpointStage
		self.authenticationConfigs = authenticationConfigs
        self.preferredAuthMethod   = preferredAuthMethod
    }
}
