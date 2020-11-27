//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBRealmKit

public struct VehicleSupportableModel {
	
	public let canReceiveVACs: Bool
	let finOrVin: String
    public let vehicleConnectivity: VehicleConnectivity
}


// MARK: - Entity

extension VehicleSupportableModel: Entity {
	
	public var id: String {
		return self.finOrVin
	}
}
