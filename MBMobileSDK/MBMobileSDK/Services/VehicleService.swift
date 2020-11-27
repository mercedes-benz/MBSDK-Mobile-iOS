//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit
import MBNetworkKit

protocol VehicleServiceCarKitRepresentable {
	func fetchVehicles(completion: @escaping VehicleService.VehicleUpdateCompletion, needsVehicleSelectionUpdate: @escaping VehicleService.VehicleSelectionUpdate)
}

/// Service to call all vehicle data related requests
public class VehicleService: VehicleServiceRepresentable, VehicleServiceCarKitRepresentable {
	
	// MARK: Typealias
	
    public typealias AutomaticValetParkingCompletion = (Result<Void, MBError>) -> Void
    
    /// Completion for reservation stauts of automated valet parking
    public typealias AVPReservationStatusCompletion = (Result<[AVPReservationStatusModel], MBError>) -> Void
    
	/// Completion for command capabilities
	public typealias CommandCapabilitiesResult = (Result<CommandCapabilitiesModel, MBError>) -> Void
	
	/// Completion for vehicle consumption
	public typealias ConsumptionResult = (Result<ConsumptionModel, MBError>) -> Void
	
	/// Completion to reset the damage detection
    public typealias DamageDetectionCompletion = (Result<Void, MBError>) -> Void
	
	/// Completion for vehicle data
	///
	/// Returns array of VehicleModel
    public typealias VehiclesCompletion = (Result<[VehicleModel], MBError>) -> Void
	
	/// Empty completion for vehicle data
    public typealias VehicleUpdateCompletion = (Result<Void, MBError>) -> Void
    
    /// Empty completion for removing Subuser
    public typealias RemoveUserAuthorizationCompletion = (Result<Void, MBError>) -> Void
    
    /// Empty completion for setting the profile sync
    public typealias SetProfileSyncCompletion = (Result<Void, MBError>) -> Void
    
    /// Completion for get pin sync statue
    public typealias PinSyncStatusCompletion = (Result<PinSyncStatus, MBError>) -> Void
    
    /// Completion for get profile sync statue
    public typealias ProfileSyncStatusCompletion = (Result<ProfileSyncStatus, MBError>) -> Void
    
    /// Empty completion for upgrading the temporary user
    public typealias UpgradeTemporaryUserCompletion = (Result<Void, MBError>) -> Void
    
	/// Empty completion for vehicle assigned user
	public typealias VehicleAssignedUserSucceeded = (Result<VehicleUserManagementModel, MBError>) -> Void
            
	typealias VehicleSelectionUpdate = (String) -> Void

	/// Completion for subuser qr-code invitation
	///
	/// Returns an image data object
	public typealias VehicleQrCodeInvitationCompletion = (Result<Data, MBError>) -> Void
	
	/// Completion for the function "getNormalizedProfileControl"
	public typealias NormalizedProfileControlCompletion = (Result<NormalizedProfileControlModel, MBError>) -> Void
	
	/// Empty completion for the function "SetNormalizedProfileControl"
	public typealias SetNormalizedProfileControlCompletion = (Result<Void, MBError>) -> Void
	
	// MARK: Dependencies
	private let dbCommandCapabilitiesStore: CommandCapabilitiesDbStoreRepresentable
	private let dbUserManagementStore: UserManagementDbStoreRepresentable
	private let dbVehicleSelectionStore: VehicleSelectionDbStoreRepresentable
	private let dbVehicleStore: VehicleDbStoreRepresentable & VehicleDbStoreCarKitRepresentable
    private let localeProvider: LocaleProviding
	private let networking: Networking
	private let tokenProviding: TokenProviding?
	private let userManagementService: UserManagementServiceRepresentable
	
	
	// MARK: - Init
	
	convenience init(networking: Networking, userManagementService: UserManagementServiceRepresentable) {
		self.init(networking: networking,
				  userManagementService: userManagementService,
				  tokenProviding: nil,
				  localeProvider: MBLocaleProvider(),
				  dbCommandCapabilitiesStore: CommandCapabilitiesDbStore(),
				  dbUserManagementStore: UserManagementDbStore(),
				  dbVehicleSelectionStore: VehicleSelectionDbStore(),
				  dbVehicleStore: VehicleDbStore())
	}
	
	init(
		networking: Networking,
		userManagementService: UserManagementServiceRepresentable,
		tokenProviding: TokenProviding?,
		localeProvider: LocaleProviding,
		dbCommandCapabilitiesStore: CommandCapabilitiesDbStoreRepresentable,
		dbUserManagementStore: UserManagementDbStoreRepresentable,
		dbVehicleSelectionStore: VehicleSelectionDbStoreRepresentable,
		dbVehicleStore: VehicleDbStoreRepresentable & VehicleDbStoreCarKitRepresentable) {
		
		self.dbCommandCapabilitiesStore = dbCommandCapabilitiesStore
		self.dbUserManagementStore = dbUserManagementStore
		self.dbVehicleSelectionStore = dbVehicleSelectionStore
		self.dbVehicleStore = dbVehicleStore
        self.localeProvider = localeProvider
		self.networking = networking
		self.tokenProviding = tokenProviding
		self.userManagementService = userManagementService
	}
	
	
	// MARK: - Public
	
	public func automaticValetParking(finOrVin: String, requestModel: AcceptAVPDriveModel, completion: @escaping AutomaticValetParkingCompletion) {
		
		let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let json        = try? requestModel.toJson()
                let requestDict = json as? [String: Any]
                let router      = BffVehicleRouter.automaticValetParking(accessToken: token.accessToken,
                                                                         vin: finOrVin,
                                                                         requestModel: requestDict)
                self.request(router: router, completion: completion)
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
	}
	
    public func avpReservationStatus(finOrVin: String, reservationIds: [String], completion: @escaping AVPReservationStatusCompletion) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { [weak self] (result) in
            
            switch result {
            case .success(let token):
                let router = BffVehicleRouter.automaticValetParkingReservationStatus(accessToken: token.accessToken, vin: finOrVin, reservationIds: reservationIds)

                self?.networking.request(router: router) { (result: Result<[APIAVPReservationStatusModel], MBError>) in
                    
                    switch result {
                    case .failure(let error):
                        LOG.E(error.localizedDescription)
                        
                        completion(.failure(error))
                        
                    case .success(let reservationStatus):
                        LOG.D(reservationStatus)
                        let models = NetworkModelMapper.map(apiAVPReservationStatus: reservationStatus)
                        completion(.success(models ?? []))
                    }
                }
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
    
	public func fetchVehicleAssignedUsers(finOrVin: String, completion: @escaping VehicleAssignedUserSucceeded) {

		self.userManagementService.fetchVehicleAssignedUsers(finOrVin: finOrVin) { [weak self] (result) in

			switch result {
			case .failure(let error):
				LOG.E(error.localizedDescription)

				if let mgmt = self?.dbUserManagementStore.item(with: finOrVin) {
					completion(.success(mgmt))
					return
				}

				completion(.failure(error))

			case .success(let apiVehicleUserManagement):
				LOG.D(apiVehicleUserManagement)

				let model = NetworkModelMapper.map(apiVehicleUserManagement: apiVehicleUserManagement, finOrVin: finOrVin)
				self?.dbUserManagementStore.save(vehicleUserManagement: model) { (result) in
					
					switch result {
					case .failure(let error):	LOG.E("Database error during update the user management: \(error)")
					case .success:				break
					}
					
					completion(.success(model))
				}
			}
		}
	}

	public func qrCodeInviteForVehicle(finOrVin: String, profileId: VehicleProfileID, completion: @escaping VehicleQrCodeInvitationCompletion) {
		self.userManagementService.fetchInvitationQrCode(finOrVin: finOrVin, profileId: profileId, completion: completion)
	}

	public func fetchCommandCapabilities(finOrVin: String, completion: @escaping CommandCapabilitiesResult) {
		
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let router = BffCapabilitiesRouter.commands(accessToken: token.accessToken,
                                                            vin: finOrVin)
                
                self.networking.request(router: router, keyPath: "commands") { [weak self] (result: Result<[APICommandCapabilityModel], MBError>) in
                    
                    switch result {
                    case .failure(let error):
                        LOG.E(error.localizedDescription)
                        
                        completion(.failure(error))
                        
                    case .success(let apiCommandCapabilities):
                        LOG.D(apiCommandCapabilities)
                        
                        let commandCapabilitiesModel = NetworkModelMapper.map(apiCommandCapabilityModels: apiCommandCapabilities,
                                                                              finOrVin: finOrVin)
                        self?.dbCommandCapabilitiesStore.save(commandCapabilitiesModel: commandCapabilitiesModel) { _ in
                            
                            // TODO: handle error case
                            completion(.success(commandCapabilitiesModel))
                        }
                    }
                }
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
	}
	
	public func fetchConsumption(finOrVin: String, completion: @escaping ConsumptionResult) {
		
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let router = BffVehicleRouter.consumption(accessToken: token.accessToken,
                                                          vin: finOrVin)
                
                self.networking.request(router: router) { (result: Result<APIVehicleConsumptionModel, MBError>) in
                    
                    switch result {
                    case .failure(let error):
                        LOG.E(error.localizedDescription)
                        
                        completion(.failure(error))
                        
                    case .success(let apiVehicleConsumption):
                        LOG.D(apiVehicleConsumption)
                        
                        let model = NetworkModelMapper.map(apiVehicleConsumptionModel: apiVehicleConsumption)
                        completion(.success(model))
                    }
                }

                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
	}
	
	public func fetchVehicles(completion: VehiclesCompletion? = nil) {
		self.fetchVehicles(returnError: true,
						   completion: completion,
						   needsVehicleSelectionUpdate: nil)
	}
	
	public func instantSelectVehicle(completion: @escaping (String?) -> Void) {
		        
		self.fetchVehicles { [weak self] (result) in
			
            switch result {
            case .success(let vehicles):
                
                guard let finOrVin = self?.handleInstantVehicleSelection(vehicles: vehicles) else {
                    completion(nil)
                    return
                }
                
				let vehicleSelection = VehicleSelectionModel(finOrVin: finOrVin)
				self?.dbVehicleSelectionStore.save(vehicleSelection: vehicleSelection) { _ in
					
					completion(finOrVin)
					CarKit.sharedVehicleSelection = nil
				}
                
            case .failure:
                completion(nil)
            }
		}
	}
	
    public func removeUserAuthorization(finOrVin: String, authorizationID: String, completion: @escaping RemoveUserAuthorizationCompletion) {
        
        self.userManagementService.removeUserAuthorization(finOrVin: finOrVin, authorizationID: authorizationID) { [weak self] (result) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
                
            case .success:
				self?.dbUserManagementStore.deleteSubuser(with: authorizationID, from: finOrVin, completion: { (result) in
					
					switch result {
					case .failure(let error):	LOG.E("Error during remove a user authorization: \(error)")
					case .success:				break
					}
                    completion(.success(()))
                })
            }
        }
    }
    
	public func resetDamageDetection(finOrVin: String, completion: @escaping DamageDetectionCompletion) {
        
        guard let pinProvider = CarKit.pinProvider else {
            completion(.failure(MBError(description: "Unable to request pin", type: .unknown)))
            return
        }
		
        pinProvider.requestPin(forReason: nil, preventFromUsageAlert: false, onSuccess: { [weak self] pin in
            
            let tokenProvider = self?.tokenProviding ?? CarKit.tokenProvider
            tokenProvider.refreshTokenIfNeeded { (result) in
                
                switch result {
                case .success(let token):
                    let router = BffVehicleRouter.resetDamageDetection(accessToken: token.accessToken,
                                                                       vin: finOrVin,
                                                                       pin: pin)
                    self?.request(router: router, completion: completion)
                    
                case .failure(let error):
                    completion(.failure(MBError(description: nil, type: .specificError(error))))
                }
            }
		}, onCancel: {
            completion(.failure(MBError(description: "User canceled pin request", type: .unknown)))
        })
	}
    
    public func setProfileSync(enabled: Bool, finOrVin: String, completion: @escaping SetProfileSyncCompletion) {
        
        self.userManagementService.setProfileSync(enabled: enabled, finOrVin: finOrVin) { [weak self] (result) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
                
            case .success:
                let status: VehicleProfileSyncStatus = enabled ? .on : .off
				self?.dbUserManagementStore.updateProfileSync(status: status, from: finOrVin, completion: { (result) in
					
					switch result {
					case .failure(let error):	LOG.E("Erorr during update profile sync status: \(error)")
					case .success:				break
					}
                    completion(.success(()))
                })
            }
        }
    }
    
    public func getPinSyncState(finOrVin: String, completion: @escaping PinSyncStatusCompletion) {
        
		let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let router = BffUserManagementRouter.syncState(accessToken: token.accessToken, vin: finOrVin)
                
                self.networking.request(router: router) { (result: Result<APIPinSyncState, MBError>) in
                    
                    switch result {
                    case .failure(let error):
                        LOG.E(error.localizedDescription)
                        
                        completion(.failure(error))
                        
                    case .success(let state):
                        completion(.success(state.status))
                    }
                }
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
    
    public func getProfileSyncState(finOrVin: String, completion: @escaping ProfileSyncStatusCompletion) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let router = BffUserManagementRouter.profileSyncState(accessToken: token.accessToken, vin: finOrVin)
                
                self.networking.request(router: router) { (result: Result<APIProfileSyncState, MBError>) in
                    
                    switch result {
                    case .failure(let error):
                        LOG.E(error.localizedDescription)
                        
                        completion(.failure(error))
                        
                    case .success(let state):
                        completion(.success(state.profileSyncStatus))
                    }
                }
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
    
    public func getSoftwareUpdate(finOrVin: String, locale: String, completion: @escaping (Result<SoftwareUpdateModel, VehicleServiceError>) -> Void) {
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded(completion: { (result) in
            switch result {
            case .failure(let error):
                LOG.E(error.localizedDescription)
                completion(.failure(.tokenRefreshError))
            case .success(let token):
                let router = BffVehicleRouter.softwareUpdate(accessToken: token.accessToken,
                                                             vin: finOrVin,
                                                             locale: locale)
                
                self.networking.request(router: router) { (result: Result<APISoftwareUpdateModel, MBError>) in
                    switch result {
                    case .failure(let error):
                        completion(.failure(.network(error)))
                    case .success(let apiModel):
                        let model = NetworkModelMapper.map(apiSoftwareUpdateModel: apiModel)
                        completion(.success(model))
                    }
                    
                }
            }
        })
    }
	
	public func updateLicense(finOrVin: String, licensePlate: String, completion: @escaping VehicleUpdateCompletion) {

		let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let router = BffVehicleRouter.licensePlate(accessToken: token.accessToken,
                                                           vin: finOrVin,
                                                           locale: self.localeProvider.locale,
                                                           license: licensePlate)

                self.networking.request(router: router) { (result: Result<Data, MBError>) in
                    
                    switch result {
                    case .failure(let error):
                        completion(.failure(error))
                        
                    case .success(let value):
                        LOG.D(value)
                        
                        self.dbVehicleStore.update(licensePlate: licensePlate, for: finOrVin, completion: nil)
                        completion(.success(()))
                    }
                }
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
	}
	
	public func updatePreferredDealer(finOrVin: String, preferredDealers: [VehicleDealerUpdateModel], completion: @escaping VehicleUpdateCompletion) {
		
		let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                
                let apiModels = NetworkModelMapper.map(dealerUpdateModels: preferredDealers)
                let json      = try? apiModels.toJson()
                let router    = BffVehicleRouter.dealersPreferred(accessToken: token.accessToken,
                                                                  vin: finOrVin,
                                                                  requestModel: json as? [[String: Any]])
                self.request(router: router, completion: completion)
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
	}
    
    public func upgradeTemporaryUser(authorizationID: String, finOrVin: String, completion: @escaping UpgradeTemporaryUserCompletion) {
        
        self.userManagementService.upgradeTemporaryUser(authorizationID: authorizationID, finOrVin: finOrVin) { [weak self] (result) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
                
            case .success:
				self?.dbUserManagementStore.deleteSubuser(with: authorizationID, from: finOrVin, completion: { (result) in
					
					switch result {
					case .failure(let error):	LOG.E("Error during deleting a sub user: \(error)")
					case .success:				break
					}
                    completion(.success(()))
                })
            }
        }
    }
	
	public func getNormalizedProfileControl(completion: @escaping NormalizedProfileControlCompletion) {
		self.userManagementService.fetchNormalizedProfileControl(completion: completion)
	}
	
	public func setNormalizedProfileControl(enabled: Bool, completion: @escaping SetNormalizedProfileControlCompletion) {
		self.userManagementService.setNormalizedProfileControl(enabled: enabled, completion: completion)
	}
	
	
	// MARK: - Internal
	
	func fetchVehicles(completion: @escaping VehicleUpdateCompletion, needsVehicleSelectionUpdate: @escaping VehicleSelectionUpdate) {

		self.fetchVehicles(returnError: false, completion: { (_) in
            completion(.success(()))
		}, needsVehicleSelectionUpdate: needsVehicleSelectionUpdate)
	}
	
	
	// MARK: - Helper
	
	private func fetchVehicles(returnError: Bool, completion: VehiclesCompletion?, needsVehicleSelectionUpdate: VehicleSelectionUpdate?) {
		
		let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let router = BffVehicleRouter.masterdata(accessToken: token.accessToken,
                                                         countryCode: self.localeProvider.regionCode,
                                                         locale: self.localeProvider.locale)
                
                self.networking.request(router: router) { [weak self] (result: Result<[APIVehicleDataModel], MBError>) in
                    
                    switch result {
                    case .failure(let error):
                        LOG.E(error.localizedDescription)
                        
                        if let vehicles = self?.dbVehicleStore.fetch(), returnError {
                            completion?(.success(vehicles))
                        }
                        
                    case .success(let apiVehicleDataModels):
                        LOG.D(apiVehicleDataModels)
                        
                        self?.handle(apiVehicleDataModels: apiVehicleDataModels, completion: completion, needsVehicleSelectionUpdate: { (selectedVin) in
                            needsVehicleSelectionUpdate?(selectedVin)
                        })
                    }
                }
                
            case .failure(let error):
                completion?(.failure(MBError(description: error.localizedDescription, type: .specificError(error))))
            }
        }
	}

	private func handle(apiVehicleDataModels: [APIVehicleDataModel], completion: VehiclesCompletion?, needsVehicleSelectionUpdate: @escaping VehicleSelectionUpdate) {
		
		let vehicles = NetworkModelMapper.map(apiVehicleDataModels: apiVehicleDataModels)
		self.dbVehicleStore.save(vehicleModels: vehicles, completion: { [weak self] in
			
            completion?(.success(vehicles))
			
			if vehicles.isEmpty {
				self?.dbVehicleSelectionStore.delete { _ in }
			}
		}, needsVehicleSelectionUpdate: { (preAssignedVin) in
			
			let newSelectedVin: String? = {
                
                // If there is a pre assign vehicle, set it to selected
                if let preAssignedVin = preAssignedVin {
                    return preAssignedVin
                } else {
                    
                    // If the selected vin isn't empty return it, if its empty use the vin from the first vehicle
                    if CarKit.selectedFinOrVin?.isEmpty == false {
						return CarKit.selectedFinOrVin
					}
					return vehicles.first?.finOrVin
                }
			}()
			
			if let selectedVin = newSelectedVin, vehicles.isEmpty == false {
				
				LOG.D("change vin selection: \(selectedVin)")
				needsVehicleSelectionUpdate(selectedVin)
			} else {
				LOG.D("reset vin selection")
			}
		})
	}
	
	private func handleInstantVehicleSelection(vehicles: [VehicleModel]) -> String? {
		
		let firstIndex = vehicles.firstIndex(where: { (vehicle) -> Bool in
			return (vehicle.trustLevel > 1 && vehicle.pending == nil) ||
                (vehicle.trustLevel == 1 && vehicle.vehicleConnectivity?.isLegacy == true)
		})
		
		guard let index = firstIndex else {
			return nil
		}
		
		let selectedVin: String = CarKit.sharedVehicleSelection ?? CarKit.selectedFinOrVin ?? ""
		let filterFinOrVin = vehicles.first(where: { $0.finOrVin == selectedVin })?.finOrVin
		return filterFinOrVin ?? vehicles.item(at: index)?.finOrVin
	}
	
	private func request(router: BffVehicleRouter, completion: @escaping (Result<Void, MBError>) -> Void) {
		
		self.networking.request(router: router) { (result: Result<Data, MBError>) in
			
			switch result {
			case .failure(let error):
				LOG.E(error.localizedDescription)
				
				completion(.failure(error))
				
			case .success:
				LOG.D()
				completion(.success(()))
			}
		}
	}
}
