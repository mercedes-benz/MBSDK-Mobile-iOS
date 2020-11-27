//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBRealmKit

class CacheService: CacheServiceRepresentable {
	
	typealias Deleted = () -> Void

	private let dbOperating: DbOperations<DBVehicleModel>
	private let dbVehicleStatusStore: VehicleStatusDbStoreRepresentable
	
	// MARK: - Init
	
	convenience init() {
		self.init(config: DatabaseConfig(),
				  dbVehicleStatusStore: VehicleStatusDbStore())
	}
	
	init(
		config: RealmConfigProtocol,
		dbVehicleStatusStore: VehicleStatusDbStoreRepresentable) {
		
		self.dbOperating = DbOperations(config: config)
		self.dbVehicleStatusStore = dbVehicleStatusStore
	}
	
	
	// MARK: - Public
	
	func deleteStatus(for vin: String, completion: Deleted?) {
		
		self.dbVehicleStatusStore.delete(with: vin) { (result) in
			
			switch result {
			case .failure(let error):	LOG.E("DB delete error: \(error)")
			case .success:				break
			}
			
			completion?()
		}
	}
	
	func deleteAll() {
		
		self.dbOperating.realmEdit(.edit, block: { (realm, finished) in
			
			realm.objects(DBVehicleModel.self).forEach {
				realm.deleteCascade(object: $0)
			}
			
			finished()
		}, completion: { (result) in
			
			switch result {
			case .failure(let dbError):	LOG.E("DB write error by deleting all vehicleModels: \(dbError)")
			case .success:				break
			}
		})
	}
	
	func getCurrentStatus() -> VehicleStatusModel {
		return self.getStatus(for: CarKit.selectedFinOrVin)
	}
	
	func getStatus(for finOrVin: String?) -> VehicleStatusModel {
		return self.dbVehicleStatusStore.item(with: finOrVin)
	}
	
	func update(statusUpdateModel: VehicleStatusDTO, completion: @escaping DTOModelMapper.CacheSaved) {
		
		if statusUpdateModel.fullUpdate {
			LOG.D("Clearing vehicle status cache for vin \(statusUpdateModel.vin)")
			
			self.deleteStatus(for: statusUpdateModel.vin) {
				self.handle(statusUpdateModel: statusUpdateModel, completion: completion)
			}
		} else {
			self.handle(statusUpdateModel: statusUpdateModel, completion: completion)
		}
	}
	
	
	// MARK: - Helper
	
	private func handle(statusUpdateModel: VehicleStatusDTO, completion: @escaping DTOModelMapper.CacheSaved) {
		
		let cachedVehicleStatusModel = self.getStatus(for: statusUpdateModel.vin)
		let vehicleStatusTupel: DTOModelMapper.VehicleStatusTupel = DTOModelMapper.map(statusUpdateModel: statusUpdateModel, cachedVehicleStatus: cachedVehicleStatusModel)
		
		LOG.D("The actual cached vehicle status: \(cachedVehicleStatusModel)")
		LOG.D("vehicle status will be cached: \(vehicleStatusTupel.model)")
		
		self.dbVehicleStatusStore.save(vehicleStatusModel: vehicleStatusTupel.model, finOrVin: statusUpdateModel.vin) { (result) in
			
			switch result {
			case .failure(let error):	LOG.E("DB write error during update vehicle status model for \(statusUpdateModel.vin): \(error)")
			case .success:				break
			}
			
			completion(vehicleStatusTupel, statusUpdateModel.vin)
		}
	}
}
