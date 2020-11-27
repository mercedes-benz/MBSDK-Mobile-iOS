//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import MBRealmKit

class VehicleSelectionDbModelMapper: DbModelMapping {
	
	typealias BusinessModel = VehicleSelectionModel
	typealias DbModel = DBVehicleSelectionModel
	
	func map(_ dbModel: DBVehicleSelectionModel) -> VehicleSelectionModel {
		return VehicleSelectionModel(finOrVin: dbModel.finOrVin)
	}
	
	func map(_ businessModel: VehicleSelectionModel) -> DBVehicleSelectionModel {
		
		let dbVehicleSelectionModel      = DBVehicleSelectionModel()
		dbVehicleSelectionModel.finOrVin = businessModel.finOrVin
		return dbVehicleSelectionModel
	}
}
