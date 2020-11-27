//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift
import MBRealmKit

// MARK: - VehicleStatusDbStoreError

enum VehicleStatusDbStoreError: Error {
	case vehicleNotFound
	case dbError
	case unknown
}


// MARK: - VehicleStatusDbStoreRepresentable

protocol VehicleStatusDbStoreRepresentable {
	
	typealias Completion = (Result<Void, VehicleStatusDbStoreError>) -> Void
	
	func delete(with finOrVin: String, completion: @escaping Completion)
	func deleteAll(completion:  @escaping Completion)
	func item(with finOrVin: String?) -> VehicleStatusModel
	func save(vehicleStatusModel: VehicleStatusModel, finOrVin: String, completion: @escaping (Result<VehicleStatusModel, VehicleStatusDbStoreError>) -> Void)
}

protocol VehicleStatusDbStoreObservable {
	
	typealias ChangeItem = (_ properties: [PropertyChange]) -> Void
	typealias DeletedItems = () -> Void
	typealias InitialItem = (VehicleStatusModel) -> Void
	
	func item(with finOrVin: String, initial: @escaping InitialItem, change: @escaping ChangeItem, deleted: @escaping DeletedItems, error: @escaping () -> Void) -> NotificationToken?
}


public class VehicleStatusDbStore {
	
	private let dbOperating: DbOperations<DBVehicleStatusModel>
	private let realm: RealmLayer<DBVehicleStatusModel>
	private let store: ExtendedDbStore<VehicleStatusModel, DBVehicleStatusModel, VehicleStatusDbModelMapper>
	
	
	// MARK: - Init
	
	convenience init() {
		self.init(config: DatabaseConfig())
	}
	
	init(config: RealmConfigProtocol) {
		
		self.dbOperating = DbOperations(config: config)
		self.realm = RealmLayer<DBVehicleStatusModel>(config: config)
		self.store = ExtendedDbStore(config: config,
									 mapper: VehicleStatusDbModelMapper())
	}
	
	
	// MARK: - Helper
	
	private func handle(result: Result<Void, DbError>, completion: @escaping Completion) {
		
		switch result {
		case .failure(let dbError):	completion(.failure(self.map(dbError)))
		case .success:				completion(.success(()))
		}
	}
	
	private func map(_ error: DbError) -> VehicleStatusDbStoreError {
		
		switch error {
		case .unknown:	return .unknown
		default:		return .dbError
		}
	}
}


// MARK: - VehicleStatusDbStoreRepresentable

extension VehicleStatusDbStore: VehicleStatusDbStoreRepresentable {
	
	func delete(with finOrVin: String, completion: @escaping (Result<Void, VehicleStatusDbStoreError>) -> Void) {
		
		guard let item = self.store.fetch(key: finOrVin) else {
			completion(.failure(.vehicleNotFound))
			return
		}
		
		self.store.delete(item) { [weak self] (result) in
			self?.handle(result: result, completion: completion)
		}
	}
	
	func deleteAll(completion:  @escaping (Result<Void, VehicleStatusDbStoreError>) -> Void) {
		
		let objects = self.store.fetchAll()
		self.store.delete(objects) { [weak self] (result) in
			self?.handle(result: result, completion: completion)
		}
	}
	
	func item(with finOrVin: String?) -> VehicleStatusModel {
		
		let fallbackFinOrVin = finOrVin ?? "-"
		guard let finOrVin = finOrVin,
			  let item = self.store.fetch(key: finOrVin) else {
			
			LOG.E("Can't find a vehicle with \(fallbackFinOrVin). Therefore returned a vehicle with nullable attributes")
			return VehicleStatusDbModelMapper().map(DBVehicleStatusModel())
		}

		return item
	}
	
	func save(vehicleStatusModel: VehicleStatusModel, finOrVin: String, completion: @escaping (Result<VehicleStatusModel, VehicleStatusDbStoreError>) -> Void) {
		
		self.store.save(vehicleStatusModel) { [weak self] (result) in
			
			switch result {
			case .failure(let dbError): completion(.failure(self?.map(dbError) ?? .unknown))
			case .success(let model):	completion(.success(model))
			}
		}
	}
}


// MARK: - VehicleStatusDbStoreObservable

extension VehicleStatusDbStore: VehicleStatusDbStoreObservable {
	
	func item(with finOrVin: String, initial: @escaping InitialItem, change: @escaping ChangeItem, deleted: @escaping DeletedItems, error: @escaping () -> Void) -> NotificationToken? {
		
		let item = self.realm.item(with: finOrVin)
		return self.realm.observe(item: item, error: { (observeError) in
			RealmLayer.handle(observeError: observeError, completion: error)
		}, initial: { (item) in
			initial(VehicleStatusDbModelMapper().map(item))
		}, change: { (properties) in
			change(properties)
		}, deleted: {
			deleted()
		})
	}
}
