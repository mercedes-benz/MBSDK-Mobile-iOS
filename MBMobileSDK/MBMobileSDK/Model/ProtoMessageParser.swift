//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import SwiftProtobuf
import MBCommonKit
#if canImport(MBCommonKitTracking)
import MBCommonKitTracking
#endif

// swiftlint:disable function_body_length
// swiftlint:disable type_body_length

class ProtoMessageParser {
	
	// MARK: Typealias
	typealias CommandRequestTriple = (data: Data?, requestId: String, vin: String)
	typealias ParseCompletion = (MessageType) -> Void
	
	// MARK: Enum
	enum MessageType {
		case assignedVehicles(model: AssignedVehiclesModel)
		case vehicleCommandStatusUpdate(model: VehicleCommandStatusUpdateModel)
		case debugMessage(message: String)
		case pendingCommands(data: Data)
		case serviceUpdate(model: VehicleServicesStatusUpdateModel)
		case serviceUpdates(models: [VehicleServicesStatusUpdateModel])
		case vehicleUpdate(model: VehicleUpdatedModel)
		case vepUpdate(model: VehicleStatusDTO)
		case vepUpdates(models: [VehicleStatusDTO])
	}
	
	// MARK: Properties
	private var parseCompletion: ParseCompletion?
    private let trackingManager: TrackingManager
    
    convenience init() {
        self.init(trackingManager: MBTrackingManager.shared)
    }
    
    init(trackingManager: TrackingManager) {
        self.trackingManager = trackingManager
    }


	// MARK: - Public
	
	func createLogoutMessage() -> Data? {
		
		let clientMessage = Proto_ClientMessage.with {
			$0.logout = Proto_Logout()
		}
		
		return ProtoMessageParser.serialized(clientMessage: clientMessage)
	}
	
	func parse(data: Data, completion: ParseCompletion?) {
		
		self.parseCompletion = completion
		self.handle(message: try? Proto_PushMessage(serializedData: data))
	}
	
	
	// MARK: - Helper
	
	private func createAcknowledgeAbilityToGetVehicleMasterDataFromRestAPI(with sequenceNumber: Int32) -> Data? {
		
		let acknowledge = Proto_AcknowledgeAbilityToGetVehicleMasterDataFromRestAPI.with {
			$0.sequenceNumber = sequenceNumber
		}
		let clientMessage = Proto_ClientMessage.with {
			$0.acknowledgeAbilityToGetVehicleMasterDataFromRestApi = acknowledge
		}
		
		return ProtoMessageParser.serialized(clientMessage: clientMessage)
	}
	
	private func createAcknowledgeAppTwinCommandStatusUpdatesClientMessage(with sequenceNumber: Int32) -> Data? {
		
		let acknowledge = Proto_AcknowledgeAppTwinCommandStatusUpdatesByVIN.with {
			$0.sequenceNumber = sequenceNumber
		}
		let clientMessage = Proto_ClientMessage.with {
			$0.acknowledgeApptwinCommandStatusUpdateByVin = acknowledge
		}
		
		return ProtoMessageParser.serialized(clientMessage: clientMessage)
	}
	
	private func createAcknowledgeAssignedVehicles() -> Data? {
		
		let acknowledge = Proto_AcknowledgeAssignedVehicles()
		let clientMessage = Proto_ClientMessage.with {
			$0.acknowledgeAssignedVehicles = acknowledge
		}
		
		return ProtoMessageParser.serialized(clientMessage: clientMessage)
	}
	
	private func createAcknowledgePreferredDealerChangeClientMessage(with sequenceNumber: Int32) -> Data? {
		
		let acknowledge = Proto_AcknowledgePreferredDealerChange.with {
			$0.sequenceNumber = sequenceNumber
		}
		let clientMessage = Proto_ClientMessage.with {
			$0.acknowledgePreferredDealerChange = acknowledge
		}
		
		return ProtoMessageParser.serialized(clientMessage: clientMessage)
	}
	
	private func createAcknowledgeServiceStatusUpdateClientMessage(with sequenceNumber: Int32) -> Data? {
		
		let acknowledge = Proto_AcknowledgeServiceStatusUpdate.with {
			$0.sequenceNumber = sequenceNumber
		}
		let clientMessage = Proto_ClientMessage.with {
			$0.acknowledgeServiceStatusUpdate = acknowledge
		}
		
		return ProtoMessageParser.serialized(clientMessage: clientMessage)
	}
	
	private func createAcknowledgeServiceStatusUpdatesClientMessage(with sequenceNumber: Int32) -> Data? {
		
		let acknowledge = Proto_AcknowledgeServiceStatusUpdatesByVIN.with {
			$0.sequenceNumber = sequenceNumber
		}
		let clientMessage = Proto_ClientMessage.with {
			$0.acknowledgeServiceStatusUpdatesByVin = acknowledge
		}
		
		return ProtoMessageParser.serialized(clientMessage: clientMessage)
	}
	
	private func createAcknowledgeVehicleUpdateClientMessage(with sequenceNumber: Int32) -> Data? {

		let acknowledge = Proto_AcknowledgeVehicleUpdated.with {
			$0.sequenceNumber = sequenceNumber
		}
		let clientMessage = Proto_ClientMessage.with {
			$0.acknowledgeVehicleUpdated = acknowledge
		}

		return ProtoMessageParser.serialized(clientMessage: clientMessage)
	}
	
	private func createAcknowledgeVEPClientMessage(with sequenceNumber: Int32) -> Data? {
		
		let acknowledge = Proto_AcknowledgeVEPRequest.with {
			$0.sequenceNumber = sequenceNumber
		}
		let clientMessage = Proto_ClientMessage.with {
			$0.acknowledgeVepRequest = acknowledge
		}
		
		return ProtoMessageParser.serialized(clientMessage: clientMessage)
	}
	
	private func createAcknowledgeVEPByVINClientMessage(with sequenceNumber: Int32) -> Data? {
		
		let acknowledge = Proto_AcknowledgeVEPUpdatesByVIN.with {
			$0.sequenceNumber = sequenceNumber
		}
		let clientMessage = Proto_ClientMessage.with {
			$0.acknowledgeVepUpdatesByVin = acknowledge
		}
		
		return ProtoMessageParser.serialized(clientMessage: clientMessage)
	}
	
	private func createDTO(clientMessageData: Data?, vepUpdate: Proto_VEPUpdate) -> VehicleStatusDTO {
		
		let statusUpdateModel = self.map(vepUpdate: vepUpdate, clientMessageData: clientMessageData)
		
		if CarKit.selectedFinOrVin == vepUpdate.vin {
			LOG.D(statusUpdateModel.debugDescription)
		}
		
		return statusUpdateModel
	}
	
	private func createEmptyDTO(clientMessageData: Data?, vepUpdate: Proto_VEPUpdate) -> VehicleStatusDTO {
		
		let vehicleStatusDTO = VehicleStatusDTO(fullUpdate: vepUpdate.fullUpdate,
												sequenceNumber: vepUpdate.sequenceNumber,
												vin: vepUpdate.vin)
		vehicleStatusDTO.clientMessageData = clientMessageData
		return vehicleStatusDTO
	}
	
	private func handle(assignedVehicles: Proto_AssignedVehicles) {
		LOG.D("assigned vehicles message: \(assignedVehicles.vins.joined(separator: ", "))")
		
		let clientMessageData = self.createAcknowledgeAssignedVehicles()
		let assignedVehicles = AssignedVehiclesModel(clientMessageData: clientMessageData,
													 vins: assignedVehicles.vins)
			
		self.parseCompletion?(.assignedVehicles(model: assignedVehicles))
	}
	
	private func handle(debugMessage: Proto_DebugMessage) {
		LOG.D("debug message: \(debugMessage.message)")
		
		self.parseCompletion?(.debugMessage(message: debugMessage.message))
	}
	
	private func handle(message: Proto_PushMessage?) {
		
		guard let msg = message?.msg else {
			LOG.D("no valid message type...")
			return
		}
		
		LOG.D("receive message...")
		
		switch msg {
		case .apptwinCommandStatusUpdatesByVin(let commandStatusUpdates):		self.handle(commandStatusUpdates: commandStatusUpdates)
		case .apptwinPendingCommandRequest(let pendingCommandsRequest):			self.handle(pendingCommandsRequest: pendingCommandsRequest)
		case .assignedVehicles(let assignedVehicles):							self.handle(assignedVehicles: assignedVehicles)
		case .debugMessage(let debugMessage):									self.handle(debugMessage: debugMessage)
		case .persPinStatusChange:												break
		case .preferredDealerChange(let preferredDealerChange):					self.handle(preferredDealerChange: preferredDealerChange)
		case .serviceStatusUpdate(let serviceStatusUpdate):						self.handle(serviceStatusUpdate: serviceStatusUpdate)
		case .serviceStatusUpdates(let serviceStatusUpdates):					self.handle(serviceStatusUpdates: serviceStatusUpdates)
		case .userDataUpdate:													break
		case .userPictureUpdate:												break
		case .userPinUpdate:													break
		case .userVehicleAuthChangedUpdate(let userVehicleAuthChangedUpdate):	self.handle(userVehicleAuthChangedUpdate: userVehicleAuthChangedUpdate)
		case .vehicleUpdated(let vehicleUpdate):								self.handle(vehicleUpdate: vehicleUpdate)
		case .vepUpdate(let vepUpdate):											self.handle(vepUpdate: vepUpdate)
		case .vepUpdates(let vepUpdates):										self.handle(vepUpdates: vepUpdates)
		}
	}
	
	private func handle(commandStatusUpdates: Proto_AppTwinCommandStatusUpdatesByPID, clientMessageData: Data?, sequenceNumber: Int32) {
		
		guard commandStatusUpdates.updatesByPid.isEmpty == false else {
			LOG.D("no vehicle api command status updates for vin \(commandStatusUpdates.vin)")
			return
		}
		
		LOG.D("vehicle api command status update")
		
		// updates that were triggered by the new commands API
		var newUpdates = Proto_AppTwinCommandStatusUpdatesByPID()
		
		commandStatusUpdates.updatesByPid.forEach { (pid, commandStatus: Proto_AppTwinCommandStatus) in
			
			self.track(commandStatus: commandStatus, finOrVin: commandStatusUpdates.vin)
			
			if commandStatus.requestID.isEmpty {
				return
			}
			
			// New commands API
			if let savedRequestModel = VehicleCommandRequestService.commandRequestModelFor(uuid: commandStatus.requestID) {
				
				let newRequestModel = savedRequestModel.updateFullStatus(with: commandStatus)
				VehicleCommandRequestService.set(commandRequestModel: newRequestModel)
				
				newUpdates.updatesByPid[pid] = commandStatus
			}
		}
		
		// New commands API
		if newUpdates.updatesByPid.count > 0 {
			
			let commandStatusUpdateModel = VehicleCommandStatusUpdateModel(requestIDs: newUpdates.updatesByPid.map { $1.requestID },
																		   clientMessageData: clientMessageData,
																		   sequenceNumber: sequenceNumber,
																		   vin: commandStatusUpdates.vin)
			
			if CarKit.selectedFinOrVin == commandStatusUpdates.vin {
				LOG.D(commandStatusUpdateModel)
			}
			
			self.parseCompletion?(.vehicleCommandStatusUpdate(model: commandStatusUpdateModel))
		}
		
		if CarKit.selectedFinOrVin == commandStatusUpdates.vin {
			LOG.D(commandStatusUpdates.updatesByPid)
		}
	}
	
	private func handle(commandStatusUpdates: Proto_AppTwinCommandStatusUpdatesByVIN) {
		LOG.D("vehicle api command status updates: \(commandStatusUpdates)")
		
		let clientMessageData = self.createAcknowledgeAppTwinCommandStatusUpdatesClientMessage(with: commandStatusUpdates.sequenceNumber)
		
		commandStatusUpdates.updatesByVin.forEach { (vin, updatesByPid) in
			
			if vin.isEmpty == false {
				self.handle(commandStatusUpdates: updatesByPid, clientMessageData: clientMessageData, sequenceNumber: commandStatusUpdates.sequenceNumber)
			}
		}
	}
	
	private func handle(pendingCommandsRequest: Proto_AppTwinPendingCommandsRequest) {
		LOG.D("pending commands request")
		
		let pendingCommands = VehicleCommandRequestService.all().map { (commandRequestModel) -> Proto_PendingCommand in
			return Proto_PendingCommand.with {
				
				$0.processID = commandRequestModel.processId
				$0.requestID = commandRequestModel.requestId
				$0.type      = commandRequestModel.commandType
				$0.vin       = commandRequestModel.vin
			}
		}
		
		let message = Proto_AppTwinPendingCommandsResponse.with {
			$0.pendingCommands = pendingCommands
		}
		let clientMessage = Proto_ClientMessage.with {
			$0.apptwinPendingCommandsResponse = message
		}
		
		guard let data = ProtoMessageParser.serialized(clientMessage: clientMessage) else {
			return
		}
		self.parseCompletion?(.pendingCommands(data: data))
	}
	
	private func handle(preferredDealerChange: Proto_PreferredDealerChange) {
		LOG.D("preferred dealer change")
		
		let clientMessageData = self.createAcknowledgePreferredDealerChangeClientMessage(with: preferredDealerChange.sequenceNumber)
		let vehicleUpdatedModel = VehicleUpdatedModel(clientMessageData: clientMessageData,
													  eventTimestamp: preferredDealerChange.emitTimestampInMs,
													  sequenceNumber: preferredDealerChange.sequenceNumber)
		self.parseCompletion?(.vehicleUpdate(model: vehicleUpdatedModel))
	}
	
	private func handle(serviceStatusUpdate: Proto_ServiceStatusUpdate) {
		
		guard serviceStatusUpdate.updates.isEmpty == false else {
			LOG.D("no service status update attributes")
			return
		}
		
		LOG.D("service status update")
		let clientMessageData = self.createAcknowledgeServiceStatusUpdateClientMessage(with: serviceStatusUpdate.sequenceNumber)
		let serviceUpdateGroupModel = self.map(serviceStatusUpdate: serviceStatusUpdate, clientMessageData: clientMessageData)
		
		LOG.D(serviceStatusUpdate.updates)
		LOG.D(serviceUpdateGroupModel)
		
		self.parseCompletion?(.serviceUpdate(model: serviceUpdateGroupModel))
	}
	
	private func handle(serviceStatusUpdates: Proto_ServiceStatusUpdatesByVIN) {
		
		LOG.D("service status updates by vin")
		let clientMessageData = self.createAcknowledgeServiceStatusUpdatesClientMessage(with: serviceStatusUpdates.sequenceNumber)
		let serviceUpdateGroupModels = serviceStatusUpdates.updates.map { (arg) -> VehicleServicesStatusUpdateModel in
			
			let (_, serviceStatusUpdate) = arg
			return self.map(serviceStatusUpdate: serviceStatusUpdate, clientMessageData: clientMessageData)
		}
		
		LOG.D(serviceStatusUpdates.updates)
		LOG.D(serviceUpdateGroupModels)
		
		self.parseCompletion?(.serviceUpdates(models: serviceUpdateGroupModels))
	}
	
	private func handle(userVehicleAuthChangedUpdate: Proto_UserVehicleAuthChangedUpdate) {
		
		LOG.D("user vehicle auth changed update")
		let clientMessageData = self.createAcknowledgeAbilityToGetVehicleMasterDataFromRestAPI(with: userVehicleAuthChangedUpdate.sequenceNumber)
		let vehicleUpdatedModel = VehicleUpdatedModel(clientMessageData: clientMessageData,
													  eventTimestamp: userVehicleAuthChangedUpdate.emitTimestampInMs,
													  sequenceNumber: userVehicleAuthChangedUpdate.sequenceNumber)
		self.parseCompletion?(.vehicleUpdate(model: vehicleUpdatedModel))
	}
	
	private func handle(vehicleUpdate: Proto_VehicleUpdated) {
		
		LOG.D("vehicle update")
		let clientMessageData = self.createAcknowledgeVehicleUpdateClientMessage(with: vehicleUpdate.sequenceNumber)
		let vehicleUpdatedModel = VehicleUpdatedModel(clientMessageData: clientMessageData,
													  eventTimestamp: vehicleUpdate.emitTimestampInMs,
													  sequenceNumber: vehicleUpdate.sequenceNumber)
		self.parseCompletion?(.vehicleUpdate(model: vehicleUpdatedModel))
	}
	
	private func handle(vepUpdate: Proto_VEPUpdate) {
		LOG.D("vep update")
		
		let clientMessageData = self.createAcknowledgeVEPClientMessage(with: vepUpdate.sequenceNumber)
		let statusUpdateModel: VehicleStatusDTO = {
			guard vepUpdate.attributes.isEmpty == false else {
				LOG.D("no vep update attributes")
				return self.createEmptyDTO(clientMessageData: clientMessageData, vepUpdate: vepUpdate)
			}
			return self.createDTO(clientMessageData: clientMessageData, vepUpdate: vepUpdate)
		}()
		
		self.parseCompletion?(.vepUpdate(model: statusUpdateModel))
	}
	
	private func handle(vepUpdates: Proto_VEPUpdatesByVIN) {
		LOG.D("vep updates: \(vepUpdates)")
		
		let clientMessageData = self.createAcknowledgeVEPByVINClientMessage(with: vepUpdates.sequenceNumber)
		let statusUpdateModels: [VehicleStatusDTO] = vepUpdates.updates.compactMap { (vin, vepUpdate) -> VehicleStatusDTO? in
			
			guard vin.isEmpty == false,
				vepUpdate.attributes.isEmpty == false else {
					return self.createEmptyDTO(clientMessageData: clientMessageData, vepUpdate: vepUpdate)
			}
			
			return self.createDTO(clientMessageData: clientMessageData, vepUpdate: vepUpdate)
		}
		
		self.parseCompletion?(.vepUpdates(models: statusUpdateModels))
	}
	
	private class func serialized(commandRequest: Proto_CommandRequest) -> Data? {
		
		let clientMessage = Proto_ClientMessage.with {
			$0.commandRequest = commandRequest
		}
		
		return ProtoMessageParser.serialized(clientMessage: clientMessage)
	}
	
	private class func serialized(clientMessage: Proto_ClientMessage) -> Data? {
		
		do {
			return try clientMessage.serializedData()
		} catch {
			LOG.E("error: serialized client message")
		}
		
		return nil
	}
	
	private func track(commandStatus: Proto_AppTwinCommandStatus, finOrVin: String) {
		
		let myCarTrackingEvent: MyCarTrackingEvent? = {
			switch commandStatus.type {
			case .auxheatConfigure:	return .configureAuxHeat(fin: finOrVin, state: self.map(commandState: commandStatus.state), condition: "")
			case .auxheatStart:		return .startAuxHeat(fin: finOrVin, state: self.map(commandState: commandStatus.state), condition: "")
			case .auxheatStop:		return .stopAuxHeat(fin: finOrVin, state: self.map(commandState: commandStatus.state), condition: "")
			case .doorsLock:		return .doorLock(fin: finOrVin, state: self.map(commandState: commandStatus.state), condition: "")
			case .doorsUnlock:		return .doorUnlock(fin: finOrVin, state: self.map(commandState: commandStatus.state), condition: "")
			case .engineStart:		return .engineStart(fin: finOrVin, state: self.map(commandState: commandStatus.state), condition: "")
			case .engineStop:		return .engineStop(fin: finOrVin, state: self.map(commandState: commandStatus.state), condition: "")
			case .roofclose:		return .closeSunroof(fin: finOrVin, state: self.map(commandState: commandStatus.state), condition: "")
			case .rooflift:			return .liftSunroof(fin: finOrVin, state: self.map(commandState: commandStatus.state), condition: "")
			case .roofopen:			return .openSunroof(fin: finOrVin, state: self.map(commandState: commandStatus.state), condition: "")
			case .windowclose:		return .closeWindow(fin: finOrVin, state: self.map(commandState: commandStatus.state), condition: "")
			case .windowopen:		return .openWindow(fin: finOrVin, state: self.map(commandState: commandStatus.state), condition: "")
			default:				return nil
			}
		}()

		guard let trackingEvent = myCarTrackingEvent else {
			return
		}

        trackingManager.track(event: trackingEvent)

	}
	
	
	// MARK: - BusinessModel
    
	private func dayTime<T: RawRepresentable>(for attributeStatus: Proto_VehicleAttributeStatus?) -> VehicleStatusAttributeModel<[DayTimeModel], T>? where T.RawValue == Int {
		
		guard let attribute = attributeStatus else {
			return nil
		}
		
		let dayTimeArray: [DayTimeModel] = attribute.weeklySettingsHeadUnitValue.weeklySettings.compactMap {
			
			guard let day = Day(rawValue: Int($0.day)) else {
				return nil
			}
			return DayTimeModel(day: day, time: Int($0.minutesSinceMidnight))
		}
		
		return VehicleStatusAttributeModel<[DayTimeModel], T>(status: attribute.status,
															  timestampInMs: attribute.timestampInMs,
															  unit: nil,
															  value: dayTimeArray)
	}
	
	private func map(commandState: Proto_VehicleAPI.CommandState) -> CommandState {
		switch commandState {
		case .enqueued:				return .enqueued
		case .failed:				return .failed
		case .finished:				return .finished
		case .initiation:			return .initiation
		case .processing:			return .processing
		case .unknownCommandState:	return .unknown
		case .UNRECOGNIZED:			return .unknown
		case .waiting:				return .waiting
		}
	}
	
	private func map(serviceStatusUpdate: Proto_ServiceStatusUpdate, clientMessageData: Data?) -> VehicleServicesStatusUpdateModel {
		
		let services = serviceStatusUpdate.updates.map { (arg) -> VehicleServiceStatusUpdateModel in
			
			let (key, value) = arg
			return VehicleServiceStatusUpdateModel(id: Int(key),
												   status: self.map(status: value))
		}
		
		return VehicleServicesStatusUpdateModel(clientMessageData: clientMessageData,
												finOrVin: serviceStatusUpdate.vin,
												sequenceNumber: serviceStatusUpdate.sequenceNumber,
												services: services)
	}
	
	private func map(status: Proto_ServiceStatus) -> ServiceActivationStatus {
		
		switch status {
		case .activationPending:	return .activationPending
		case .active:				return .active
		case .deactivationPending:	return .deactivationPending
		case .inactive:				return .inactive
		case .unknown:				return .unknown
		case .UNRECOGNIZED:			return .unknown
		}
	}
	
	private func map(vepUpdate: Proto_VEPUpdate, clientMessageData: Data?) -> VehicleStatusDTO {
		
		let dto = VehicleStatusDTO(fullUpdate: vepUpdate.fullUpdate,
								   sequenceNumber: vepUpdate.sequenceNumber,
								   vin: vepUpdate.vin)
		
		dto.acChargingCurrentLimitation = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.acChargingCurrentLimitation])
		dto.auxheatActive = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.auxheatActive])
		dto.auxheatRuntime = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.auxheatRuntime])
		dto.auxheatState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.auxheatStatus])
		dto.auxheatTime1 = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.auxheatTime1])
		dto.auxheatTime2 = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.auxheatTime2])
		dto.auxheatTime3 = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.auxheatTime3])
		dto.auxheatTimeSelection = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.auxheatTimeSelection])
		dto.auxheatWarnings = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.auxheatWarnings])
		dto.averageSpeedReset = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.averageSpeedReset])
		dto.averageSpeedStart = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.averageSpeedStart])
		dto.bidirectionalChargingActive = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.bidirectionalChargingActive])
		dto.chargeCouplerACLockStatus = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.chargeCouplerACLockStatus])
		dto.chargeCouplerACStatus = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.chargeCouplerACStatus])
		dto.chargeCouplerDCLockStatus = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.chargeCouplerDCLockStatus])
		dto.chargeCouplerDCStatus = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.chargeCouplerDCStatus])
        dto.chargePrograms = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.chargePrograms])
		dto.chargeFlapACStatus = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.chargeFlapACStatus])
		dto.chargeFlapDCStatus = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.chargeFlapDCStatus])
		dto.chargingActive = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.chargingActive])
		dto.chargingBreakClockTimer = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.chargingBreakClockTimer])
		dto.chargingErrorDetails = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.chargingErrorDetails])
		dto.chargingErrorInfrastructure = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.chargingErrorInfrastructure])
		dto.chargingErrorWim = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.chargingErrorWim])
		dto.chargingMode = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.chargingMode])
		dto.chargingPower = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.chargingPower])
		dto.chargingPowerControl = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.chargingPowerControl])
		dto.chargingPowerEcoLimit = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.chargingPowerEcoLimit])
		dto.chargingStatus = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.chargingStatus])
		dto.chargingTimeType = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.chargingTimeType])
		dto.clientMessageData = clientMessageData
		dto.decklidLockState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.doorLockStatusDecklid])
		dto.decklidState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.decklidStatus])
		dto.departureTime = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.departureTime])
		dto.departureTimeIcon = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.departureTimeIcon])
		dto.departureTimeMode = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.departureTimeMode])
		dto.departureTimeSoc = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.departureTimeSoc])
		dto.departureTimeWeekday = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.departureTimeWeekday])
		dto.distanceElectricalReset = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.distanceElectricalReset])
		dto.distanceElectricalStart = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.distanceElectricalStart])
		dto.distanceGasReset = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.distanceGasReset])
		dto.distanceGasStart = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.distanceGasStart])
		dto.distanceReset = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.distanceReset])
		dto.distanceStart = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.distanceStart])
		dto.distanceZEReset = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.distanceZEReset])
		dto.distanceZEStart = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.distanceZEStart])
		dto.doorFrontLeftLockState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.doorLockStatusFrontLeft])
		dto.doorFrontLeftState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.doorStatusFrontLeft])
		dto.doorFrontRightLockState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.doorLockStatusFrontRight])
		dto.doorFrontRightState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.doorStatusFrontRight])
		dto.doorLockStatusGas = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.doorLockStatusGas])
		dto.doorLockStatusOverall = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.doorLockStatusOverall])
		dto.doorLockStatusVehicle = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.doorLockStatusVehicle])
		dto.doorRearLeftLockState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.doorLockStatusRearLeft])
		dto.doorRearLeftState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.doorStatusRearLeft])
		dto.doorRearRightLockState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.doorLockStatusRearRight])
		dto.doorRearRightState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.doorStatusRearRight])
		dto.doorStatusOverall = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.doorStatusOverall])
		dto.drivenTimeReset = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.drivenTimeReset])
		dto.drivenTimeStart = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.drivenTimeStart])
		dto.drivenTimeZEReset = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.drivenTimeZEReset])
		dto.drivenTimeZEStart = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.drivenTimeZEStart])
		dto.ecoScoreAccel = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.ecoScoreAccel])
		dto.ecoScoreBonusRange = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.ecoScoreBonusRange])
		dto.ecoScoreConst = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.ecoScoreConst])
		dto.ecoScoreFreeWhl = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.ecoScoreFreeWhl])
		dto.ecoScoreTotal = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.ecoScoreTotal])
		dto.electricConsumptionReset = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.electricConsumptionReset])
		dto.electricConsumptionStart = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.electricConsumptionStart])
		dto.electricalRangeSkipIndication = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.electricalRangeSkipIndication])
		dto.endOfChargeTime = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.endOfChargeTime])
		dto.endOfChargeTimeRelative = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.endOfChargeTimeRelative])
		dto.endOfChargeTimeWeekday = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.endOfChargeTimeWeekday])
		dto.engineHoodStatus = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.engineHoodStatus])
		dto.engineState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.engineState])
		dto.eventTimestamp = vepUpdate.emitTimestampInMs
		dto.evRangeAssistDriveOnSoc = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.evRangeAssistDriveOnSoc])
		dto.evRangeAssistDriveOnTime = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.evRangeAssistDriveOnTime])
		dto.filterParticleLoading = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.filterParticleLoading])
		dto.flipWindowStatus = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.flipWindowStatus])
		dto.gasConsumptionReset = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.gasConsumptionReset])
		dto.gasConsumptionStart = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.gasConsumptionStart])
		dto.hybridWarnings = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.hybridWarnings])
		dto.ignitionState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.ignitionState])
		dto.interiorProtectionSensorStatus = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.interiorProtectionSensorStatus])
        dto.keyActivationState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.keyActivationState])
		dto.languageHU = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.languageHU])
		dto.lastParkEvent = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.lastParkEvent])
		dto.lastParkEventNotConfirmed = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.lastParkEventNotConfirmed])
		dto.lastTheftWarning = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.lastTheftWarning])
		dto.lastTheftWarningReason = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.lastTheftWarningReason])
		dto.liquidConsumptionReset = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.liquidConsumptionReset])
		dto.liquidConsumptionStart = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.liquidConsumptionStart])
		dto.liquidRangeSkipIndication = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.liquidRangeSkipIndication])
		dto.maxRange = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.maxRange])
		dto.maxSoc = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.maxSoc])
		dto.maxSocLowerLimit = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.maxSocLowerLimit])
		dto.maxSocUpperLimit = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.maxSocUpperLimit])
		dto.minSoc = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.minSoc])
		dto.minSocLowerLimit = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.minSocLowerLimit])
		dto.minSocUpperLimit = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.minSocUpperLimit])
		dto.nextDepartureTime = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.nextDepartureTime])
		dto.nextDepartureTimeWeekday = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.nextDepartureTimeWeekday])
		dto.odo = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.odo])
		dto.parkBrakeStatus = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.parkBrakeStatus])
		dto.parkEventLevel = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.parkEventLevel])
		dto.parkEventSensorStatus = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.parkEventSensorStatus])
		dto.parkEventType = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.parkEventType])
		dto.positionErrorCode = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.positionErrorCode])
		dto.positionHeading = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.positionHeading])
		dto.positionLat = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.positionLat])
		dto.positionLong = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.positionLong])
		dto.precondActive = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.precondActive])
		dto.precondAtDeparture = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.precondAtDeparture])
		dto.precondAtDepartureDisable = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.precondAtDepartureDisable])
		dto.precondDuration = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.precondDuration])
		dto.precondError = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.precondError])
		dto.precondNow = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.precondNow])
		dto.precondNowError = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.precondNowError])
		dto.precondSeatFrontLeft = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.precondSeatFrontLeft])
		dto.precondSeatFrontRight = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.precondSeatFrontRight])
		dto.precondSeatRearLeft = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.precondSeatRearLeft])
		dto.precondSeatRearRight = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.precondSeatRearRight])
        dto.proximityCalculationForVehiclePositionRequired = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.proximityCalculationForVehiclePositionRequired])
		dto.remoteStartActive = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.remoteStartActive])
		dto.remoteStartEndtime = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.remoteStartEndtime])
		dto.remoteStartTemperature = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.remoteStartTemperature])
		dto.roofTopStatus = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.roofTopStatus])
		dto.selectedChargeProgram = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.selectedChargeProgram])
		dto.serviceIntervalDays = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.serviceIntervalDays])
		dto.serviceIntervalDistance = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.serviceIntervalDistance])
		dto.smartCharging = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.smartCharging])
		dto.smartChargingAtDeparture = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.smartChargingAtDeparture])
		dto.smartChargingAtDeparture2 = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.smartChargingAtDeparture2])
        dto.speedAlert = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.speedAlert])
		dto.soc = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.soc])
		dto.socProfile = self.socProfile(for: vepUpdate.attributes[ProtoMessageKey.socProfile])
		dto.speedUnitFromIC = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.speedUnitFromIC])
		dto.starterBatteryState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.starterBatteryState])
		dto.sunroofBlindFrontStatus = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.sunroofStatusFrontBlind])
		dto.sunroofBlindRearStatus = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.sunroofStatusRearBlind])
		dto.sunroofEventState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.sunroofEvent])
		dto.sunroofEventActive = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.sunroofEventActive])
		dto.sunroofState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.sunroofStatus])
		dto.tankAdBlueLevel = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tankLevelAdBlue])
		dto.tankElectricRange = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.rangeElectric])
		dto.tankGasLevel = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.gasTankLevel])
		dto.tankGasRange = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.gasTankRange])
		dto.tankLiquidLevel = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tankLevelPercent])
		dto.tankLiquidRange = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.rangeLiquid])
		dto.tankOverallRange = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.overallRange])
        dto.teenageDrivingMode = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.teenageDrivingMode])
		dto.temperaturePointFrontCenter = self.temperaturePoints(for: vepUpdate.attributes[ProtoMessageKey.temperaturePoints], zone: .frontCenter)
		dto.temperaturePointFrontLeft = self.temperaturePoints(for: vepUpdate.attributes[ProtoMessageKey.temperaturePoints], zone: .frontLeft)
		dto.temperaturePointFrontRight = self.temperaturePoints(for: vepUpdate.attributes[ProtoMessageKey.temperaturePoints], zone: .frontRight)
		dto.temperaturePointRearCenter = self.temperaturePoints(for: vepUpdate.attributes[ProtoMessageKey.temperaturePoints], zone: .rearCenter)
		dto.temperaturePointRearCenter2 = self.temperaturePoints(for: vepUpdate.attributes[ProtoMessageKey.temperaturePoints], zone: .rear2center)
		dto.temperaturePointRearLeft = self.temperaturePoints(for: vepUpdate.attributes[ProtoMessageKey.temperaturePoints], zone: .rearLeft)
		dto.temperaturePointRearRight = self.temperaturePoints(for: vepUpdate.attributes[ProtoMessageKey.temperaturePoints], zone: .rearRight)
		dto.temperatureUnitHU = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.temperatureUnitHU])
		dto.theftSystemArmed = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.theftSystemArmed])
		dto.theftAlarmActive = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.theftAlarmActive])
		dto.timeFormatHU = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.timeFormatHU])
		dto.tireMarkerFrontLeft = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tireMarkerFrontLeft])
		dto.tireMarkerFrontRight = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tireMarkerFrontRight])
		dto.tireMarkerRearLeft = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tireMarkerRearLeft])
		dto.tireMarkerRearRight = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tireMarkerRearRight])
		dto.tirePressureFrontLeft = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tirePressureFrontLeft])
		dto.tirePressureFrontRight = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tirePressureFrontRight])
		dto.tirePressureMeasTimestamp = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tirePressMeasTimestamp])
		dto.tirePressureRearLeft = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tirePressureRearLeft])
		dto.tirePressureRearRight = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tirePressureRearRight])
		dto.tireSensorAvailable = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tireSensorAvailable])
		dto.towProtectionSensorStatus = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.towProtectionSensorStatus])
		dto.trackingStateHU = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.trackingStateHU])
        dto.valetDrivingMode = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.valetDrivingMode])
		dto.vehicleDataConnectionState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.vehicleDataConnectionState])
		dto.vehicleLockState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.vehicleLockState])
        dto.vTime = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.vTime])
		dto.warningBreakFluid = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.warningBrakeFluid])
		dto.warningBrakeLiningWear = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.warningBrakeLiningWear])
		dto.warningCoolantLevelLow = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.warningCoolantLevelLow])
		dto.warningEngineLight = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.warningEngineLight])
		dto.warningTireLamp = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tireWarningLamp])
		dto.warningTireLevelPrw = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tireWarningLevelPrw])
		dto.warningTireSprw = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tireWarningSprw])
		dto.warningTireSrdk = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tireWarningSrdk])
		dto.warningWashWater = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.warningWashWater])
		dto.weekdaytariff = self.tariff(for: vepUpdate.attributes[ProtoMessageKey.weekdaytariff], type: .weekday)
		dto.weekendtariff = self.tariff(for: vepUpdate.attributes[ProtoMessageKey.weekendtariff], type: .weekend)
		dto.weeklyProfile = self.weeklyProfile(for: vepUpdate.attributes[ProtoMessageKey.weeklyProfile])
		dto.weeklySetHU = self.dayTime(for: vepUpdate.attributes[ProtoMessageKey.weeklySetHU])
		dto.windowBlindRearStatus = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.windowStatusRearBlind])
		dto.windowBlindRearLeftStatus = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.windowStatusRearLeftBlind])
		dto.windowBlindRearRightStatus = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.windowStatusRearRightBlind])
		dto.windowFrontLeftState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.windowStatusFrontLeft])
		dto.windowFrontRightState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.windowStatusFrontRight])
		dto.windowRearLeftState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.windowStatusRearLeft])
		dto.windowRearRightState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.windowStatusRearRight])
		dto.windowStatusOverall = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.windowStatusOverall])
		dto.zevActive = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.active])
		return dto
	}
	
	private func attributeUnit<T: RawRepresentable>(for attribute: Proto_VehicleAttributeStatus) -> VehicleAttributeUnitModel<T>? where T.RawValue == Int {

		guard let displayUnit = attribute.displayUnit else {
			return nil
		}

		switch displayUnit {
		case .clockHourUnit(let unit):
			return VehicleAttributeUnitModel<T>(value: attribute.displayValue,
												unit: T(rawValue: unit.rawValue))

		case .combustionConsumptionUnit(let unit):
			return VehicleAttributeUnitModel<T>(value: attribute.displayValue,
												unit: T(rawValue: unit.rawValue))

		case .distanceUnit(let unit):
			return VehicleAttributeUnitModel<T>(value: attribute.displayValue,
												unit: T(rawValue: unit.rawValue))
			
		case .electricityConsumptionUnit(let unit):
			return VehicleAttributeUnitModel<T>(value: attribute.displayValue,
												unit: T(rawValue: unit.rawValue))

		case .gasConsumptionUnit(let unit):
			return VehicleAttributeUnitModel<T>(value: attribute.displayValue,
												unit: T(rawValue: unit.rawValue))
			
		case .pressureUnit(let unit):
			return VehicleAttributeUnitModel<T>(value: attribute.displayValue,
												unit: T(rawValue: unit.rawValue))

		case .ratioUnit(let unit):
			return VehicleAttributeUnitModel<T>(value: attribute.displayValue,
												unit: T(rawValue: unit.rawValue))

		case .speedDistanceUnit(let unit):
			return VehicleAttributeUnitModel<T>(value: attribute.displayValue,
												unit: T(rawValue: unit.rawValue))

		case .speedUnit(let unit):
			return VehicleAttributeUnitModel<T>(value: attribute.displayValue,
												unit: T(rawValue: unit.rawValue))
			
		case .temperatureUnit(let unit):
			return VehicleAttributeUnitModel<T>(value: attribute.displayValue,
												unit: T(rawValue: unit.rawValue))
		}
	}
	
	private func weeklyProfile<T: RawRepresentable>(for attributeStatus: Proto_VehicleAttributeStatus?) -> VehicleStatusAttributeModel<WeeklyProfileModel, T>? where T.RawValue == Int {
		
		guard let attribute = attributeStatus else {
			return nil
		}
		
		let weeklyProfileValue = attribute.weeklyProfileValue
		
		let timeProfiles = weeklyProfileValue.timeProfiles.map {
			return TimeProfile(applicationIdentifier: Int($0.applicationIdentifier),
							   identifier: Int($0.identifier),
							   hour: Int($0.hour),
							   minute: Int($0.minute),
							   active: $0.active,
							   days: Set.init($0.days.compactMap(Day.fromTimeProfileDay)))
		}
		
		let value = WeeklyProfileModel(singleEntriesActivatable: weeklyProfileValue.singleTimeProfileEntriesActivatable,
									   maxSlots: Int(weeklyProfileValue.maxNumberOfWeeklyTimeProfileSlots),
									   maxTimeProfiles: Int(weeklyProfileValue.maxNumberOfTimeProfiles),
									   currentSlots: Int(weeklyProfileValue.currentNumberOfTimeProfileSlots),
									   currentTimeProfiles: Int(weeklyProfileValue.currentNumberOfTimeProfiles),
									   allTimeProfiles: timeProfiles)
		
		return VehicleStatusAttributeModel<WeeklyProfileModel, T>(status: attribute.status,
																  timestampInMs: attribute.timestampInMs,
																  unit: nil,
																  value: value)
	}
	
	private func socProfile<T: RawRepresentable>(for attributeStatus: Proto_VehicleAttributeStatus?) -> VehicleStatusAttributeModel<[VehicleZEVSocProfileModel], T>? where T.RawValue == Int {
		
		guard let attribute = attributeStatus else {
			return nil
		}
		
		let value = attribute.stateOfChargeProfileValue.statesOfCharge.map { VehicleZEVSocProfileModel(soc: $0.stateOfCharge, time: $0.timestampInS)}
		
		return VehicleStatusAttributeModel<[VehicleZEVSocProfileModel], T>(status: attribute.status,
																		   timestampInMs: attribute.timestampInMs,
																		   unit: nil,
																		   value: value)
	}
	
	private func tariff<T: RawRepresentable>(for attributeStatus: Proto_VehicleAttributeStatus?, type: TariffType) -> VehicleStatusAttributeModel<[VehicleZEVTariffModel], T>? where T.RawValue == Int {
		
		guard let attribute = attributeStatus else {
			return nil
		}
		
		let value: [VehicleZEVTariffModel] = {
			switch type {
			case .weekday:	return attribute.weekdayTariffValue.tariffs.map { VehicleZEVTariffModel(rate: $0.rate, time: $0.time) }
			case .weekend:	return attribute.weekendTariffValue.tariffs.map { VehicleZEVTariffModel(rate: $0.rate, time: $0.time) }
			}
		}()
		
		return VehicleStatusAttributeModel<[VehicleZEVTariffModel], T>(status: attribute.status,
																	   timestampInMs: attribute.timestampInMs,
																	   unit: nil,
																	   value: value)
	}
    
    private func vehicleStatusUpdate<T: RawRepresentable>(for attributeStatus: Proto_VehicleAttributeStatus?) -> VehicleStatusAttributeModel<[VehicleChargeProgramModel], T>? where T.RawValue == Int {
        
        guard let attribute = attributeStatus else {
            return nil
        }
        
        let chargePrograms: [VehicleChargeProgramModel] = attribute.chargeProgramsValue.chargeProgramParameters.compactMap {
            
            guard let chargeProgram = ChargingProgram(rawValue: $0.chargeProgram.rawValue) else {
                return nil
            }
            
            return VehicleChargeProgramModel(autoUnlock: $0.autoUnlock,
                                             chargeProgram: chargeProgram,
                                             clockTimer: $0.clockTimer,
                                             ecoCharging: $0.ecoCharging,
                                             locationBasedCharging: $0.locationBasedCharging,
                                             maxChargingCurrent: Int($0.maxSoc),
                                             maxSoc: Int($0.maxSoc),
                                             weeklyProfile: $0.weeklyProfile)
        }
        
        return VehicleStatusAttributeModel<[VehicleChargeProgramModel], T>(status: attribute.status,
																		   timestampInMs: attribute.timestampInMs,
																		   unit: nil,
																		   value: chargePrograms)
    }

	private func vehicleStatusUpdate<T: RawRepresentable>(for attributeStatus: Proto_VehicleAttributeStatus?) -> VehicleStatusAttributeModel<[VehicleChargingBreakClockTimerModel], T>? where T.RawValue == Int {

        guard let attribute = attributeStatus else {
            return nil
        }
		
		let chargingBreakClockTimers: [VehicleChargingBreakClockTimerModel] = attribute.chargingBreakClockTimer.clockTimer.compactMap {
			
			guard let action = ChargingBreakClockTimer(rawValue: $0.action.rawValue) else {
				return nil
			}
			
			return VehicleChargingBreakClockTimerModel(action: action,
													   endTimeHour: Int($0.endTimeHour),
													   endTimeMin: Int($0.endTimeMin),
													   startTimeHour: Int($0.startTimeHour),
													   startTimeMin: Int($0.startTimeMin),
													   timerId: Int($0.timerID))
		}
		
        return VehicleStatusAttributeModel<[VehicleChargingBreakClockTimerModel], T>(status: attribute.status,
																					 timestampInMs: attribute.timestampInMs,
																					 unit: nil,
																					 value: chargingBreakClockTimers)
    }
	
	private func vehicleStatusUpdate<T: RawRepresentable>(for attributeStatus: Proto_VehicleAttributeStatus?) -> VehicleStatusAttributeModel<VehicleChargingPowerControlModel, T>? where T.RawValue == Int {

        guard let attribute = attributeStatus else {
            return nil
        }

		let chargingPowerControl = VehicleChargingPowerControlModel(chargingStatus: Int(attribute.chargingPowerControl.chargeStatus),
																	controlDuration: Int64(attribute.chargingPowerControl.ctrlDuration),
																	controlInfo: Int(attribute.chargingPowerControl.ctrlInfo),
																	chargingPower: Int(attribute.chargingPowerControl.chargePower),
																	serviceStatus: Int(attribute.chargingPowerControl.servStat),
																	serviceAvailable: Int(attribute.chargingPowerControl.servAvail),
																	useCase: Int(attribute.chargingPowerControl.useCase))

        return VehicleStatusAttributeModel<VehicleChargingPowerControlModel, T>(status: attribute.status,
																				timestampInMs: attribute.timestampInMs,
																				unit: nil,
																				value: chargingPowerControl)
    }
	
    private func vehicleStatusUpdate<T: RawRepresentable>(for attributeStatus: Proto_VehicleAttributeStatus?) -> VehicleStatusAttributeModel<[VehicleSpeedAlertModel], T>? where T.RawValue == Int {

        guard let attribute = attributeStatus else {
            
            return nil
        }

        var value = [VehicleSpeedAlertModel]()
        let attributeUnit: VehicleAttributeUnitModel<T>? = self.attributeUnit(for: attribute)

        for element in attribute.speedAlertConfigurationValue.speedAlertConfigurations {

            value.append(VehicleSpeedAlertModel(endtime: Int(element.endTimestampInS),
                                                threshold: Int(element.thresholdInKph),
                                                thresholdDisplayValue: element.thresholdDisplayValue))
        }

        return VehicleStatusAttributeModel<[VehicleSpeedAlertModel], T>(status: attribute.status,
                                                                        timestampInMs: attribute.timestampInMs,
                                                                        unit: attributeUnit,
                                                                        value: value)
    }
	
	private func temperaturePoints<T: RawRepresentable>(for attributeStatus: Proto_VehicleAttributeStatus?, zone: TemperatureZone) -> VehicleStatusAttributeModel<Double, T>? where T.RawValue == Int {
		
		guard let attribute = attributeStatus,
			let temperaturePoint = attribute.temperaturePointsValue.temperaturePoints.first(where: { $0.zone == zone.rawValue }) else {
				return nil
		}
		
		let attributeUnit: VehicleAttributeUnitModel<T>? = self.attributeUnit(for: attribute)
		return VehicleStatusAttributeModel<Double, T>(status: attribute.status,
													  timestampInMs: attribute.timestampInMs,
													  unit: attributeUnit,
													  value: temperaturePoint.temperature)
	}
	
	private func vehicleStatusUpdate<T: RawRepresentable>(for attributeStatus: Proto_VehicleAttributeStatus?) -> VehicleStatusAttributeModel<Bool, T>? where T.RawValue == Int {
		
		guard let attribute = attributeStatus else {
			return nil
		}
		
		let attributeUnit: VehicleAttributeUnitModel<T>? = self.attributeUnit(for: attribute)
		return VehicleStatusAttributeModel<Bool, T>(status: attribute.status,
													timestampInMs: attribute.timestampInMs,
													unit: attributeUnit,
													value: attribute.boolValue)
	}
	
	private func vehicleStatusUpdate<T: RawRepresentable>(for attributeStatus: Proto_VehicleAttributeStatus?) -> VehicleStatusAttributeModel<Double, T>? where T.RawValue == Int {

		guard let attribute = attributeStatus else {
			return nil
		}

		let attributeUnit: VehicleAttributeUnitModel<T>? = self.attributeUnit(for: attribute)
		return VehicleStatusAttributeModel<Double, T>(status: attribute.status,
													  timestampInMs: attribute.timestampInMs,
													  unit: attributeUnit,
													  value: attribute.doubleValue)
	}

	private func vehicleStatusUpdate<T: RawRepresentable>(for attributeStatus: Proto_VehicleAttributeStatus?) -> VehicleStatusAttributeModel<Int, T>? where T.RawValue == Int {

		guard let attribute = attributeStatus else {
			return nil
		}

		let attributeUnit: VehicleAttributeUnitModel<T>? = self.attributeUnit(for: attribute)
		let value: Int = {
			
			guard attribute.intValue == 0 else {
				return Int(attribute.intValue)
			}
			return Int(attribute.doubleValue)
		}()
		
		return VehicleStatusAttributeModel<Int, T>(status: attribute.status,
													 timestampInMs: attribute.timestampInMs,
													 unit: attributeUnit,
													 value: value)
	}

}

// swiftlint:enable function_body_length
// swiftlint:enable type_body_length
