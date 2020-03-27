//
// Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Enum for all possible errors when creating a configuration using a the builder.
public enum MBMobileSDKConfigurationError {
    case applicationIdentifierMissing
    case clientIdMissing
    case endpointRegionMissing
    case endpointStageMissing
}

extension MBMobileSDKConfigurationError: LocalizedError {
	
    public var errorDescription: String? {
        switch self {
        case .applicationIdentifierMissing:	return "The applicationIdentifier was not set."
        case .clientIdMissing:				return "The clientId was not set."
        case .endpointRegionMissing:		return "The endpointRegion was not set."
        case .endpointStageMissing:			return "The endpointStage was not set."
        }
    }
}
