  //
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBRealmKit

public struct SendToCarCapabilitiesModel: Equatable {
    
    /// List of available send to car modes.
    public let capabilities: [SendToCarCapability]
	public let finOrVin: String
    /// These preconditions are returned if something needs to be done before a user can use send to car.
	public let preconditions: [SendToCarPrecondition]
}

// MARK: - Entity

extension SendToCarCapabilitiesModel: Entity {
	
	public var id: String {
		return self.finOrVin
	}
}
