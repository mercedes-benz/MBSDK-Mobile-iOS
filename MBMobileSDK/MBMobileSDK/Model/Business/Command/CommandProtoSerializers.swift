//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import SwiftProtobuf

extension Command.ActivateVehicleKeys: CommandPinSerializable {
    
    func populate(commandRequest: inout Proto_CommandRequest, pin: String) {
        commandRequest.activateVehicleKeys = Proto_ActivateVehicleKeys.with {
            
            $0.expirationUnix  = Int64(self.expirationDate?.timeIntervalSince1970 ?? 0)
            $0.pin = pin
        }
    }
}

extension Command.DeactivateVehicleKeys: CommandPinSerializable {
    
    func populate(commandRequest: inout Proto_CommandRequest, pin: String) {
        commandRequest.deactivateVehicleKeys = Proto_DeactivateVehicleKeys.with {
            
            $0.expirationUnix  = Int64(self.expirationDate?.timeIntervalSince1970 ?? 0)
            $0.pin = pin
        }
    }
}

extension Command.AuxHeatConfigure: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		
		commandRequest.auxheatConfigure = Proto_AuxheatConfigure.with {
			
			$0.time1 = Int32(time1)
			$0.time2 = Int32(time2)
			$0.time3 = Int32(time3)
			$0.timeSelection = timeSelection.proto()
		}
	}
}

extension Command.AuxHeatStart: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.auxheatStart = Proto_AuxheatStart()
	}
}

extension Command.AuxHeatStop: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.auxheatStop = Proto_AuxheatStop()
	}
}

extension Command.BatteryMaxStateOfChargeConfigure: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.batteryMaxSoc = Proto_BatteryMaxSocConfigure.with {
			$0.maxSoc = Int32(self.maxStateOfCharge)
		}
	}
}

extension Command.ChargeControlConfigure: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.chargeControlConfigure = Proto_ChargeControlConfigure.with {
			
			if let enableBidirectionalCharging = self.enableBidirectionalCharging {
				$0.biChargingEnabled = SwiftProtobuf.Google_Protobuf_BoolValue(booleanLiteral: enableBidirectionalCharging)
			}
			
			if let minStateOfCharge = self.minStateOfCharge {
				$0.minSoc = SwiftProtobuf.Google_Protobuf_Int32Value(integerLiteral: Int32(minStateOfCharge))
			}
			
//			if let chargingPower = self.chargingPower {
//				$0.chargingPower = SwiftProtobuf.Google_Protobuf_FloatValue(floatLiteral: Float(chargingPower))
//			}
		}
	}
}


extension Command.ChargeOptimizationConfigure: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.chargeOptConfigure = Proto_ChargeOptConfigure.with {
			
			$0.weekdayTariff = self.weekdays.compactMap { $0.proto() }
			$0.weekendTariff = self.weekends.compactMap { $0.proto() }
		}
	}
}

extension Command.ChargeOptimizationStart: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.chargeOptStart = Proto_ChargeOptStart()
	}
}

extension Command.ChargeOptimizationStop: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.chargeOptStop = Proto_ChargeOptStop()
	}
}

extension Command.ChargeProgramConfigure: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.chargeProgramConfigure = Proto_ChargeProgramConfigure.with {
			
			$0.chargeProgram = self.chargeProgram.proto()
			
			if let enableAutoUnlock = self.enableAutoUnlock {
				$0.autoUnlock = SwiftProtobuf.Google_Protobuf_BoolValue(booleanLiteral: enableAutoUnlock)
			}
			
			if let enableLocationBasedCharging = self.enableLocationBasedCharging {
				$0.locationBasedCharging = SwiftProtobuf.Google_Protobuf_BoolValue(booleanLiteral: enableLocationBasedCharging)
			}
			
			if let maxStateOfCharge = self.maxStateOfCharge {
				$0.maxSoc = SwiftProtobuf.Google_Protobuf_Int32Value(integerLiteral: Int32(maxStateOfCharge))
			}
			
			if let enableEcoCharging = self.enableEcoCharging {
			    $0.ecoCharging = SwiftProtobuf.Google_Protobuf_BoolValue(booleanLiteral: enableEcoCharging)
			}
		}
	}
}


extension Command.DoorsLock: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.doorsLock = Proto_DoorsLock()
	}
}

extension Command.DoorsUnlock: CommandPinSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest, pin: String) {
		commandRequest.doorsUnlock = Proto_DoorsUnlock.with {
			$0.pin = pin
		}
	}
}

extension Command.EngineStart: CommandPinSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest, pin: String) {
		commandRequest.engineStart = Proto_EngineStart.with {
			$0.pin = pin
		}
	}
}

extension Command.EngineStop: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.engineStop = Proto_EngineStop()
	}
}

extension Command.SignalPosition: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.sigposStart = Proto_SigPosStart.with {
			$0.hornRepeat = Int32(self.hornRepeat)
			$0.hornType = self.hornType.proto()
			$0.lightType = self.lightType.proto()
            $0.sigposDuration = Int32(self.durationInSeconds)
			$0.sigposType = self.sigPosType.proto()
		}
	}
}

extension Command.SpeedAlertStart: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.speedalertStart = Proto_SpeedalertStart.with {
			$0.alertEndTime = Int64(self.alertEndTime)
			$0.threshold = Int32(self.threshold)
		}
	}
}

extension Command.SpeedAlertStop: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.speedalertStop = Proto_SpeedalertStop()
	}
}

extension Command.SunroofClose: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.sunroofClose = Proto_SunroofClose()
	}
}

extension Command.SunroofLift: CommandPinSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest, pin: String) {
		commandRequest.sunroofLift = Proto_SunroofLift.with {
			$0.pin = pin
		}
	}
}

extension Command.SunroofOpen: CommandPinSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest, pin: String) {
		commandRequest.sunroofOpen = Proto_SunroofOpen.with {
			$0.pin = pin
		}
	}
}

extension Command.SunroofMove: CommandPinSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest, pin: String) {
		commandRequest.sunroofMove = Proto_SunroofMove.with {
			$0.pin = pin
			
			if let sunroofPosition = self.sunroofPosition {
				$0.sunroof = SwiftProtobuf.Google_Protobuf_Int32Value(integerLiteral: Int32(sunroofPosition))
			}

			if let blindFrontPosition = self.blindFrontPosition {
				$0.sunroofBlindFront = SwiftProtobuf.Google_Protobuf_Int32Value(integerLiteral: Int32(blindFrontPosition))
			}

			if let blindRearPosition = self.blindRearPosition {
				$0.sunroofBlindRear = SwiftProtobuf.Google_Protobuf_Int32Value(integerLiteral: Int32(blindRearPosition))
			}
		}
	}
}

extension Command.TeenageDrivingModeActivate: CommandSerializable {
    func populate(commandRequest: inout Proto_CommandRequest) {
        commandRequest.teenageDrivingModeActivate = Proto_TeenageDrivingModeActivate()
    }
}

extension Command.TeenageDrivingModeDeactivate: CommandSerializable {
    func populate(commandRequest: inout Proto_CommandRequest) {
        commandRequest.teenageDrivingModeDeactivate = Proto_TeenageDrivingModeDeactivate()
    }
}

extension Command.TemperatureConfigure: CommandSerializable {
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.temperatureConfigure = Proto_TemperatureConfigure.with {
			$0.temperaturePoints = self.temperaturePoints.compactMap { $0.proto() }
		}
	}
}

extension Command.TheftAlarmConfirmDamageDetection: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.theftalarmConfirmDamagedetection = Proto_TheftalarmConfirmDamagedetection()
	}
}

extension Command.TheftAlarmDeselectDamageDetection: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.theftalarmDeselectDamagedetection = Proto_TheftalarmDeselectDamagedetection()
	}
}

extension Command.TheftAlarmDeselectInterior: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.theftalarmDeselectInterior = Proto_TheftalarmDeselectInterior()
	}
}

extension Command.TheftAlarmDeselectTow: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.theftalarmDeselectTow = Proto_TheftalarmDeselectTow()
	}
}

extension Command.TheftAlarmSelectDamageDetection: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.theftalarmSelectDamagedetection = Proto_TheftalarmSelectDamagedetection()
	}
}

extension Command.TheftAlarmSelectInterior: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.theftalarmSelectInterior = Proto_TheftalarmSelectInterior()
	}
}

extension Command.TheftAlarmSelectTow: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.theftalarmSelectTow = Proto_TheftalarmSelectTow()
	}
}

extension Command.TheftAlarmStart: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.theftalarmStart = Proto_TheftalarmStart.with {
			$0.alarmDurationInSeconds = Int32(self.durationInSeconds)
		}
	}
}

extension Command.TheftAlarmStop: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.theftalarmStop = Proto_TheftalarmStop()
	}
}

extension Command.ValetDrivingModeActivate: CommandSerializable {
    func populate(commandRequest: inout Proto_CommandRequest) {
        commandRequest.valetDrivingModeActivate = Proto_ValetDrivingModeActivate()
    }
}

extension Command.ValetDrivingModeDeactivate: CommandSerializable {
    func populate(commandRequest: inout Proto_CommandRequest) {
        commandRequest.valetDrivingModeDeactivate = Proto_ValetDrivingModeDeactivate()
    }
}

extension Command.WeekProfileConfigure: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.weekProfileConfigure = Proto_WeekProfileConfigure.with {
			$0.weeklySetHu = self.dayTimes.compactMap { $0.proto() }
		}
	}
}

extension Command.WeekProfileConfigureV2: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		
		commandRequest.weekProfileConfigureV2 = Proto_WeekProfileConfigureV2.with {
			
			$0.timeProfiles = self.weeklyProfileModel.allTimeProfiles.map { (timeProfile) -> Proto_TimeProfile in
				
				return Proto_TimeProfile.with { (protoTimeProfile) in
					
					if let id = timeProfile.identifier {
						protoTimeProfile.identifier = Google_Protobuf_Int32Value(integerLiteral: Int32(id))
					}
                    
					guard !timeProfile.toBeRemoved else {
						return
					}
				
					protoTimeProfile.active = Google_Protobuf_BoolValue(booleanLiteral: timeProfile.active)
					protoTimeProfile.hour = Google_Protobuf_Int32Value(integerLiteral: Int32(timeProfile.hour))
					protoTimeProfile.minute = Google_Protobuf_Int32Value(integerLiteral: Int32(timeProfile.minute))
					protoTimeProfile.applicationIdentifier = Int32(timeProfile.applicationIdentifier)
					protoTimeProfile.days = timeProfile.days.map { (day) -> Proto_TimeProfileDay in
						switch day {
						case .monday:    return .monday
						case .tuesday:   return .tuesday
						case .wednesday: return .wednesday
						case .thursday:  return .thursday
						case .friday:    return .friday
						case .saturday:  return .saturday
						case .sunday:    return .sunday
						}
					}
					
				}
			}
		}
	}
}

extension Command.WindowsClose: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.windowsClose = Proto_WindowsClose()
	}
}

extension Command.WindowsOpen: CommandPinSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest, pin: String) {
		commandRequest.windowsOpen = Proto_WindowsOpen.with {
			$0.pin = pin
		}
	}
}

extension Command.WindowsVentilate: CommandPinSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest, pin: String) {
		commandRequest.windowsVentilate = Proto_WindowsVentilate.with {
			$0.pin = pin
		}
	}
}

extension Command.WindowsMove: CommandPinSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest, pin: String) {
		commandRequest.windowsMove = Proto_WindowsMove.with {
			
			$0.pin = pin
			
			if let frontLeftPosition = self.frontLeftPosition {
				$0.frontLeft = Google_Protobuf_Int32Value.init(integerLiteral: Int32(frontLeftPosition))
			}
			
			if let frontRightPosition = self.frontRightPosition {
				$0.frontRight = Google_Protobuf_Int32Value.init(integerLiteral: Int32(frontRightPosition))
			}
			
			if let rearBlindPosition = self.rearBlindPosition {
				$0.rearBlind = Google_Protobuf_Int32Value.init(integerLiteral: Int32(rearBlindPosition))
			}
			
			if let rearLeftBlindPosition = self.rearLeftBlindPosition {
				$0.rearLeftBlind = Google_Protobuf_Int32Value.init(integerLiteral: Int32(rearLeftBlindPosition))
			}
			
			if let rearLeftPosition = self.rearLeftPosition {
				$0.rearLeft = Google_Protobuf_Int32Value.init(integerLiteral: Int32(rearLeftPosition))
			}
			
			if let rearRightBlindPosition = self.rearRightBlindPosition {
				$0.rearRightBlind = Google_Protobuf_Int32Value.init(integerLiteral: Int32(rearRightBlindPosition))
			}
			
			if let rearRightPosition = self.rearRightPosition {
				$0.rearRight = Google_Protobuf_Int32Value.init(integerLiteral: Int32(rearRightPosition))
			}
		}
	}
}

extension Command.ZevPreconditioningConfigure: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.zevPreconditionConfigure = Proto_ZEVPreconditioningConfigure.with {
			
			if self.departureTimeMode != .weekly {
				$0.departureTime = Int32(self.departureTime)
			}
			
			$0.departureTimeMode = self.departureTimeMode.proto()
		}
	}
}

extension Command.ZevPreconditioningConfigureSeats: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.zevPreconditionConfigureSeats = Proto_ZEVPreconditioningConfigureSeats.with {
			$0.frontLeft = self.frontLeft
			$0.frontRight = self.frontRight
			$0.rearLeft = self.rearLeft
			$0.rearRight = self.rearRight
		}
	}
}

extension Command.ZevPreconditioningStart: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.zevPreconditioningStart = Proto_ZEVPreconditioningStart.with {
			$0.departureTime = Int32(self.departureTime)
			$0.type = self.type.proto()
		}
	}
}

extension Command.ZevPreconditioningStop: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.zevPreconditioningStop = Proto_ZEVPreconditioningStop.with {
			$0.type = self.type.proto()
		}
	}
}

extension Command.AutomaticValetParkingActivate: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.automaticValetParkingActivate = Proto_AutomaticValetParkingActivate.with {
			$0.bookingID = self.bookingId
			$0.driveType = self.driveType.proto()
		}
	}
}

extension Command.ChargeFlapUnlock: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.chargeFlapUnlock = Proto_ChargeFlapUnlock()
	}
}

extension Command.ChargeCouplerUnlock: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.chargeCouplerUnlock = Proto_ChargeCouplerUnlock()
	}
}
