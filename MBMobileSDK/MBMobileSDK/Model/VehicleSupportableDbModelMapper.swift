//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import MBRealmKit

class VehicleSupportableDbModelMapper: DbModelMapping {
	
	typealias BusinessModel = VehicleSupportableModel
	typealias DbModel = DBVehicleSupportableModel
	
	func map(_ dbModel: DBVehicleSupportableModel) -> VehicleSupportableModel {
		
		let vehicleConnectivity = VehicleConnectivity(rawValue: dbModel.vehicleConnectivity) ?? .builtin
		return VehicleSupportableModel(canReceiveVACs: dbModel.canReceiveVACs,
									   finOrVin: dbModel.finOrVin,
                                       vehicleConnectivity: vehicleConnectivity)
	}
	
	func map(_ businessModel: VehicleSupportableModel) -> DBVehicleSupportableModel {
		
		let dbVehicleSupportable                 = DBVehicleSupportableModel()
		dbVehicleSupportable.canReceiveVACs      = businessModel.canReceiveVACs
		dbVehicleSupportable.finOrVin            = businessModel.finOrVin
		dbVehicleSupportable.vehicleConnectivity = businessModel.vehicleConnectivity.rawValue
		return dbVehicleSupportable
	}
}
