//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

// swiftlint:disable function_body_length
// swiftlint:disable line_length
// swiftlint:disable type_body_length

final class DTOModelMapper {
	
	// MARK: Typealias
	typealias CacheSaved = (VehicleStatusTupel, String) -> Void
	typealias AuxheatTupel = (model: VehicleAuxheatModel, updated: Bool)
	typealias CollisionTupel = (model: VehicleCollisionModel, updated: Bool)
	typealias DoorsTupel = (model: VehicleDoorsModel, updated: Bool)
    typealias DrivingModeTupel = (model: VehicleDrivingModeModel, updated: Bool)
	typealias EcoScoreTupel = (model: VehicleEcoScoreModel, updated: Bool)
	typealias EngineTupel = (model: VehicleEngineModel, updated: Bool)
	typealias EventTimeTupel = (value: Int64, updated: Bool)
	typealias HuTupel = (model: VehicleHuModel, updated: Bool)
	typealias LocationTupel = (model: VehicleLocationModel, updated: Bool)
	typealias StatisticResetStartDoubleTupel<T: RawRepresentable> = (model: VehicleStatisticResetStartDoubleModel<T>, updated: Bool)
	typealias StatisticResetStartIntTupel<T: RawRepresentable> = (model: VehicleStatisticResetStartIntModel<T>, updated: Bool)
	typealias StatisticsTupel = (model: VehicleStatisticsModel, updated: Bool)
	typealias SunroofTupel = (model: VehicleSunroofModel, updated: Bool)
	typealias TankTupel = (model: VehicleTankModel, updated: Bool)
	typealias TheftTupel = (model: VehicleTheftModel, updated: Bool)
	typealias TiresTupel = (model: VehicleTiresModel, updated: Bool)
	typealias VehicleTupel = (model: VehicleVehicleModel, updated: Bool)
	typealias VehicleStatusTupel = (model: VehicleStatusModel, updates: [SocketUpdateType])
	typealias WarningsTupel = (model: VehicleWarningsModel, updated: Bool)
	typealias WindowsTupel = (model: VehicleWindowsModel, updated: Bool)
	typealias ZEVTupel = (model: VehicleZEVModel, updated: Bool)
	
	
	// MARK: - Internal
	
	static func map(statusUpdateModel: VehicleStatusDTO, cachedVehicleStatus: VehicleStatusModel) -> VehicleStatusTupel {
		
		let auxheat: AuxheatTupel       = self.map(statusUpdateModel: statusUpdateModel, cachedVehicleStatus: cachedVehicleStatus)
		let doors: DoorsTupel           = self.map(statusUpdateModel: statusUpdateModel, cachedVehicleStatus: cachedVehicleStatus)
        let drivingMode: DrivingModeTupel = self.map(statusUpdateModel: statusUpdateModel, cachedVehicleStatus: cachedVehicleStatus)
        let ecoScore: EcoScoreTupel     = self.map(statusUpdateModel: statusUpdateModel, cachedVehicleStatus: cachedVehicleStatus)
		let engine: EngineTupel         = self.map(statusUpdateModel: statusUpdateModel, cachedVehicleStatus: cachedVehicleStatus)
		let eventTime                   = EventTimeTupel(value: statusUpdateModel.eventTimestamp ?? cachedVehicleStatus.eventTimestamp, updated: statusUpdateModel.eventTimestamp != nil)
		let hu: HuTupel                 = self.map(statusUpdateModel: statusUpdateModel, cachedVehicleStatus: cachedVehicleStatus)
		let location: LocationTupel     = self.map(statusUpdateModel: statusUpdateModel, cachedVehicleStatus: cachedVehicleStatus)
		let statistics: StatisticsTupel = self.map(statusUpdateModel: statusUpdateModel, cachedVehicleStatus: cachedVehicleStatus)
		let tank: TankTupel             = self.map(statusUpdateModel: statusUpdateModel, cachedVehicleStatus: cachedVehicleStatus)
		let theft: TheftTupel           = self.map(statusUpdateModel: statusUpdateModel, cachedVehicleStatus: cachedVehicleStatus)
		let tires: TiresTupel           = self.map(statusUpdateModel: statusUpdateModel, cachedVehicleStatus: cachedVehicleStatus)
		let vehicle: VehicleTupel       = self.map(statusUpdateModel: statusUpdateModel, cachedVehicleStatus: cachedVehicleStatus)
		let warnings: WarningsTupel     = self.map(statusUpdateModel: statusUpdateModel, cachedVehicleStatus: cachedVehicleStatus)
		let windows: WindowsTupel       = self.map(statusUpdateModel: statusUpdateModel, cachedVehicleStatus: cachedVehicleStatus)
		let zev: ZEVTupel               = self.map(statusUpdateModel: statusUpdateModel, cachedVehicleStatus: cachedVehicleStatus)
        
		let model = VehicleStatusModel(auxheat: auxheat.model,
									   doors: doors.model,
                                       drivingMode: drivingMode.model,
									   ecoScore: ecoScore.model,
									   engine: engine.model,
									   eventTimestamp: eventTime.value,
									   finOrVin: statusUpdateModel.vin,
									   hu: hu.model,
									   location: location.model,
									   statistics: statistics.model,
									   tank: tank.model,
									   theft: theft.model,
									   tires: tires.model,
									   vehicle: vehicle.model,
									   warnings: warnings.model,
									   windows: windows.model,
									   zev: zev.model)
		
		let socketUpdateTypes: [SocketUpdateType] = [
			auxheat.updated ? .auxheat : nil,
			doors.updated ? .doors : nil,
            drivingMode.updated ? .drivingMode : nil,
			ecoScore.updated ? .ecoScore : nil,
			engine.updated ? .engine : nil,
			eventTime.updated ? .eventTime : nil,
			hu.updated ? .hu : nil,
			location.updated ? .location : nil,
			statistics.updated ? .statistics : nil,
			tank.updated ? .tank : nil,
			theft.updated ? .theft : nil,
			tires.updated ? .tires : nil,
			vehicle.updated ? .vehicle : nil,
			warnings.updated ? .warnings : nil,
			windows.updated ? .windows : nil,
			zev.updated ? .zev : nil
		].compactMap { $0 }
		let updates: [SocketUpdateType] = socketUpdateTypes.isEmpty == false ? socketUpdateTypes + [.status] : []
		
		return VehicleStatusTupel(model: model, updates: updates)
	}
	
	
	// MARK: - Helper
	
	private static func map<T: RawRepresentable>(
		reset: VehicleStatusAttributeModel<Double, T>?,
		start: VehicleStatusAttributeModel<Double, T>?,
		cachedVehicleResetStart: VehicleStatisticResetStartDoubleModel<T>) -> StatisticResetStartDoubleTupel<T> where T.RawValue == Int {
		
		let model = VehicleStatisticResetStartDoubleModel(reset: self.map(statusAttribute: reset, cachedStatusAttribute: cachedVehicleResetStart.reset),
														  start: self.map(statusAttribute: start, cachedStatusAttribute: cachedVehicleResetStart.start))
		let updated = reset != nil || start != nil
		
		return StatisticResetStartDoubleTupel(model: model, updated: updated)
	}
	
	private static func map<T: RawRepresentable>(
		reset: VehicleStatusAttributeModel<Int, T>?,
		start: VehicleStatusAttributeModel<Int, T>?,
		cachedVehicleResetStart: VehicleStatisticResetStartIntModel<T>) -> StatisticResetStartIntTupel<T> where T.RawValue == Int {
		
		let model = VehicleStatisticResetStartIntModel(reset: self.map(statusAttribute: reset, cachedStatusAttribute: cachedVehicleResetStart.reset),
													   start: self.map(statusAttribute: start, cachedStatusAttribute: cachedVehicleResetStart.start))
		let updated = reset != nil || start != nil
		
		return StatisticResetStartIntTupel(model: model, updated: updated)
	}
	
	private static func map<T: RawRepresentable>(statusAttribute: VehicleStatusAttributeModel<Bool, T>?, cachedStatusAttribute: StatusAttributeType<Bool, T>) -> StatusAttributeType<Bool, T> where T.RawValue == Int {

		guard let statusAttribute = statusAttribute,
			let statusType = StatusType(rawValue: statusAttribute.status) else {
				return cachedStatusAttribute
			}
		
		let timestamp = self.mapToSeconds(milliseconds: statusAttribute.timestampInMs)
		switch statusType {
		case .invalid:	    return .invalid(timestamp: timestamp)
		case .notAvailable:	return .notAvailable(timestamp: timestamp)
		case .noValue:	    return .noValue(timestamp: timestamp)
		case .valid:	    return .valid(value: statusAttribute.value, timestamp: timestamp, unit: statusAttribute.unit)
		}
	}

	private static func map<T: RawRepresentable, U: RawRepresentable>(statusAttribute: VehicleStatusAttributeModel<Bool, U>?, cachedStatusAttribute: StatusAttributeType<T, U>) -> StatusAttributeType<T, U> where T.RawValue == Bool, U.RawValue == Int {

		guard let statusAttribute = statusAttribute,
			let statusType = StatusType(rawValue: statusAttribute.status),
			let value = statusAttribute.value else {
				return cachedStatusAttribute
			}
		
		let timestamp = self.mapToSeconds(milliseconds: statusAttribute.timestampInMs)
		switch statusType {
		case .invalid:	    return .invalid(timestamp: timestamp)
		case .notAvailable:	return .notAvailable(timestamp: timestamp)
		case .noValue:	    return .noValue(timestamp: timestamp)
		case .valid:	    return .valid(value: T(rawValue: value), timestamp: timestamp, unit: statusAttribute.unit)
		}
	}

	private static func map<T: RawRepresentable>(statusAttribute: VehicleStatusAttributeModel<Double, T>?, cachedStatusAttribute: StatusAttributeType<Double, T>) -> StatusAttributeType<Double, T> where T.RawValue == Int {

		guard let statusAttribute = statusAttribute,
			let statusType = StatusType(rawValue: statusAttribute.status) else {
				return cachedStatusAttribute
			}
		
		let timestamp = self.mapToSeconds(milliseconds: statusAttribute.timestampInMs)
		switch statusType {
		case .invalid:	    return .invalid(timestamp: timestamp)
		case .notAvailable:	return .notAvailable(timestamp: timestamp)
		case .noValue:		return .noValue(timestamp: timestamp)
		case .valid:	    return .valid(value: statusAttribute.value, timestamp: timestamp, unit: statusAttribute.unit)
		}
	}
	
	private static func map<T: RawRepresentable, U: RawRepresentable>(statusAttribute: VehicleStatusAttributeModel<Double, U>?, cachedStatusAttribute: StatusAttributeType<T, U>) -> StatusAttributeType<T, U> where T.RawValue == Double, U.RawValue == Int {

		guard let statusAttribute = statusAttribute,
			let statusType = StatusType(rawValue: statusAttribute.status),
			let value = statusAttribute.value else {
				return cachedStatusAttribute
			}
		
		let timestamp = self.mapToSeconds(milliseconds: statusAttribute.timestampInMs)
		switch statusType {
		case .invalid:	    return .invalid(timestamp: timestamp)
		case .notAvailable:	return .notAvailable(timestamp: timestamp)
		case .noValue:	    return .noValue(timestamp: timestamp)
		case .valid:	    return .valid(value: T(rawValue: value), timestamp: timestamp, unit: statusAttribute.unit)
		}
	}
	
	private static func map<T: RawRepresentable>(statusAttribute: VehicleStatusAttributeModel<Double, T>?, cachedStatusAttribute: StatusAttributeType<Int, T>) -> StatusAttributeType<Int, T> where T.RawValue == Int {

		guard let statusAttribute = statusAttribute,
			let statusType = StatusType(rawValue: statusAttribute.status) else {
				return cachedStatusAttribute
		}
		
		let timestamp = self.mapToSeconds(milliseconds: statusAttribute.timestampInMs)
		switch statusType {
		case .invalid:	    return .invalid(timestamp: timestamp)
		case .notAvailable:	return .notAvailable(timestamp: timestamp)
		case .noValue:	    return .noValue(timestamp: timestamp)
		case .valid:	    return .valid(value: Int(statusAttribute.value ?? 0), timestamp: timestamp, unit: statusAttribute.unit)
		}
	}
	
	private static func map<T: RawRepresentable, U: RawRepresentable>(statusAttribute: VehicleStatusAttributeModel<Double, U>?, cachedStatusAttribute: StatusAttributeType<T, U>) -> StatusAttributeType<T, U> where T.RawValue == Int64, U.RawValue == Int {

		guard let statusAttribute = statusAttribute,
			let statusType = StatusType(rawValue: statusAttribute.status),
			let value = statusAttribute.value else {
				return cachedStatusAttribute
		}
		
		let timestamp = self.mapToSeconds(milliseconds: statusAttribute.timestampInMs)
		switch statusType {
		case .invalid:	    return .invalid(timestamp: timestamp)
		case .notAvailable:	return .notAvailable(timestamp: timestamp)
		case .noValue:	    return .noValue(timestamp: timestamp)
		case .valid:	    return .valid(value: T(rawValue: Int64(value)), timestamp: timestamp, unit: statusAttribute.unit)
		}
	}
	
	private static func map<T: RawRepresentable>(statusAttribute: VehicleStatusAttributeModel<Int, T>?, cachedStatusAttribute: StatusAttributeType<Int, T>) -> StatusAttributeType<Int, T> where T.RawValue == Int {

		guard let statusAttribute = statusAttribute,
			let statusType = StatusType(rawValue: statusAttribute.status) else {
				return cachedStatusAttribute
			}
		
		let timestamp = self.mapToSeconds(milliseconds: statusAttribute.timestampInMs)
		switch statusType {
		case .invalid:	    return .invalid(timestamp: timestamp)
		case .notAvailable:	return .notAvailable(timestamp: timestamp)
		case .noValue:	    return .noValue(timestamp: timestamp)
		case .valid:	    return .valid(value: statusAttribute.value, timestamp: timestamp, unit: statusAttribute.unit)
		}
	}
	
	private static func map<T: RawRepresentable, U: RawRepresentable>(statusAttribute: VehicleStatusAttributeModel<Int, U>?, cachedStatusAttribute: StatusAttributeType<T, U>) -> StatusAttributeType<T, U> where T.RawValue == Int, U.RawValue == Int {

		guard let statusAttribute = statusAttribute,
			let statusType = StatusType(rawValue: statusAttribute.status),
			let value = statusAttribute.value else {
				return cachedStatusAttribute
			}
		
		let timestamp = self.mapToSeconds(milliseconds: statusAttribute.timestampInMs)
		switch statusType {
		case .invalid:	    return .invalid(timestamp: timestamp)
		case .notAvailable:	return .notAvailable(timestamp: timestamp)
		case .noValue:	    return .noValue(timestamp: timestamp)
		case .valid:	    return .valid(value: T(rawValue: value), timestamp: timestamp, unit: statusAttribute.unit)
		}
	}
    
	private static func map<T: RawRepresentable>(statusAttribute: VehicleStatusAttributeModel<Int, T>?, cachedStatusAttribute: StatusAttributeType<ChargingLimitation, T>) -> StatusAttributeType<ChargingLimitation, T> where T.RawValue == Int {
		
		guard let statusAttribute = statusAttribute,
			let statusType = StatusType(rawValue: statusAttribute.status) else {
				return cachedStatusAttribute
		}
		
		let timestamp = self.mapToSeconds(milliseconds: statusAttribute.timestampInMs)
		switch statusType {
		case .invalid:	    return .invalid(timestamp: timestamp)
		case .notAvailable:	return .notAvailable(timestamp: timestamp)
		case .noValue:	    return .noValue(timestamp: timestamp)
		case .valid:	    return .valid(value: ChargingLimitation(rawValue: statusAttribute.value), timestamp: timestamp, unit: statusAttribute.unit)
		}
	}
	
	private static func map<T: RawRepresentable>(statusAttribute: VehicleStatusAttributeModel<[VehicleChargeProgramModel], T>?, cachedStatusAttribute: StatusAttributeType<[VehicleChargeProgramModel], T>) -> StatusAttributeType<[VehicleChargeProgramModel], T> where T.RawValue == Int {
        
        guard let statusAttribute = statusAttribute,
            let statusType = StatusType(rawValue: statusAttribute.status) else {
                return cachedStatusAttribute
        }
        
        let timestamp = self.mapToSeconds(milliseconds: statusAttribute.timestampInMs)
        switch statusType {
        case .invalid:      return .invalid(timestamp: timestamp)
        case .notAvailable: return .notAvailable(timestamp: timestamp)
        case .noValue:      return .noValue(timestamp: timestamp)
        case .valid:        return .valid(value: statusAttribute.value, timestamp: timestamp, unit: statusAttribute.unit)
        }
    }
    
	private static func map<T: RawRepresentable>(statusAttribute: VehicleStatusAttributeModel<[VehicleChargingBreakClockTimerModel], T>?, cachedStatusAttribute: StatusAttributeType<[VehicleChargingBreakClockTimerModel], T>) -> StatusAttributeType<[VehicleChargingBreakClockTimerModel], T> where T.RawValue == Int {
        
        guard let statusAttribute = statusAttribute,
            let statusType = StatusType(rawValue: statusAttribute.status) else {
                return cachedStatusAttribute
        }
        
        let timestamp = self.mapToSeconds(milliseconds: statusAttribute.timestampInMs)
        switch statusType {
        case .invalid:      return .invalid(timestamp: timestamp)
        case .notAvailable: return .notAvailable(timestamp: timestamp)
        case .noValue:      return .noValue(timestamp: timestamp)
        case .valid:        return .valid(value: statusAttribute.value, timestamp: timestamp, unit: statusAttribute.unit)
        }
    }
	
	private static func map<T: RawRepresentable>(statusAttribute: VehicleStatusAttributeModel<VehicleChargingPowerControlModel, T>?, cachedStatusAttribute: StatusAttributeType<VehicleChargingPowerControlModel, T>) -> StatusAttributeType<VehicleChargingPowerControlModel, T> where T.RawValue == Int {
        
        guard let statusAttribute = statusAttribute,
            let statusType = StatusType(rawValue: statusAttribute.status) else {
                return cachedStatusAttribute
        }
        
        let timestamp = self.mapToSeconds(milliseconds: statusAttribute.timestampInMs)
        switch statusType {
        case .invalid:      return .invalid(timestamp: timestamp)
        case .notAvailable: return .notAvailable(timestamp: timestamp)
        case .noValue:      return .noValue(timestamp: timestamp)
        case .valid:        return .valid(value: statusAttribute.value, timestamp: timestamp, unit: statusAttribute.unit)
        }
    }
	
	private static func map<T: RawRepresentable>(statusAttribute: VehicleStatusAttributeModel<[DayTimeModel], T>?, cachedStatusAttribute: StatusAttributeType<[DayTimeModel], T>) -> StatusAttributeType<[DayTimeModel], T> where T.RawValue == Int {
		
		guard let statusAttribute = statusAttribute,
			let statusType = StatusType(rawValue: statusAttribute.status) else {
				return cachedStatusAttribute
		}
		
		let timestamp = self.mapToSeconds(milliseconds: statusAttribute.timestampInMs)
		switch statusType {
		case .invalid:	    return .invalid(timestamp: timestamp)
		case .notAvailable:	return .notAvailable(timestamp: timestamp)
		case .noValue:	    return .noValue(timestamp: timestamp)
		case .valid:	    return .valid(value: statusAttribute.value, timestamp: timestamp, unit: statusAttribute.unit)
		}
	}
	
	private static func map<T: RawRepresentable>(statusAttribute: VehicleStatusAttributeModel<WeeklyProfileModel, T>?, cachedStatusAttribute: StatusAttributeType<WeeklyProfileModel, T>) -> StatusAttributeType<WeeklyProfileModel, T> where T.RawValue == Int {
		
		guard let statusAttribute = statusAttribute,
			let statusType = StatusType(rawValue: statusAttribute.status) else {
				return cachedStatusAttribute
		}
		
		let timestamp = self.mapToSeconds(milliseconds: statusAttribute.timestampInMs)
		switch statusType {
		case .invalid:	    return .invalid(timestamp: timestamp)
		case .notAvailable:	return .notAvailable(timestamp: timestamp)
		case .noValue:	    return .noValue(timestamp: timestamp)
		case .valid:	    return .valid(value: statusAttribute.value, timestamp: timestamp, unit: statusAttribute.unit)
		}
	}
	
	private static func map<T: RawRepresentable>(statusAttribute: VehicleStatusAttributeModel<[VehicleZEVSocProfileModel], T>?, cachedStatusAttribute: StatusAttributeType<[VehicleZEVSocProfileModel], T>) -> StatusAttributeType<[VehicleZEVSocProfileModel], T> where T.RawValue == Int {

		guard let statusAttribute = statusAttribute,
			let statusType = StatusType(rawValue: statusAttribute.status) else {
				return cachedStatusAttribute
		}
		
		let timestamp = self.mapToSeconds(milliseconds: statusAttribute.timestampInMs)
		switch statusType {
		case .invalid:	    return .invalid(timestamp: timestamp)
		case .notAvailable:	return .notAvailable(timestamp: timestamp)
		case .noValue:	    return .noValue(timestamp: timestamp)
		case .valid:	    return .valid(value: statusAttribute.value, timestamp: timestamp, unit: statusAttribute.unit)
		}
	}
	
	private static func map<T: RawRepresentable>(statusAttribute: VehicleStatusAttributeModel<[VehicleZEVTariffModel], T>?, cachedStatusAttribute: StatusAttributeType<[VehicleZEVTariffModel], T>) -> StatusAttributeType<[VehicleZEVTariffModel], T> where T.RawValue == Int {

		guard let statusAttribute = statusAttribute,
			let statusType = StatusType(rawValue: statusAttribute.status) else {
				return cachedStatusAttribute
		}
		
		let timestamp = self.mapToSeconds(milliseconds: statusAttribute.timestampInMs)
		switch statusType {
		case .invalid:	    return .invalid(timestamp: timestamp)
		case .notAvailable:	return .notAvailable(timestamp: timestamp)
		case .noValue:	    return .noValue(timestamp: timestamp)
		case .valid:	    return .valid(value: statusAttribute.value, timestamp: timestamp, unit: statusAttribute.unit)
		}
	}

    private static func map<T: RawRepresentable>(statusAttribute: VehicleStatusAttributeModel<[VehicleSpeedAlertModel], T>?, cachedStatusAttribute: StatusAttributeType<[VehicleSpeedAlertModel], T>) -> StatusAttributeType<[VehicleSpeedAlertModel], T> where T.RawValue == Int {
        
        guard let statusAttribute = statusAttribute,
            let statusType = StatusType(rawValue: statusAttribute.status) else {
                return cachedStatusAttribute
        }
        
		let timestamp = self.mapToSeconds(milliseconds: statusAttribute.timestampInMs)
        switch statusType {
        case .invalid:      return .invalid(timestamp: timestamp)
        case .notAvailable: return .notAvailable(timestamp: timestamp)
        case .noValue:      return .noValue(timestamp: timestamp)
        case .valid:        return .valid(value: statusAttribute.value, timestamp: timestamp, unit: statusAttribute.unit)
        }
    }
	
	private static func map(statusUpdateModel: VehicleStatusDTO, cachedVehicleStatus: VehicleStatusModel) -> AuxheatTupel {
		
		let model = VehicleAuxheatModel(isActive: self.map(statusAttribute: statusUpdateModel.auxheatActive,
														   cachedStatusAttribute: cachedVehicleStatus.auxheat.isActive),
										runtime: self.map(statusAttribute: statusUpdateModel.auxheatRuntime,
														  cachedStatusAttribute: cachedVehicleStatus.auxheat.runtime),
										state: self.map(statusAttribute: statusUpdateModel.auxheatState,
														cachedStatusAttribute: cachedVehicleStatus.auxheat.state),
										time1: self.map(statusAttribute: statusUpdateModel.auxheatTime1,
														cachedStatusAttribute: cachedVehicleStatus.auxheat.time1),
										time2: self.map(statusAttribute: statusUpdateModel.auxheatTime2,
														cachedStatusAttribute: cachedVehicleStatus.auxheat.time2),
										time3: self.map(statusAttribute: statusUpdateModel.auxheatTime3,
														cachedStatusAttribute: cachedVehicleStatus.auxheat.time3),
										timeSelection: self.map(statusAttribute: statusUpdateModel.auxheatTimeSelection,
																cachedStatusAttribute: cachedVehicleStatus.auxheat.timeSelection),
										warnings: self.map(statusAttribute: statusUpdateModel.auxheatWarnings,
														   cachedStatusAttribute: cachedVehicleStatus.auxheat.warnings))
		
		let updated = statusUpdateModel.auxheatActive != nil ||
			statusUpdateModel.auxheatRuntime != nil ||
			statusUpdateModel.auxheatState != nil ||
			statusUpdateModel.auxheatTime1 != nil ||
			statusUpdateModel.auxheatTime2 != nil ||
			statusUpdateModel.auxheatTime3 != nil ||
			statusUpdateModel.auxheatTimeSelection != nil ||
			statusUpdateModel.auxheatWarnings != nil
		
		return AuxheatTupel(model: model, updated: updated)
	}
	
	private static func map(statusUpdateModel: VehicleStatusDTO, cachedVehicleStatus: VehicleStatusModel) -> CollisionTupel {
		
		let model = VehicleCollisionModel(lastParkEvent: self.map(statusAttribute: statusUpdateModel.lastParkEvent,
																  cachedStatusAttribute: cachedVehicleStatus.theft.collision.lastParkEvent),
										  lastParkEventNotConfirmed: self.map(statusAttribute: statusUpdateModel.lastParkEventNotConfirmed,
																			  cachedStatusAttribute: cachedVehicleStatus.theft.collision.lastParkEventNotConfirmed),
										  parkEventLevel: self.map(statusAttribute: statusUpdateModel.parkEventLevel,
																   cachedStatusAttribute: cachedVehicleStatus.theft.collision.parkEventLevel),
										  parkEventSensorStatus: self.map(statusAttribute: statusUpdateModel.parkEventSensorStatus,
																		  cachedStatusAttribute: cachedVehicleStatus.theft.collision.parkEventSensorStatus),
										  parkEventType: self.map(statusAttribute: statusUpdateModel.parkEventType,
																  cachedStatusAttribute: cachedVehicleStatus.theft.collision.parkEventType))
		
		let updated = statusUpdateModel.lastParkEvent != nil ||
			statusUpdateModel.lastParkEventNotConfirmed != nil ||
			statusUpdateModel.parkEventLevel != nil ||
			statusUpdateModel.parkEventSensorStatus != nil ||
			statusUpdateModel.parkEventType != nil
		
		return CollisionTupel(model: model, updated: updated)
	}
	
	private static func map(statusUpdateModel: VehicleStatusDTO, cachedVehicleStatus: VehicleStatusModel) -> DoorsTupel {
		
		let model = VehicleDoorsModel(decklid: VehicleDoorModel(lockState: self.map(statusAttribute: statusUpdateModel.decklidLockState,
																					cachedStatusAttribute: cachedVehicleStatus.doors.decklid.lockState),
																state: self.map(statusAttribute: statusUpdateModel.decklidState,
																				cachedStatusAttribute: cachedVehicleStatus.doors.decklid.state)),
									  frontLeft: VehicleDoorModel(lockState: self.map(statusAttribute: statusUpdateModel.doorFrontLeftLockState,
																					  cachedStatusAttribute: cachedVehicleStatus.doors.frontLeft.lockState),
																  state: self.map(statusAttribute: statusUpdateModel.doorFrontLeftState,
																				  cachedStatusAttribute: cachedVehicleStatus.doors.frontLeft.state)),
									  frontRight: VehicleDoorModel(lockState: self.map(statusAttribute: statusUpdateModel.doorFrontRightLockState,
																					   cachedStatusAttribute: cachedVehicleStatus.doors.frontRight.lockState),
																   state: self.map(statusAttribute: statusUpdateModel.doorFrontRightState,
																				   cachedStatusAttribute: cachedVehicleStatus.doors.frontRight.state)),
									  lockStatusOverall: self.map(statusAttribute: statusUpdateModel.doorLockStatusOverall,
																  cachedStatusAttribute: cachedVehicleStatus.doors.lockStatusOverall),
									  rearLeft: VehicleDoorModel(lockState: self.map(statusAttribute: statusUpdateModel.doorRearLeftLockState,
																					 cachedStatusAttribute: cachedVehicleStatus.doors.rearLeft.lockState),
																 state: self.map(statusAttribute: statusUpdateModel.doorRearLeftState,
																				 cachedStatusAttribute: cachedVehicleStatus.doors.rearLeft.state)),
									  rearRight: VehicleDoorModel(lockState: self.map(statusAttribute: statusUpdateModel.doorRearRightLockState,
																					  cachedStatusAttribute: cachedVehicleStatus.doors.rearRight.lockState),
																  state: self.map(statusAttribute: statusUpdateModel.doorRearRightState,
																				  cachedStatusAttribute: cachedVehicleStatus.doors.rearRight.state)),
									  statusOverall: self.map(statusAttribute: statusUpdateModel.doorStatusOverall,
															  cachedStatusAttribute: cachedVehicleStatus.doors.statusOverall))
		
		let updated = statusUpdateModel.decklidLockState != nil ||
			statusUpdateModel.decklidState != nil ||
			statusUpdateModel.doorFrontLeftLockState != nil ||
			statusUpdateModel.doorFrontRightLockState != nil ||
			statusUpdateModel.doorLockStatusOverall != nil ||
			statusUpdateModel.doorRearLeftLockState != nil ||
			statusUpdateModel.doorRearRightLockState != nil ||
			statusUpdateModel.doorFrontLeftState != nil ||
			statusUpdateModel.doorFrontRightState != nil ||
			statusUpdateModel.doorRearLeftState != nil ||
			statusUpdateModel.doorRearRightState != nil ||
			statusUpdateModel.doorStatusOverall != nil
		
		return DoorsTupel(model: model, updated: updated)
	}
	
	private static func map(statusUpdateModel: VehicleStatusDTO, cachedVehicleStatus: VehicleStatusModel) -> EcoScoreTupel {
		
		let model = VehicleEcoScoreModel(accel: self.map(statusAttribute: statusUpdateModel.ecoScoreAccel,
														 cachedStatusAttribute: cachedVehicleStatus.ecoScore.accel),
										 bonusRange: self.map(statusAttribute: statusUpdateModel.ecoScoreBonusRange,
															  cachedStatusAttribute: cachedVehicleStatus.ecoScore.bonusRange),
										 const: self.map(statusAttribute: statusUpdateModel.ecoScoreConst,
														 cachedStatusAttribute: cachedVehicleStatus.ecoScore.const),
										 freeWhl: self.map(statusAttribute: statusUpdateModel.ecoScoreFreeWhl,
														   cachedStatusAttribute: cachedVehicleStatus.ecoScore.freeWhl),
										 total: self.map(statusAttribute: statusUpdateModel.ecoScoreTotal,
														 cachedStatusAttribute: cachedVehicleStatus.ecoScore.total))
		
		let updated = statusUpdateModel.ecoScoreAccel != nil ||
			statusUpdateModel.ecoScoreBonusRange != nil ||
			statusUpdateModel.ecoScoreConst != nil ||
			statusUpdateModel.ecoScoreFreeWhl != nil ||
			statusUpdateModel.ecoScoreTotal != nil

		return EcoScoreTupel(model: model, updated: updated)
	}
	
	private static func map(statusUpdateModel: VehicleStatusDTO, cachedVehicleStatus: VehicleStatusModel) -> EngineTupel {
		
		let model = VehicleEngineModel(ignitionState: self.map(statusAttribute: statusUpdateModel.ignitionState,
															   cachedStatusAttribute: cachedVehicleStatus.engine.ignitionState),
									   remoteStartEndtime: self.map(statusAttribute: statusUpdateModel.remoteStartEndtime,
																	cachedStatusAttribute: cachedVehicleStatus.engine.remoteStartEndtime),
									   remoteStartIsActive: self.map(statusAttribute: statusUpdateModel.remoteStartActive,
																	 cachedStatusAttribute: cachedVehicleStatus.engine.remoteStartIsActive),
									   remoteStartTemperature: self.map(statusAttribute: statusUpdateModel.remoteStartTemperature,
																		cachedStatusAttribute: cachedVehicleStatus.engine.remoteStartTemperature),
									   state: self.map(statusAttribute: statusUpdateModel.engineState,
													   cachedStatusAttribute: cachedVehicleStatus.engine.state))
		
		let updated = statusUpdateModel.engineState != nil ||
			statusUpdateModel.ignitionState != nil ||
			statusUpdateModel.remoteStartActive != nil ||
			statusUpdateModel.remoteStartEndtime != nil ||
			statusUpdateModel.remoteStartTemperature != nil
		
		return EngineTupel(model: model, updated: updated)
	}
	
	private static func map(statusUpdateModel: VehicleStatusDTO, cachedVehicleStatus: VehicleStatusModel) -> HuTupel {
		
		let model = VehicleHuModel(isTrackingEnable: self.map(statusAttribute: statusUpdateModel.trackingStateHU,
															  cachedStatusAttribute: cachedVehicleStatus.hu.isTrackingEnable),
								   language: self.map(statusAttribute: statusUpdateModel.languageHU,
													  cachedStatusAttribute: cachedVehicleStatus.hu.language),
								   temperatureType: self.map(statusAttribute: statusUpdateModel.temperatureUnitHU,
															 cachedStatusAttribute: cachedVehicleStatus.hu.temperatureType),
								   timeFormatType: self.map(statusAttribute: statusUpdateModel.timeFormatHU,
															cachedStatusAttribute: cachedVehicleStatus.hu.timeFormatType),
								   weeklyProfile: self.map(statusAttribute: statusUpdateModel.weeklyProfile,
														   cachedStatusAttribute: cachedVehicleStatus.hu.weeklyProfile),
								   weeklySetHU: self.map(statusAttribute: statusUpdateModel.weeklySetHU,
														 cachedStatusAttribute: cachedVehicleStatus.hu.weeklySetHU))
		
		let updated = statusUpdateModel.trackingStateHU != nil ||
			statusUpdateModel.languageHU != nil ||
			statusUpdateModel.temperatureUnitHU != nil ||
			statusUpdateModel.timeFormatHU != nil ||
			statusUpdateModel.weeklyProfile != nil ||
			statusUpdateModel.weeklySetHU != nil

		return HuTupel(model: model, updated: updated)
	}
	
	private static func map(statusUpdateModel: VehicleStatusDTO, cachedVehicleStatus: VehicleStatusModel) -> LocationTupel {
		
		let model = VehicleLocationModel(heading: self.map(statusAttribute: statusUpdateModel.positionHeading,
														   cachedStatusAttribute: cachedVehicleStatus.location.heading),
										 latitude: self.map(statusAttribute: statusUpdateModel.positionLat,
															cachedStatusAttribute: cachedVehicleStatus.location.latitude),
										 longitude: self.map(statusAttribute: statusUpdateModel.positionLong,
                                                             cachedStatusAttribute: cachedVehicleStatus.location.longitude),
										 positionErrorCode: self.map(statusAttribute: statusUpdateModel.positionErrorCode,
																	 cachedStatusAttribute: cachedVehicleStatus.location.positionErrorCode),
                                         proximityCalculationForVehiclePositionRequired: self.map(statusAttribute: statusUpdateModel.proximityCalculationForVehiclePositionRequired,
                                                                     cachedStatusAttribute: cachedVehicleStatus.location.proximityCalculationForVehiclePositionRequired))
		
		let updated = statusUpdateModel.positionErrorCode != nil ||
			statusUpdateModel.positionHeading != nil ||
			statusUpdateModel.positionLat != nil ||
			statusUpdateModel.positionLong != nil ||
            statusUpdateModel.proximityCalculationForVehiclePositionRequired != nil
		
		return LocationTupel(model: model, updated: updated)
	}
	
	private static func map(statusUpdateModel: VehicleStatusDTO, cachedVehicleStatus: VehicleStatusModel) -> StatisticsTupel {
		
		let average: StatisticResetStartDoubleTupel = self.map(reset: statusUpdateModel.averageSpeedReset,
															   start: statusUpdateModel.averageSpeedStart,
															   cachedVehicleResetStart: cachedVehicleStatus.statistics.averageSpeed)
		
		let distanceZe: StatisticResetStartIntTupel = self.map(reset: statusUpdateModel.distanceZEReset,
															   start: statusUpdateModel.distanceZEStart,
															   cachedVehicleResetStart: cachedVehicleStatus.statistics.distance.ze)
		let distance = VehicleStatisticDistanceModel(reset: self.map(statusAttribute: statusUpdateModel.distanceReset,
																	 cachedStatusAttribute: cachedVehicleStatus.statistics.distance.reset),
													 start: self.map(statusAttribute: statusUpdateModel.distanceStart,
																	 cachedStatusAttribute: cachedVehicleStatus.statistics.distance.start),
													 ze: distanceZe.model)
		
		let drivenTimeZe: StatisticResetStartIntTupel = self.map(reset: statusUpdateModel.drivenTimeZEReset,
																 start: statusUpdateModel.drivenTimeZEStart,
																 cachedVehicleResetStart: cachedVehicleStatus.statistics.drivenTime.ze)
		let drivenTime = VehicleStatisticDrivenTimeModel(reset: self.map(statusAttribute: statusUpdateModel.drivenTimeReset,
																		 cachedStatusAttribute: cachedVehicleStatus.statistics.drivenTime.reset),
														 start: self.map(statusAttribute: statusUpdateModel.drivenTimeStart,
																		 cachedStatusAttribute: cachedVehicleStatus.statistics.drivenTime.start),
														 ze: drivenTimeZe.model)
		
		let electricConsumption: StatisticResetStartDoubleTupel = self.map(reset: statusUpdateModel.electricConsumptionReset,
																		   start: statusUpdateModel.electricConsumptionStart,
																		   cachedVehicleResetStart: cachedVehicleStatus.statistics.electric.consumption)
		let electricDistance: StatisticResetStartDoubleTupel = self.map(reset: statusUpdateModel.distanceElectricalReset,
																		start: statusUpdateModel.distanceElectricalStart,
																		cachedVehicleResetStart: cachedVehicleStatus.statistics.electric.distance)
		let electric = VehicleStatisticTankModel(consumption: electricConsumption.model,
												 distance: electricDistance.model)
		
		let gasConsumption: StatisticResetStartDoubleTupel = self.map(reset: statusUpdateModel.gasConsumptionReset,
																	  start: statusUpdateModel.gasConsumptionStart,
																	  cachedVehicleResetStart: cachedVehicleStatus.statistics.gas.consumption)
		let gasDistance: StatisticResetStartDoubleTupel = self.map(reset: statusUpdateModel.distanceGasReset,
																   start: statusUpdateModel.distanceGasStart,
																   cachedVehicleResetStart: cachedVehicleStatus.statistics.gas.distance)
		let gas = VehicleStatisticTankModel(consumption: gasConsumption.model,
											distance: gasDistance.model)
		
		let liquidConsumption: StatisticResetStartDoubleTupel = self.map(reset: statusUpdateModel.liquidConsumptionReset,
																		 start: statusUpdateModel.liquidConsumptionStart,
																		 cachedVehicleResetStart: cachedVehicleStatus.statistics.liquid.consumption)
		let liquidDistance: StatisticResetStartDoubleTupel = self.map(reset: statusUpdateModel.distanceElectricalReset,
																	  start: statusUpdateModel.distanceElectricalStart,
																	  cachedVehicleResetStart: cachedVehicleStatus.statistics.liquid.distance)
		let liquid = VehicleStatisticTankModel(consumption: liquidConsumption.model,
											   distance: liquidDistance.model)
		
		let model = VehicleStatisticsModel(averageSpeed: average.model,
										   distance: distance,
										   drivenTime: drivenTime,
										   electric: electric,
										   gas: gas,
										   liquid: liquid)
		
		let updated = average.updated ||
			statusUpdateModel.distanceReset != nil ||
			statusUpdateModel.distanceStart != nil ||
			distanceZe.updated ||
			statusUpdateModel.drivenTimeReset != nil ||
			statusUpdateModel.drivenTimeStart != nil ||
			drivenTimeZe.updated ||
			electricConsumption.updated ||
			electricDistance.updated ||
			gasConsumption.updated ||
			gasDistance.updated ||
			liquidConsumption.updated ||
			liquidDistance.updated
		
		return StatisticsTupel(model: model, updated: updated)
	}
	
	private static func map(statusUpdateModel: VehicleStatusDTO, cachedVehicleStatus: VehicleStatusModel) -> SunroofTupel {
		
		let model = VehicleSunroofModel(blindFront: self.map(statusAttribute: statusUpdateModel.sunroofBlindFrontStatus,
															 cachedStatusAttribute: cachedVehicleStatus.windows.sunroof.blindFront),
										blindRear: self.map(statusAttribute: statusUpdateModel.sunroofBlindRearStatus,
															cachedStatusAttribute: cachedVehicleStatus.windows.sunroof.blindRear),
										event: self.map(statusAttribute: statusUpdateModel.sunroofEventState,
														cachedStatusAttribute: cachedVehicleStatus.windows.sunroof.event),
										isEventActive: self.map(statusAttribute: statusUpdateModel.sunroofEventActive,
																cachedStatusAttribute: cachedVehicleStatus.windows.sunroof.isEventActive),
										status: self.map(statusAttribute: statusUpdateModel.sunroofState,
														 cachedStatusAttribute: cachedVehicleStatus.windows.sunroof.status))
		
		let updated = statusUpdateModel.sunroofEventState != nil ||
			statusUpdateModel.sunroofEventActive != nil ||
			statusUpdateModel.sunroofState != nil ||
            statusUpdateModel.sunroofBlindFrontStatus != nil ||
            statusUpdateModel.sunroofBlindRearStatus != nil
		
		return SunroofTupel(model: model, updated: updated)
	}
	
	private static func map(statusUpdateModel: VehicleStatusDTO, cachedVehicleStatus: VehicleStatusModel) -> TankTupel {
		
		let model = VehicleTankModel(adBlueLevel: self.map(statusAttribute: statusUpdateModel.tankAdBlueLevel,
														   cachedStatusAttribute: cachedVehicleStatus.tank.adBlueLevel),
									 electricLevel: self.map(statusAttribute: statusUpdateModel.soc,
															 cachedStatusAttribute: cachedVehicleStatus.vehicle.soc),
									 electricRange: self.map(statusAttribute: statusUpdateModel.tankElectricRange,
															 cachedStatusAttribute: cachedVehicleStatus.tank.electricRange),
									 gasLevel: self.map(statusAttribute: statusUpdateModel.tankGasLevel,
														cachedStatusAttribute: cachedVehicleStatus.tank.gasLevel),
									 gasRange: self.map(statusAttribute: statusUpdateModel.tankGasRange,
														cachedStatusAttribute: cachedVehicleStatus.tank.gasRange),
									 liquidLevel: self.map(statusAttribute: statusUpdateModel.tankLiquidLevel,
														   cachedStatusAttribute: cachedVehicleStatus.tank.liquidLevel),
									 liquidRange: self.map(statusAttribute: statusUpdateModel.tankLiquidRange,
														   cachedStatusAttribute: cachedVehicleStatus.tank.liquidRange),
									 overallRange: self.map(statusAttribute: statusUpdateModel.tankOverallRange,
									 cachedStatusAttribute: cachedVehicleStatus.tank.overallRange))
		
		let updated = statusUpdateModel.tankAdBlueLevel != nil ||
			statusUpdateModel.soc != nil ||
			statusUpdateModel.tankElectricRange != nil ||
			statusUpdateModel.tankGasLevel != nil ||
			statusUpdateModel.tankGasRange != nil ||
			statusUpdateModel.tankLiquidLevel != nil ||
			statusUpdateModel.tankLiquidRange != nil ||
			statusUpdateModel.tankOverallRange != nil
		
		return TankTupel(model: model, updated: updated)
	}
	
	private static func map(statusUpdateModel: VehicleStatusDTO, cachedVehicleStatus: VehicleStatusModel) -> TheftTupel {
		
		let collisionTupel: CollisionTupel = self.map(statusUpdateModel: statusUpdateModel, cachedVehicleStatus: cachedVehicleStatus)
		let model = VehicleTheftModel(collision: collisionTupel.model,
									  interiorProtectionSensorStatus: self.map(statusAttribute: statusUpdateModel.interiorProtectionSensorStatus,
																			   cachedStatusAttribute: cachedVehicleStatus.theft.interiorProtectionSensorStatus),
									  keyActivationState: self.map(statusAttribute: statusUpdateModel.keyActivationState,
									  
																   cachedStatusAttribute: cachedVehicleStatus.theft.keyActivationState),
									  lastTheftWarning: self.map(statusAttribute: statusUpdateModel.lastTheftWarning,
																 cachedStatusAttribute: cachedVehicleStatus.theft.lastTheftWarning),
									  lastTheftWarningReason: self.map(statusAttribute: statusUpdateModel.lastTheftWarningReason,
																	   cachedStatusAttribute: cachedVehicleStatus.theft.lastTheftWarningReason),
									  theftAlarmActive: self.map(statusAttribute: statusUpdateModel.theftAlarmActive,
																 cachedStatusAttribute: cachedVehicleStatus.theft.theftAlarmActive),
									  theftSystemArmed: self.map(statusAttribute: statusUpdateModel.theftSystemArmed,
																 cachedStatusAttribute: cachedVehicleStatus.theft.theftSystemArmed),
									  towProtectionSensorStatus: self.map(statusAttribute: statusUpdateModel.towProtectionSensorStatus,
                                          cachedStatusAttribute: cachedVehicleStatus.theft.towProtectionSensorStatus))
		
		let updated = statusUpdateModel.interiorProtectionSensorStatus != nil ||
			statusUpdateModel.keyActivationState != nil ||
            statusUpdateModel.lastTheftWarningReason != nil ||
            statusUpdateModel.lastTheftWarning != nil ||
			statusUpdateModel.theftAlarmActive != nil ||
            statusUpdateModel.theftSystemArmed != nil ||
			statusUpdateModel.towProtectionSensorStatus != nil ||
			collisionTupel.updated
		
		return TheftTupel(model: model, updated: updated)
	}
	
	private static func map(statusUpdateModel: VehicleStatusDTO, cachedVehicleStatus: VehicleStatusModel) -> TiresTupel {
		
		let frontLeft = VehicleTireModel(pressure: self.map(statusAttribute: statusUpdateModel.tirePressureFrontLeft,
															cachedStatusAttribute: cachedVehicleStatus.tires.frontLeft.pressure),
										 warningLevel: self.map(statusAttribute: statusUpdateModel.tireMarkerFrontLeft,
																cachedStatusAttribute: cachedVehicleStatus.tires.frontLeft.warningLevel))
		let frontRight = VehicleTireModel(pressure: self.map(statusAttribute: statusUpdateModel.tirePressureFrontRight,
															 cachedStatusAttribute: cachedVehicleStatus.tires.frontRight.pressure),
										  warningLevel: self.map(statusAttribute: statusUpdateModel.tireMarkerFrontRight,
																 cachedStatusAttribute: cachedVehicleStatus.tires.frontRight.warningLevel))
		let rearLeft = VehicleTireModel(pressure: self.map(statusAttribute: statusUpdateModel.tirePressureRearLeft,
														   cachedStatusAttribute: cachedVehicleStatus.tires.rearLeft.pressure),
										warningLevel: self.map(statusAttribute: statusUpdateModel.tireMarkerRearLeft,
															   cachedStatusAttribute: cachedVehicleStatus.tires.rearLeft.warningLevel))
		let rearRight = VehicleTireModel(pressure: self.map(statusAttribute: statusUpdateModel.tirePressureRearRight,
															cachedStatusAttribute: cachedVehicleStatus.tires.rearRight.pressure),
										 warningLevel: self.map(statusAttribute: statusUpdateModel.tireMarkerRearRight,
																cachedStatusAttribute: cachedVehicleStatus.tires.rearRight.warningLevel))
		
		let model = VehicleTiresModel(frontLeft: frontLeft,
									  frontRight: frontRight,
									  pressureMeasurementTimestamp: self.map(statusAttribute: statusUpdateModel.tirePressureMeasTimestamp,
																			 cachedStatusAttribute: cachedVehicleStatus.tires.pressureMeasurementTimestamp),
									  rearLeft: rearLeft,
									  rearRight: rearRight,
									  sensorAvailable: self.map(statusAttribute: statusUpdateModel.tireSensorAvailable,
																cachedStatusAttribute: cachedVehicleStatus.tires.sensorAvailable),
									  warningLevelOverall: self.map(statusAttribute: statusUpdateModel.warningTireSrdk,
																	cachedStatusAttribute: cachedVehicleStatus.tires.warningLevelOverall))


		let updated = statusUpdateModel.tireMarkerFrontLeft != nil ||
			statusUpdateModel.tireMarkerFrontRight != nil ||
			statusUpdateModel.tireMarkerRearLeft != nil ||
			statusUpdateModel.tireMarkerRearRight != nil ||
			statusUpdateModel.tirePressureFrontLeft != nil ||
			statusUpdateModel.tirePressureFrontRight != nil ||
			statusUpdateModel.tirePressureMeasTimestamp != nil ||
			statusUpdateModel.tirePressureRearLeft != nil ||
			statusUpdateModel.tirePressureRearRight != nil ||
			statusUpdateModel.tireSensorAvailable != nil
		
		return TiresTupel(model: model, updated: updated)
	}
	
	private static func map(statusUpdateModel: VehicleStatusDTO, cachedVehicleStatus: VehicleStatusModel) -> VehicleTupel {
		
		let model = VehicleVehicleModel(dataConnectionState: self.map(statusAttribute: statusUpdateModel.vehicleDataConnectionState,
																	  cachedStatusAttribute: cachedVehicleStatus.vehicle.dataConnectionState),
										engineHoodStatus: self.map(statusAttribute: statusUpdateModel.engineHoodStatus,
																   cachedStatusAttribute: cachedVehicleStatus.vehicle.engineHoodStatus),
										filterParticaleState: self.map(statusAttribute: statusUpdateModel.filterParticleLoading,
																	   cachedStatusAttribute: cachedVehicleStatus.vehicle.filterParticaleState),
										odo: self.map(statusAttribute: statusUpdateModel.odo,
													  cachedStatusAttribute: cachedVehicleStatus.vehicle.odo),
										lockGasState: self.map(statusAttribute: statusUpdateModel.doorLockStatusGas,
															   cachedStatusAttribute: cachedVehicleStatus.vehicle.lockGasState),
										parkBrakeStatus: self.map(statusAttribute: statusUpdateModel.parkBrakeStatus,
																  cachedStatusAttribute: cachedVehicleStatus.vehicle.parkBrakeStatus),
										roofTopState: self.map(statusAttribute: statusUpdateModel.roofTopStatus,
															   cachedStatusAttribute: cachedVehicleStatus.vehicle.roofTopState),
										serviceIntervalDays: self.map(statusAttribute: statusUpdateModel.serviceIntervalDays,
																	  cachedStatusAttribute: cachedVehicleStatus.vehicle.serviceIntervalDays),
										serviceIntervalDistance: self.map(statusAttribute: statusUpdateModel.serviceIntervalDistance,
																		  cachedStatusAttribute: cachedVehicleStatus.vehicle.serviceIntervalDistance),
										soc: self.map(statusAttribute: statusUpdateModel.soc,
                                                      cachedStatusAttribute: cachedVehicleStatus.vehicle.soc),
                                        speedAlert: self.map(statusAttribute: statusUpdateModel.speedAlert,
                                                                                cachedStatusAttribute: cachedVehicleStatus.vehicle.speedAlert),
										speedUnitFromIC: self.map(statusAttribute: statusUpdateModel.speedUnitFromIC,
																  cachedStatusAttribute: cachedVehicleStatus.vehicle.speedUnitFromIC),
										starterBatteryState: self.map(statusAttribute: statusUpdateModel.starterBatteryState,
																	  cachedStatusAttribute: cachedVehicleStatus.vehicle.starterBatteryState),
										time: self.map(statusAttribute: statusUpdateModel.vTime,
													   cachedStatusAttribute: cachedVehicleStatus.vehicle.time),
										vehicleLockState: self.map(statusAttribute: statusUpdateModel.vehicleLockState,
																   cachedStatusAttribute: cachedVehicleStatus.vehicle.vehicleLockState))
		
		let updated = statusUpdateModel.vehicleDataConnectionState != nil ||
			statusUpdateModel.engineHoodStatus != nil ||
			statusUpdateModel.filterParticleLoading != nil ||
			statusUpdateModel.ignitionState != nil ||
			statusUpdateModel.odo != nil ||
			statusUpdateModel.doorLockStatusGas != nil ||
			statusUpdateModel.vehicleLockState != nil ||
			statusUpdateModel.parkBrakeStatus != nil ||
			statusUpdateModel.roofTopStatus != nil ||
			statusUpdateModel.serviceIntervalDays != nil ||
			statusUpdateModel.serviceIntervalDistance != nil ||
			statusUpdateModel.soc != nil ||
			statusUpdateModel.speedAlert != nil ||
			statusUpdateModel.speedUnitFromIC != nil ||
			statusUpdateModel.starterBatteryState != nil ||
			statusUpdateModel.vTime != nil ||
			statusUpdateModel.vehicleLockState != nil
		
		return VehicleTupel(model: model, updated: updated)
	}
	
	private static func map(statusUpdateModel: VehicleStatusDTO, cachedVehicleStatus: VehicleStatusModel) -> WarningsTupel {
		
		let model = VehicleWarningsModel(brakeFluid: self.map(statusAttribute: statusUpdateModel.warningBreakFluid,
															  cachedStatusAttribute: cachedVehicleStatus.warnings.brakeFluid),
										 brakeLiningWear: self.map(statusAttribute: statusUpdateModel.warningBrakeLiningWear,
																   cachedStatusAttribute: cachedVehicleStatus.warnings.brakeLiningWear),
										 coolantLevelLow: self.map(statusAttribute: statusUpdateModel.warningCoolantLevelLow,
																   cachedStatusAttribute: cachedVehicleStatus.warnings.coolantLevelLow),
										 electricalRangeSkipIndication: self.map(statusAttribute: statusUpdateModel.electricalRangeSkipIndication,
																				 cachedStatusAttribute: cachedVehicleStatus.warnings.electricalRangeSkipIndication),
										 engineLight: self.map(statusAttribute: statusUpdateModel.warningEngineLight,
															   cachedStatusAttribute: cachedVehicleStatus.warnings.engineLight),
										 liquidRangeSkipIndication: self.map(statusAttribute: statusUpdateModel.liquidRangeSkipIndication,
																			 cachedStatusAttribute: cachedVehicleStatus.warnings.liquidRangeSkipIndication),
										 tireLamp: self.map(statusAttribute: statusUpdateModel.warningTireLamp,
															cachedStatusAttribute: cachedVehicleStatus.warnings.tireLamp),
										 tireLevelPrw: self.map(statusAttribute: statusUpdateModel.warningTireLevelPrw,
																cachedStatusAttribute: cachedVehicleStatus.warnings.tireLevelPrw),
										 tireSprw: self.map(statusAttribute: statusUpdateModel.warningTireSprw,
															cachedStatusAttribute: cachedVehicleStatus.warnings.tireSprw),
										 washWater: self.map(statusAttribute: statusUpdateModel.warningWashWater,
															 cachedStatusAttribute: cachedVehicleStatus.warnings.washWater))
		
		let updated = statusUpdateModel.warningBreakFluid != nil ||
			statusUpdateModel.warningBrakeLiningWear != nil ||
			statusUpdateModel.warningCoolantLevelLow != nil ||
			statusUpdateModel.electricalRangeSkipIndication != nil ||
			statusUpdateModel.warningEngineLight != nil ||
			statusUpdateModel.liquidRangeSkipIndication != nil ||
			statusUpdateModel.warningTireLamp != nil ||
			statusUpdateModel.warningTireLevelPrw != nil ||
			statusUpdateModel.warningTireSprw != nil ||
			statusUpdateModel.warningTireSrdk != nil ||
			statusUpdateModel.warningWashWater != nil
		
		return WarningsTupel(model: model, updated: updated)
	}
	
	private static func map(statusUpdateModel: VehicleStatusDTO, cachedVehicleStatus: VehicleStatusModel) -> WindowsTupel {
		
		let sunroof: SunroofTupel = self.map(statusUpdateModel: statusUpdateModel, cachedVehicleStatus: cachedVehicleStatus)
		let model = VehicleWindowsModel(blindRear: self.map(statusAttribute: statusUpdateModel.windowBlindRearStatus,
															cachedStatusAttribute: cachedVehicleStatus.windows.blindRear),
										blindRearLeft: self.map(statusAttribute: statusUpdateModel.windowBlindRearLeftStatus,
																cachedStatusAttribute: cachedVehicleStatus.windows.blindRearLeft),
										blindRearRight: self.map(statusAttribute: statusUpdateModel.windowBlindRearRightStatus,
																 cachedStatusAttribute: cachedVehicleStatus.windows.blindRearRight),
										flipWindowStatus: self.map(statusAttribute: statusUpdateModel.flipWindowStatus,
																   cachedStatusAttribute: cachedVehicleStatus.windows.flipWindowStatus),
										frontLeft: self.map(statusAttribute: statusUpdateModel.windowFrontLeftState,
															cachedStatusAttribute: cachedVehicleStatus.windows.frontLeft),
										frontRight: self.map(statusAttribute: statusUpdateModel.windowFrontRightState,
															 cachedStatusAttribute: cachedVehicleStatus.windows.frontRight),
										overallState: self.map(statusAttribute: statusUpdateModel.windowStatusOverall,
															   cachedStatusAttribute: cachedVehicleStatus.windows.overallState),
										rearLeft: self.map(statusAttribute: statusUpdateModel.windowRearLeftState,
														   cachedStatusAttribute: cachedVehicleStatus.windows.rearLeft),
										rearRight: self.map(statusAttribute: statusUpdateModel.windowRearRightState,
															cachedStatusAttribute: cachedVehicleStatus.windows.rearRight),
										sunroof: sunroof.model)
		
		let updated = statusUpdateModel.flipWindowStatus != nil ||
			statusUpdateModel.windowFrontLeftState != nil ||
			statusUpdateModel.windowFrontRightState != nil ||
			statusUpdateModel.windowRearLeftState != nil ||
			statusUpdateModel.windowRearRightState != nil ||
			statusUpdateModel.windowStatusOverall != nil ||
			sunroof.updated ||
            statusUpdateModel.windowBlindRearStatus != nil ||
            statusUpdateModel.windowBlindRearLeftStatus != nil ||
            statusUpdateModel.windowBlindRearRightStatus
            != nil
		return WindowsTupel(model: model, updated: updated)
	}
	
	private static func map(statusUpdateModel: VehicleStatusDTO, cachedVehicleStatus: VehicleStatusModel) -> VehicleZEVTemperatureModel {
		return VehicleZEVTemperatureModel(frontCenter: self.map(statusAttribute: statusUpdateModel.temperaturePointFrontCenter,
																cachedStatusAttribute: cachedVehicleStatus.zev.temperature.frontCenter),
										  frontLeft: self.map(statusAttribute: statusUpdateModel.temperaturePointFrontLeft,
															  cachedStatusAttribute: cachedVehicleStatus.zev.temperature.frontLeft),
										  frontRight: self.map(statusAttribute: statusUpdateModel.temperaturePointFrontRight,
															   cachedStatusAttribute: cachedVehicleStatus.zev.temperature.frontRight),
										  rearCenter: self.map(statusAttribute: statusUpdateModel.temperaturePointRearCenter,
															   cachedStatusAttribute: cachedVehicleStatus.zev.temperature.rearCenter),
										  rearCenter2: self.map(statusAttribute: statusUpdateModel.temperaturePointRearCenter2,
																cachedStatusAttribute: cachedVehicleStatus.zev.temperature.rearCenter2),
										  rearLeft: self.map(statusAttribute: statusUpdateModel.temperaturePointRearLeft,
															 cachedStatusAttribute: cachedVehicleStatus.zev.temperature.rearLeft),
										  rearRight: self.map(statusAttribute: statusUpdateModel.temperaturePointRearRight,
															  cachedStatusAttribute: cachedVehicleStatus.zev.temperature.rearRight))
	}

    private static func map(statusUpdateModel: VehicleStatusDTO, cachedVehicleStatus: VehicleStatusModel) -> DrivingModeTupel {
        
        let model = VehicleDrivingModeModel(
            teenage: self.map(statusAttribute: statusUpdateModel.teenageDrivingMode,
                              cachedStatusAttribute: cachedVehicleStatus.drivingMode.teenage),
            valet: self.map(statusAttribute: statusUpdateModel.valetDrivingMode,
                            cachedStatusAttribute: cachedVehicleStatus.drivingMode.valet))
        
        let updated = statusUpdateModel.teenageDrivingMode != nil ||
                      statusUpdateModel.valetDrivingMode != nil
        
        return DrivingModeTupel(model: model, updated: updated)
    }
    
	private static func map(statusUpdateModel: VehicleStatusDTO, cachedVehicleStatus: VehicleStatusModel) -> ZEVTupel {

		let temperature: VehicleZEVTemperatureModel = self.map(statusUpdateModel: statusUpdateModel,
															   cachedVehicleStatus: cachedVehicleStatus)
		let model = VehicleZEVModel(acChargingCurrentLimitation: self.map(statusAttribute: statusUpdateModel.acChargingCurrentLimitation,
																		  cachedStatusAttribute: cachedVehicleStatus.zev.acChargingCurrentLimitation),
									bidirectionalChargingActive: self.map(statusAttribute: statusUpdateModel.bidirectionalChargingActive,
																		  cachedStatusAttribute: cachedVehicleStatus.zev.bidirectionalChargingActive),
									chargeCouplerACLockStatus: self.map(statusAttribute: statusUpdateModel.chargeCouplerACLockStatus,
																		cachedStatusAttribute: cachedVehicleStatus.zev.chargeCouplerACLockStatus),
									chargeCouplerACStatus: self.map(statusAttribute: statusUpdateModel.chargeCouplerACStatus,
																	cachedStatusAttribute: cachedVehicleStatus.zev.chargeCouplerACStatus),
									chargeCouplerDCLockStatus: self.map(statusAttribute: statusUpdateModel.chargeCouplerDCLockStatus,
																		cachedStatusAttribute: cachedVehicleStatus.zev.chargeCouplerDCLockStatus),
									chargeCouplerDCStatus: self.map(statusAttribute: statusUpdateModel.chargeCouplerDCStatus,
																	cachedStatusAttribute: cachedVehicleStatus.zev.chargeCouplerDCStatus),
									chargeFlapACStatus: self.map(statusAttribute: statusUpdateModel.chargeFlapACStatus,
																 cachedStatusAttribute: cachedVehicleStatus.zev.chargeFlapACStatus),
									chargeFlapDCStatus: self.map(statusAttribute: statusUpdateModel.chargeFlapDCStatus,
																 cachedStatusAttribute: cachedVehicleStatus.zev.chargeFlapDCStatus),
									chargePrograms: self.map(statusAttribute: statusUpdateModel.chargePrograms,
                                                             cachedStatusAttribute: cachedVehicleStatus.zev.chargePrograms),
                                    chargingActive: self.map(statusAttribute: statusUpdateModel.chargingActive,
															 cachedStatusAttribute: cachedVehicleStatus.zev.chargingActive),
									chargingBreakClockTimer: self.map(statusAttribute: statusUpdateModel.chargingBreakClockTimer,
																	  cachedStatusAttribute: cachedVehicleStatus.zev.chargingBreakClockTimer),
									chargingError: self.map(statusAttribute: statusUpdateModel.chargingErrorDetails,
															cachedStatusAttribute: cachedVehicleStatus.zev.chargingError),
									chargingErrorInfrastructure: self.map(statusAttribute: statusUpdateModel.chargingErrorInfrastructure,
																		  cachedStatusAttribute: cachedVehicleStatus.zev.chargingErrorInfrastructure),
									chargingErrorWim: self.map(statusAttribute: statusUpdateModel.chargingErrorWim,
															   cachedStatusAttribute: cachedVehicleStatus.zev.chargingErrorWim),
									chargingMode: self.map(statusAttribute: statusUpdateModel.chargingMode,
														   cachedStatusAttribute: cachedVehicleStatus.zev.chargingMode),
									chargingPower: self.map(statusAttribute: statusUpdateModel.chargingPower,
															cachedStatusAttribute: cachedVehicleStatus.zev.chargingPower),
									chargingPowerControl: self.map(statusAttribute: statusUpdateModel.chargingPowerControl,
																   cachedStatusAttribute: cachedVehicleStatus.zev.chargingPowerControl),
									chargingPowerEcoLimit: self.map(statusAttribute: statusUpdateModel.chargingPowerEcoLimit,
																	cachedStatusAttribute: cachedVehicleStatus.zev.chargingPowerEcoLimit),
									chargingStatus: self.map(statusAttribute: statusUpdateModel.chargingStatus,
															 cachedStatusAttribute: cachedVehicleStatus.zev.chargingStatus),
									chargingTimeType: self.map(statusAttribute: statusUpdateModel.chargingTimeType,
															   cachedStatusAttribute: cachedVehicleStatus.zev.chargingTimeType),
									departureTime: self.map(statusAttribute: statusUpdateModel.departureTime,
															cachedStatusAttribute: cachedVehicleStatus.zev.departureTime),
									departureTimeIcon: self.map(statusAttribute: statusUpdateModel.departureTimeIcon,
																cachedStatusAttribute: cachedVehicleStatus.zev.departureTimeIcon),
									departureTimeMode: self.map(statusAttribute: statusUpdateModel.departureTimeMode,
																cachedStatusAttribute: cachedVehicleStatus.zev.departureTimeMode),
									departureTimeSoc: self.map(statusAttribute: statusUpdateModel.departureTimeSoc,
															   cachedStatusAttribute: cachedVehicleStatus.zev.departureTimeSoc),
									departureTimeWeekday: self.map(statusAttribute: statusUpdateModel.departureTimeWeekday,
																   cachedStatusAttribute: cachedVehicleStatus.zev.departureTimeWeekday),
									endOfChargeTime: self.map(statusAttribute: statusUpdateModel.endOfChargeTime,
															  cachedStatusAttribute: cachedVehicleStatus.zev.endOfChargeTime),
									endOfChargeTimeRelative: self.map(statusAttribute: statusUpdateModel.endOfChargeTimeRelative,
																	  cachedStatusAttribute: cachedVehicleStatus.zev.endOfChargeTimeRelative),
									endOfChargeTimeWeekday: self.map(statusAttribute: statusUpdateModel.endOfChargeTimeWeekday,
																	 cachedStatusAttribute: cachedVehicleStatus.zev.endOfChargeTimeWeekday),
									hybridWarnings: self.map(statusAttribute: statusUpdateModel.hybridWarnings,
															 cachedStatusAttribute: cachedVehicleStatus.zev.hybridWarnings),
									isActive: self.map(statusAttribute: statusUpdateModel.zevActive,
													   cachedStatusAttribute: cachedVehicleStatus.zev.isActive),
									maxRange: self.map(statusAttribute: statusUpdateModel.maxRange,
													   cachedStatusAttribute: cachedVehicleStatus.zev.maxRange),
									maxSoc: self.map(statusAttribute: statusUpdateModel.maxSoc,
													 cachedStatusAttribute: cachedVehicleStatus.zev.maxSoc),
									maxSocLowerLimit: self.map(statusAttribute: statusUpdateModel.maxSocLowerLimit,
															   cachedStatusAttribute: cachedVehicleStatus.zev.maxSocLowerLimit),
									maxSocUpperLimit: self.map(statusAttribute: statusUpdateModel.maxSocUpperLimit,
															   cachedStatusAttribute: cachedVehicleStatus.zev.maxSocUpperLimit),
									minSoc: self.map(statusAttribute: statusUpdateModel.minSoc,
													 cachedStatusAttribute: cachedVehicleStatus.zev.minSoc),
									minSocLowerLimit: self.map(statusAttribute: statusUpdateModel.minSocLowerLimit,
															   cachedStatusAttribute: cachedVehicleStatus.zev.minSocLowerLimit),
									minSocUpperLimit: self.map(statusAttribute: statusUpdateModel.minSocUpperLimit,
															   cachedStatusAttribute: cachedVehicleStatus.zev.minSocUpperLimit),
									nextDepartureTime: self.map(statusAttribute: statusUpdateModel.nextDepartureTime,
																cachedStatusAttribute: cachedVehicleStatus.zev.nextDepartureTime),
									nextDepartureTimeWeekday: self.map(statusAttribute: statusUpdateModel.nextDepartureTimeWeekday,
																	   cachedStatusAttribute: cachedVehicleStatus.zev.nextDepartureTimeWeekday),
									precondActive: self.map(statusAttribute: statusUpdateModel.precondActive,
															cachedStatusAttribute: cachedVehicleStatus.zev.precondActive),
									precondAtDeparture: self.map(statusAttribute: statusUpdateModel.precondAtDeparture,
																 cachedStatusAttribute: cachedVehicleStatus.zev.precondAtDeparture),
									precondAtDepartureDisable: self.map(statusAttribute: statusUpdateModel.precondAtDepartureDisable,
																		cachedStatusAttribute: cachedVehicleStatus.zev.precondAtDepartureDisable),
									precondDuration: self.map(statusAttribute: statusUpdateModel.precondDuration,
															  cachedStatusAttribute: cachedVehicleStatus.zev.precondDuration),
									precondError: self.map(statusAttribute: statusUpdateModel.precondError,
														   cachedStatusAttribute: cachedVehicleStatus.zev.precondError),
									precondNow: self.map(statusAttribute: statusUpdateModel.precondNow,
														 cachedStatusAttribute: cachedVehicleStatus.zev.precondNow),
									precondNowError: self.map(statusAttribute: statusUpdateModel.precondNowError,
															  cachedStatusAttribute: cachedVehicleStatus.zev.precondNowError),
									precondSeatFrontLeft: self.map(statusAttribute: statusUpdateModel.precondSeatFrontLeft,
																   cachedStatusAttribute: cachedVehicleStatus.zev.precondSeatFrontLeft),
									precondSeatFrontRight: self.map(statusAttribute: statusUpdateModel.precondSeatFrontRight,
																	cachedStatusAttribute: cachedVehicleStatus.zev.precondSeatFrontRight),
									precondSeatRearLeft: self.map(statusAttribute: statusUpdateModel.precondSeatRearLeft,
																  cachedStatusAttribute: cachedVehicleStatus.zev.precondSeatRearLeft),
									precondSeatRearRight: self.map(statusAttribute: statusUpdateModel.precondSeatRearRight,
																   cachedStatusAttribute: cachedVehicleStatus.zev.precondSeatRearRight),
									rangeAssistDriveOnSoc: self.map(statusAttribute: statusUpdateModel.evRangeAssistDriveOnSoc,
																	cachedStatusAttribute: cachedVehicleStatus.zev.rangeAssistDriveOnSoc),
									rangeAssistDriveOnTime: self.map(statusAttribute: statusUpdateModel.evRangeAssistDriveOnTime,
																	 cachedStatusAttribute: cachedVehicleStatus.zev.rangeAssistDriveOnTime),
									selectedChargeProgram: self.map(statusAttribute: statusUpdateModel.selectedChargeProgram,
																	cachedStatusAttribute: cachedVehicleStatus.zev.selectedChargeProgram),
									smartCharging: self.map(statusAttribute: statusUpdateModel.smartCharging,
															cachedStatusAttribute: cachedVehicleStatus.zev.smartCharging),
									smartChargingAtDeparture: self.map(statusAttribute: statusUpdateModel.smartChargingAtDeparture,
																	   cachedStatusAttribute: cachedVehicleStatus.zev.smartChargingAtDeparture),
									smartChargingAtDeparture2: self.map(statusAttribute: statusUpdateModel.smartChargingAtDeparture2,
																		cachedStatusAttribute: cachedVehicleStatus.zev.smartChargingAtDeparture2),
									socProfile: self.map(statusAttribute: statusUpdateModel.socProfile,
														 cachedStatusAttribute: cachedVehicleStatus.zev.socProfile),
									temperature: temperature,
									weekdayTariff: self.map(statusAttribute: statusUpdateModel.weekdaytariff,
															cachedStatusAttribute: cachedVehicleStatus.zev.weekdayTariff),
									weekendTariff: self.map(statusAttribute: statusUpdateModel.weekendtariff,
															cachedStatusAttribute: cachedVehicleStatus.zev.weekendTariff))

		let updated = statusUpdateModel.acChargingCurrentLimitation != nil ||
			statusUpdateModel.bidirectionalChargingActive != nil ||
			statusUpdateModel.chargeCouplerACLockStatus != nil ||
			statusUpdateModel.chargeCouplerACStatus != nil ||
			statusUpdateModel.chargeCouplerDCLockStatus != nil ||
			statusUpdateModel.chargeCouplerDCStatus != nil ||
			statusUpdateModel.chargeFlapACStatus != nil ||
			statusUpdateModel.chargePrograms != nil ||
			statusUpdateModel.chargingActive != nil ||
			statusUpdateModel.chargingBreakClockTimer != nil ||
			statusUpdateModel.chargingErrorDetails != nil ||
			statusUpdateModel.chargingErrorInfrastructure != nil ||
			statusUpdateModel.chargingErrorWim != nil ||
			statusUpdateModel.chargingMode != nil ||
			statusUpdateModel.chargingPower != nil ||
			statusUpdateModel.chargingPowerControl != nil ||
			statusUpdateModel.chargingPowerEcoLimit != nil ||
			statusUpdateModel.chargingStatus != nil ||
			statusUpdateModel.chargingTimeType != nil ||
			statusUpdateModel.departureTime != nil ||
			statusUpdateModel.departureTimeIcon != nil ||
			statusUpdateModel.departureTimeMode != nil ||
			statusUpdateModel.departureTimeSoc != nil ||
			statusUpdateModel.departureTimeWeekday != nil ||
			statusUpdateModel.endOfChargeTime != nil ||
			statusUpdateModel.endOfChargeTimeRelative != nil ||
			statusUpdateModel.endOfChargeTimeWeekday != nil ||
			statusUpdateModel.evRangeAssistDriveOnSoc != nil ||
			statusUpdateModel.evRangeAssistDriveOnTime != nil ||
			statusUpdateModel.hybridWarnings != nil ||
			statusUpdateModel.maxRange != nil ||
			statusUpdateModel.maxSoc != nil ||
			statusUpdateModel.maxSocLowerLimit != nil ||
			statusUpdateModel.maxSocUpperLimit != nil ||
			statusUpdateModel.minSoc != nil ||
			statusUpdateModel.minSocLowerLimit != nil ||
			statusUpdateModel.minSocUpperLimit != nil ||
			statusUpdateModel.nextDepartureTime != nil ||
			statusUpdateModel.nextDepartureTimeWeekday != nil ||
			statusUpdateModel.precondActive != nil ||
			statusUpdateModel.precondAtDeparture != nil ||
			statusUpdateModel.precondAtDepartureDisable != nil ||
			statusUpdateModel.precondDuration != nil ||
			statusUpdateModel.precondError != nil ||
			statusUpdateModel.precondNow != nil ||
			statusUpdateModel.precondNowError != nil ||
			statusUpdateModel.precondSeatFrontLeft != nil ||
			statusUpdateModel.precondSeatFrontRight != nil ||
			statusUpdateModel.precondSeatRearLeft != nil ||
			statusUpdateModel.precondSeatRearRight != nil ||
			statusUpdateModel.selectedChargeProgram != nil ||
			statusUpdateModel.smartCharging != nil ||
			statusUpdateModel.smartChargingAtDeparture != nil ||
			statusUpdateModel.smartChargingAtDeparture2 != nil ||
			statusUpdateModel.socProfile != nil ||
			statusUpdateModel.temperaturePointFrontCenter != nil ||
			statusUpdateModel.temperaturePointFrontLeft != nil ||
			statusUpdateModel.temperaturePointFrontRight != nil ||
			statusUpdateModel.temperaturePointRearCenter != nil ||
			statusUpdateModel.temperaturePointRearCenter2 != nil ||
			statusUpdateModel.temperaturePointRearLeft != nil ||
			statusUpdateModel.temperaturePointRearRight != nil ||
			statusUpdateModel.weekdaytariff != nil ||
			statusUpdateModel.weekendtariff != nil ||
			statusUpdateModel.zevActive != nil
		
		return ZEVTupel(model: model, updated: updated)
	}
	
	private static func mapToSeconds(milliseconds: Int64) -> Int64 {
		return milliseconds / 1000
	}
}

// swiftlint:enable function_body_length
// swiftlint:enable line_length
// swiftlint:enable type_body_length
