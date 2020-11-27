//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit
import MBNetworkKit

/// Service to call all vehicle assignment related requests
public class AssignmentService: AssignmentServiceRepresentable {
	
	// MARK: Typealias
	
	/// Completion for rif support
	///
	/// Returns a VehicleSupportableModel
    public typealias RifResult = (Result<VehicleSupportableModel, MBError>) -> Void
	
	/// Completion for assignment
    public typealias AssignmentResult = (Result<Void, MBError>) -> Void

	/// Completion for vin based assignment
	///
	/// Returns a AssignmentModel
	public typealias AssignmentFinishResult = (Result<AssignmentModel, MBError>) -> Void
	
	/// Completion for vin based assignment with precondition fails
	///
	/// Returns a AssignmentPreconditionModel
	public typealias AssignmentPreconditionResult = (AssignmentPreconditionModel) -> Void
	
	
	// MARK: Dependencies
	private let caching: CacheServiceRepresentable
	private let dbVehicleSelectionStore: VehicleSelectionDbStoreRepresentable
	private let dbVehicleServiceStoreCarKit: VehicleServicesDbStoreCarKitRepresentable
	private let dbVehicleStore: VehicleDbStoreRepresentable & VehicleDbStoreCarKitRepresentable
	private let dbVehicleSupportableStore: VehicleSupportableDbStoreCarKitRepresentable
	private let networking: Networking
	private let tokenProviding: TokenProviding?

	
	// MARK: - Init
	
	convenience init(networking: Networking) {
		self.init(caching: CacheService(),
				  networking: networking,
                  tokenProviding: nil,
				  dbVehicleSelectionStore: VehicleSelectionDbStore(),
				  dbVehicleServiceStoreCarKit: VehicleServicesDbStore(),
				  dbVehicleStore: VehicleDbStore(),
				  dbVehicleSupportableStore: VehicleSupportableDbStore())
	}
	
	init(
		caching: CacheServiceRepresentable,
		networking: Networking,
		tokenProviding: TokenProviding?,
		dbVehicleSelectionStore: VehicleSelectionDbStoreRepresentable,
		dbVehicleServiceStoreCarKit: VehicleServicesDbStoreCarKitRepresentable,
		dbVehicleStore: VehicleDbStoreRepresentable & VehicleDbStoreCarKitRepresentable,
		dbVehicleSupportableStore: VehicleSupportableDbStoreCarKitRepresentable) {
		
		self.caching = caching
		self.dbVehicleSelectionStore = dbVehicleSelectionStore
		self.dbVehicleServiceStoreCarKit = dbVehicleServiceStoreCarKit
		self.dbVehicleStore = dbVehicleStore
		self.dbVehicleSupportableStore = dbVehicleSupportableStore
		self.networking = networking
		self.tokenProviding = tokenProviding
	}
	
	
    // MARK: - Public
	
    public func addVehicleQR(link: String, completion: @escaping AssignmentFinishResult, onPreconditionFailed: @escaping AssignmentPreconditionResult) {

        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let router = BffAssignmentRouter.addQR(accessToken: token.accessToken,
                                                       link: link)

                self.networking.request(router: router) { [weak self] (result: Result<APIAssignmentModel, MBError>) in

                    switch result {
                    case .failure(let error):
                        LOG.E(error.localizedDescription)

                        self?.handle(error: error,
                                     completion: completion,
                                     onPreconditionFailed: onPreconditionFailed)

                    case .success(let apiAssignmentModel):
                        LOG.D(apiAssignmentModel)

                        let assignmentModel = NetworkModelMapper.map(apiAssignmentModel: apiAssignmentModel)
                        let vehicleModel = VehicleModel(baumuster: "",
                                                        carline: nil,
                                                        dataCollectorVersion: nil,
                                                        dealers: [],
                                                        doorsCount: nil,
                                                        fin: apiAssignmentModel.vin,
                                                        fuelType: nil,
                                                        handDrive: nil,
                                                        hasAuxHeat: false,
                                                        hasFacelift: false,
                                                        indicatorImageUrl: nil,
                                                        isOwner: assignmentModel.assignmentType != .user,
                                                        licensePlate: "",
                                                        model: "",
                                                        normalizedProfileControlSupport: nil,
                                                        pending: .assigning,
                                                        profileSyncSupport: nil,
                                                        roofType: nil,
                                                        starArchitecture: nil,
                                                        tcuHardwareVersion: nil,
                                                        tcuSoftwareVersion: nil,
                                                        tirePressureMonitoringType: nil,
                                                        trustLevel: 0,
                                                        vin: apiAssignmentModel.vin,
                                                        windowsLiftCount: nil,
                                                        vehicleConnectivity: nil,
                                                        vehicleSegment: .default,
                                                        paint: nil,
                                                        upholstery: nil,
                                                        line: nil)

                        self?.dbVehicleStore.save(vehicleModel: vehicleModel, completion: {
                            completion(.success(assignmentModel))
                        })

                        let vehicleSupportable = VehicleSupportableModel(canReceiveVACs: true,
                                                                         finOrVin: vehicleModel.finOrVin,
                                                                         vehicleConnectivity: .builtin)
                        self?.dbVehicleSupportableStore.save(vehicleSupportable: vehicleSupportable) { _ in
                            
                        }
                    }
                }
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }

    public func addVehicleVIN(finOrVin: String, completion: @escaping RifResult) {

        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let router = BffAssignmentRouter.addVIN(accessToken: token.accessToken,
                                                        vin: finOrVin)
                self.canCarReceiveVACs(for: router, finOrVin: finOrVin) { [weak self] (result) in
                    
                    switch result {
                    case .failure:
                        break
                        
                    case .success(let vehicleSupportable):
                        
                        guard vehicleSupportable.canReceiveVACs == false,
                            finOrVin.isEmpty == false else {
                                break
                        }
                        
                        let vehicleSelection = VehicleSelectionModel(finOrVin: finOrVin)
                        self?.dbVehicleSelectionStore.save(vehicleSelection: vehicleSelection) { _ in }
                    }
                    
                    completion(result)
                }

            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }

    public func canCarReceiveVACs(finOrVin: String, completion: @escaping RifResult) {

        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let router = BffVehicleRouter.rifability(accessToken: token.accessToken,
                                                         vin: finOrVin)
                self.canCarReceiveVACs(for: router, finOrVin: finOrVin, completion: completion)
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }

    public func confirmVehicle(finOrVin: String, vac: String, completion: @escaping AssignmentResult, onPreconditionFailed: @escaping AssignmentPreconditionResult) {

        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let router = BffAssignmentRouter.confirm(accessToken: token.accessToken,
                                                         vac: vac,
                                                         vin: finOrVin)

                self.assignment(router: router, onSuccess: { [weak self] in

                    self?.dbVehicleStore.update(pendingState: .assigning, for: finOrVin) {
                        completion(.success(()))
                    }

                    if finOrVin.isEmpty == false {
                        
                        let vehicleSelection = VehicleSelectionModel(finOrVin: finOrVin)
                        self?.dbVehicleSelectionStore.save(vehicleSelection: vehicleSelection) { _ in }
                    }
                }, onError: { [weak self] (error) in
                    
                    self?.handle(error: error, completion: { (result) in
                        
                        switch result {
                        case .failure(let error):    completion(.failure(error))
                        case .success:                completion(.success(()))
                        }
                    }, onPreconditionFailed: onPreconditionFailed)
                })
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }

    public func deleteVehicle(finOrVin: String, completion: @escaping AssignmentResult) {

        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let router = BffAssignmentRouter.delete(accessToken: token.accessToken,
                                                        vin: finOrVin)

                self.assignment(router: router, onSuccess: { [weak self] in

                    let selectedVin = CarKit.selectedFinOrVin
                    if selectedVin == finOrVin,
                        selectedVin?.isEmpty == false &&
                            finOrVin.isEmpty == false {
                        self?.caching.deleteStatus(for: finOrVin, completion: nil)
                    }

                    self?.dbVehicleStore.update(pendingState: .deleting, for: finOrVin) { [weak self] in

                        if let newAssignedVehicle = self?.dbVehicleStore.firstAssignedVehicle() {
                            
                            let vehicleSelection = VehicleSelectionModel(finOrVin: newAssignedVehicle.finOrVin)
                            self?.dbVehicleSelectionStore.save(vehicleSelection: vehicleSelection) { _ in }
                        } else {
                            self?.dbVehicleSelectionStore.delete { _ in }
                        }
                    }

                    self?.dbVehicleSupportableStore.delete(with: finOrVin) { _ in
                        
                    }
                    self?.dbVehicleServiceStoreCarKit.delete(finOrVin: finOrVin) {
                        
                    }
                    
                    completion(.success(()))
                }, onError: { (error) in
                    completion(.failure(error))
                })
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
    
    
    // MARK: - Helper
    
    private func assignment(router: EndpointRouter, onSuccess: @escaping () -> Void, onError: @escaping (MBError) -> Void) {
        
		self.networking.request(router: router) { (result: Result<Data, MBError>) in
            
            switch result {
            case .failure(let error):
                LOG.E(error.localizedDescription)
                
                onError(error)
                
            case .success:
                onSuccess()
            }
        }
    }
    
    private func canCarReceiveVACs(for router: EndpointRouter, finOrVin: String, completion: @escaping RifResult) {
        
		self.networking.request(router: router) { (result: Result<APIVehicleRifModel, MBError>) in
            
            switch result {
            case .failure(let error):
                LOG.E(error.localizedDescription)
				
				completion(.failure(error))
                
            case .success(let apiRif):
                LOG.D(apiRif)
                
				let vehicleSupportable = NetworkModelMapper.map(apiVehicleRifModel: apiRif,
																finOrVin: finOrVin)
				self.dbVehicleSupportableStore.save(vehicleSupportable: vehicleSupportable) { (_) in
					
				}
                
                completion(.success(vehicleSupportable))
            }
        }
    }
    
	private func handle(error: MBError, completion: @escaping AssignmentFinishResult, onPreconditionFailed: @escaping AssignmentPreconditionResult) {
		
		switch error.type {
		case .http(let httpError):

			if let data = httpError.data,
				let apiAssignmentPreconditionModel = try? JSONDecoder().decode(APIAssignmentPreconditionModel.self, from: data) {

				let assignmentPreconditionModel = NetworkModelMapper.map(apiAssignmentPreconditionModel: apiAssignmentPreconditionModel)
				LOG.E(assignmentPreconditionModel)
				onPreconditionFailed(assignmentPreconditionModel)
			} else {
				completion(.failure(error))
			}
			
		case .network,
			 .specificError,
			 .unknown:
			completion(.failure(error))
		}
	}
}
