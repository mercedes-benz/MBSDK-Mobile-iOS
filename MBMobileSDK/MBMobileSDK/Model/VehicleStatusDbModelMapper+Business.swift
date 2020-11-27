//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import MBRealmKit

extension VehicleStatusDbModelMapper {
	
	internal func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleAuxheatModel {
		return VehicleAuxheatModel(isActive: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.auxheatActive),
								   runtime: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.auxheatRuntime),
								   state: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.auxheatState),
								   time1: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.auxheatTime1),
								   time2: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.auxheatTime2),
								   time3: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.auxheatTime3),
								   timeSelection: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.auxheatTimeSelection),
								   warnings: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.auxheatWarnings))
	}
	
	internal func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleCollisionModel {
		return VehicleCollisionModel(lastParkEvent: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.lastParkEvent),
									 lastParkEventNotConfirmed: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.lastParkEventNotConfirmed),
									 parkEventLevel: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.parkEventLevel),
									 parkEventSensorStatus: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.parkEventSensorStatus),
									 parkEventType: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.parkEventType))
	}
	
	internal func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleDoorsModel {
		
		let decklidLockState: StatusAttributeType<LockStatus, NoUnit>              = self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.decklidLockState)
		let decklidState: StatusAttributeType<DoorStatus, NoUnit>                  = self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.decklidStatus)
		let frontLeftLockState: StatusAttributeType<LockStatus, NoUnit>            = self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.doorFrontLeftLockState)
		let frontRightLockState: StatusAttributeType<LockStatus, NoUnit>           = self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.doorFrontRightLockState)
		let lockStatusOverall: StatusAttributeType<DoorLockOverallStatus, NoUnit>  = self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.doorLockStatusOverall)
		let rearLeftLockState: StatusAttributeType<LockStatus, NoUnit>             = self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.doorRearLeftLockState)
		let rearRightLockState: StatusAttributeType<LockStatus, NoUnit>            = self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.doorRearRightLockState)
		let frontLeftState: StatusAttributeType<DoorStatus, NoUnit>                = self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.doorFrontLeftState)
		let frontRightState: StatusAttributeType<DoorStatus, NoUnit>               = self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.doorFrontRightState)
		let rearLeftState: StatusAttributeType<DoorStatus, NoUnit>                 = self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.doorRearLeftState)
		let rearRightState: StatusAttributeType<DoorStatus, NoUnit>                = self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.doorRearRightState)
		let statusOverall: StatusAttributeType<DoorOverallStatus, NoUnit>          = self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.doorStatusOverall)

		return VehicleDoorsModel(decklid: VehicleDoorModel(lockState: decklidLockState,
														   state: decklidState),
								 frontLeft: VehicleDoorModel(lockState: frontLeftLockState,
															 state: frontLeftState),
								 frontRight: VehicleDoorModel(lockState: frontRightLockState,
															  state: frontRightState),
								 lockStatusOverall: lockStatusOverall,
								 rearLeft: VehicleDoorModel(lockState: rearLeftLockState,
															state: rearLeftState),
								 rearRight: VehicleDoorModel(lockState: rearRightLockState,
															 state: rearRightState),
								 statusOverall: statusOverall)
	}
	
	internal func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleDrivingModeModel {
		return VehicleDrivingModeModel(teenage: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.teenageDrivingMode),
									   valet: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.valetDrivingMode))
	}
	
	internal func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleEcoScoreModel {
		return VehicleEcoScoreModel(accel: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.ecoScoreAccel),
									bonusRange: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.ecoScoreBonusRange),
									const: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.ecoScoreConst),
									freeWhl: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.ecoScoreFreeWhl),
									total: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.ecoScoreTotal))
	}
	
	internal func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleEngineModel {
		return VehicleEngineModel(ignitionState: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.ignitionState),
								  remoteStartEndtime: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.remoteStartEndtime),
								  remoteStartIsActive: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.remoteStartActive),
								  remoteStartTemperature: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.remoteStartTemperature),
								  state: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.engineState))
	}
	
	internal func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleHuModel {
		return VehicleHuModel(isTrackingEnable: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.trackingStateHU),
							  language: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.languageHU),
							  temperatureType: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.temperatureUnitHU),
							  timeFormatType: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.timeFormatHU),
							  weeklyProfile: self.map(dbVehicleStatusWeeklyProfileModel: dbVehicleStatusModel.weeklyProfile),
							  weeklySetHU: self.map(dbVehicleStatusDayTimeModel: dbVehicleStatusModel.weeklySetHU))
	}
	
	internal func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleLocationModel {
		return VehicleLocationModel(heading: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.positionHeading),
									latitude: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.positionLat),
									longitude: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.positionLong),
									positionErrorCode: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.positionErrorCode),
									proximityCalculationForVehiclePositionRequired: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.proximityCalculationForVehiclePositionRequired))
	}
	
	internal func map(dbVehicleStatusModel: DBVehicleStatusModel) -> [VehicleSpeedAlertModel] {
		
		var model = [VehicleSpeedAlertModel]()
		
		guard let dbVehicleStatusModelSpeedAlertValues = dbVehicleStatusModel.speedAlert?.values else {

			return model
		}
		for element in dbVehicleStatusModelSpeedAlertValues {
			let vehicleSpeedAlertModel = self.map(dbVehicleStatusSpeedAlertModel: element)
			model.append(vehicleSpeedAlertModel)
		}
		
		return model
	}
	
	internal func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleStatisticsModel {
		
		let averageSpeed = VehicleStatisticResetStartDoubleModel<SpeedUnit>(reset: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.averageSpeedReset),
																			start: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.averageSpeedStart))
		let distance     = VehicleStatisticDistanceModel(reset: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.distanceReset),
														 start: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.distanceStart),
														 ze: VehicleStatisticResetStartIntModel(reset: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.distanceZEReset),
																							 start: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.distanceZEStart)))
		let drivenTime   = VehicleStatisticDrivenTimeModel(reset: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.drivenTimeReset),
														   start: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.drivenTimeStart),
														   ze: VehicleStatisticResetStartIntModel(reset: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.drivenTimeZEReset),
																							   start: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.drivenTimeZEStart)))
		let electric     = VehicleStatisticTankModel(consumption: VehicleStatisticResetStartDoubleModel<ElectricityConsumptionUnit>(reset: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.electricConsumptionReset),
																																	start: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.electricConsumptionStart)),
													 distance: VehicleStatisticResetStartDoubleModel<DistanceUnit>(reset: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.distanceElectricalReset),
																												   start: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.distanceElectricalStart)))
		let gas          = VehicleStatisticTankModel(consumption: VehicleStatisticResetStartDoubleModel<GasConsumptionUnit>(reset: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.gasConsumptionReset),
																															start: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.gasConsumptionStart)),
													 distance: VehicleStatisticResetStartDoubleModel<DistanceUnit>(reset: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.distanceElectricalReset),
																												   start: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.distanceElectricalStart)))
		let liquid       = VehicleStatisticTankModel(consumption: VehicleStatisticResetStartDoubleModel<CombustionConsumptionUnit>(reset: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.liquidConsumptionReset),
																																   start: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.liquidConsumptionStart)),
													 distance: VehicleStatisticResetStartDoubleModel<DistanceUnit>(reset: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.distanceElectricalReset),
																												   start: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.distanceElectricalStart)))
		
		return VehicleStatisticsModel(averageSpeed: averageSpeed,
									  distance: distance,
									  drivenTime: drivenTime,
									  electric: electric,
									  gas: gas,
									  liquid: liquid)
	}
	
	internal func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleSunroofModel {
		return VehicleSunroofModel(blindFront: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.sunroofBlindFrontStatus),
								   blindRear: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.sunroofBlindRearStatus),
								   event: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.sunroofEventState),
								   isEventActive: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.sunroofEventActive),
								   status: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.sunroofState))
	}
	
	internal func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleTankModel {
		return VehicleTankModel(adBlueLevel: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.tankAdBlueLevel),
								electricLevel: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.soc),
								electricRange: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.tankElectricRange),
								gasLevel: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.tankGasLevel),
								gasRange: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.tankGasRange),
								liquidLevel: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.tankLiquidLevel),
								liquidRange: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.tankLiquidRange),
								overallRange: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.tankOverallRange))
	}
	
	internal func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleTheftModel {
		return VehicleTheftModel(collision: self.map(dbVehicleStatusModel: dbVehicleStatusModel),
								 interiorProtectionSensorStatus: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.interiorProtectionSensorStatus),
								 keyActivationState: self.map(dbVehicleStatusBoolModel:
								 dbVehicleStatusModel.keyActivationState),
								 lastTheftWarning: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.lastTheftWarning),
								 lastTheftWarningReason: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.lastTheftWarningReason),
								 theftAlarmActive: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.theftAlarmActive),
								 theftSystemArmed: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.theftSystemArmed),
								 towProtectionSensorStatus: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.towProtectionSensorStatus))
	}
	
	internal func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleTiresModel {
		
		let frontLeftMarker: StatusAttributeType<TireMarkerWarning, NoUnit>   = self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.tireMarkerFrontLeft)
		let frontLeftPressure: StatusAttributeType<Double, PressureUnit>      = self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.tirePressureFrontLeft)
		let frontRightMarker: StatusAttributeType<TireMarkerWarning, NoUnit>  = self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.tireMarkerFrontRight)
		let frontRightPressure: StatusAttributeType<Double, PressureUnit>     = self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.tirePressureFrontRight)
		let rearLeftMarker: StatusAttributeType<TireMarkerWarning, NoUnit>    = self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.tireMarkerRearLeft)
		let rearLeftPressure: StatusAttributeType<Double, PressureUnit>       = self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.tirePressureRearLeft)
		let rearRightMarker: StatusAttributeType<TireMarkerWarning, NoUnit>   = self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.tireMarkerRearRight)
		let rearRightPressure: StatusAttributeType<Double, PressureUnit>      = self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.tirePressureRearRight)

		return VehicleTiresModel(frontLeft: VehicleTireModel(pressure: frontLeftPressure,
															 warningLevel: frontLeftMarker),
								 frontRight: VehicleTireModel(pressure: frontRightPressure,
															  warningLevel: frontRightMarker),
								 pressureMeasurementTimestamp: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.tirePressureMeasTimestamp),
								 rearLeft: VehicleTireModel(pressure: rearLeftPressure,
															warningLevel: rearLeftMarker),
								 rearRight: VehicleTireModel(pressure: rearRightPressure,
															 warningLevel: rearRightMarker),
								 sensorAvailable: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.tireSensorAvailable),
								 warningLevelOverall: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.warningTireSrdk))
	}
	
	internal func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleVehicleModel {
		return VehicleVehicleModel(dataConnectionState: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.vehicleDataConnectionState),
								   engineHoodStatus: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.engineHoodStatus),
								   filterParticaleState: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.filterParticleLoading),
								   odo: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.odo),
								   lockGasState: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.doorLockStatusGas),
								   parkBrakeStatus: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.parkBrakeStatus),
								   roofTopState: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.roofTopStatus),
								   serviceIntervalDays: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.serviceIntervalDays),
								   serviceIntervalDistance: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.serviceIntervalDistance),
								   soc: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.soc),
								   speedAlert: self.map(dbVehicleStatusSpeedAlertModel: dbVehicleStatusModel.speedAlert),
								   speedUnitFromIC: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.speedUnitFromIC),
								   starterBatteryState: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.starterBatteryState),
								   time: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.vTime),
								   vehicleLockState: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.vehicleLockState))
	}
	
	internal func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleWarningsModel {
		return VehicleWarningsModel(brakeFluid: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.warningBrakeFluid),
									brakeLiningWear: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.warningBrakeLiningWear),
									coolantLevelLow: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.warningCoolantLevelLow),
									electricalRangeSkipIndication: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.electricalRangeSkipIndication),
									engineLight: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.warningEngineLight),
									liquidRangeSkipIndication: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.liquidRangeSkipIndication),
									tireLamp: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.warningTireLamp),
									tireLevelPrw: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.warningTireLevelPrw),
									tireSprw: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.warningTireSprw),
									washWater: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.warningWashWater))
	}
	
	internal func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleWindowsModel {
		return VehicleWindowsModel(blindRear: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.windowBlindRearStatus),
								   blindRearLeft: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.windowBlindRearLeftStatus),
								   blindRearRight: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.windowBlindRearRightStatus),
								   flipWindowStatus: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.flipWindowStatus),
								   frontLeft: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.windowFrontLeftState),
								   frontRight: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.windowFrontRightState),
								   overallState: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.windowStatusOverall),
								   rearLeft: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.windowRearLeftState),
								   rearRight: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.windowRearRightState),
								   sunroof: self.map(dbVehicleStatusModel: dbVehicleStatusModel))
	}
	
	internal func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleZEVModel {
		return VehicleZEVModel(acChargingCurrentLimitation: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.acChargingCurrentLimitation),
							   bidirectionalChargingActive: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.bidirectionalChargingActive),
							   chargeCouplerACLockStatus: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.chargeCouplerACLockStatus),
							   chargeCouplerACStatus: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.chargeCouplerACStatus),
							   chargeCouplerDCLockStatus: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.chargeCouplerDCLockStatus),
							   chargeCouplerDCStatus: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.chargeCouplerDCStatus),
							   chargeFlapACStatus: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.chargeFlapACStatus),
							   chargeFlapDCStatus: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.chargeFlapDCStatus),
							   chargePrograms: self.map(dbVehicleStatusChargeProgramModel: dbVehicleStatusModel.chargePrograms),
							   chargingActive: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.chargingActive),
							   chargingBreakClockTimer: self.map(dbVehicleStatusChargingBreakClockTimerModel: dbVehicleStatusModel.chargingBreakClockTimer),
							   chargingError: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.chargingError),
							   chargingErrorInfrastructure: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.chargingErrorInfrastructure),
							   chargingErrorWim: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.chargingErrorWim),
							   chargingMode: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.chargingMode),
							   chargingPower: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.chargingPower),
							   chargingPowerControl: self.map(dbVehicleStatusChargingPowerControlModel: dbVehicleStatusModel.chargingPowerControl),
							   chargingPowerEcoLimit: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.chargingPowerEcoLimit),
							   chargingStatus: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.chargingStatus),
							   chargingTimeType: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.chargingTimeType),
							   departureTime: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.departureTime),
							   departureTimeIcon: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.departureTimeIcon),
							   departureTimeMode: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.departureTimeMode),
							   departureTimeSoc: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.departureTimeSoc),
							   departureTimeWeekday: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.departureTimeWeekday),
							   endOfChargeTime: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.endOfChargeTime),
							   endOfChargeTimeRelative: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.endOfChargeTimeRelative),
							   endOfChargeTimeWeekday: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.endOfChargeTimeWeekday),
							   hybridWarnings: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.hybridWarnings),
							   isActive: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.zevActive),
							   maxRange: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.maxRange),
							   maxSoc: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.maxSoc),
							   maxSocLowerLimit: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.maxSocLowerLimit),
							   maxSocUpperLimit: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.maxSocUpperLimit),
							   minSoc: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.minSoc),
							   minSocLowerLimit: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.minSocLowerLimit),
							   minSocUpperLimit: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.minSocUpperLimit),
							   nextDepartureTime: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.nextDepartureTime),
							   nextDepartureTimeWeekday: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.nextDepartureTimeWeekday),
							   precondActive: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.precondActive),
							   precondAtDeparture: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.precondAtDeparture),
							   precondAtDepartureDisable: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.precondAtDepartureDisable),
							   precondDuration: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.precondDuration),
							   precondError: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.precondError),
							   precondNow: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.precondNow),
							   precondNowError: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.precondNowError),
							   precondSeatFrontLeft: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.precondSeatFrontLeft),
							   precondSeatFrontRight: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.precondSeatFrontRight),
							   precondSeatRearLeft: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.precondSeatRearLeft),
							   precondSeatRearRight: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.precondSeatRearRight),
							   rangeAssistDriveOnSoc: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.evRangeAssistDriveOnSoc),
							   rangeAssistDriveOnTime: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.evRangeAssistDriveOnTime),
							   selectedChargeProgram: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.selectedChargeProgram),
							   smartCharging: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.smartCharging),
							   smartChargingAtDeparture: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.smartChargingAtDeparture),
							   smartChargingAtDeparture2: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.smartChargingAtDeparture2),
							   socProfile: self.map(dbVehicleStatusSocProfileModel: dbVehicleStatusModel.socProfile),
							   temperature: self.map(dbVehicleStatusModel: dbVehicleStatusModel),
							   weekdayTariff: self.map(dbVehicleStatusTariffModel: dbVehicleStatusModel.weekdaytariff),
							   weekendTariff: self.map(dbVehicleStatusTariffModel: dbVehicleStatusModel.weekendtariff))
	}
	
	internal func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleZEVTemperatureModel {
		return VehicleZEVTemperatureModel(frontCenter: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.temperaturePointFrontCenter),
										  frontLeft: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.temperaturePointFrontLeft),
										  frontRight: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.temperaturePointFrontRight),
										  rearCenter: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.temperaturePointRearCenter),
										  rearCenter2: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.temperaturePointRearCenter2),
										  rearLeft: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.temperaturePointRearLeft),
										  rearRight: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.temperaturePointRearRight))
	}
}

extension VehicleStatusDbModelMapper {
	
	internal func map<T: RawRepresentable>(dbVehicleStatusBoolModel model: DBVehicleStatusBoolModel?) -> StatusAttributeType<Bool, T> where T.RawValue == Int {
		
		let timestamp = model?.timestamp ?? 0
		
		guard let statusType = StatusType(rawValue: model?.status ?? -1) else {
			return .invalid(timestamp: timestamp)
		}
		
		switch statusType {
		case .invalid:	    return .invalid(timestamp: timestamp)
		case .notAvailable: return .notAvailable(timestamp: timestamp)
		case .noValue:	    return .noValue(timestamp: timestamp)
		case .valid:	    return .valid(value: model?.value.value, timestamp: timestamp, unit: self.map(dbVehicleStatusBoolModel: model))
		}
	}
	
	internal func map<T: RawRepresentable>(dbVehicleStatusBoolModel model: DBVehicleStatusBoolModel?) -> VehicleAttributeUnitModel<T> where T.RawValue == Int {
		return VehicleAttributeUnitModel<T>(value: model?.displayValue ?? "",
											unit: T(rawValue: model?.displayUnit.value ?? -1))
	}
	
	internal func map<T: RawRepresentable, U: RawRepresentable>(dbVehicleStatusBoolModel model: DBVehicleStatusBoolModel?) -> StatusAttributeType<T, U> where T.RawValue == Bool, U.RawValue == Int {
		
		let timestamp = model?.timestamp ?? 0
		
		guard let statusType = StatusType(rawValue: model?.status ?? -1) else {
			return .invalid(timestamp: timestamp)
		}
		
		switch statusType {
		case .invalid:
			return .invalid(timestamp: timestamp)
			
		case .notAvailable:
			return .notAvailable(timestamp: timestamp)
			
		case .noValue:
			return .noValue(timestamp: timestamp)
			
		case .valid:
			guard let value = model?.value.value else {
				return .valid(value: nil, timestamp: timestamp, unit: self.map(dbVehicleStatusBoolModel: model))
			}
			return .valid(value: T(rawValue: value), timestamp: timestamp, unit: self.map(dbVehicleStatusBoolModel: model))
		}
	}
	
	internal func map<T: RawRepresentable>(dbVehicleStatusDayTimeModel model: DBVehicleStatusDayTimeModel?) -> StatusAttributeType<[DayTimeModel], T> where T.RawValue == Int {
		
		let timestamp = model?.timestamp ?? 0
		
		guard let statusType = StatusType(rawValue: model?.status ?? -1) else {
			return .invalid(timestamp: timestamp)
		}
		
		switch statusType {
		case .invalid:	    return .invalid(timestamp: timestamp)
		case .notAvailable: return .notAvailable(timestamp: timestamp)
		case .noValue:	    return .noValue(timestamp: timestamp)
		case .valid:	    return .valid(value: self.map(dbVehicleStatusDayTimeModel: model), timestamp: timestamp, unit: self.map(dbVehicleStatusDayTimeModel: model))
		}
	}
	
	internal func map(dbVehicleStatusDayTimeModel model: DBVehicleStatusDayTimeModel?) -> [DayTimeModel]? {
		
		guard let days = model?.days,
			let times = model?.times else {
				return nil
		}
		
		return zip(days, times).compactMap {
			
			guard let day = Day(rawValue: $0) else {
				return nil
			}
			return DayTimeModel(day: day, time: Int($1))
		}
	}
	
	internal func map<T: RawRepresentable>(dbVehicleStatusDayTimeModel model: DBVehicleStatusDayTimeModel?) -> VehicleAttributeUnitModel<T> where T.RawValue == Int {
		return VehicleAttributeUnitModel<T>(value: model?.displayValue ?? "",
											unit: nil)
	}
	
	internal func map<T: RawRepresentable>(dbVehicleStatusWeeklyProfileModel model: DBVehicleStatusWeeklyProfileModel?) -> StatusAttributeType<WeeklyProfileModel, T> where T.RawValue == Int {
		
		let timestamp = model?.timestamp ?? 0
		
		guard let statusType = StatusType(rawValue: model?.status ?? -1) else {
			return .invalid(timestamp: timestamp)
		}
		
		switch statusType {
		case .invalid:	    return .invalid(timestamp: timestamp)
		case .notAvailable: return .notAvailable(timestamp: timestamp)
		case .noValue:	    return .noValue(timestamp: timestamp)
		case .valid:	    return .valid(value: self.map(dbVehicleStatusWeeklyProfileModel: model), timestamp: timestamp, unit: self.map(dbVehicleStatusWeeklyProfileModel: model))
		}
	}
	
	internal func map(dbVehicleStatusWeeklyProfileModel model: DBVehicleStatusWeeklyProfileModel?) -> WeeklyProfileModel? {

		guard let dbModel = model else {
			return nil
		}
		
		let timeProfiles: [TimeProfile] = dbModel.timeProfiles.map { (dbTimeProfileModel) -> TimeProfile in
			
			let days: [Day] = dbTimeProfileModel.days.compactMap { Day(rawValue: Int($0)) }
			return TimeProfile(applicationIdentifier: dbTimeProfileModel.applicationIdentifier,
							   identifier: dbTimeProfileModel.identifier,
							   hour: dbTimeProfileModel.hour,
							   minute: dbTimeProfileModel.minute,
							   active: dbTimeProfileModel.active,
							   days: Set(days))
		}
		
		return WeeklyProfileModel(singleEntriesActivatable: dbModel.singleTimeProfileEntriesActivatable,
								  maxSlots: Int(dbModel.maxNumberOfWeeklyTimeProfileSlots),
								  maxTimeProfiles: Int(dbModel.maxNumberOfTimeProfiles),
								  currentSlots: Int(dbModel.currentNumberOfTimeProfileSlots),
								  currentTimeProfiles: Int(dbModel.currentNumberOfTimeProfiles),
								  allTimeProfiles: Array(timeProfiles))
	}
	
	internal func map<T: RawRepresentable>(dbVehicleStatusWeeklyProfileModel model: DBVehicleStatusWeeklyProfileModel?) -> VehicleAttributeUnitModel<T> where T.RawValue == Int {
		return VehicleAttributeUnitModel<T>(value: model?.displayValue ?? "",
											unit: nil)
	}
	
	internal func map<T: RawRepresentable>(dbVehicleStatusDoubleModel model: DBVehicleStatusDoubleModel?) -> StatusAttributeType<Double, T> where T.RawValue == Int {
		
		let timestamp = model?.timestamp ?? 0
		
		guard let statusType = StatusType(rawValue: model?.status ?? -1) else {
			return .invalid(timestamp: timestamp)
		}

		switch statusType {
		case .invalid:	    return .invalid(timestamp: timestamp)
		case .notAvailable: return .notAvailable(timestamp: timestamp)
		case .noValue:	    return .noValue(timestamp: timestamp)
		case .valid:	    return .valid(value: model?.value.value, timestamp: timestamp, unit: self.map(dbVehicleStatusDoubleModel: model))
		}
	}
	
	internal func map<T: RawRepresentable>(dbVehicleStatusDoubleModel model: DBVehicleStatusDoubleModel?) -> VehicleAttributeUnitModel<T> where T.RawValue == Int {
		return VehicleAttributeUnitModel<T>(value: model?.displayValue ?? "",
											unit: T(rawValue: model?.displayUnit.value ?? -1))
	}

	internal func map<T: RawRepresentable, U: RawRepresentable>(dbVehicleStatusDoubleModel model: DBVehicleStatusDoubleModel?) -> StatusAttributeType<T, U> where T.RawValue == Double, U.RawValue == Int {
		
		let timestamp = model?.timestamp ?? 0
		
		guard let statusType = StatusType(rawValue: model?.status ?? -1) else {
			return .invalid(timestamp: timestamp)
		}
		
		switch statusType {
		case .invalid:
			return .invalid(timestamp: timestamp)
			
		case .notAvailable:
			return .notAvailable(timestamp: timestamp)
			
		case .noValue:
			return .noValue(timestamp: timestamp)
			
		case .valid:
			guard let value = model?.value.value else {
				return .valid(value: nil, timestamp: timestamp, unit: self.map(dbVehicleStatusDoubleModel: model))
			}
			return .valid(value: T(rawValue: value), timestamp: timestamp, unit: self.map(dbVehicleStatusDoubleModel: model))
		}
	}

	internal func map<T: RawRepresentable>(dbVehicleStatusSpeedAlertModel model: DBVehicleStatusSpeedAlertModel?) -> StatusAttributeType<[VehicleSpeedAlertModel], T> where T.RawValue == Int {
		
		let timestamp = model?.timestamp ?? 0
		
		guard let statusType = StatusType(rawValue: model?.status ?? -1) else {
			return .invalid(timestamp: timestamp)
		}
		 
		switch statusType {
		case .invalid:
			return .invalid(timestamp: timestamp)
			
		case .notAvailable:
			return .notAvailable(timestamp: timestamp)
			
		case .noValue:
			return .noValue(timestamp: timestamp)
			
		case .valid:
			guard let values = model?.values else {
				return .valid(value: nil, timestamp: timestamp, unit: self.map(dbVehicleStatusSpeedAlertModel: model))
			}
			
			let dbVehicleStatusSpeedAlertModels: [DBVehicleSpeedAlertModel] = values.map { $0 }
			return .valid(value: self.map(dbVehicleStatusSpeedAlertModels: dbVehicleStatusSpeedAlertModels), timestamp: timestamp, unit: self.map(dbVehicleStatusSpeedAlertModel: model))
		}
	}
	
	internal func map(dbVehicleStatusSpeedAlertModels models: [DBVehicleSpeedAlertModel]) -> [VehicleSpeedAlertModel] {
		return models.map { self.map(dbVehicleStatusSpeedAlertModel: $0) }
	}

	internal func map(dbVehicleStatusSpeedAlertModel model: DBVehicleSpeedAlertModel) -> VehicleSpeedAlertModel {
		return VehicleSpeedAlertModel(endtime: Int(model.endTime),
									  threshold: Int(model.threshold),
									  thresholdDisplayValue: model.thresholdDisplayValue)
	}

	internal func map<T: RawRepresentable>(dbVehicleStatusSpeedAlertModel model: DBVehicleStatusSpeedAlertModel?) -> VehicleAttributeUnitModel<T> where T.RawValue == Int {

		return VehicleAttributeUnitModel<T>(value: model?.displayValue ?? "", unit: nil)
	}

	internal func map<T: RawRepresentable>(dbVehicleStatusIntModel model: DBVehicleStatusIntModel?) -> StatusAttributeType<ChargingLimitation, T> where T.RawValue == Int {
		
		let timestamp = model?.timestamp ?? 0
		
		guard let statusType = StatusType(rawValue: model?.status ?? -1) else {
			return .invalid(timestamp: timestamp)
		}
		
		switch statusType {
		case .invalid:	    return .invalid(timestamp: timestamp)
		case .notAvailable: return .notAvailable(timestamp: timestamp)
		case .noValue:	    return .noValue(timestamp: timestamp)
		case .valid:	    return .valid(value: ChargingLimitation(rawValue: model?.value.value), timestamp: timestamp, unit: self.map(dbVehicleStatusIntModel: model))
		}
	}
	
	internal func map<T: RawRepresentable>(dbVehicleStatusIntModel model: DBVehicleStatusIntModel?) -> StatusAttributeType<Int, T> where T.RawValue == Int {
		
		let timestamp = model?.timestamp ?? 0
		
		guard let statusType = StatusType(rawValue: model?.status ?? -1) else {
			return .invalid(timestamp: timestamp)
		}
		
		switch statusType {
		case .invalid:	    return .invalid(timestamp: timestamp)
		case .notAvailable: return .notAvailable(timestamp: timestamp)
		case .noValue:	    return .noValue(timestamp: timestamp)
		case .valid:	    return .valid(value: model?.value.value, timestamp: timestamp, unit: self.map(dbVehicleStatusIntModel: model))
		}
	}

	internal func map<T: RawRepresentable>(dbVehicleStatusIntModel model: DBVehicleStatusIntModel?) -> VehicleAttributeUnitModel<T> where T.RawValue == Int {
		return VehicleAttributeUnitModel<T>(value: model?.displayValue ?? "",
											unit: T(rawValue: model?.displayUnit.value ?? -1))
	}
	
	internal func map<T: RawRepresentable, U: RawRepresentable>(dbVehicleStatusIntModel model: DBVehicleStatusIntModel?) -> StatusAttributeType<T, U> where T.RawValue == Int, U.RawValue == Int {

		let timestamp = model?.timestamp ?? 0
		
		guard let statusType = StatusType(rawValue: model?.status ?? -1) else {
			return .invalid(timestamp: timestamp)
		}
		
		switch statusType {
		case .invalid:
			return .invalid(timestamp: timestamp)
			
		case .notAvailable:
			return .notAvailable(timestamp: timestamp)
			
		case .noValue:
			return .noValue(timestamp: timestamp)
			
		case .valid:
			guard let value = model?.value.value else {
				return .valid(value: nil, timestamp: timestamp, unit: self.map(dbVehicleStatusIntModel: model))
			}
			return .valid(value: T(rawValue: value), timestamp: timestamp, unit: self.map(dbVehicleStatusIntModel: model))
		}
	}
	
	internal func map<T: RawRepresentable>(dbVehicleStatusSocProfileModel model: DBVehicleStatusSocProfileModel?) -> StatusAttributeType<[VehicleZEVSocProfileModel], T> where T.RawValue == Int {
		
		let timestamp = model?.timestamp ?? 0
		
		guard let statusType = StatusType(rawValue: model?.status ?? -1) else {
			return .invalid(timestamp: timestamp)
		}
		
		switch statusType {
		case .invalid:	    return .invalid(timestamp: timestamp)
		case .notAvailable: return .notAvailable(timestamp: timestamp)
		case .noValue:	    return .noValue(timestamp: timestamp)
		case .valid:	    return .valid(value: self.map(dbVehicleStatusSocProfileModel: model), timestamp: timestamp, unit: self.map(dbVehicleStatusSocProfileModel: model))
		}
	}
	
	internal func map<T: RawRepresentable>(dbVehicleStatusSocProfileModel model: DBVehicleStatusSocProfileModel?) -> VehicleAttributeUnitModel<T> where T.RawValue == Int {
		return VehicleAttributeUnitModel<T>(value: model?.displayValue ?? "",
											unit: nil)
	}
	
	internal func map(dbVehicleStatusSocProfileModel model: DBVehicleStatusSocProfileModel?) -> [VehicleZEVSocProfileModel]? {
		
		guard let socs = model?.socs,
			let times = model?.times else {
				return nil
		}
		
		return zip(socs, times).map { VehicleZEVSocProfileModel(soc: $0, time: $1) }
	}
	
	internal func map(int64Value: Int64?) -> Int64 {
		return int64Value ?? 0
	}
}


// MARK: - ZEV

extension VehicleStatusDbModelMapper {
	
	internal func map<T: RawRepresentable>(dbVehicleStatusChargeProgramModel model: DBVehicleStatusChargeProgramModel?) -> StatusAttributeType<[VehicleChargeProgramModel], T> where T.RawValue == Int {
		
		let timestamp = model?.timestamp ?? 0
		
		guard let statusType = StatusType(rawValue: model?.status ?? -1) else {
			return .invalid(timestamp: timestamp)
		}
		 
		switch statusType {
		case .invalid:
			return .invalid(timestamp: timestamp)
			
		case .notAvailable:
			return .notAvailable(timestamp: timestamp)
			
		case .noValue:
			return .noValue(timestamp: timestamp)
			
		case .valid:
			guard let values = model?.values else {
				return .valid(value: nil, timestamp: timestamp, unit: self.map(dbVehicleStatusChargeProgramModel: model))
			}
			
			let dbVehicleChargeProgramModels: [DBVehicleChargeProgramModel] = values.map { $0 }
			return .valid(value: self.map(dbVehicleChargeProgramModels: dbVehicleChargeProgramModels), timestamp: timestamp, unit: self.map(dbVehicleStatusChargeProgramModel: model))
		}
	}
	
	// swiftlint:disable line_length
	internal func map<T: RawRepresentable>(dbVehicleStatusChargingBreakClockTimerModel model: DBVehicleStatusChargingBreakClockTimerModel?) -> StatusAttributeType<[VehicleChargingBreakClockTimerModel], T> where T.RawValue == Int {
		
		let timestamp = model?.timestamp ?? 0
		
		guard let statusType = StatusType(rawValue: model?.status ?? -1) else {
			return .invalid(timestamp: timestamp)
		}
		 
		switch statusType {
		case .invalid:
			return .invalid(timestamp: timestamp)
			
		case .notAvailable:
			return .notAvailable(timestamp: timestamp)
			
		case .noValue:
			return .noValue(timestamp: timestamp)
			
		case .valid:
			guard let values = model?.values else {
				return .valid(value: nil, timestamp: timestamp, unit: nil)
			}
			
			let models: [DBVehicleChargingBreakClockTimerModel] = values.map { $0 }
			return .valid(value: self.map(dbVehicleChargingBreakClockTimerModels: models), timestamp: timestamp, unit: nil)
		}
	}
	// swiftlint:enable line_length
	
	internal func map<T: RawRepresentable>(dbVehicleStatusChargingPowerControlModel model: DBVehicleStatusChargingPowerControlModel?) -> StatusAttributeType<VehicleChargingPowerControlModel, T> where T.RawValue == Int {
		
		let timestamp = model?.timestamp ?? 0
		
		guard let statusType = StatusType(rawValue: model?.status ?? -1) else {
			return .invalid(timestamp: timestamp)
		}
		 
		switch statusType {
		case .invalid:		return .invalid(timestamp: timestamp)
		case .notAvailable:	return .notAvailable(timestamp: timestamp)
		case .noValue:		return .noValue(timestamp: timestamp)
		case .valid:		return .valid(value: self.map(dbVehicleChargingPowerControlModel: model), timestamp: timestamp, unit: nil)
		}
	}
	
	internal func map<T: RawRepresentable>(dbVehicleStatusTariffModel model: DBVehicleStatusTariffModel?) -> StatusAttributeType<[VehicleZEVTariffModel], T> where T.RawValue == Int {
		
		let timestamp = model?.timestamp ?? 0
		
		guard let statusType = StatusType(rawValue: model?.status ?? -1) else {
			return .invalid(timestamp: timestamp)
		}
		
		switch statusType {
		case .invalid:	    return .invalid(timestamp: timestamp)
		case .notAvailable: return .notAvailable(timestamp: timestamp)
		case .noValue:	    return .noValue(timestamp: timestamp)
		case .valid:	    return .valid(value: self.map(dbVehicleStatusTariffModel: model), timestamp: timestamp, unit: self.map(dbVehicleStatusTariffModel: model))
		}
	}
	
	
	// MARK: - Helper
	
	internal func map<T: RawRepresentable>(dbVehicleStatusChargeProgramModel model: DBVehicleStatusChargeProgramModel?) -> VehicleAttributeUnitModel<T> where T.RawValue == Int {
		return VehicleAttributeUnitModel<T>(value: model?.displayValue ?? "", unit: nil)
	}
	
	internal func map<T: RawRepresentable>(dbVehicleStatusTariffModel model: DBVehicleStatusTariffModel?) -> VehicleAttributeUnitModel<T> where T.RawValue == Int {
		return VehicleAttributeUnitModel<T>(value: model?.displayValue ?? "",
											unit: nil)
	}
	
	internal func map(dbVehicleChargeProgramModel model: DBVehicleChargeProgramModel) -> VehicleChargeProgramModel {
		return VehicleChargeProgramModel(autoUnlock: model.autoUnlock,
										 chargeProgram: ChargingProgram(rawValue: Int(model.chargeProgram)) ?? .default,
										 clockTimer: model.clockTimer,
										 ecoCharging: model.ecoCharging,
										 locationBasedCharging: model.locationBasedCharging,
										 maxChargingCurrent: Int(model.maxChargingCurrent),
										 maxSoc: Int(model.maxSoc),
										 weeklyProfile: model.weeklyProfile)
	}
	
	internal func map(dbVehicleChargeProgramModels models: [DBVehicleChargeProgramModel]) -> [VehicleChargeProgramModel] {
		return models.map { self.map(dbVehicleChargeProgramModel: $0) }
	}
	
	internal func map(dbVehicleChargingBreakClockTimerModel model: DBVehicleChargingBreakClockTimerModel) -> VehicleChargingBreakClockTimerModel {
		return VehicleChargingBreakClockTimerModel(action: ChargingBreakClockTimer(rawValue: model.action) ?? .delete,
												   endTimeHour: model.endTimeHour,
												   endTimeMin: model.endTimeMin,
												   startTimeHour: model.startTimeHour,
												   startTimeMin: model.startTimeMin,
												   timerId: model.timerId)
	}
	
	internal func map(dbVehicleChargingBreakClockTimerModels models: [DBVehicleChargingBreakClockTimerModel]) -> [VehicleChargingBreakClockTimerModel] {
		return models.map { self.map(dbVehicleChargingBreakClockTimerModel: $0) }
	}
	
	internal func map(dbVehicleChargingPowerControlModel model: DBVehicleStatusChargingPowerControlModel?) -> VehicleChargingPowerControlModel? {
		
		guard let model = model else {
			return nil
		}
		return VehicleChargingPowerControlModel(chargingStatus: model.chargingStatus,
												controlDuration: model.controlDuration,
												controlInfo: model.controlInfo,
												chargingPower: model.chargingPower,
												serviceStatus: model.serviceStatus,
												serviceAvailable: model.serviceAvailable,
												useCase: model.useCase)
	}
	
	internal func map(dbVehicleStatusTariffModel model: DBVehicleStatusTariffModel?) -> [VehicleZEVTariffModel]? {
		
		guard let rates = model?.rates,
			let times = model?.times else {
				return nil
		}
		
		return zip(rates, times).map { VehicleZEVTariffModel(rate: $0, time: $1) }
	}
}
