//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift
import MBRealmKit

// MARK: - VehicleSupportableDbStoreError

enum VehicleSupportableDbStoreError: Error {
    case vehicleNotFound
    case dbError
    case unknown
}


// MARK: - Protocols

public protocol VehicleSupportableDbStoreRepresentable {
	
	func item(with finOrVin: String) -> VehicleSupportableModel?
}

protocol VehicleSupportableDbStoreCarKitRepresentable {

	func delete(with finOrVin: String, completion: @escaping (Result<Void, VehicleSupportableDbStoreError>) -> Void)
	func save(vehicleSupportable: VehicleSupportableModel, completion: @escaping (Result<VehicleSupportableModel, VehicleSupportableDbStoreError>) -> Void)
}


// MARK: - VehicleSupportableDbStore

public class VehicleSupportableDbStore {
	
	let store: DbStore<VehicleSupportableModel, DBVehicleSupportableModel, VehicleSupportableDbModelMapper>
	
	public init() {
		self.store = DbStore(config: DatabaseConfig(),
							 mapper: VehicleSupportableDbModelMapper())
	}
	
	
	// MARK: - Helper
	
	private func map(_ error: DbError) -> VehicleSupportableDbStoreError {
		
        switch error {
        case .unknown:	return .unknown
        default:		return .dbError
        }
    }
}


// MARK: - VehicleSupportableDbStoreRepresentable

extension VehicleSupportableDbStore: VehicleSupportableDbStoreRepresentable {
	
	public func item(with finOrVin: String) -> VehicleSupportableModel? {
		return self.store.fetch(key: finOrVin)
	}
}


// MARK: - VehicleSupportableDbStoreCarKitRepresentable

extension VehicleSupportableDbStore: VehicleSupportableDbStoreCarKitRepresentable {
	
	func delete(with finOrVin: String, completion: @escaping (Result<Void, VehicleSupportableDbStoreError>) -> Void) {
		
		guard let item = self.item(with: finOrVin) else {
			completion(.failure(.vehicleNotFound))
			return
		}
		
		self.store.delete(item) { [weak self] (result) in
			
			switch result {
			case .failure(let dbError):	completion(.failure(self?.map(dbError) ?? .unknown))
			case .success:				completion(.success(()))
			}
		}
	}
	
	func save(vehicleSupportable: VehicleSupportableModel, completion: @escaping (Result<VehicleSupportableModel, VehicleSupportableDbStoreError>) -> Void) {
		
		self.store.save(vehicleSupportable, update: true) { [weak self] (result) in
			
			switch result {
			case .failure(let dbError):				completion(.failure(self?.map(dbError) ?? .unknown))
			case .success(let vehicleSupportable):	completion(.success(vehicleSupportable))
			}
		}
	}
}
