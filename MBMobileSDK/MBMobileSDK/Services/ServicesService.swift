//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit
import MBRealmKit
import MBCommonKit

/// Service to call all vehicle service related requests
public class ServicesService: ServicesServiceRepresentable {
	
	// MARK: Typealias
	
	/// Completion for a single service
    public typealias ServiceCompletion = (VehicleServiceModel) -> Void

	/// Completion for grouped based services
	///
	/// Returns array of VehicleServiceGroupModel
    public typealias ServicesGroupCompletion = (Result<[VehicleServiceGroupModel], MBError>) -> Void
    public typealias ServiceUpdateCompletion = (Result<Void, MBError>) -> Void
	
	// MARK: - Struct
	
	private struct Constants {
		static let service = "service"
		static let services = "services"
	}
	
	// MARK: - Properties
	
	private var tokenName: String {
		return String(describing: Self.self)
	}
	
	// MARK: Dependencies
	private let dbVehicleServiceStoreCarKit: VehicleServicesDbStoreCarKitRepresentable
	private let dbVehicleServiceStoreObservable: VehicleServicesDbStoreObservable
	private let networking: Networking
	private let localeProvider: LocaleProviding
	private let tokenProviding: TokenProviding?

	// MARK: - Init
	
	convenience init(networking: Networking) {
		self.init(networking: networking,
				  dbVehicleServiceStoreCarKit: VehicleServicesDbStore())
	}
	
	convenience init(networking: Networking, dbVehicleServiceStoreCarKit: VehicleServicesDbStoreCarKitRepresentable & VehicleServicesDbStoreObservable) {
		self.init(networking: networking,
                  localeProvider: MBLocaleProvider(),
                  tokenProviding: nil,
                  dbVehicleServiceStoreCarKit: dbVehicleServiceStoreCarKit,
                  dbVehicleServiceStoreObservable: dbVehicleServiceStoreCarKit)
	}
	
	init(
		networking: Networking,
		localeProvider: LocaleProviding,
		tokenProviding: TokenProviding?,
		dbVehicleServiceStoreCarKit: VehicleServicesDbStoreCarKitRepresentable,
		dbVehicleServiceStoreObservable: VehicleServicesDbStoreObservable) {
		
		self.dbVehicleServiceStoreCarKit = dbVehicleServiceStoreCarKit
		self.dbVehicleServiceStoreObservable = dbVehicleServiceStoreObservable
		self.networking = networking
        self.localeProvider = localeProvider
		self.tokenProviding = tokenProviding
	}
	
	
	// MARK: - Public
	
    public func fetchVehicleServices(
        finOrVin: String,
        groupedOption: ServiceGroupedOption,
        requestsMissingData: Bool,
        services: [Int]?,
        completion: @escaping ServicesGroupCompletion) {

		let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
        
            switch result {
            case .success(let token):
                let router = BffServicesRouter.get(accessToken: token.accessToken,
                                                   vin: finOrVin,
                                                   locale: IngressKit.localeIdentifier,
                                                   fillMissingData: requestsMissingData,
                                                   grouped: groupedOption == .none ? nil : groupedOption.rawValue,
                                                   services: services)
                
                self.networking.request(router: router) { [weak self] (result: Result<[APIVehicleServiceGroupModel], MBError>) in
                    
                    switch result {
                    case .failure(let error):
                        LOG.E(error.localizedDescription)
                        
                        completion(.failure(error))
                        
                    case .success(let apiServiceGroupModels):
                        LOG.D(apiServiceGroupModels.map({ group -> [(String, Int, String)] in
                            let mappedModel = group.services.map { model -> (String, Int, String) in
                                (model.name, model.id, model.activationStatus.rawValue)
                            }
                            
                            return mappedModel
                        }))
                        
                        let serviceGroups = NetworkModelMapper.map(apiServiceGroupModels: apiServiceGroupModels, finOrVin: finOrVin)
                        
                        self?.dbVehicleServiceStoreCarKit.save(finOrVin: finOrVin, serviceGroups: serviceGroups, hasMissingDataIncluded: requestsMissingData, completion: {
                            completion(.success(serviceGroups))
                        })
                    }
                }
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
    
    public func requestServiceActivationChanges(finOrVin: String, models: [VehicleServiceModel], completion: @escaping ServiceUpdateCompletion) {

		let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
        
            switch result {
            case .success(let token):
                let apiModels = NetworkModelMapper.map(serviceModels: models)
                let json      = try? apiModels.toJson()
                let router    = BffServicesRouter.update(accessToken: token.accessToken,
                                                         vin: finOrVin,
                                                         locale: self.localeProvider.locale,
                                                         requestModel: apiModels.isEmpty ? nil : json as? [[String: Any]])
                
                self.networking.request(router: router) { [weak self] (result: Result<Data, MBError>) in
                    
                    switch result {
                    case .failure(let error):
                        LOG.E(error.localizedDescription)
                        
                        completion(.failure(error))
                        
                    case .success:
                        let desiredStatus = apiModels.map { $0.desiredServiceStatus }
                        let zipServices = zip(models, desiredStatus)
                        
                        self?.dbVehicleServiceStoreCarKit.setPendingType(finOrVin: finOrVin, services: zipServices, completion: {
                            completion(.success(()))
                        })
                    }
                }
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
	
	public func observeService(by serviceId: Int, finOrVin: String, completion: @escaping (VehicleServiceModel) -> Void) {
		
		let token = self.dbVehicleServiceStoreObservable.item(with: finOrVin, for: serviceId, initial: { (item) in
			completion(item)
		}, change: { (item) in
			completion(item)
		})
		RealmToken.set(token: token, for: self.tokenName + Constants.service)
	}
	
	public func observeServices(by serviceIds: [Int], finOrVin: String, completion: @escaping (ResultsServicesProvider) -> Void) {
		
		let token = self.dbVehicleServiceStoreObservable.provider(with: finOrVin, for: serviceIds, initial: { (provider) in
			completion(provider)
		}, change: { (provider) in
			completion(provider)
		})
		RealmToken.set(token: token, for: self.tokenName + Constants.services)
	}
	
	public func unregisterServiceObserver() {
		RealmToken.invalide(for: self.tokenName + Constants.service, isDeinit: true)
	}
	
	public func unregisterServicesObserver() {
		RealmToken.invalide(for: self.tokenName + Constants.services, isDeinit: true)
	}
	
	
	// MARK: - Life cycle
	
	deinit {
		
		RealmToken.invalide(for: self.tokenName + Constants.service, isDeinit: true)
		RealmToken.invalide(for: self.tokenName + Constants.services, isDeinit: true)
	}
}
