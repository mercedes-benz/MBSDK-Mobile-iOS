//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - VehicleCommandStatusUpdateModel

struct VehicleCommandStatusUpdateModel {
	
	let requestIDs: [String]
	let clientMessageData: Data?
	let sequenceNumber: Int32
	let vin: String
}
