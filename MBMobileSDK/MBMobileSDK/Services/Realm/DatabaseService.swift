//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift
import MBRealmKit

/// Service for common database handling
public class DatabaseService {
	
	// MARK: Typealias
	
	/// Completion for database transactions
	public typealias Completion = () -> Void
    
    public typealias DidUpdateCompletion = (Result<Void, VehicleServiceError>) -> Void
	
	// MARK: Properties
	private static let config = DatabaseConfig()
	private static let realm = RealmLayer<DBVehicleModel>(config: DatabaseService.config)
	
	
	// MARK: - Debug
	public static var encryptionKey: Data {
		return self.realm.config.realm?.configuration.encryptionKey ?? Data(count: 0)
	}
	
	
	// MARK: - Public
	
	/// Delete the complete vehicle attribute database
	///
	/// - Parameters:
	///   - method: Write method async or sync
	public static func deleteAll(method: RealmConstants.RealmWriteMethod) {
		
		switch method {
		case .async:
			guard let results = self.realm.all() else {
				return
			}
			
			self.realm.delete(results: results, method: .cascade, completion: nil)
			
		case .sync:
			self.realm.deleteAll()
		}
	}
	
	/// Fetch a list of selected vehicle to observe any changes of the list
	///
	/// - Parameters:
	///   - initial: Closure with Completion
	///   - update: Closure with Completion
	///   - error: Closure with ErrorCompletion
	/// - Returns: Optional NotificationToken to observe any changes
	public static func fetchSelectVehicle(initial: @escaping Completion, update: @escaping Completion, error: RealmConstants.ErrorCompletion?) -> NotificationToken? {
		return VehicleSelectionDbStore().get(initial: initial,
											 update: update,
											 error: error)
	}
	
	/// Update the selected vehicle in database
	///
	/// - Parameters:
	///   - finOrVin: Vehicle identifier
	///   - completion: Closure with Completion
	public static func update(finOrVin: String, completion:  @escaping DidUpdateCompletion) {
		
		guard VehicleDbStore().item(with: finOrVin) != nil else {
            completion(.failure(.vehicleForVinNotFound))
			return
		}
		
		let vehicleSelection = VehicleSelectionModel(finOrVin: finOrVin)
		VehicleSelectionDbStore().save(vehicleSelection: vehicleSelection) { (result) in
			
			switch result {
			case .failure(let error):
                LOG.E("Error during save vehicle selection: \(error)")
                completion(.failure(.dbOperationError))
			case .success:
                completion(.success(()))
			}
		}
	}
    
}
