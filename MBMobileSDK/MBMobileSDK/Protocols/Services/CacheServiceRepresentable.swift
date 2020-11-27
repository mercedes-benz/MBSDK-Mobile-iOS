//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

protocol CacheServiceRepresentable {

	func deleteAll()
	func deleteStatus(for vin: String, completion: CacheService.Deleted?)
	func getCurrentStatus() -> VehicleStatusModel
	func getStatus(for vin: String?) -> VehicleStatusModel
	func update(statusUpdateModel: VehicleStatusDTO, completion: @escaping DTOModelMapper.CacheSaved)
}
