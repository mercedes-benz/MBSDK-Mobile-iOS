//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift
import MBRealmKit

// MARK: - CommandCapabilitiesDbStoreError

enum CommandCapabilitiesDbStoreError: Error {
    case vehicleNotFound
    case dbError
    case unknown
}


// MARK: - CommandCapabilitiesDbStoreRepresentable

protocol CommandCapabilitiesDbStoreRepresentable {
	
	typealias Completion = (Result<Void, CommandCapabilitiesDbStoreError>) -> Void
	
	func delete(with finOrVin: String, completion: @escaping Completion)
	func deleteAll(completion: @escaping Completion)
	
	/// Fetch a command capability from database
	///
	/// - Parameters:
	///   - finOrVin: Vehicle identifier
	/// - Returns: Optional CommandCapabilitiesModel. If there no capability exists the return value is nil.
	func item(with finOrVin: String) -> CommandCapabilitiesModel?
	func save(commandCapabilitiesModel: CommandCapabilitiesModel, completion: @escaping (Result<CommandCapabilitiesModel, CommandCapabilitiesDbStoreError>) -> Void)
}


public class CommandCapabilitiesDbStore {
	
	let store: DbStore<CommandCapabilitiesModel, DBVehicleCommandCapabilitiesModel, CommandCapabilitiesDbModelMapper>
	
	public init() {
		self.store = DbStore(config: DatabaseConfig(),
							 mapper: CommandCapabilitiesDbModelMapper())
	}
	
	
	// MARK: - Helper
	
	private func handle(result: Result<Void, DbError>, completion: @escaping Completion) {
		
		switch result {
		case .failure(let dbError):	completion(.failure(self.map(dbError)))
		case .success:				completion(.success(()))
		}
	}
	
	private func map(_ error: DbError) -> CommandCapabilitiesDbStoreError {
		
        switch error {
        case .unknown:	return .unknown
        default:		return .dbError
        }
    }
}


// MARK: - CommandCapabilitiesDbStoreRepresentable

extension CommandCapabilitiesDbStore: CommandCapabilitiesDbStoreRepresentable {
	
	func delete(with finOrVin: String, completion: @escaping (Result<Void, CommandCapabilitiesDbStoreError>) -> Void) {
		
		guard let item = self.item(with: finOrVin) else {
			completion(.failure(.vehicleNotFound))
			return
		}
		
		self.store.delete(item) { [weak self] (result) in
			self?.handle(result: result, completion: completion)
		}
	}
	
	func deleteAll(completion: @escaping (Result<Void, CommandCapabilitiesDbStoreError>) -> Void) {
		
		self.store.delete(self.store.fetchAll()) { [weak self] (result) in
			self?.handle(result: result, completion: completion)
		}
	}
	
	public func item(with finOrVin: String) -> CommandCapabilitiesModel? {
		return self.store.fetch(key: finOrVin)
	}
	
	func save(commandCapabilitiesModel: CommandCapabilitiesModel, completion: @escaping (Result<CommandCapabilitiesModel, CommandCapabilitiesDbStoreError>) -> Void) {
		
		self.store.save(commandCapabilitiesModel, update: true) { [weak self] (result) in
			
			switch result {
			case .failure(let dbError):						completion(.failure(self?.map(dbError) ?? .unknown))
			case .success(let commandCapabilitiesModel):	completion(.success(commandCapabilitiesModel))
			}
		}
	}
}
