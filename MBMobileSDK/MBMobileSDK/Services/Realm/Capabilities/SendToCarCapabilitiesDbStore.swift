//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift
import MBRealmKit

// MARK: - SendToCarCapabilitiesDbStoreError

enum SendToCarCapabilitiesDbStoreError: Error {
    case vehicleNotFound
    case dbError
    case unknown
}


// MARK: - SendToCarCapabilitiesDbStoreRepresentable

protocol SendToCarCapabilitiesDbStoreRepresentable {
	
	typealias Completion = (Result<Void, SendToCarCapabilitiesDbStoreError>) -> Void
	
	func delete(with finOrVin: String, completion: @escaping Completion)
	func deleteAll(completion: @escaping Completion)
	func item(with finOrVin: String) -> SendToCarCapabilitiesModel?
	func save(sendToCarModel: SendToCarCapabilitiesModel, completion: @escaping (Result<SendToCarCapabilitiesModel, SendToCarCapabilitiesDbStoreError>) -> Void)
}


public class SendToCarCapabilitiesDbStore {
	
	let store: DbStore<SendToCarCapabilitiesModel, DBSendToCarCapabilitiesModel, SendToCarCapabilitiesDbModelMapper>
	
	init() {
		self.store = DbStore(config: DatabaseConfig(),
							 mapper: SendToCarCapabilitiesDbModelMapper())
	}
	
	
	// MARK: - Helper
	
	private func handle(result: Result<Void, DbError>, completion: @escaping Completion) {
		
		switch result {
		case .failure(let dbError):	completion(.failure(self.map(dbError)))
		case .success:				completion(.success(()))
		}
	}
	
	private func map(_ error: DbError) -> SendToCarCapabilitiesDbStoreError {
		
        switch error {
        case .unknown:	return .unknown
        default:		return .dbError
        }
    }
}


extension SendToCarCapabilitiesDbStore: SendToCarCapabilitiesDbStoreRepresentable {
	
	func delete(with finOrVin: String, completion: @escaping (Result<Void, SendToCarCapabilitiesDbStoreError>) -> Void) {
		
		guard let item = self.item(with: finOrVin) else {
			completion(.failure(.vehicleNotFound))
			return
		}
		
		self.store.delete(item) { [weak self] (result) in
			self?.handle(result: result, completion: completion)
		}
	}
	
	func deleteAll(completion: @escaping (Result<Void, SendToCarCapabilitiesDbStoreError>) -> Void) {
		
		self.store.delete(self.store.fetchAll()) { [weak self] (result) in
			self?.handle(result: result, completion: completion)
		}
	}
	
	func item(with finOrVin: String) -> SendToCarCapabilitiesModel? {
		return self.store.fetch(key: finOrVin)
	}
	
	func save(sendToCarModel: SendToCarCapabilitiesModel, completion: @escaping (Result<SendToCarCapabilitiesModel, SendToCarCapabilitiesDbStoreError>) -> Void) {
		
		self.store.save(sendToCarModel, update: true) { [weak self] (result) in
			
			switch result {
			case .failure(let dbError):			completion(.failure(self?.map(dbError) ?? .unknown))
			case .success(let sendToCarModel):	completion(.success(sendToCarModel))
			}
		}
	}
}
