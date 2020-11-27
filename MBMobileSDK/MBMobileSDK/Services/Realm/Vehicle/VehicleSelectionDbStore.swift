//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift
import MBRealmKit


// MARK: - VehicleSelectionDbStoreError

enum VehicleSelectionDbStoreError: Error {
    case vehicleNotFound
    case dbError
    case unknown
}


// MARK: - VehicleSelectionDbStore

protocol VehicleSelectionDbStoreRepresentable {
	
	var selectedVehicle: VehicleSelectionModel? { get }
	
	func delete(completion: @escaping (Result<Void, VehicleSelectionDbStoreError>) -> Void)
	func get(initial: @escaping () -> Void, update: @escaping () -> Void, error: RealmConstants.ErrorCompletion?) -> NotificationToken?
	func save(vehicleSelection: VehicleSelectionModel, completion: @escaping (Result<VehicleSelectionModel, VehicleSelectionDbStoreError>) -> Void)
}


class VehicleSelectionDbStore {
	
	let realm: RealmLayer<DBVehicleSelectionModel>
	let store: DbStore<VehicleSelectionModel, DBVehicleSelectionModel, VehicleSelectionDbModelMapper>
	
	convenience init() {
		self.init(config: DatabaseConfig())
	}
	
	init(config: RealmConfigProtocol) {
		
		self.realm = RealmLayer<DBVehicleSelectionModel>(config: config)
		self.store = DbStore(config: config,
							 mapper: VehicleSelectionDbModelMapper())
	}
	
	
	// MARK: - Helper
	
	private func map(_ error: DbError) -> VehicleSelectionDbStoreError {
		
        switch error {
        case .unknown:	return .unknown
        default:		return .dbError
        }
    }
}


// MARK: - VehicleSelectionDbStoreRepresentable

extension VehicleSelectionDbStore: VehicleSelectionDbStoreRepresentable {
	
	var selectedVehicle: VehicleSelectionModel? {
		return self.store.fetch(key: "1")
	}
	
	func delete(completion: @escaping (Result<Void, VehicleSelectionDbStoreError>) -> Void) {
		
		guard let selectedVehicle = self.selectedVehicle else {
			completion(.failure(.vehicleNotFound))
			return
		}
		
		self.store.delete(selectedVehicle) { [weak self] (result) in
			
			switch result {
			case .failure(let dbError):	completion(.failure(self?.map(dbError) ?? .unknown))
			case .success:				completion(.success(()))
			}
		}
	}
	
	func get(initial: @escaping () -> Void, update: @escaping () -> Void, error: RealmConstants.ErrorCompletion?) -> NotificationToken? {
		
		let results = self.realm.all()
		return self.realm.observe(results: results, error: { (observeError) in
			RealmLayer.handle(observeError: observeError, completion: error)
		}, initial: { (_) in
			initial()
		}, update: { (_, _, _, _) in
			update()
		})
	}
	
	func save(vehicleSelection: VehicleSelectionModel, completion: @escaping (Result<VehicleSelectionModel, VehicleSelectionDbStoreError>) -> Void) {
		
		self.store.save(vehicleSelection, update: true) { [weak self] (result) in
			
			switch result {
			case .failure(let dbError):
				completion(.failure(self?.map(dbError) ?? .unknown))
				
			case .success(let vehicleSelection):
				completion(.success(vehicleSelection))
			}
		}
	}
}
