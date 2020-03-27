//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Configuration object for MBMobileSDK initialization
open class MBMobileSDKConfiguration {

    // MARK: - Properties

    /// The identifier for your AppFamily-app
    ///
    /// Identifier will be provided by the SDK-team
    public internal(set) var applicationIdentifier: String

    /// App group identifier
    public internal(set) var clientId: String

    /// Available backend regions (ece)
    public internal(set) var endpointRegion: String
    
    /// Available backend stages (mock, prod)
    public internal(set) var endpointStage: String
    
    
	// MARK: - Init

	public convenience init(applicationIdentifier: String, clientId: String, endpoint: MBMobileSDKEndpoint) {
        self.init(applicationIdentifier: applicationIdentifier,
                  clientId: clientId,
                  endpointRegion: endpoint.region.rawValue,
                  endpointStage: endpoint.stage.rawValue)
    }
    
	public init(applicationIdentifier: String, clientId: String, endpointRegion: String, endpointStage: String) {

        self.applicationIdentifier = applicationIdentifier
        self.clientId              = clientId
        self.endpointRegion        = endpointRegion
        self.endpointStage         = endpointStage
    }
}
