//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift
import MBRealmKit

// MARK: - VehicleDbStoreError

enum VehicleDbStoreError: Error {
    case vehicleNotFound
    case dbError
    case unknown
}


// MARK: - VehicleDbStoreRepresentable

public protocol VehicleDbStoreRepresentable {
	
	func fetch() -> [VehicleModel]
	// swiftlint:disable:next line_length
	func fetch(initial: @escaping (_ provider: ResultsVehicleProvider) -> Void, update: @escaping (_ provider: ResultsVehicleProvider, _ deletions: [Int], _ insertions: [Int], _ modifications: [Int]) -> Void, error: (() -> Void)?) -> NotificationToken?
	func fetchProvider() -> ResultsVehicleProvider?
	func firstAssignedVehicle() -> VehicleModel?
	func item(with finOrVin: String) -> VehicleModel?
}

protocol VehicleDbStoreCarKitRepresentable {

	func save(vehicleModel: VehicleModel, completion: @escaping () -> Void)
	func save(vehicleModels: [VehicleModel], completion: @escaping () -> Void, needsVehicleSelectionUpdate: @escaping (String?) -> Void)
	func update(licensePlate: String, for finOrVin: String, completion: (() -> Void)?)
	func update(pendingState: AssignmentPendingState, for finOrVin: String, completion: (() -> Void)?)
}

protocol VehicleDbStoreObservable {
	
	typealias ChangeItem = (_ properties: [PropertyChange]) -> Void
	typealias DeletedItems = () -> Void
	typealias InitialItem = (VehicleModel) -> Void
	
	func item(with finOrVin: String, initial: @escaping InitialItem, change: @escaping ChangeItem, deleted: @escaping DeletedItems, error: RealmConstants.ErrorCompletion?) -> NotificationToken?
}


public class VehicleDbStore {
	
	private let dbOperating: DbOperations<DBVehicleModel>
	private let realm: RealmLayer<DBVehicleModel>
	private let store: DbStore<VehicleModel, DBVehicleModel, VehicleDbModelMapper>
	
	
	// MARK: - Init
	
	public convenience init() {
		self.init(config: DatabaseConfig())
	}
	
	init(config: RealmConfigProtocol) {
		
		self.dbOperating = DbOperations(config: config)
		self.realm = RealmLayer<DBVehicleModel>(config: config)
		self.store = DbStore(config: config,
							 mapper: VehicleDbModelMapper())
	}
	
	
	// MARK: - Helper
	
	private func map(_ error: DbError) -> VehicleDbStoreError {
		
        switch error {
        case .unknown:	return .unknown
        default:		return .dbError
        }
    }
}


// MARK: - VehicleDbStoreRepresentable

extension VehicleDbStore: VehicleDbStoreRepresentable {
	
	public func fetch() -> [VehicleModel] {
		return self.store.fetchAll()
	}
	
	// swiftlint:disable:next line_length
	public func fetch(initial: @escaping (_ provider: ResultsVehicleProvider) -> Void, update: @escaping (_ provider: ResultsVehicleProvider, _ deletions: [Int], _ insertions: [Int], _ modifications: [Int]) -> Void, error: (() -> Void)?) -> NotificationToken? {
		
		let results = self.realm.all()
		return self.realm.observe(results: results, error: { (observeError) in
			RealmLayer.handle(observeError: observeError, completion: error)
		}, initial: { (results) in
			initial(ResultsVehicleProvider(results: results))
		}, update: { (results, deletions, insertions, modifications) in
			update(ResultsVehicleProvider(results: results),
				   deletions,
				   insertions,
				   modifications)
		})
	}
	
	public func fetchProvider() -> ResultsVehicleProvider? {
		
		guard let results = self.realm.all(),
			results.isEmpty == false else {
				return nil
		}
		
		return ResultsVehicleProvider(results: results)
	}
	
	public func firstAssignedVehicle() -> VehicleModel? {
		
		let predicates = [
			NSPredicate(format: "pending != %@", AssignmentPendingState.assigning.rawValue),
			NSPredicate(format: "pending != %@", AssignmentPendingState.deleting.rawValue)
		]
		let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
		
		return self.store.fetch(predicate: predicate).first
	}
	
	public func item(with finOrVin: String) -> VehicleModel? {
		return self.store.fetch(key: finOrVin)
	}
}


// MARK: - VehicleDbStoreCarKitRepresentable

extension VehicleDbStore: VehicleDbStoreCarKitRepresentable {
	
	func save(vehicleModel: VehicleModel, completion: @escaping () -> Void) {
		
		self.store.save(vehicleModel) { (result) in
			
			switch result {
			case .failure(let dbError):	LOG.E("DB write error by save(vehicleModel:completion:): \(dbError)")
			case .success:				break
			}
			
			completion()
		}
	}
	
	func save(vehicleModels: [VehicleModel], completion: @escaping () -> Void, needsVehicleSelectionUpdate: @escaping (String?) -> Void) {
		
		if self.store.fetchAll().isEmpty {
			
			self.store.save(vehicleModels) { (_) in
				completion()
			}
			return
		}
		
		var preAssignedVin: String?
		var updateVehicles = vehicleModels
		
		self.dbOperating.realmEdit(.edit, block: { (realm, finished) in
			
			let pendingAssignPredicate = NSPredicate(format: "pending = %@", AssignmentPendingState.assigning.rawValue)
            let pendingNegatedAssignPredicate = NSPredicate(format: "pending != %@", AssignmentPendingState.assigning.rawValue)
			let pendingDeletePredicate = NSPredicate(format: "pending = %@", AssignmentPendingState.deleting.rawValue)
			
			// delete block
			let deletePredicates = vehicleModels.map { NSPredicate(format: "finOrVin != %@", $0.finOrVin) } + [pendingNegatedAssignPredicate]
			let deletePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: deletePredicates)
			realm.objects(DBVehicleModel.self)
				.filter(deletePredicate)
				.forEach {
					if $0.isInvalidated == false {
						
						if $0.dealers.isInvalidated == false &&
							$0.dealers.isEmpty == false {
							$0.dealers.delete(method: .cascade, type: DBVehicleDealerItemModel.self)
						}
						realm.delete($0)
					}
			}
			
			let deleteResults = realm.objects(DBVehicleModel.self)
				.filter(pendingDeletePredicate)
			updateVehicles.removeAll { (vehicle) -> Bool in
				return deleteResults.contains { (dbVehicle) -> Bool in
					return dbVehicle.finOrVin == vehicle.finOrVin
				}
			}
			
			// filter first fin
			let preAssignPredicates = updateVehicles.map { NSPredicate(format: "finOrVin = %@", $0.finOrVin) }
			let preAssignPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: preAssignPredicates)
            
            let preAssignResults = realm.objects(DBVehicleModel.self)
                .filter(pendingAssignPredicate)
			preAssignedVin = preAssignResults.filter(preAssignPredicate).first?.finOrVin
			
			// update block
			self.store.save(updateVehicles) { (_) in
				finished()
			}
		}, completion: { (result) in
			
			switch result {
			case .failure(let dbError):	LOG.E("DB write error by save(vehicleModel:completion:): \(dbError)")
			case .success:				break
			}
			
			completion()
			needsVehicleSelectionUpdate(preAssignedVin)
		})
	}
	
	func update(licensePlate: String, for finOrVin: String, completion: (() -> Void)?) {
		
		self.dbOperating.realmEdit(.edit, block: { (realm, finished) in
			
			if let item = realm.object(ofType: DBVehicleModel.self, forPrimaryKey: finOrVin), item.isInvalidated == false {
				item.licensePlate = licensePlate
			}
			
			finished()
		}, completion: { (result) in
			
			switch result {
			case .failure(let dbError):	LOG.E("DB write error by save(vehicleModel:completion:): \(dbError)")
			case .success:				break
			}
			
			completion?()
		})
	}
	
	func update(pendingState: AssignmentPendingState, for finOrVin: String, completion: (() -> Void)?) {
		
		self.dbOperating.realmEdit(.edit, block: { (realm, finished) in
			
			if let item = realm.object(ofType: DBVehicleModel.self, forPrimaryKey: finOrVin), item.isInvalidated == false {
				item.pending = pendingState.rawValue
			}
			
			finished()
		}, completion: { (result) in
			
			switch result {
			case .failure(let dbError):	LOG.E("DB write error by save(vehicleModel:completion:): \(dbError)")
			case .success:				break
			}
			
			completion?()
		})
	}
}


// MARK: - VehicleDbStoreObservable

extension VehicleDbStore: VehicleDbStoreObservable {
	
	func item(with finOrVin: String, initial: @escaping InitialItem, change: @escaping ChangeItem, deleted: @escaping DeletedItems, error: RealmConstants.ErrorCompletion?) -> NotificationToken? {
		
		let item = self.dbOperating.realm?.object(ofType: DBVehicleModel.self, forPrimaryKey: finOrVin)
		return self.realm.observe(item: item, error: { (observeError) in
			RealmLayer.handle(observeError: observeError, completion: error)
		}, initial: { (item) in
			initial(VehicleDbModelMapper().map(item))
		}, change: { (properties) in
			change(properties)
		}, deleted: {
			deleted()
		})
	}
}
