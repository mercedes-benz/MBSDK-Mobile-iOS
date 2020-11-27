//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of the status update for service activation group
public struct VehicleServicesStatusUpdateModel {
	
	let clientMessageData: Data?
	public let finOrVin: String
	let sequenceNumber: Int32
	public let services: [VehicleServiceStatusUpdateModel]
}
