//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit
import MBCommonKit
#if canImport(MBCommonKitTracking)
import MBCommonKitTracking
#endif

@available(*, deprecated, message: "Please use SendToCarServiceV2Representable instead.")
public protocol SendToCarServiceRepresentable {
    @available(*, deprecated, message: "The method fetchSendToCarCapabilities(finOrVin:onCompletion:) is deprecated. Please use fetchCapabilities(finOrVin:fromCache:completion:) instead.")
    func fetchSendToCarCapabilities(finOrVin: String, onCompletion: @escaping (FetchSendToCarCapabilitiesResult) -> Void)
    
    @available(*, deprecated, message: "The method sendRoute(finOrVin:routeModel:onCompletion:) is deprecated. Please use sendPoiOrRoute(capabilities:routeModel:completion:) instead.")
    func sendRoute(finOrVin: String, routeModel: SendToCarRouteModel, onCompletion: @escaping (SendRouteResult) -> Void)
}

/// Result object for SendRoute requests
public enum SendRouteResult {
    case success
    case failure(SendRouteError)
}

/// Result object for FetchSendToCarCapabilities requests
public enum FetchSendToCarCapabilitiesResult {
    case success([SendToCarCapability])
    case failure(FetchSendToCarCapabilitiesError)
}

/// Completion for sending a route to the vehicle
///
/// Returns  a SendRouteResult
public typealias OnSendRouteCompletion = ((SendRouteResult) -> Void)


/// Completion for fetching a list of capabilities of the vehicle
///
/// Returns a FetchSendToCarCapabilitiesResult
public typealias OnFetchSendToCarCapabilitiesCompletion = ((FetchSendToCarCapabilitiesResult) -> Void)

/// Service to send notifications to the head unit
public class SendToCarService: SendToCarServiceRepresentable {
    
    // MARK: Types
    private enum SendToCarOptions {
        case bluetoothWithBackendFallback(SendToCarWaypointModel)
        case bluetoothOnly(SendToCarWaypointModel)
        case backend
        case notPossible(Error?)
        
        var title: String {
            switch self {
            case .bluetoothWithBackendFallback: return "bluetoothWithBackendFallback"
            case .bluetoothOnly: return "bluetoothOnly"
            case .backend: return "backend"
            case .notPossible: return "notPossible"
            }
        }
    }

    // MARK: Dependencies
    private let dbStore: SendToCarCapabilitiesDbStoreRepresentable
    private let networking: Networking
    private let tokenProviding: TokenProviding?
    private let trackingManager: TrackingManager
    
    
    // MARK: - Init
    
    convenience init(networking: Networking) {
        self.init(networking: networking,
                  tokenProviding: nil,
                  dbStore: SendToCarCapabilitiesDbStore(),
                  trackingManager: MBTrackingManager.shared)
    }
    
    init(networking: Networking, tokenProviding: TokenProviding?, dbStore: SendToCarCapabilitiesDbStoreRepresentable, trackingManager: TrackingManager) {
        
        self.dbStore = dbStore
        self.networking = networking
        self.tokenProviding = tokenProviding
        self.trackingManager = trackingManager
    }
    
    
    // MARK: - SendToCarServiceRepresentable
    
    public func fetchSendToCarCapabilities(finOrVin: String, onCompletion: @escaping OnFetchSendToCarCapabilitiesCompletion) {
        
        if self.hasSendToCarCapabilityCache(finOrVin: finOrVin) {
            
            let capabilities = self.dbStore.item(with: finOrVin)?.capabilities ?? []
            onCompletion(.success(capabilities))
            self.requestSendToCarCapabilitiesAndUpdateCache(finOrVin: finOrVin)
        } else {
            self.requestSendToCarCapabilitiesAndUpdateCache(finOrVin: finOrVin, onCompletion: onCompletion)
        }
    }
    
    public func sendRoute(finOrVin: String, routeModel: SendToCarRouteModel, onCompletion: @escaping OnSendRouteCompletion) {

        LOG.I("Sending route to the vehicle.\n  - finOrVin: \(finOrVin)\n  - routeModel: \(routeModel)")
        
        LOG.D("Assuring SendToCar capability cache for vin: \(finOrVin)")
        self.assureSendToCarCapabilityCache(
            finOrVin: finOrVin,
            onFailure: { error in
                LOG.E("Refreshing SendToCar capability cache failed. Aborting SendRoute request.")
                onCompletion(.failure(error))
            },
            onCompletion: { [weak self] wasRefreshed in
                LOG.D("Successfully assured SendToCar capability cache. Required refresh: \(wasRefreshed).  Continuing sending the route...")
                
                if let sendToCarOptions = self?.getSendToCarOptions(finOrVin: finOrVin, routeModel: routeModel) {
                    LOG.I("Available SendToCar option: \(sendToCarOptions.title)")
                    
                    self?.sendRoute(for: sendToCarOptions, finOrVin: finOrVin, routeModel: routeModel, onCompletion: onCompletion)
                } else {
                    LOG.E("Could not determine sendToCarOptions. Aborting SendRoute request.")
                    onCompletion(.failure(.unknown))
                }
            }
        )
    }
    
    
    // MARK: - Helper
    
    private func requestSendToCarCapabilitiesAndUpdateCache(finOrVin: String, onCompletion: OnFetchSendToCarCapabilitiesCompletion? = nil) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
        
            switch result {
            case .success(let token):
                let router = BffCapabilitiesRouter.sendToCarV2(accessToken: token.accessToken,
                                                               vin: finOrVin)
                
                self.networking.request(router: router) { [weak self] (result: Result<APISendToCarCapabilitiesModel, MBError>) in
                    
                    switch result {
                    case .failure(let error):
                        LOG.E(error.localizedDescription)
                        
                        onCompletion?(.failure(.network))
                        
                    case .success(let apiSendToCarCapabilities):
                        guard let self = self else {
                            onCompletion?(.failure(.unknown))
                            return
                        }
                        
                        LOG.D(apiSendToCarCapabilities)
                        let sendToCarCapabilitiesModel = self.buildSendToCarCapabilitiesModel(apiSendToCarCapabilities: apiSendToCarCapabilities,
                                                                                              for: finOrVin)
                        
                        // if capabilites havent changed no need to save to cache
                        if self.isRetrievedCapabilitiesEqualToCachedCapabilities(sendToCarCapabilitiesModel: sendToCarCapabilitiesModel) {
                            onCompletion?(.success(sendToCarCapabilitiesModel.capabilities))
                            return
                        }
                        
                        // Update cache and post notification if capabilities have changed
                        self.dbStore.save(sendToCarModel: sendToCarCapabilitiesModel) { (_) in
                            
                            NotificationCenter.default.post(name: NSNotification.Name.didChangeSendToCarCapabilities,
                                                            object: sendToCarCapabilitiesModel.capabilities)
                            onCompletion?(.success(sendToCarCapabilitiesModel.capabilities))
                        }
                    }
                }
                
            case .failure:
                onCompletion?(.failure(.token))
            }
        }
    }
    
    private func isRetrievedCapabilitiesEqualToCachedCapabilities(sendToCarCapabilitiesModel: SendToCarCapabilitiesModel) -> Bool {
        
        guard self.hasSendToCarCapabilityCache(finOrVin: sendToCarCapabilitiesModel.finOrVin) else {
            return false
        }
        
        let cacheCapabilites: [SendToCarCapability] = self.dbStore.item(with: sendToCarCapabilitiesModel.finOrVin)?.capabilities ?? []
        let cacheCapabilitesSet = Set(cacheCapabilites)
        let backendCapabilitesSet = Set(sendToCarCapabilitiesModel.capabilities)
        
        return cacheCapabilitesSet == backendCapabilitesSet
    }
    
    private func buildSendToCarCapabilitiesModel(apiSendToCarCapabilities: APISendToCarCapabilitiesModel, for vin: String) -> SendToCarCapabilitiesModel {
        let capabilities: [SendToCarCapability] = {
            
            let capabilities = apiSendToCarCapabilities.capabilities.compactMap { SendToCarCapability(rawValue: $0) }
            guard CarKit.bluetoothProvider == nil else {
                return capabilities
            }
            // if BT is an available capability, but the BT provider is not set, remove the BT capability
            return capabilities.filter { $0 != .singlePoiBluetooth }
        }()
        
        return SendToCarCapabilitiesModel(capabilities: capabilities,
                                                                    finOrVin: vin,
                                                                    preconditions: apiSendToCarCapabilities.preconditions.compactMap { SendToCarPrecondition(rawValue: $0) })
    }
    
    private func sendRoute(for sendToCarOptions: SendToCarService.SendToCarOptions, finOrVin: String, routeModel: SendToCarRouteModel, onCompletion: @escaping OnSendRouteCompletion) {
        
        switch sendToCarOptions {
        case .bluetoothOnly(let poi):
            LOG.D("Check bluetooth connection..")
            
            if self.isBluetoothConnectionAvailable(for: finOrVin) {

                self.sendPoiViaBluetooth(poi: poi,
                                          finOrVin: finOrVin,
                                          allowedQueuing: true,
                                          onCompletion: onCompletion)

            } else {
                LOG.E("Bluetooth connection could not be established. Bluetooth is only capability. Add POI to cache")
                self.sendPoiViaBluetooth(poi: poi,
                                          finOrVin: finOrVin,
                                          allowedQueuing: true,
                                          onCompletion: onCompletion)
            }
            
        case .bluetoothWithBackendFallback(let poi):
            LOG.D("Check bluetooth connection..")
            
            if self.isBluetoothConnectionAvailable(for: finOrVin) {
                
                let bluetoothFailedFallback: (() -> Void) = {
                    LOG.D("Sending POI via Bluetooth failed. Using sendToCar via Backend as fallback.")
                    self.sendRouteToBackend(finOrVin: finOrVin,
                                            routeModel: routeModel,
                                            onCompletion: onCompletion)
                }
                
                self.sendPoiViaBluetooth(poi: poi,
                                         finOrVin: finOrVin,
                                         allowedQueuing: false,
                                         fallback: bluetoothFailedFallback,
                                         onCompletion: onCompletion)
            } else {
                LOG.E("Bluetooth connection did fail. Using sendToCar via Backend as fallback.")
                self.sendRouteToBackend(finOrVin: finOrVin,
                                        routeModel: routeModel,
                                        onCompletion: onCompletion)
            }
            
            
        case .backend:
            LOG.D("Sending route via Backend.")
            self.sendRouteToBackend(finOrVin: finOrVin,
                                    routeModel: routeModel,
                                    onCompletion: onCompletion)
            
        case .notPossible(let error):
            LOG.E("SendToCar is currently not possible: \(error?.localizedDescription ?? "<unkown>"). Aborting SendRoute.")
            onCompletion(.failure(.unknown))
        }
    }
    
    private func isBluetoothConnectionAvailable(for finOrVin: String) -> Bool {
        return CarKit.bluetoothProvider?.connectionStatus == .connected &&
               CarKit.bluetoothProvider?.connectedFinOrVin == finOrVin
    }
    
    private func assureSendToCarCapabilityCache(finOrVin: String, onFailure: @escaping ((SendRouteError) -> Void), onCompletion: @escaping ((Bool) -> Void)) {
        
        guard self.hasSendToCarCapabilityCache(finOrVin: finOrVin) == false else {
            onCompletion(false)
            return
        }
        
        self.fetchSendToCarCapabilities(finOrVin: finOrVin) { result in
            switch result {
            case .success(let capabilities):
                guard capabilities.isEmpty == false else {
                    onFailure(.noCapabilitiesAvailable)
                    return
                }
                onCompletion(true)
                
            case .failure:
                onFailure(.noCapabilitiesAvailable)
            }
        }
    }
    
    private func sendPoiViaBluetooth<T: BluetoothPoiMappable>(poi: T, finOrVin: String, allowedQueuing: Bool, fallback: (() -> Void)? = nil, onCompletion: @escaping OnSendRouteCompletion) {
        
        self.track(finOrVin: finOrVin,
                   routeType: .singlePoiBluetooth,
                   state: .enqueued)
        
        CarKit.bluetoothProvider?.send(poi: poi, to: finOrVin, allowedQueuing: allowedQueuing) { result in
            
            switch result {
            case .failure(let error):
                LOG.E("Sending POI over Bluetooth failed. Reason: \(String(describing: error))")
                self.track(finOrVin: finOrVin,
                           routeType: .singlePoiBluetooth,
                           state: .failed)
                
                if let fallback = fallback {
                    fallback()
                } else {
                    LOG.E("No fallback defined for S2C Bluetooth. Completing with error")
                    onCompletion(.failure(.sendViaBluetoothFailed(error)))
                }
                
            case .success:
                self.track(finOrVin: finOrVin,
                           routeType: .singlePoiBluetooth,
                           state: .finished)
                
                onCompletion(.success)
            }
        }
    }
    
    private func getSendToCarOptions(finOrVin: String, routeModel: SendToCarRouteModel) -> SendToCarOptions {
        
        guard let poi = routeModel.waypoints.first else {
            return .notPossible(nil)
        }
        
        let capabilities: [SendToCarCapability] = self.dbStore.item(with: finOrVin)?.capabilities ?? []
        
        guard self.doesSupportBluetooth(finOrVin: finOrVin, routeModel: routeModel, capabilities: capabilities) else {
            return .backend
        }
        
        if capabilities.count == 1 { // make sure ONLY singlePoiBluetooth is available, nothing else
            return .bluetoothOnly(poi)
        }
        
        return .bluetoothWithBackendFallback(poi)
    }
    
    private func hasSendToCarCapabilityCache(finOrVin: String) -> Bool {
        return self.dbStore.item(with: finOrVin)?.capabilities.isEmpty == false
    }
    
    private func doesSupportBluetooth(finOrVin: String, routeModel: SendToCarRouteModel, capabilities: [SendToCarCapability]) -> Bool {
        return CarKit.bluetoothProvider != nil &&
                routeModel.routeType == .singlePOI &&
                capabilities.contains(SendToCarCapability.singlePoiBluetooth)
    }

    private func sendRouteToBackend(finOrVin: String, routeModel: SendToCarRouteModel, onCompletion: @escaping OnSendRouteCompletion) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                
                let json   = try? routeModel.toJson()
                let router = BffVehicleRouter.route(accessToken: token.accessToken,
                                                    vin: finOrVin,
                                                    requestModel: json as? [String: Any])
                
                self.track(finOrVin: finOrVin, routeType: routeModel.routeType, state: .initiation)
                
                self.networking.request(router: router) { [weak self] (result: Result<Data, MBError>) in
                    
                    switch result {
                    case .failure(let error):
                        LOG.E("Sending route via Backend failed: \(String(describing: error.localizedDescription))")
                        self?.track(finOrVin: finOrVin, routeType: routeModel.routeType, state: .finished)
                        
                        onCompletion(.failure(.sendViaBackendFailed(error.localizedDescription)))
                        
                    case .success:
                        LOG.D("Successfully send poi or route via Backend")
                        self?.track(finOrVin: finOrVin, routeType: routeModel.routeType, state: .finished)

                        onCompletion(.success)
                    }
                }
                
            case .failure:
                onCompletion(.failure(.token))
            }
        }
    }
    
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
        trackingManager.track(event: event)
    }
}
