//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBRealmKit

class ResultsVehicleStatusProvider: RealmDataSourceProvider<DBVehicleStatusModel, VehicleStatusModel> {
	
	override func map(model: DBVehicleStatusModel) -> VehicleStatusModel? {
		return VehicleStatusDbModelMapper().map(model)
	}
}
