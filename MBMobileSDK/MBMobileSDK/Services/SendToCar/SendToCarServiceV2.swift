//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit
import MBCommonKit
#if canImport(MBCommonKitTracking)
import MBCommonKitTracking
#endif

public enum SendRouteError: Error {
    /// no sendRoute capabilities are available or could be fetched
    case noCapabilitiesAvailable
    
    /// sending the route via the bluetooth provider failed. This error is only returned
    /// if no send via backend is available, otherwise it will fallback to sending via the backend
    /// instead.
    case sendViaBluetoothFailed(Error?)
    
    /// sending the route via the backend failed
    case sendViaBackendFailed(String?)
    
    /// there is no bluetooth connection available. This error is only returned
    /// if no send via backend is available, otherwise it will fallback to sending via the backend
    /// instead.
    case noBluetoothConnection

	/// The following preconditions by MBApps are not satisfied and need to be resolved before being able to use S2C over backend.
	case mbAppsPreconditionsNotSatisfied([SendToCarPrecondition])
    
    /// No Waypoints were supplied for `sendPoiOrRoute`
    case noWaypointsSupplied
    
    case token
	
    case unknown
}

public enum FetchSendToCarCapabilitiesError: Error {
    /// Fetching capabilities from the backend services did fail
    case network
    
    case token
    
    case unknown
}

/// Service to send notifications to the head unit
public class SendToCarServiceV2: SendToCarServiceV2Representable {
    
    // MARK: Types
    enum SendToCarOptions: Equatable {
        static func == (lhs: SendToCarServiceV2.SendToCarOptions, rhs: SendToCarServiceV2.SendToCarOptions) -> Bool {
            switch (lhs, rhs) {
            case (.backend, .backend):
                return true
            case (.bluetoothOnly(let waypoint), .bluetoothOnly(let waypoint2)):
                return waypoint == waypoint2
            case (.bluetoothWithBackendFallback(let waypoint), .bluetoothWithBackendFallback(let waypoint2)):
                return waypoint == waypoint2
            default:
                return false
            }
        }
        
		case bluetoothWithBackendFallback(SendToCarWaypointModel)
        case bluetoothOnly(SendToCarWaypointModel)
        case backend
    }

    // MARK: Dependencies
	private let dbStore: SendToCarCapabilitiesDbStoreRepresentable
	private let networking: Networking
	private let tokenProviding: TokenProviding?
    private let trackingManager: TrackingManager
    private let capabilityBuilding: SendToCarCapabilitiesModelBuilding
    private let optionsBuilding: SendToCarOptionsBuilding
    private let notificationSending: Send2CarNotificationSending
    private let bluetoothProviding: BluetoothProviding?
	
	
	// MARK: - Init
	
    public convenience init(networking: Networking = NetworkService()) {
		self.init(networking: networking,
                  tokenProviding: nil,
                  dbStore: SendToCarCapabilitiesDbStore(),
                  trackingManager: MBTrackingManager.shared,
                  capabilityBuilding: SendToCarCapabilitiesModelBuilder(),
                  optionsBuilding: SendToCarOptionsBuilder(),
                  notificationSending: Send2CarNotificationSender(),
                  bluetoothProviding: CarKit.bluetoothProvider)
	}
	
    init(networking: Networking,
         tokenProviding: TokenProviding?,
         dbStore: SendToCarCapabilitiesDbStoreRepresentable,
         trackingManager: TrackingManager,
         capabilityBuilding: SendToCarCapabilitiesModelBuilding,
         optionsBuilding: SendToCarOptionsBuilding,
         notificationSending: Send2CarNotificationSending,
         bluetoothProviding: BluetoothProviding?) {
		
		self.dbStore = dbStore
		self.networking = networking
		self.tokenProviding = tokenProviding
        self.trackingManager = trackingManager
        self.capabilityBuilding = capabilityBuilding
        self.optionsBuilding = optionsBuilding
        self.notificationSending = notificationSending
        self.bluetoothProviding = bluetoothProviding
	}
    
    // MARK: - Public interface
    
    public func fetchCapabilities(finOrVin: String, completion: @escaping (Result<SendToCarCapabilitiesModel, FetchSendToCarCapabilitiesError>) -> Void) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { [weak self] result in
            switch result {
            case .failure:
                completion(.failure(.token))
            case .success(let token):
                let router = BffCapabilitiesRouter.sendToCarV2(accessToken: token.accessToken,
                                                               vin: finOrVin)
                
                LOG.D("Fetching S2C capabilities")
                self?.networking.request(router: router) { [weak self] (result: Result<APISendToCarCapabilitiesModel, MBError>) in
                    
                    switch result {
                    case .failure(let error):
                        LOG.E(error.localizedDescription)
                        
                        if let cachedCapabilities = self?.cachedCapabilities(for: finOrVin) {
                            LOG.D("Backend request to update capabilities failed but there is cached data available. Returning from cache")
                            completion(.success(cachedCapabilities))
                        } else {
                            LOG.E("Backend request to update capabilities failed and there is no cached data available. Returning with error \(error.localizedDescription ?? "unknown error")")
                            completion(.failure(.network))
                        }
                        
                    case .success(let apiSendToCarCapabilities):
                        LOG.D(apiSendToCarCapabilities)
                        
                        guard let sendToCarCapabilitiesModel = self?.capabilityBuilding.build(bluetoothProviding: self?.bluetoothProviding, apiModel: apiSendToCarCapabilities, for: finOrVin) else {
                            completion(.failure(.unknown))
                            return
                        }
                        
                        // if capabilites havent changed no need to save to cache
                        if let cachedCapabilities = self?.cachedCapabilities(for: finOrVin), cachedCapabilities == sendToCarCapabilitiesModel {
                            LOG.D("Retrieved capabilities from backend are the same as cached capabilities. Returning without updating cache")
                            completion(.success(sendToCarCapabilitiesModel))
                            return
                        }
                        
                        // Update cache and post notification if capabilities have changed
                        self?.notificationSending.sendDidChangeSendToCarCapabilities(capabilities: sendToCarCapabilitiesModel)
                        self?.storeCapabilities(sendToCarCapabilitiesModel: sendToCarCapabilitiesModel, completion: completion)
                    }
                }
            }
        }
    }
    
    public func sendPoiOrRoute(finOrVin: String, routeModel: SendToCarRouteModel, completion: @escaping (Result<Void, SendRouteError>) -> Void) {

        LOG.I("Checking S2C capability cache state")
        
        if let cachedCapabilities = self.cachedCapabilities(for: finOrVin) {
            LOG.D("Cached capabilities available, using these.")
            self.sendPoiOrRoute(finOrVin: finOrVin, routeModel: routeModel, prefetchedCapabilities: cachedCapabilities, completion: completion)
            
            LOG.V("Silently update capabilities cache in Background")
            self.fetchCapabilities(finOrVin: finOrVin, completion: {_ in })
        } else {
            
            LOG.D("No cached capabilities available, requesting from Backend")
            self.fetchCapabilities(finOrVin: finOrVin) { [weak self] result in
                switch result {
                case .failure:
                    completion(.failure(.noCapabilitiesAvailable))
                case .success(let capabilities):
                    self?.sendPoiOrRoute(finOrVin: finOrVin, routeModel: routeModel, prefetchedCapabilities: capabilities, completion: completion)
                }
            }
        }
    }
    
    public func sendPoiOrRoute(finOrVin: String,
                               routeModel: SendToCarRouteModel,
                               prefetchedCapabilities: SendToCarCapabilitiesModel,
                               completion: @escaping (Result<Void, SendRouteError>) -> Void) {

        LOG.I("Sending route to the vehicle.\n - finOrVin: \(finOrVin)\n - routeModel: \(routeModel)")
        
        let sendToCarOptionsResult = self.optionsBuilding.build(bluetoothProviding: self.bluetoothProviding, capabilities: prefetchedCapabilities, routeModel: routeModel)
        
        switch sendToCarOptionsResult {
        case .failure(.noWaypointsSupplied):
            completion(.failure(.noWaypointsSupplied))
        case .success(let sendToCarOptions):
            self.sendRoute(routeModel: routeModel, with: sendToCarOptions, with: prefetchedCapabilities, to: finOrVin, completion: completion)
        }
    }
	
	
	// MARK: - Private methods
    
    private func storeCapabilities(sendToCarCapabilitiesModel: SendToCarCapabilitiesModel, completion: @escaping (Result<SendToCarCapabilitiesModel, FetchSendToCarCapabilitiesError>) -> Void) {
        self.dbStore.save(sendToCarModel: sendToCarCapabilitiesModel) { result in
            
            switch result {
            case .failure(let dbError):
                LOG.E("Saving to store failed. Reason \(dbError.localizedDescription). Still returning with fetched capabilities")
            case .success:
                LOG.D("Updating cached S2C capabilities succeeded")
            }
            
            // no need to check for cache failures here because we can not handle them meaningful anyway
            // next time capabilities are fetched we try updating cache again
            completion(.success(sendToCarCapabilitiesModel))
        }
    }
    
    private func sendRoute(routeModel: SendToCarRouteModel,
                           with sendToCarOptions: SendToCarServiceV2.SendToCarOptions,
                           with capabilities: SendToCarCapabilitiesModel,
                           to finOrVin: String, completion: @escaping (Result<Void, SendRouteError>) -> Void) {
        
        switch sendToCarOptions {
        case .bluetoothOnly(let poi):
            
            LOG.D("Sending over bluetooth..")
            
            if !self.isBluetoothConnectionAvailable(for: finOrVin) {
                LOG.E("Bluetooth connection could not be established. Bluetooth is the only capability, no BE fallback possible. Adding POI to cache")
            }
            
            self.sendPoiViaBluetooth(poi: poi,
                                     finOrVin: finOrVin,
                                     allowedQueuing: true,
                                     completion: completion)
            
        case .bluetoothWithBackendFallback(let poi):
            
            let sendRouteToBackend: (() -> Void) = {
                self.sendRouteToBackend(finOrVin: finOrVin,
                                        routeModel: routeModel,
                                        capabilities: capabilities,
                                        completion: completion)
            }
            
            if self.isBluetoothConnectionAvailable(for: finOrVin) {
                
                LOG.D("Bluetooth connection available. Trying to send over Bluetooth with backend fallback")
                self.sendPoiViaBluetooth(poi: poi,
                                         finOrVin: finOrVin,
                                         allowedQueuing: false,
                                         fallback: sendRouteToBackend,
                                         completion: completion)
            } else {
                
                LOG.E("Bluetooth connection not available. Trying sendToCar via Backend.")
                sendRouteToBackend()
            }
            
        case .backend:
            
            LOG.D("Sending route via Backend.")
            self.sendRouteToBackend(finOrVin: finOrVin,
                                    routeModel: routeModel,
                                    capabilities: capabilities,
                                    completion: completion)
        }
    }
    
    private func isBluetoothConnectionAvailable(for finOrVin: String) -> Bool {
        return self.bluetoothProviding?.connectionStatus == .connected &&
               self.bluetoothProviding?.connectedFinOrVin == finOrVin
    }
    
    private func sendPoiViaBluetooth<T: BluetoothPoiMappable>(poi: T,
                                                              finOrVin: String,
                                                              allowedQueuing: Bool,
                                                              fallback: (() -> Void)? = nil, completion: @escaping (Result<Void, SendRouteError>) -> Void) {
		
		self.track(finOrVin: finOrVin,
				   routeType: .singlePoiBluetooth,
				   state: .enqueued)
        
        self.bluetoothProviding?.send(poi: poi, to: finOrVin, allowedQueuing: allowedQueuing) { [weak self] result in
            
			switch result {
			case .failure(let error):
				LOG.E("Sending POI over Bluetooth failed. Reason: \(String(describing: error))")
				self?.track(finOrVin: finOrVin,
						   routeType: .singlePoiBluetooth,
						   state: .failed)
				
				if let fallback = fallback {
                    fallback()
                } else {
                    LOG.E("No fallback defined for S2C Bluetooth. Completing with error")
					completion(.failure(.sendViaBluetoothFailed(error)))
                }
				
			case .success:
				self?.track(finOrVin: finOrVin,
						   routeType: .singlePoiBluetooth,
						   state: .finished)
				
				completion(.success(()))
            }
        }
    }

    private func sendRouteToBackend(finOrVin: String, routeModel: SendToCarRouteModel, capabilities: SendToCarCapabilitiesModel, completion: @escaping (Result<Void, SendRouteError>) -> Void) {
        
        guard capabilities.preconditions.isEmpty else {
            completion(.failure(.mbAppsPreconditionsNotSatisfied(capabilities.preconditions)))
            return
        }
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { [weak self] result in
            switch result {
            case .failure:
                completion(.failure(.token))
            case .success(let token):
                let json   = try? routeModel.toJson()
                let router = BffVehicleRouter.route(accessToken: token.accessToken,
                                                    vin: finOrVin,
                                                    requestModel: json as? [String: Any])
                
                self?.track(finOrVin: finOrVin, routeType: routeModel.routeType, state: .initiation)
                
                self?.networking.request(router: router) { [weak self] (result: Result<Data, MBError>) in
                    
                    switch result {
                    case .failure(let error):
                        LOG.E("Sending route via Backend failed: \(String(describing: error.localizedDescription))")
                        self?.track(finOrVin: finOrVin, routeType: routeModel.routeType, state: .finished)
                        
                        completion(.failure(.sendViaBackendFailed(error.localizedDescription)))
                        
                    case .success:
                        LOG.D("Successfully send poi or route via Backend")
                        self?.track(finOrVin: finOrVin, routeType: routeModel.routeType, state: .finished)

                        completion(.success(()))
                    }
                }
            }
        }
    }
    
    private func cachedCapabilities(for finOrVin: String) -> SendToCarCapabilitiesModel? {
        return self.dbStore.item(with: finOrVin)
    }
    
    // MARK: - Tracking
	
	private func track(finOrVin: String, routeType: HuCapability, state: CommandState) {
		
		let event = MyCarTrackingEvent.sendToCar(fin: finOrVin,
												 routeType: routeType,
												 state: state,
												 condition: "")
		self.track(event: event)
	}
	
	private func track(finOrVin: String, routeType: SendToCarCapability, state: CommandState) {
		
		let event = MyCarTrackingEvent.sendToCarBluetooth(fin: finOrVin,
														  routeType: routeType,
														  state: state,
														  condition: "")
		self.track(event: event)
	}
	
	private func track(event: MyCarTrackingEvent) {
        self.trackingManager.track(event: event)
	}
}
