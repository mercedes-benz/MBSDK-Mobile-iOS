//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBRealmKit

/// Representation of the command capabilities
public struct CommandCapabilitiesModel {
	
	public let capabilities: [CommandCapabilityModel]
	public let finOrVin: String
}


// MARK: - Entity

extension CommandCapabilitiesModel: Entity {
	
	public var id: String {
		return self.finOrVin
	}
}
