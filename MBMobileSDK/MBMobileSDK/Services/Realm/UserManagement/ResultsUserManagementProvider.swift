//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBRealmKit

class ResultsUserManagementProvider: RealmDataSourceProvider<DBVehicleUserManagementModel, VehicleUserManagementModel> {
	
	override func map(model: DBVehicleUserManagementModel) -> VehicleUserManagementModel? {
		return UserManagementDbModelMapper().map(model)
	}
}
