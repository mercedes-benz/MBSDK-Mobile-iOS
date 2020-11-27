//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift
import MBRealmKit

// MARK: - TopImageDbStoreError

public enum TopImageDbStoreError: Error {
	case dbError
	case unknown
}


// MARK: - TopImageDbStoreRepresentable

protocol TopImageDbStoreRepresentable {
	
	typealias Completion = (Result<Void, TopImageDbStoreError>) -> Void
	
	/// Delete a single image from database
	///
	/// - Parameters:
	///   - finOrVin: Vehicle identifier
	func delete(with finOrVin: String, completion: @escaping Completion)
	
	/// Delete the complete vahicle image database
	func deleteAll(completion: @escaping Completion)
	
	/// Fetch a top image from database
	///
	/// - Parameters:
	///   - finOrVin: Vehicle identifier
	/// - Returns: Optional TopImageModel. If there no image exists the return value is nil.
	func item(with finOrVin: String) -> TopImageModel?
	func save(topImageModel: TopImageModel, completion: @escaping (Result<TopImageModel, TopImageDbStoreError>) -> Void)
}


public class TopImageDbStore {
	
	private let store: DbStore<TopImageModel, DBTopImageModel, ImageDbModelMapper>
	
	
	// MARK: - Init
	
	public convenience init() {
		self.init(config: ImageCacheConfig())
	}
	
	init(config: RealmConfigProtocol) {
		
		self.store = DbStore(config: config,
							 mapper: ImageDbModelMapper())
	}
	
	
	// MARK: - Helper
	
	private func handle(result: Result<Void, DbError>, completion: @escaping (Result<Void, TopImageDbStoreError>) -> Void) {
		
		switch result {
		case .failure(let dbError):	completion(.failure(self.map(dbError)))
		case .success:				completion(.success(()))
		}
	}
	
	private func map(_ error: DbError) -> TopImageDbStoreError {
		
		switch error {
		case .unknown:	return .unknown
		default:		return .dbError
		}
	}
}


// MARK: - TopImageDbStoreRepresentable

extension TopImageDbStore: TopImageDbStoreRepresentable {
	
	public func delete(with finOrVin: String, completion: @escaping (Result<Void, TopImageDbStoreError>) -> Void) {
		
		guard let item = self.item(with: finOrVin) else {
			return
		}
		
		self.store.delete(item) { [weak self] (result) in
			self?.handle(result: result, completion: completion)
		}
	}
	
	public func deleteAll(completion: @escaping (Result<Void, TopImageDbStoreError>) -> Void) {
		self.store.deleteAll { [weak self] (result) in
			self?.handle(result: result, completion: completion)
		}
	}
	
	public func item(with finOrVin: String) -> TopImageModel? {
		return self.store.fetch(key: finOrVin)
	}
	
	func save(topImageModel: TopImageModel, completion: @escaping (Result<TopImageModel, TopImageDbStoreError>) -> Void) {
		
		self.store.save(topImageModel) { [weak self] (result) in
			
			switch result {
			case .failure(let dbError):	completion(.failure(self?.map(dbError) ?? .unknown))
			case .success(let value):	completion(.success(value))
			}
		}
	}
}
