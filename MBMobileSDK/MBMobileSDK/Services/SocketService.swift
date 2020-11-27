//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

// swiftlint:disable type_body_length

import Foundation
import MBCommonKit
#if canImport(MBCommonKitTracking)
import MBCommonKitTracking
#endif
import MBNetworkKit

public class SocketService: SocketServiceRepresentable {
	
	// MARK: Lazy
	private lazy var vepRealmQueue: OperationQueue = {
		
		let queue = OperationQueue()
		queue.maxConcurrentOperationCount = 1
		queue.name = "vepRealmQueue"
		queue.qualityOfService = .userInitiated
		return queue
	}()
	
	// MARK: Structs
	private struct Constants {
		static let SendCommandTimeout: TimeInterval = 6.0
	}
	
	// MARK: Properties
	private var protoMessageParser = ProtoMessageParser()
	private var myCarSocketConnectionState: MyCarSocketConnectionState = .disconnected {
		didSet {
			self.notificationTokens.forEach {
				$0.notify(state: self.myCarSocketConnectionState)
			}
		}
	}
	private var notificationTokens: [MyCarSocketNotificationToken]
	private var socketObservable: SocketObservable
	private var socketConnectionToken: SocketConnectionToken?
	private var socketReceiveDataToken: SocketReceiveDataToken?

	// MARK: Dependencies
	private let caching: CacheServiceRepresentable
	private let dbVehicleSelectionStore: VehicleSelectionDbStoreRepresentable
	private let dbVehicleServiceStoreCarKit: VehicleServicesDbStoreCarKitRepresentable
	private let dbVehicleStore: VehicleDbStoreRepresentable
	private let networking: Networking
	private let servicesService: ServicesServiceRepresentable
	private let tokenProviding: TokenProviding?
	private let vehicleServiceCarKit: VehicleServiceCarKitRepresentable
    private let trackingManager: TrackingManager
	
	
	// MARK: - Init
	
	convenience init(networking: Networking, servicesService: ServicesServiceRepresentable, vehicleServiceCarKit: VehicleServiceCarKitRepresentable) {
		self.init(caching: CacheService(),
				  networking: networking,
				  servicesService: servicesService,
				  tokenProviding: nil,
				  vehicleServiceCarKit: vehicleServiceCarKit,
				  dbVehicleSelectionStore: VehicleSelectionDbStore(),
				  dbVehicleServiceStoreCarKit: VehicleServicesDbStore(),
                  dbVehicleStore: VehicleDbStore(),
                  trackingManager: MBTrackingManager.shared)
    }
	
	init(
		caching: CacheServiceRepresentable,
		networking: Networking,
		servicesService: ServicesServiceRepresentable,
		tokenProviding: TokenProviding?,
		vehicleServiceCarKit: VehicleServiceCarKitRepresentable,
		dbVehicleSelectionStore: VehicleSelectionDbStoreRepresentable,
		dbVehicleServiceStoreCarKit: VehicleServicesDbStoreCarKitRepresentable,
		dbVehicleStore: VehicleDbStoreRepresentable,
		trackingManager: TrackingManager) {
		
		self.caching = caching
		self.dbVehicleSelectionStore = dbVehicleSelectionStore
		self.dbVehicleServiceStoreCarKit = dbVehicleServiceStoreCarKit
		self.dbVehicleStore = dbVehicleStore
		self.networking	= networking
		self.notificationTokens = []
		self.servicesService = servicesService
		self.socketObservable = SocketObservable(vehicleStatusModel: caching.getCurrentStatus())
		self.tokenProviding	= tokenProviding
		self.vehicleServiceCarKit = vehicleServiceCarKit
        self.trackingManager = trackingManager
	}
	
	
	// MARK: - Public
	
	public func closeConnection() {
		
		Socket.service.unregisterAndDisconnectIfPossible(connectionToken: self.socketConnectionToken,
														 receiveDataToken: self.socketReceiveDataToken)
		self.notificationTokens     = []
		self.socketConnectionToken  = nil
		self.socketReceiveDataToken = nil
		
		Socket.service.close()
	}
	
	public func connect(
		notificationTokenCreated: @escaping MyCarSocketNotificationToken.MyCarSocketNotificationTokenCreated,
		socketConnectionState: @escaping MyCarSocketNotificationToken.MyCarSocketConnectionObserver) -> (socketConnectionState: MyCarSocketConnectionState, socketObservable: SocketObservableProtocol) {
		
		let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { [weak self] (result) in
        
            switch result {
            case .success(let token):
                if self?.socketConnectionToken == nil {
                    
                    let socketToken = SocketToken(accessToken: token.accessToken,
                                                  expiredDate: token.expirationDate)
                    self?.socketConnectionToken = Socket.service.connect(socketToken: socketToken) { [weak self] (connectionState) in
                        self?.handle(connectionState: connectionState)
                    }
                }
                
                if self?.socketReceiveDataToken == nil {
                    self?.socketReceiveDataToken = Socket.service.receiveData { [weak self] (data) in
                        self?.handle(receiveData: data)
                    }
                }
                
                let notificationToken = MyCarSocketNotificationToken(socketConnectionObserver: socketConnectionState)
                self?.notificationTokens.append(notificationToken)
                
                notificationTokenCreated(notificationToken)
                
            case .failure(let error):
                LOG.E(error.localizedDescription)
            }
        }
		
		return (socketConnectionState: self.myCarSocketConnectionState, socketObservable: self.socketObservable)
	}
	
	public func disconnect() {
		Socket.service.disconnect(forced: true)
	}
	
	public func reconnect(manually: Bool) {
		self.update(reconnectManually: manually)
	}
	
    public func send<T>(command: T, completion: @escaping CarKit.CommandUpdateCallback<T.Error>) where T: BaseCommandProtocol, T: CommandTypeProtocol {
        
        let selectedFinOrVin = CarKit.selectedFinOrVin ?? ""
        guard selectedFinOrVin.isEmpty == false else {
            completion(.failed(errors: [command.createGenericError(error: .noVehicleSelected)]), CommandProcessingMetaData(timestamp: Date()))
            return
        }
        
        switch command {
        // If the command conforms to `CommandPinProtocol` a pin will be requested before sending the command
        case let commandType as CommandPinProtocol:
            
            guard let pinProvider = CarKit.pinProvider else {
                completion(.failed(errors: [command.createGenericError(error: .pinProviderMissing)]), CommandProcessingMetaData(timestamp: Date()))
                return
            }
            
            pinProvider.requestPin(forReason: nil, preventFromUsageAlert: false, onSuccess: { [weak self] (pin) in
                
                let requestId = UUID().uuidString
                let commandData = commandType.serialize(with: selectedFinOrVin, requestId: requestId, pin: pin)
                self?.send(command: command,
						   serializedCommand: commandData,
						   requestId: requestId,
						   vin: selectedFinOrVin,
						   completion: completion)
            }, onCancel: {
                completion(.failed(errors: [command.createGenericError(error: .pinInputCancelled)]), CommandProcessingMetaData(timestamp: Date()))
            })

        // If the command conforms to `CommandProtocol` the command will be immediately send
        case let commandType as CommandProtocol:
            let requestId = UUID().uuidString
            let commandData = commandType.serialize(with: selectedFinOrVin, requestId: requestId)
            self.send(command: command,
					  serializedCommand: commandData,
					  requestId: requestId,
					  vin: selectedFinOrVin,
					  completion: completion)
            
        default:
            completion(.failed(errors: [command.createGenericError(error: .commandUnavailable)]), CommandProcessingMetaData(timestamp: Date()))
        }
    }
	
	public func sendLogoutMessage() {
		
		guard let logoutMessage = protoMessageParser.createLogoutMessage() else {
			return
		}
		
		Socket.service.send(data: logoutMessage) {
			LOG.D("send logout message")
		}
	}
	
	public func update(reconnectManually: Bool) {

		let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
		tokenProvider.refreshTokenIfNeeded { (result) in
			
			switch result {
			case .failure:
                NotificationCenter.default.post(name: Notification.Name.didConnectionLost, object: nil)
				
			case .success(let token):
				let socketToken = SocketToken(accessToken: token.accessToken,
											  expiredDate: token.expirationDate)
				Socket.service.update(socketToken: socketToken,
									  needsReconnect: true,
									  reconnectManually: reconnectManually)
			}
		}
	}
	
	public func updateObservables() {
		
		let vehicleStatusModel = self.caching.getCurrentStatus()
		self.updateObservables(vehicleStatusModel: vehicleStatusModel,
							   for: SocketUpdateType.allCases,
							   withNotification: true)
	}
    
    public func updateObservablesWithoutNotifyObserver() {
		
		let vehicleStatusModel = self.caching.getCurrentStatus()
		self.updateObservables(vehicleStatusModel: vehicleStatusModel,
							   for: SocketUpdateType.allCases,
							   withNotification: false)
    }
	
	public func unregister(token: MyCarSocketNotificationToken?) {
		self.unregister(token: token, includesDisconnet: false)
	}
	
	public func unregisterAndDisconnectIfPossible(token: MyCarSocketNotificationToken?) {
		self.unregister(token: token, includesDisconnet: true)
	}
	
	
	// MARK: - Helper
	
	private func ackServiceActivation(serviceStatusUpdate: VehicleServicesStatusUpdateModel) {
		
		guard let clientMessageData = serviceStatusUpdate.clientMessageData else {
			return
		}
		
		Socket.service.send(data: clientMessageData) {
			LOG.D("sent service activation ack with sequence number: \(serviceStatusUpdate.sequenceNumber)")
		}
	}
	
	private func addCacheOperation(with vehicleStatusDTO: VehicleStatusDTO) {
		
		let vepCacheOperation = VepCacheOperation(vehicleStatusDTO: vehicleStatusDTO, writeCompleted: { [weak self] (vehicleStatusTupel, updatedVin) in
			
			if CarKit.selectedFinOrVin == updatedVin {
				self?.updateObservables(vehicleStatusModel: vehicleStatusTupel.model,
										for: vehicleStatusTupel.updates,
										withNotification: true)
			}
		}, notifySocketHandler: { [weak self] (data, sequenceNumber) in
			self?.notifySocket(data: data, sequenceNumber: sequenceNumber)
		})
		
		self.vepRealmQueue.addOperation(vepCacheOperation)
	}
	
	private func addCacheOperations(with vehicleStatusDTOs: [VehicleStatusDTO]) {
		
		let vepCacheOperations: [VepCacheOperation] = vehicleStatusDTOs.map {
			return VepCacheOperation(vehicleStatusDTO: $0, writeCompleted: { [weak self] (vehicleStatusTupel, updatedVin) in
				
				if CarKit.selectedFinOrVin == updatedVin {
					self?.updateObservables(vehicleStatusModel: vehicleStatusTupel.model,
											for: vehicleStatusTupel.updates,
											withNotification: true)
				}
			}, notifySocketHandler: nil)
		}
		
		vepCacheOperations.last?.set(notifySocketHandler: { [weak self] (data, sequenceNumber) in
			self?.notifySocket(data: data, sequenceNumber: sequenceNumber)
		})
		
		self.vepRealmQueue.addOperations(vepCacheOperations, waitUntilFinished: false)
	}
	
	private func handle(assignedVehicles: AssignedVehiclesModel) {
		
		let cachedFinOrVins = self.dbVehicleStore.fetch().map { $0.finOrVin }
		if assignedVehicles.vins.difference(from: cachedFinOrVins).isEmpty {
			
			if let data = assignedVehicles.clientMessageData {
				Socket.service.send(data: data) {
					LOG.D("sent assigned vehicles ack")
				}
			}
		} else {
			
            self.vehicleServiceCarKit.fetchVehicles(completion: { _ in
				
				if let data = assignedVehicles.clientMessageData {
					Socket.service.send(data: data) {
						LOG.D("sent assigned vehicles ack")
					}
				}
			}, needsVehicleSelectionUpdate: { (selectedVin) in
				
				if CarKit.selectedFinOrVin != selectedVin {
					
					let vehicleSelectionModel = VehicleSelectionModel(finOrVin: selectedVin)
					self.dbVehicleSelectionStore.save(vehicleSelection: vehicleSelectionModel) { _ in
						
					}
				}
			})
		}
	}
	
	private func handle(authChangedUpdateModel: VehicleUpdatedModel) {

		NotificationCenter.default.post(name: NSNotification.Name.didUserVehicleAuthChangedUpdate, object: nil)
		
        self.vehicleServiceCarKit.fetchVehicles(completion: { _ in

            if let data = authChangedUpdateModel.clientMessageData {
                Socket.service.send(data: data) {
                    LOG.D("send vehicle auth changed ack with sequence number: \(authChangedUpdateModel.sequenceNumber)")
                }
            }
		}, needsVehicleSelectionUpdate: { [weak self] (selectedVin) in
			
			if CarKit.selectedFinOrVin != selectedVin {
				
				let vehicleSelectionModel = VehicleSelectionModel(finOrVin: selectedVin)
				self?.dbVehicleSelectionStore.save(vehicleSelection: vehicleSelectionModel) { _ in
					
				}
			}
			
			self?.servicesService.fetchVehicleServices(finOrVin: selectedVin, groupedOption: .categoryName, requestsMissingData: false, services: nil) { (result) in
				
				switch result {
				case .failure:	LOG.E("fetch services: error after vehicle auth changed message")
				case .success:	LOG.D("fetch services: success after vehicle auth changed message")
				}
			}
		})
	}
	
	private func handle(newCommandStatus: VehicleCommandStatusUpdateModel) {
		
		newCommandStatus.requestIDs.forEach { (requestID) in
			
			defer {
				if let data = newCommandStatus.clientMessageData {
					Socket.service.send(data: data) {
						LOG.D("sent vehicle api command ack with sequence number: \(newCommandStatus.sequenceNumber)")
					}
				}
			}
			
			guard let savedCommandRequestModel = VehicleCommandRequestService.commandRequestModelFor(uuid: requestID) else {
				return
			}
			
			savedCommandRequestModel.callCompletion()
			
			guard let state = savedCommandRequestModel.commandState else {
				return
			}
			
			switch state {
			case .unknownCommandState, .finished, .failed, .UNRECOGNIZED:
				VehicleCommandRequestService.remove(for: savedCommandRequestModel.requestId)
				
			default:
				break
			}
		}
	}
	
	private func handle(connectionState: SocketConnectionState) {
		
		let newSocketConnectionState: MyCarSocketConnectionState = {
			switch connectionState {
			case .closed:								return .closed
			case .connected:							return .connected
			case .connecting:							return .connecting
			case .connectionLost(let needsTokenUpdate):	return .connectionLost(needsTokenUpdate: needsTokenUpdate)
			case .disconnected:							return .disconnected
			}
		}()
		
		self.myCarSocketConnectionState = newSocketConnectionState
	}
	
	private func handle(receiveData: Data) {
		
		LOG.D("my car module receive data")
		self.protoMessageParser.parse(data: receiveData) { [weak self] (messageType) in
			
			switch messageType {
			case .assignedVehicles(let model):				self?.handle(assignedVehicles: model)
			case .vehicleCommandStatusUpdate(let model): 	self?.handle(newCommandStatus: model)
			case .debugMessage(let message):				self?.socketObservable.debugMessage.value = message
			case .pendingCommands(let data):				self?.handle(pendingCommandsData: data)
			case .serviceUpdate(let model):					self?.handle(servicesStatusUpdate: [model])
			case .serviceUpdates(let models):				self?.handle(servicesStatusUpdate: models)
			case .vehicleUpdate(let model):					self?.handle(authChangedUpdateModel: model)
			case .vepUpdate(let model):						self?.addCacheOperation(with: model)
			case .vepUpdates(let models):					self?.addCacheOperations(with: models)
			}
		}
	}
	
	private func handle(pendingCommandsData: Data) {
		
		Socket.service.send(data: pendingCommandsData) {
			LOG.D("send pending commands response")
		}
	}
	
	private func handle(servicesStatusUpdate: [VehicleServicesStatusUpdateModel]) {
		
		self.dbVehicleServiceStoreCarKit.setPendingType(services: servicesStatusUpdate) { [weak self] in
			
			let dispatchGroup = DispatchGroup()
			
			servicesStatusUpdate.forEach { (serviceStatusUpdate) in
				
				let requestedServices = serviceStatusUpdate.services.compactMap { (service) -> Int? in
					
					let relevantStatus: [ServiceActivationStatus] = [.active, .activationPending, .deactivationPending, .inactive]
					guard relevantStatus.contains(service.status) else {
						return nil
					}
					return service.id
				}
				
				guard requestedServices.isEmpty == false else {
					return
				}
				
				dispatchGroup.enter()
				CarKit.servicesService.fetchVehicleServices(finOrVin: serviceStatusUpdate.finOrVin, groupedOption: .categoryName, requestsMissingData: false, services: requestedServices, completion: { (result) in
					
                    switch result {
                    case .success:				LOG.D("update service status after activation")
                    case .failure(let error):	LOG.E("update service status error after activation: \(error.localizedDescription ?? "No description")")
                    }
                    
					dispatchGroup.leave()
				})
			}
			
			dispatchGroup.notify(queue: .main, execute: { [weak self] in
				
				guard let serviceStatusUpdate = servicesStatusUpdate.first else {
					return
				}
				self?.ackServiceActivation(serviceStatusUpdate: serviceStatusUpdate)
			})
		}
	}
	
	private func trackCommand<T: BaseCommandProtocol>(command: T, vin: String) {
		switch command {
		case is Command.AuxHeatConfigure:
			trackingManager.track(event: MyCarTrackingEvent.configureAuxHeat(fin: vin, state: .initiation, condition: ""))

		case is Command.AuxHeatStart:
			trackingManager.track(event: MyCarTrackingEvent.startAuxHeat(fin: vin, state: .initiation, condition: ""))

		case is Command.AuxHeatStop:
			trackingManager.track(event: MyCarTrackingEvent.stopAuxHeat(fin: vin, state: .initiation, condition: ""))

		case is Command.DoorsUnlock:
			trackingManager.track(event: MyCarTrackingEvent.doorUnlock(fin: vin, state: .initiation, condition: ""))

		case is Command.EngineStart:
			trackingManager.track(event: MyCarTrackingEvent.engineStart(fin: vin, state: .initiation, condition: ""))

		case is Command.EngineStop:
			trackingManager.track(event: MyCarTrackingEvent.engineStop(fin: vin, state: .initiation, condition: ""))

		case is Command.SunroofOpen:
			trackingManager.track(event: MyCarTrackingEvent.openSunroof(fin: vin, state: .initiation, condition: ""))

		case is Command.SunroofClose:
			trackingManager.track(event: MyCarTrackingEvent.closeSunroof(fin: vin, state: .initiation, condition: ""))

		case is Command.SunroofLift:
			trackingManager.track(event: MyCarTrackingEvent.liftSunroof(fin: vin, state: .initiation, condition: ""))

		case is Command.WindowsOpen:
			trackingManager.track(event: MyCarTrackingEvent.openWindow(fin: vin, state: .initiation, condition: ""))

		case is Command.WindowsClose:
			trackingManager.track(event: MyCarTrackingEvent.closeWindow(fin: vin, state: .initiation, condition: ""))

		case is Command.TheftAlarmConfirmDamageDetection:
			trackingManager.track(event: MyCarTrackingEvent.theftAlarmConfirmDamageDetection(fin: vin, state: .initiation, condition: ""))

		case is Command.TheftAlarmDeselectDamageDetection:
			trackingManager.track(event: MyCarTrackingEvent.theftAlarmDeselectDamageDetection(fin: vin, state: .initiation, condition: ""))

		case is Command.TheftAlarmDeselectInterior:
			trackingManager.track(event: MyCarTrackingEvent.theftAlarmDeselectInterior(fin: vin, state: .initiation, condition: ""))

		case is Command.TheftAlarmDeselectTow:
			trackingManager.track(event: MyCarTrackingEvent.theftAlarmDeselectTow(fin: vin, state: .initiation, condition: ""))

		case is Command.TheftAlarmSelectDamageDetection:
			trackingManager.track(event: MyCarTrackingEvent.theftAlarmSelectDamageDetection(fin: vin, state: .initiation, condition: ""))

		case is Command.TheftAlarmSelectInterior:
			trackingManager.track(event: MyCarTrackingEvent.theftAlarmSelectInterior(fin: vin, state: .initiation, condition: ""))

		case is Command.TheftAlarmSelectTow:
			trackingManager.track(event: MyCarTrackingEvent.theftAlarmSelectTow(fin: vin, state: .initiation, condition: ""))

		case is Command.TheftAlarmStart:
			trackingManager.track(event: MyCarTrackingEvent.theftAlarmStart(fin: vin, state: .initiation, condition: ""))

		case is Command.TheftAlarmStop:
			trackingManager.track(event: MyCarTrackingEvent.theftAlarmStop(fin: vin, state: .initiation, condition: ""))

		default:
			print("No tracking for command \(command)")
		}
	}
	
	private func send<T>(
		command: T,
		serializedCommand: Data?,
		requestId: String,
		vin: String,
		completion: @escaping CarKit.CommandUpdateCallback<T.Error>) where T: BaseCommandProtocol, T: CommandTypeProtocol {

		guard let serializeCommand = serializedCommand else {
			completion(.failed(errors: [command.createGenericError(error: .unknownError(message: "Command serialization failed"))]), CommandProcessingMetaData(timestamp: Date()))
			return
		}

		guard Socket.service.isConnected == true else {
			completion(.failed(errors: [command.createGenericError(error: .noInternetConnection)]), CommandProcessingMetaData(timestamp: Date()))
			return
		}

		self.trackCommand(command: command, vin: vin)

		let commandRequestModel = VehicleCommandRequestModel<T>(completion: completion,
																requestId: requestId,
																command: command,
																vin: vin,
																fullStatus: nil)

		let timeout = DispatchWorkItem(block: {
			commandRequestModel.handleTimeout()
		})

		DispatchQueue.main.asyncAfter(deadline: .now() + Constants.SendCommandTimeout, execute: timeout)

        completion(.updated(state: .commandIsAboutToSend), CommandProcessingMetaData(timestamp: Date()))
        
		Socket.service.send(data: serializeCommand, completion: {
			DispatchQueue.main.sync {

				LOG.D("send vehicle command request: \(command)")

				VehicleCommandRequestService.set(commandRequestModel: commandRequestModel)

				timeout.cancel()
			}
		})
	}
	
	private func update<T>(observable: WriteObservable<T>, with model: T, notify: Bool) {
		
		if notify {
			observable.value = model
		} else {
			observable.updateWithoutNotifyObserver(value: model)
		}
	}
	
	private func updateObservables(vehicleStatusModel: VehicleStatusModel, for updateTypes: [SocketUpdateType], withNotification: Bool) {
		
		updateTypes.forEach {
			
            switch $0 {
            case .auxheat:		self.update(observable: self.socketObservable.vepAuxheat, with: vehicleStatusModel.auxheat, notify: withNotification)
            case .drivingMode:  self.update(observable: self.socketObservable.vepDrivingMode, with: vehicleStatusModel.drivingMode, notify: withNotification)
            case .doors:		self.update(observable: self.socketObservable.vepDoors, with: vehicleStatusModel.doors, notify: withNotification)
            case .ecoScore:		self.update(observable: self.socketObservable.vepEcoScroe, with: vehicleStatusModel.ecoScore, notify: withNotification)
            case .engine:		self.update(observable: self.socketObservable.vepEngine, with: vehicleStatusModel.engine, notify: withNotification)
            case .eventTime:	self.update(observable: self.socketObservable.vepEventTime, with: vehicleStatusModel.eventTimestamp, notify: withNotification)
            case .hu:			self.update(observable: self.socketObservable.vepHu, with: vehicleStatusModel.hu, notify: withNotification)
            case .location:		self.update(observable: self.socketObservable.vepLocation, with: vehicleStatusModel.location, notify: withNotification)
            case .statistics:	self.update(observable: self.socketObservable.vepStatistics, with: vehicleStatusModel.statistics, notify: withNotification)
            case .status:		self.update(observable: self.socketObservable.vepStatus, with: vehicleStatusModel, notify: withNotification)
            case .tank:			self.update(observable: self.socketObservable.vepTank, with: vehicleStatusModel.tank, notify: withNotification)
            case .theft:		self.update(observable: self.socketObservable.vepTheft, with: vehicleStatusModel.theft, notify: withNotification)
            case .tires:		self.update(observable: self.socketObservable.vepTires, with: vehicleStatusModel.tires, notify: withNotification)
            case .vehicle:		self.update(observable: self.socketObservable.vepVehicle, with: vehicleStatusModel.vehicle, notify: withNotification)
            case .warnings:		self.update(observable: self.socketObservable.vepWarnings, with: vehicleStatusModel.warnings, notify: withNotification)
            case .windows:		self.update(observable: self.socketObservable.vepWindows, with: vehicleStatusModel.windows, notify: withNotification)
            case .zev:			self.update(observable: self.socketObservable.vepZEV, with: vehicleStatusModel.zev, notify: withNotification)
            }
		}
	}
	
	private func notifySocket(data: Data?, sequenceNumber: Int32?) {
		
		guard let data = data,
			let sequenceNumber = sequenceNumber else {
				return
		}
		
		Socket.service.send(data: data) { [weak self] in
			LOG.D("send sequence number: \(sequenceNumber)")
			
			self?.socketObservable.sequnce.value = sequenceNumber
		}
	}
	
	private func unregister(token: MyCarSocketNotificationToken?, includesDisconnet: Bool) {
		
		guard let token = token,
			let index = self.notificationTokens.firstIndex(where: { $0 == token }) else {
				return
		}
		
		self.notificationTokens.remove(at: index)
		
		if includesDisconnet {
			
			if self.notificationTokens.isEmpty {
				
				Socket.service.unregisterAndDisconnectIfPossible(connectionToken: self.socketConnectionToken,
																 receiveDataToken: self.socketReceiveDataToken)
				
				self.socketConnectionToken = nil
				self.socketReceiveDataToken = nil
			}
		}
	}
}

// swiftlint:enable type_body_length
