//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift
import MBRealmKit


// MARK: - VehicleServicesDbStoreError

enum VehicleServicesDbStoreError: Error {
    case vehicleNotFound
    case serviceNotFound
    case dbError
    case unknown
}

public protocol VehicleServicesDbStoreRepresentable {
	
	func fetchProvider(with finOrVin: String, rights: [ServiceRight]) -> ResultsServicesProvider?
	func fetchProvider(with finOrVin: String, categoryName: String?, rights: [ServiceRight]) -> ResultsServicesProvider?
	func fetchServiceGroupProvider(with finOrVin: String, rights: [ServiceRight]) -> ResultsServiceGroupProvider?
	
	func removeMissingData(with finOrVin: String, accountType: AccountType)
	func resetPendingType(with finOrVin: String, onlyTrustLevel: Bool)
}

public extension VehicleServicesDbStoreRepresentable {
	
	func fetchProvider(with finOrVin: String) -> ResultsServicesProvider? {
		return self.fetchProvider(with: finOrVin, rights: ServiceRight.allCases)
	}
	
	func fetchProvider(with finOrVin: String, categoryName: String?) -> ResultsServicesProvider? {
		return self.fetchProvider(with: finOrVin, categoryName: categoryName, rights: ServiceRight.allCases)
	}
	
	func fetchServiceGroupProvider(with finOrVin: String) -> ResultsServiceGroupProvider? {
		return self.fetchServiceGroupProvider(with: finOrVin, rights: ServiceRight.allCases)
	}
}

protocol VehicleServicesDbStoreCarKitRepresentable {
	
	typealias Completion = () -> Void
	typealias InitialProvider = (_ results: Results<DBVehicleServiceModel>) -> Void
	typealias UpdateProvider = (_ results: Results<DBVehicleServiceModel>, _ deletions: [Int], _ insertions: [Int], _ modifications: [Int]) -> Void
	
	func delete(finOrVin: String, completion: @escaping Completion)
	func fetch(initial: @escaping InitialProvider, update: @escaping UpdateProvider, error: RealmConstants.ErrorCompletion?) -> NotificationToken?
	func setPendingType(finOrVin: String, services: Zip2Sequence<[VehicleServiceModel], [ServiceActivationStatus]>, completion: @escaping Completion)
	func setPendingType(services: [VehicleServicesStatusUpdateModel], completion: @escaping Completion)
	func save(finOrVin: String, serviceGroups: [VehicleServiceGroupModel], hasMissingDataIncluded: Bool, completion: @escaping Completion)
}

protocol VehicleServicesDbStoreObservable {
	
	typealias ObservedItem = (VehicleServiceModel) -> Void
	typealias ObservedResults = (ResultsServicesProvider) -> Void
	
	func item(with finOrVin: String, for serviceId: Int, initial: @escaping ObservedItem, change: @escaping ObservedItem) -> NotificationToken?
	func provider(with finOrVin: String, for serviceIds: [Int], initial: @escaping ObservedResults, change: @escaping ObservedResults) -> NotificationToken?
}


// MARK: - VehicleServicesDbStore

public class VehicleServicesDbStore {
	
	let dbOperating: DbOperations<DBVehicleServiceModel>
	let mapper = VehicleServicesDbModelMapper()
	let realm: RealmLayer<DBVehicleServiceModel>
	let store: DbStore<VehicleServiceModel, DBVehicleServiceModel, VehicleServicesDbModelMapper>

	
	// MARK: - Init
	
	public convenience init() {
		self.init(config: DatabaseConfig())
	}
	
	init(config: RealmConfigProtocol) {
		
		self.dbOperating = DbOperations(config: config)
		self.realm = RealmLayer<DBVehicleServiceModel>(config: config)
		self.store = DbStore(config: config,
							 mapper: self.mapper)
	}
	
	
	// MARK: - Helper
	
	private func map(_ error: DbError) -> VehicleServicesDbStoreError {
		
        switch error {
        case .unknown:	return .unknown
        default:		return .dbError
        }
    }
	
	private func map(_ pendingStatus: ServicePendingState) -> String {
		
		switch pendingStatus {
		case .activation:	return pendingStatus.rawValue
		case .deactivation:	return pendingStatus.rawValue
		case .none:			return ""
		}
	}
	
	private func pendingStatus(item: DBVehicleServiceModel, status: ServiceActivationStatus, allowedActions: [ServiceAction]) -> ServicePendingState {

		let currentPendingStatus: ServicePendingState = ServicePendingState(rawValue: item.pending) ?? .none
		switch currentPendingStatus {
		case .activation:
			let canResetPendingState = status == .active || (status == .activationPending && allowedActions.contains(.setDesiredInactive))
			return canResetPendingState ? .none : currentPendingStatus
			
		case .deactivation:
			let canResetPendingState = status == .inactive || (status == .deactivationPending && allowedActions.contains(.setDesiredActive))
			return canResetPendingState ? .none : currentPendingStatus
			
		case .none:
			switch status {
			case .activationPending:			return .activation
			case .active:						return .none
			case .deactivationPending:			return .deactivation
			case .inactive:						return .none
			case .unknown:						return .none
			}
		}
	}
	
	private func pendingStatus(item: DBVehicleServiceModel, status: ServiceActivationStatus, allowedActions: String) -> ServicePendingState {
		
		let actions: [ServiceAction] = allowedActions.components(separatedBy: ",").compactMap { ServiceAction(rawValue: $0) }
		return self.pendingStatus(item: item, status: status, allowedActions: actions)
	}
	
	private func pendingStatus(results: Results<DBVehicleServiceModel>, dbServiceModel: DBVehicleServiceModel) {
		
		guard let item = results.filter("id = %@", dbServiceModel.id).first else {
			return
		}

		let status = ServiceActivationStatus(rawValue: dbServiceModel.activationStatus) ?? .unknown
		let pendingStatus = self.pendingStatus(item: item, status: status, allowedActions: dbServiceModel.allowedActions)
		dbServiceModel.pending = self.map(pendingStatus)
		
		LOG.D("change service status 1: \(dbServiceModel.id) to: \(pendingStatus.rawValue)")
	}
	
	private func pendingStatus(results: Results<DBVehicleServiceModel>, service: (model: VehicleServiceModel, desiredStatus: ServiceActivationStatus)) {
		
		guard let item = results.filter("id = %@", service.model.serviceId).first else {
			return
		}
		
		guard service.model.activationStatus != service.desiredStatus else {
			LOG.D("change service status 2: \(item.id) to: \(ServicePendingState.none.rawValue)")
			item.pending = ""
			return
		}
		
		let newPendingStatus: ServicePendingState = {
			switch service.desiredStatus {
			case .activationPending:			return .activation
			case .active:						return .activation
			case .deactivationPending:			return .deactivation
			case .inactive:						return .deactivation
			case .unknown:						return .none
			}
		}()
		
		item.pending = newPendingStatus.rawValue
		LOG.D("change service status 3: \(item.id) to: \(newPendingStatus.rawValue)")
	}
	
	private func predicateFor(finOrVin: String, categoryName: String?, rights: [ServiceRight]) -> NSPredicate {
		
		let category = categoryName ?? ""
		let predicates: [NSPredicate] = [
			NSPredicate(format: "finOrVin = %@", finOrVin),
			category.isEmpty == false ? NSPredicate(format: "categoryName = %@", category) : nil
		].compactMap { $0 }
		let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
		
		if rights == ServiceRight.allCases {
			return predicate
		}
		
		let rightPredicates = rights.map { NSPredicate(format: "rights CONTAINS %@", $0.rawValue) }
        let rightPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: rightPredicates)
		return NSCompoundPredicate(andPredicateWithSubpredicates: [
			predicate,
			rightPredicate
		])
	}
	
	private func results(finOrVin: String, in realm: Realm) -> Results<DBVehicleServiceModel> {
		return realm.objects(DBVehicleServiceModel.self)
			.filter(self.predicateFor(finOrVin: finOrVin, categoryName: nil, rights: ServiceRight.allCases))
	}
}


// MARK: - VehicleServicesDbStoreRepresentable

extension VehicleServicesDbStore: VehicleServicesDbStoreRepresentable {
	
	public func fetchProvider(with finOrVin: String, rights: [ServiceRight]) -> ResultsServicesProvider? {
		return self.fetchProvider(with: finOrVin, categoryName: nil, rights: rights)
	}
	
	public func fetchProvider(with finOrVin: String, categoryName: String? = nil, rights: [ServiceRight]) -> ResultsServicesProvider? {
		
		guard let results = self.realm.all()?
			.filter(self.predicateFor(finOrVin: finOrVin, categoryName: categoryName, rights: rights)) else {
				return nil
		}
		return ResultsServicesProvider(results: results)
	}
	
	public func fetchServiceGroupProvider(with finOrVin: String, rights: [ServiceRight]) -> ResultsServiceGroupProvider? {
		
		guard let results = self.realm.all()?
			.filter(self.predicateFor(finOrVin: finOrVin, categoryName: nil, rights: rights))
			.sorted(byKeyPath: "sortIndex")
			.distinct(by: ["categoryName"]) else {
				return nil
		}
		return ResultsServiceGroupProvider(results: results)
	}
	
	public func removeMissingData(with finOrVin: String, accountType: AccountType) {
		
		let predicates = [
			NSPredicate(format: "missingData != nil"),
			NSPredicate(format: "missingData.accountLinkageType = %@", accountType.rawValue)
		]
		let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
		
		self.dbOperating.realmEdit(.edit, block: { (realm, finished) in
			
			let results = self.results(finOrVin: finOrVin, in: realm)
				.filter(predicate)
			
			results.forEach { (item) in
				
				if item.isInvalidated == false {
					if let missingDataObject = item.missingData {
						realm.deleteCascade(object: missingDataObject)
					}
				}
			}
			
			finished()
		}, completion: { (result) in
			
			switch result {
			case .failure(let dbError):	LOG.E("DB write error by removeMissingData: \(dbError)")
			case .success:				break
			}
		})
	}
	
	public func resetPendingType(with finOrVin: String, onlyTrustLevel: Bool) {
		
		let pending = self.map(ServicePendingState.activation)
		self.dbOperating.realmEdit(.edit, block: { (realm, finished) in
			
			let results = self.results(finOrVin: finOrVin, in: realm)
				.filter("pending = %@", pending)
			
			results.forEach { (item) in
				
				if item.isInvalidated == false {
					
					let resetPendingStatus: Bool = {
						guard onlyTrustLevel else {
							return true
						}
						let actions = item.allowedActions.components(separatedBy: ",").compactMap { ServiceAction(rawValue: $0) }
						return actions.contains(.updateTrustLevel)
					}()
					
					if resetPendingStatus {
						item.pending = ""
					}
				}
			}
			finished()
		}, completion: { (result) in
			
			switch result {
			case .failure(let dbError):	LOG.E("DB write error by resetPendingType: \(dbError)")
			case .success:				break
			}
		})
	}
}


// MARK: - VehicleServicesDbStoreCarKitRepresentable

extension VehicleServicesDbStore: VehicleServicesDbStoreCarKitRepresentable {
	
	func delete(finOrVin: String, completion: @escaping Completion) {
		
		let services = self.store.fetch(predicate: self.predicateFor(finOrVin: finOrVin, categoryName: nil, rights: ServiceRight.allCases))
		self.store.delete(services) { (result) in
			
			switch result {
			case .failure(let dbError): LOG.E("DB write error by delete(finOrVin:): \(dbError)")
			case .success:				break
			}
			
			completion()
		}
	}
	
	func fetch(initial: @escaping InitialProvider, update: @escaping UpdateProvider, error: RealmConstants.ErrorCompletion?) -> NotificationToken? {
		
		let results = self.realm.all()
		return self.realm.observe(results: results, error: { (observeError) in
			RealmLayer.handle(observeError: observeError, completion: error)
		}, initial: { (results) in
			initial(results)
		}, update: { (results, deletions, insertions, modifications) in
			update(results, deletions, insertions, modifications)
		})
	}
	
	func setPendingType(finOrVin: String, services: Zip2Sequence<[VehicleServiceModel], [ServiceActivationStatus]>, completion: @escaping Completion) {
		
		let predicates = services.map { NSPredicate(format: "id == %i", $0.0.serviceId) }
		let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
		
		self.dbOperating.realmEdit(.edit, block: { (realm, finished) in
			
			let results = self.results(finOrVin: finOrVin, in: realm)
				.filter(predicate)
			
			services.forEach {
				self.pendingStatus(results: results, service: $0)
			}
			
			finished()
		}, completion: { (result) in
			
			switch result {
			case .failure(let dbError): LOG.E("DB write error by setPendingType(finOrVin:): \(dbError)")
			case .success:				break
			}
			
			completion()
		})
	}
	
	func setPendingType(services: [VehicleServicesStatusUpdateModel], completion: @escaping Completion) {
		
		self.dbOperating.realmEdit(.edit, block: { (realm, finished) in
			
			services.forEach { (statusUpdateModel) in
				statusUpdateModel.services.forEach { (serviceUpdateModel) in
					
					let primaryKey = "\(statusUpdateModel.finOrVin)_\(serviceUpdateModel.id)"
					if let service = realm.object(ofType: DBVehicleServiceModel.self, forPrimaryKey: primaryKey), service.isInvalidated == false {
						
						service.activationStatus = serviceUpdateModel.status.rawValue
						let pendingStatus = self.pendingStatus(item: service, status: serviceUpdateModel.status, allowedActions: [])
						service.pending = self.map(pendingStatus)
					}
				}
			}
			
			finished()
		}, completion: { (result) in
			
			switch result {
			case .failure(let dbError): LOG.E("DB write error by setPendingType(services:): \(dbError)")
			case .success:				break
			}
			
			completion()
		})
	}
	
	func save(finOrVin: String, serviceGroups: [VehicleServiceGroupModel], hasMissingDataIncluded: Bool, completion: @escaping Completion) {
		
		self.dbOperating.realmEdit(.edit, block: { (realm, finished) in
			
			let incomingServicesCount = serviceGroups.flatMap { $0.services }.count
			let results = self.results(finOrVin: finOrVin, in: realm)
			
			if results.count <= incomingServicesCount {
				
				/// pre assigned vehicles
				let prePendingResults = results.filter("pending != %@", "")
				
				/// remove and add all services again
				let dbServiceItems = CarKitDatabaseModelMapper.map(finOrVin: finOrVin, serviceGroups: serviceGroups)

				if prePendingResults.isEmpty == false {
					dbServiceItems.forEach {
						self.pendingStatus(results: prePendingResults, dbServiceModel: $0)
					}
				}
				
				if hasMissingDataIncluded == false {

					let missingDataModels: [VehicleServiceModel] = results.filter("missingData != nil").map {
						return self.mapper.map($0)
					}

					missingDataModels.forEach { (vehicleServiceModel) in

						if let dbServiceItem = dbServiceItems.first(where: { $0.id == vehicleServiceModel.serviceId }) {
							dbServiceItem.missingData = CarKitDatabaseModelMapper.map(missingAccountLinkage: vehicleServiceModel.missingData?.missingAccountLinkage)
						}
					}
				}
				
				results.forEach {
					realm.delete($0.prerequisites)
				}
				realm.add(dbServiceItems, update: .modified)
			} else {
				
				/// selected update
				let services = serviceGroups.flatMap { $0.services }
				let predicates = services.map { NSPredicate(format: "id = %i", $0.serviceId) }
				let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
				
				results.filter(predicate).forEach { (dbServiceModel) in

					if dbServiceModel.isInvalidated == false {

						if let service = services.first(where: { $0.serviceId == dbServiceModel.id }) {

							let missingData = CarKitDatabaseModelMapper.map(dbVehicleServiceMissingDataModel: dbServiceModel.missingData)

							if let dbMissingData = dbServiceModel.missingData {
								realm.delete(dbMissingData)
							}
							dbServiceModel.prerequisites.delete(method: .cascade, type: DBVehicleServicePrerequisiteModel.self)

							CarKitDatabaseModelMapper.map(service: service, dbService: dbServiceModel)

							let pendingStatus = self.pendingStatus(item: dbServiceModel,
																   status: service.activationStatus,
																   allowedActions: service.allowedActions)
							dbServiceModel.pending = self.map(pendingStatus)

							if hasMissingDataIncluded == false {
								dbServiceModel.missingData = CarKitDatabaseModelMapper.map(missingAccountLinkage: missingData?.missingAccountLinkage)
							}
						}
					}
				}
			}
			
			finished()
		}, completion: { (result) in
			
			switch result {
			case .failure(let dbError): LOG.E("DB write error by save(finOrVin:serviceGroups:hasMissingDataIncluded:): \(dbError)")
			case .success:				break
			}
			
			completion()
		})
	}
}


// MARK: - VehicleServicesDbStoreObservable

extension VehicleServicesDbStore: VehicleServicesDbStoreObservable {
	
	func item(with finOrVin: String, for serviceId: Int, initial: @escaping ObservedItem, change: @escaping ObservedItem) -> NotificationToken? {
		return self.realm.observe(results: self.realm.all(), error: { (_) in
			
		}, initial: { (results) in
			
			let predicates = [
				NSPredicate(format: "finOrVin = %@", finOrVin),
				NSPredicate(format: "id = %i", serviceId)
			]
			let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
			if let item = results.filter(predicate).first {
				
				let service = self.mapper.map(item)
				initial(service)
			}
		}, update: { (results, _, insertions, modifications) in
			
			var service: VehicleServiceModel?
			var serviceIndex: Int?
			
			let predicates = [
				NSPredicate(format: "finOrVin = %@", finOrVin),
				NSPredicate(format: "id = %i", serviceId)
			]
			let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
			if let item = results.filter(predicate).first {

				service = self.mapper.map(item)
				serviceIndex = results.index(of: item)
			}
			
			guard let mappedService = service,
				let mappedServiceIndex = serviceIndex else {
					return
			}
			
			if insertions.contains(mappedServiceIndex) || modifications.contains(mappedServiceIndex) {
				change(mappedService)
			}
		})
	}
	
	func provider(with finOrVin: String, for serviceIds: [Int], initial: @escaping ObservedResults, change: @escaping ObservedResults) -> NotificationToken? {
		
		let servicePredicates = serviceIds.map { NSPredicate(format: "id = %i", $0) }
		let servicePredicate = NSCompoundPredicate(orPredicateWithSubpredicates: servicePredicates)
		let predicates = [
			NSPredicate(format: "finOrVin = %@", finOrVin),
			servicePredicate
		]
		let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
		
		return self.realm.observe(results: self.realm.all(), error: { (_) in
			
		}, initial: { (results) in
			
			let filteredResults = results.filter(predicate)
			guard filteredResults.isEmpty == false else {
				return
			}
			
			initial(ResultsServicesProvider(results: filteredResults))
		}, update: { (results, _, insertions, modifications) in
			
			var filteredServiceIds: [Int] = []

			let filteredResults = results.filter(predicate)
			filteredResults.forEach {

				if let index = results.index(of: $0),
					insertions.contains(index) || modifications.contains(index) {
						filteredServiceIds.append($0.id)
				}
			}
			
			guard filteredServiceIds.isEmpty == false else {
				return
			}
			
			change(ResultsServicesProvider(results: filteredResults))
		})
	}
}
