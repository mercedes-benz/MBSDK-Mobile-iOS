//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift
import MBRealmKit

// MARK: - UserManagementDbStoreError

enum UserManagementDbStoreError: Error {
	case vehicleNotFound
	case dbError
	case unknown
}


// MARK: - UserManagementDbStoreRepresentable

protocol UserManagementDbStoreRepresentable {
	
	typealias Completion = (Result<Void, UserManagementDbStoreError>) -> Void
	
	func delete(with finOrVin: String, completion: @escaping Completion)
	func deleteAll(completion: @escaping Completion)
	func deleteSubuser(with authorizationId: String, from finOrVin: String, completion: @escaping Completion)
	func item(with finOrVin: String) -> VehicleUserManagementModel?
	func save(vehicleUserManagement: VehicleUserManagementModel, completion: @escaping (Result<VehicleUserManagementModel, UserManagementDbStoreError>) -> Void)
	func updateProfileSync(status: VehicleProfileSyncStatus, from finOrVin: String, completion: @escaping Completion)
	func upgradeTemporaryUser(with authorizationId: String, from finOrVin: String, completion: @escaping Completion)
}

protocol UserManagementDbStoreObservable {
	
	typealias ChangeItem = (_ properties: [PropertyChange]) -> Void
	typealias DeletedItems = () -> Void
	typealias InitialItem = (VehicleUserManagementModel) -> Void
	
	func item(with finOrVin: String, initial: @escaping InitialItem, change: @escaping ChangeItem, deleted: @escaping DeletedItems, error: RealmConstants.ErrorCompletion?) -> NotificationToken?
}

class UserManagementDbStore {
	
	private let dbOperating: DbOperations<DBVehicleUserManagementModel>
	private let realm: RealmLayer<DBVehicleUserManagementModel>
	private let store: DbStore<VehicleUserManagementModel, DBVehicleUserManagementModel, UserManagementDbModelMapper>
	
	
	// MARK: - Init
	
	convenience init() {
		self.init(config: DatabaseConfig())
	}
	
	init(config: RealmConfigProtocol) {
		
		self.dbOperating = DbOperations(config: config)
		self.realm = RealmLayer<DBVehicleUserManagementModel>(config: config)
		self.store = DbStore(config: config,
							 mapper: UserManagementDbModelMapper())
	}
	
	
	// MARK: - Helper
	
	private func getItem(with finOrVin: String, in realm: Realm) -> DBVehicleUserManagementModel? {
		
		let item = realm.object(ofType: DBVehicleUserManagementModel.self, forPrimaryKey: finOrVin)
		return item?.isInvalidated == false ? item : nil
	}
	
	private func handle(result: Result<Void, DbError>, completion: @escaping Completion) {
		
		switch result {
		case .failure(let dbError):	completion(.failure(self.map(dbError)))
		case .success:				completion(.success(()))
		}
	}
	
	private func map(_ error: DbError) -> UserManagementDbStoreError {
		
		switch error {
		case .unknown:	return .unknown
		default:		return .dbError
		}
	}
}


// MARK: - UserManagementDbStoreRepresentable

extension UserManagementDbStore: UserManagementDbStoreRepresentable {
	
	func delete(with finOrVin: String, completion: @escaping (Result<Void, UserManagementDbStoreError>) -> Void) {
		
		guard let item = self.store.fetch(key: finOrVin) else {
			completion(.failure(.vehicleNotFound))
			return
		}
		
		self.store.delete(item) { [weak self] (result) in
			self?.handle(result: result, completion: completion)
		}
	}
	
	func deleteAll(completion: @escaping (Result<Void, UserManagementDbStoreError>) -> Void) {
		self.store.deleteAll { [weak self] (result) in
			self?.handle(result: result, completion: completion)
		}
	}
	
	func deleteSubuser(with authorizationId: String, from finOrVin: String, completion: @escaping (Result<Void, UserManagementDbStoreError>) -> Void) {
		
		self.dbOperating.realmEdit(.edit, block: { [weak self] (realm, finished) in
			
			if let item = self?.getItem(with: finOrVin, in: realm),
			   let index = item.users.firstIndex(where: { $0.authorizationId == authorizationId }) {
				item.users.remove(at: index)
			}
			
			finished()
		}, completion: { [weak self] (result) in
			self?.handle(result: result, completion: completion)
		})
	}
	
	func item(with finOrVin: String) -> VehicleUserManagementModel? {
		return self.store.fetch(key: finOrVin)
	}
	
	func save(vehicleUserManagement: VehicleUserManagementModel, completion: @escaping (Result<VehicleUserManagementModel, UserManagementDbStoreError>) -> Void) {
		
		self.store.save(vehicleUserManagement) { [weak self] (result) in
			
			switch result {
			case .failure(let dbError): completion(.failure(self?.map(dbError) ?? .unknown))
			case .success(let model):	completion(.success(model))
			}
		}
	}
	
	func updateProfileSync(status: VehicleProfileSyncStatus, from finOrVin: String, completion: @escaping Completion) {
		
		self.dbOperating.realmEdit(.edit, block: { [weak self] (realm, finished) in
			
			if let item = self?.getItem(with: finOrVin, in: realm) {
				item.metaData?.profileSyncStatus = status.rawValue
			}
			
			finished()
		}, completion: { [weak self] (result) in
			self?.handle(result: result, completion: completion)
		})
	}
	
	func upgradeTemporaryUser(with authorizationId: String, from finOrVin: String, completion: @escaping Completion) {
		
		self.dbOperating.realmEdit(.edit, block: { [weak self] (realm, finished) in
			
			if let item = self?.getItem(with: finOrVin, in: realm),
			   let user = item.users.first(where: { $0.authorizationId == authorizationId }) {
				user.validUntil = nil
			}
			
			finished()
		}, completion: { [weak self] (result) in
			self?.handle(result: result, completion: completion)
		})
	}
}


// MARK: - UserManagementDbStoreObservable

extension UserManagementDbStore: UserManagementDbStoreObservable {
	
	func item(with finOrVin: String, initial: @escaping InitialItem, change: @escaping ChangeItem, deleted: @escaping DeletedItems, error: RealmConstants.ErrorCompletion?) -> NotificationToken? {
		
		let item = self.realm.item(with: finOrVin)
		return self.realm.observe(item: item, error: { (observeError) in
			RealmLayer.handle(observeError: observeError, completion: error)
		}, initial: { (item) in
			initial(UserManagementDbModelMapper().map(item))
		}, change: { (properties) in
			change(properties)
		}, deleted: {
			deleted()
		})
	}
}
