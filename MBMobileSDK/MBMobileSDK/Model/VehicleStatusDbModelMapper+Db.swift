//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import MBRealmKit

// swiftlint:disable line_length

extension VehicleStatusDbModelMapper {
	
	internal func map<T: RawRepresentable>(statusAttribute: StatusAttributeType<Bool, T>, dbModel: DBVehicleStatusBoolModel?) -> DBVehicleStatusBoolModel where T.RawValue == Int {

		let newDbModel: DBVehicleStatusBoolModel = {
			guard let dbModel = dbModel else {
				return DBVehicleStatusBoolModel()
			}
			return dbModel
		}()
		newDbModel.displayUnit.value = statusAttribute.unit?.unit?.rawValue
		newDbModel.displayValue      = statusAttribute.unit?.value ?? ""
		newDbModel.status            = statusAttribute.status
		newDbModel.timestamp         = statusAttribute.timestamp ?? 0
		newDbModel.value.value       = statusAttribute.value
		return newDbModel
	}
	
	internal func map<T: RawRepresentable, U: RawRepresentable>(statusAttribute: StatusAttributeType<T, U>, dbModel: DBVehicleStatusBoolModel?) -> DBVehicleStatusBoolModel where T.RawValue == Bool, U.RawValue == Int {
		
		let boolStatusAttribute: StatusAttributeType<Bool, U> = {
			switch statusAttribute {
			case .invalid(let timestamp):						return .invalid(timestamp: timestamp)
			case .notAvailable(let timestamp):					return .notAvailable(timestamp: timestamp)
			case .noValue(let timestamp):						return .noValue(timestamp: timestamp)
			case .valid(let value, let timestamp, let unit):	return .valid(value: value?.rawValue, timestamp: timestamp, unit: unit)
			}
		}()
		
		return self.map(statusAttribute: boolStatusAttribute, dbModel: dbModel)
	}
	
	internal func map<T: RawRepresentable>(statusAttribute: StatusAttributeType<[DayTimeModel], T>, dbModel: DBVehicleStatusDayTimeModel?) -> DBVehicleStatusDayTimeModel where T.RawValue == Int {
		
		let newDbModel: DBVehicleStatusDayTimeModel = {
			guard let dbModel = dbModel else {
				return DBVehicleStatusDayTimeModel()
			}
			return dbModel
		}()
		newDbModel.displayValue = statusAttribute.unit?.value ?? ""
		newDbModel.status       = statusAttribute.status
		newDbModel.timestamp    = statusAttribute.timestamp ?? 0
		
		newDbModel.days.removeAll()
		newDbModel.days.append(objectsIn: statusAttribute.value?.map { $0.day.rawValue } ?? [])
		newDbModel.times.removeAll()
		newDbModel.times.append(objectsIn: statusAttribute.value?.map { $0.time } ?? [])
		
		return newDbModel
	}
	
	internal func map<T: RawRepresentable>(statusAttribute: StatusAttributeType<WeeklyProfileModel, T>, dbModel: DBVehicleStatusWeeklyProfileModel?) -> DBVehicleStatusWeeklyProfileModel where T.RawValue == Int {
		
		let newDbModel: DBVehicleStatusWeeklyProfileModel = {
			guard let dbModel = dbModel else {
				return DBVehicleStatusWeeklyProfileModel()
			}
			return dbModel
		}()
		newDbModel.displayValue = statusAttribute.unit?.value ?? ""
		newDbModel.status       = statusAttribute.status
		newDbModel.timestamp    = statusAttribute.timestamp ?? 0
		
		newDbModel.currentNumberOfTimeProfiles = Int32(statusAttribute.value?.currentTimeProfiles ?? 0)
		newDbModel.currentNumberOfTimeProfileSlots = Int32(statusAttribute.value?.currentSlots ?? 0)
		newDbModel.maxNumberOfTimeProfiles = Int32(statusAttribute.value?.maxTimeProfiles ?? 0)
		newDbModel.maxNumberOfWeeklyTimeProfileSlots = Int32(statusAttribute.value?.maxSlots ?? 0)
		newDbModel.singleTimeProfileEntriesActivatable = statusAttribute.value?.singleEntriesActivatable ?? false
		
		newDbModel.timeProfiles.removeAll()
		newDbModel.timeProfiles.append(objectsIn: statusAttribute.value?.timeProfiles.map { self.map(timeProfile: $0, dbModel: DBVehicleStatusTimeProfileModel()) } ?? [])
		
		return newDbModel
	}
	
	internal func map(timeProfile: TimeProfile, dbModel: DBVehicleStatusTimeProfileModel?) -> DBVehicleStatusTimeProfileModel {
		
		let newDbModel: DBVehicleStatusTimeProfileModel = {
			guard let dbModel = dbModel else {
				return DBVehicleStatusTimeProfileModel()
			}
			return dbModel
		}()
		
		if let id = timeProfile.identifier {
			newDbModel.identifier = id
		}
		
		newDbModel.active = timeProfile.active
		newDbModel.applicationIdentifier = timeProfile.applicationIdentifier
		newDbModel.hour = timeProfile.hour
		newDbModel.minute = timeProfile.minute
		newDbModel.days.append(objectsIn: timeProfile.days.map { $0.rawValue })
		
		return newDbModel
	}
	
	internal func map<T: RawRepresentable>(statusAttribute: StatusAttributeType<Double, T>, dbModel: DBVehicleStatusDoubleModel?) -> DBVehicleStatusDoubleModel where T.RawValue == Int {
		
		let newDbModel: DBVehicleStatusDoubleModel = {
			guard let dbModel = dbModel else {
				return DBVehicleStatusDoubleModel()
			}
			return dbModel
		}()
		newDbModel.displayUnit.value = statusAttribute.unit?.unit?.rawValue
		newDbModel.displayValue      = statusAttribute.unit?.value ?? ""
		newDbModel.status            = statusAttribute.status
		newDbModel.timestamp         = statusAttribute.timestamp ?? 0
		newDbModel.value.value       = statusAttribute.value
		return newDbModel
	}
	
	internal func map<T: RawRepresentable, U: RawRepresentable>(statusAttribute: StatusAttributeType<T, U>, dbModel: DBVehicleStatusDoubleModel?) -> DBVehicleStatusDoubleModel where T.RawValue == Double, U.RawValue == Int {
		
		let doubleStatusAttribute: StatusAttributeType<Double, U> = {
			switch statusAttribute {
			case .invalid(let timestamp):						return .invalid(timestamp: timestamp)
			case .notAvailable(let timestamp):					return .notAvailable(timestamp: timestamp)
			case .noValue(let timestamp):						return .noValue(timestamp: timestamp)
			case .valid(let value, let timestamp, let unit):	return .valid(value: value?.rawValue, timestamp: timestamp, unit: unit)
			}
		}()
		
		return self.map(statusAttribute: doubleStatusAttribute, dbModel: dbModel)
	}
	
	internal func map<T: RawRepresentable>(statusAttribute: StatusAttributeType<Int, T>, dbModel: DBVehicleStatusIntModel?) -> DBVehicleStatusIntModel where T.RawValue == Int {
		
		let newDbModel: DBVehicleStatusIntModel = {
			guard let dbModel = dbModel else {
				return DBVehicleStatusIntModel()
			}
			return dbModel
		}()
		newDbModel.displayUnit.value = statusAttribute.unit?.unit?.rawValue
		newDbModel.displayValue      = statusAttribute.unit?.value ?? ""
		newDbModel.status            = statusAttribute.status
		newDbModel.timestamp         = statusAttribute.timestamp ?? 0
		newDbModel.value.value       = statusAttribute.value
		return newDbModel
	}
	
	internal func map<T: RawRepresentable, U: RawRepresentable>(statusAttribute: StatusAttributeType<T, U>, dbModel: DBVehicleStatusIntModel?) -> DBVehicleStatusIntModel where T.RawValue == Int, U.RawValue == Int {
		
		let intStatusAttribute: StatusAttributeType<Int, U> = {
			switch statusAttribute {
			case .invalid(let timestamp):						return .invalid(timestamp: timestamp)
			case .notAvailable(let timestamp):					return .notAvailable(timestamp: timestamp)
			case .noValue(let timestamp):						return .noValue(timestamp: timestamp)
			case .valid(let value, let timestamp, let unit):	return .valid(value: value?.rawValue, timestamp: timestamp, unit: unit)
			}
		}()
		
		return self.map(statusAttribute: intStatusAttribute, dbModel: dbModel)
	}
	
	internal func map<T: RawRepresentable>(statusAttribute: StatusAttributeType<ChargingLimitation, T>, dbModel: DBVehicleStatusIntModel?) -> DBVehicleStatusIntModel where T.RawValue == Int {
		
		let intStatusAttribute: StatusAttributeType<Int, T> = {
			switch statusAttribute {
			case .invalid(let timestamp):						return .invalid(timestamp: timestamp)
			case .notAvailable(let timestamp):					return .notAvailable(timestamp: timestamp)
			case .noValue(let timestamp):						return .noValue(timestamp: timestamp)
			case .valid(let value, let timestamp, let unit):	return .valid(value: value?.rawValue, timestamp: timestamp, unit: unit)
			}
		}()
		
		return self.map(statusAttribute: intStatusAttribute, dbModel: dbModel)
	}
	
	internal func map<T: RawRepresentable>(statusAttribute: StatusAttributeType<[VehicleChargeProgramModel], T>, dbModel: DBVehicleStatusChargeProgramModel?) -> DBVehicleStatusChargeProgramModel where T.RawValue == Int {
		
		let newDbModel: DBVehicleStatusChargeProgramModel = {
			guard let dbModel = dbModel else {
				return DBVehicleStatusChargeProgramModel()
			}
			return dbModel
		}()
		newDbModel.displayValue = statusAttribute.unit?.value ?? ""
		newDbModel.status       = statusAttribute.status
		newDbModel.timestamp    = statusAttribute.timestamp ?? 0
		
		newDbModel.values.removeAll()
		newDbModel.values.append(objectsIn: statusAttribute.value?.map { self.map(vehicleChargeProgramModel: $0) } ?? [])
		return newDbModel
	}
	
	internal func map<T: RawRepresentable>(statusAttribute: StatusAttributeType<[VehicleChargingBreakClockTimerModel], T>, dbModel: DBVehicleStatusChargingBreakClockTimerModel?) -> DBVehicleStatusChargingBreakClockTimerModel where T.RawValue == Int {
		
		let newDbModel: DBVehicleStatusChargingBreakClockTimerModel = {
			guard let dbModel = dbModel else {
				return DBVehicleStatusChargingBreakClockTimerModel()
			}
			return dbModel
		}()
		
		newDbModel.displayValue = statusAttribute.unit?.value ?? ""
		newDbModel.status       = statusAttribute.status
		newDbModel.timestamp    = statusAttribute.timestamp ?? 0
		
		newDbModel.values.removeAll()
		newDbModel.values.append(objectsIn: statusAttribute.value?.map { self.map(vehicleChargingBreakClockTimerModel: $0) } ?? [])
		return newDbModel
	}
	
	internal func map<T: RawRepresentable>(statusAttribute: StatusAttributeType<VehicleChargingPowerControlModel, T>, dbModel: DBVehicleStatusChargingPowerControlModel?) -> DBVehicleStatusChargingPowerControlModel where T.RawValue == Int {
		
		let newDbModel: DBVehicleStatusChargingPowerControlModel = {
			guard let dbModel = dbModel else {
				return DBVehicleStatusChargingPowerControlModel()
			}
			return dbModel
		}()
		
		newDbModel.displayValue = statusAttribute.unit?.value ?? ""
		newDbModel.status       = statusAttribute.status
		newDbModel.timestamp    = statusAttribute.timestamp ?? 0
		
		newDbModel.chargingPower = statusAttribute.value?.chargingPower ?? 0
		newDbModel.chargingStatus = statusAttribute.value?.chargingStatus ?? 0
		newDbModel.controlDuration = statusAttribute.value?.controlDuration ?? 0
		newDbModel.controlInfo = statusAttribute.value?.controlInfo ?? 0
		newDbModel.serviceAvailable = statusAttribute.value?.serviceAvailable ?? 0
		newDbModel.serviceStatus = statusAttribute.value?.serviceStatus ?? 0
		newDbModel.useCase = statusAttribute.value?.useCase ?? 0
		
		return newDbModel
	}
	
	internal func map<T: RawRepresentable>(statusAttribute: StatusAttributeType<[VehicleSpeedAlertModel], T>, dbModel: DBVehicleStatusSpeedAlertModel?) -> DBVehicleStatusSpeedAlertModel where T.RawValue == Int {
		
		let newDbModel: DBVehicleStatusSpeedAlertModel = {
			guard let dbModel = dbModel else {
				return DBVehicleStatusSpeedAlertModel()
			}
			return dbModel
		}()
		newDbModel.displayValue = statusAttribute.unit?.value ?? ""
		newDbModel.status       = statusAttribute.status
		newDbModel.timestamp    = statusAttribute.timestamp ?? 0
		
		newDbModel.values.removeAll()
		newDbModel.values.append(objectsIn: statusAttribute.value?.map { self.map(vehicleStatusSpeedAlertModel: $0) } ?? [])
		return newDbModel
	}
	
	internal func map<T: RawRepresentable>(statusAttribute: StatusAttributeType<[VehicleZEVSocProfileModel], T>, dbModel: DBVehicleStatusSocProfileModel?) -> DBVehicleStatusSocProfileModel where T.RawValue == Int {
		
		let newDbModel: DBVehicleStatusSocProfileModel = {
			guard let dbModel = dbModel else {
				return DBVehicleStatusSocProfileModel()
			}
			return dbModel
		}()
		newDbModel.displayValue = statusAttribute.unit?.value ?? ""
		newDbModel.status       = statusAttribute.status
		newDbModel.timestamp    = statusAttribute.timestamp ?? 0
		
		newDbModel.socs.removeAll()
		newDbModel.socs.append(objectsIn: statusAttribute.value?.map { $0.soc } ?? [])
		newDbModel.times.removeAll()
		newDbModel.times.append(objectsIn: statusAttribute.value?.map { $0.time } ?? [])
		
		return newDbModel
	}
	
	internal func map<T: RawRepresentable>(statusAttribute: StatusAttributeType<[VehicleZEVTariffModel], T>, dbModel: DBVehicleStatusTariffModel?) -> DBVehicleStatusTariffModel where T.RawValue == Int {
		
		let newDbModel: DBVehicleStatusTariffModel = {
			guard let dbModel = dbModel else {
				return DBVehicleStatusTariffModel()
			}
			return dbModel
		}()
		newDbModel.displayValue = statusAttribute.unit?.value ?? ""
		newDbModel.status       = statusAttribute.status
		newDbModel.timestamp    = statusAttribute.timestamp ?? 0
		
		newDbModel.rates.removeAll()
		newDbModel.rates.append(objectsIn: statusAttribute.value?.map { $0.rate } ?? [])
		newDbModel.times.removeAll()
		newDbModel.times.append(objectsIn: statusAttribute.value?.map { $0.time } ?? [])

		return newDbModel
	}
	
	internal func map(vehicleChargeProgramModel model: VehicleChargeProgramModel) -> DBVehicleChargeProgramModel {
		
		let dbModel = DBVehicleChargeProgramModel()
		dbModel.autoUnlock = model.autoUnlock
		dbModel.chargeProgram = Int64(model.chargeProgram.rawValue)
		dbModel.clockTimer = model.clockTimer
		dbModel.ecoCharging = model.ecoCharging
		dbModel.locationBasedCharging = model.locationBasedCharging
		dbModel.maxChargingCurrent = Int64(model.maxChargingCurrent)
		dbModel.maxSoc = Int64(model.maxSoc)
		dbModel.weeklyProfile = model.weeklyProfile
		return dbModel
	}
	
	internal func map(vehicleChargingBreakClockTimerModel model: VehicleChargingBreakClockTimerModel) -> DBVehicleChargingBreakClockTimerModel {
		
		let dbModel = DBVehicleChargingBreakClockTimerModel()
		dbModel.action = model.action.rawValue
		dbModel.endTimeHour = model.endTimeHour
		dbModel.endTimeMin = model.endTimeMin
		dbModel.startTimeHour = model.startTimeHour
		dbModel.startTimeMin = model.startTimeMin
		dbModel.timerId = model.timerId
		return dbModel
	}
	
	internal func map(vehicleStatusSpeedAlertModel model: VehicleSpeedAlertModel) -> DBVehicleSpeedAlertModel {
		let dbModel = DBVehicleSpeedAlertModel()
		dbModel.endTime = Int64(model.endtime)
		dbModel.threshold = Int64(model.threshold)
		dbModel.thresholdDisplayValue = model.thresholdDisplayValue
		return dbModel
	}
}

// swiftlint:enable line_length
