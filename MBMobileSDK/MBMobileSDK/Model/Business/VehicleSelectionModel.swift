//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import MBRealmKit

struct VehicleSelectionModel {
	let finOrVin: String
}


// MARK: - Entity

extension VehicleSelectionModel: Entity {
	
	var id: String {
		return "1"
	}
}
