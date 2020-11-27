//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import SwiftProtobuf

extension AuxheatTimeSelectionState {
	
	internal func proto() -> Proto_AuxheatConfigure.Selection {
		switch self {
		case .none:  return .noSelection
		case .time1: return .time1
		case .time2: return .time2
		case .time3: return .time3
		}
	}
}

extension TemperatureZone {
	
	internal func proto() -> Proto_TemperatureConfigure.TemperaturePoint.Zone {
		switch self {
		case .frontCenter: return .frontCenter
		case .frontLeft:   return .frontLeft
		case .frontRight:  return .frontRight
		case .rear2center: return .rear2Center
		case .rear2left:   return .rear2Left
		case .rear2right:  return .rear2Right
		case .rearCenter:  return .rearCenter
		case .rearLeft:    return .rearLeft
		case .rearRight:   return .rearRight
		}
	}
}

extension BatteryChargeProgram {
	
	internal func proto() -> Proto_BatteryChargeProgramConfigure.ChargeProgram {
		switch self {
		case .default: return .default
		case .instant: return .instant
		}
	}
}

extension ChargeProgram {
	
	internal func proto() -> Proto_ChargeProgramConfigure.ChargeProgram {
		switch self {
		case .default: return .defaultChargeProgram
		case .home:    return .homeChargeProgram
		case .work:    return .workChargeProgram
		}
	}
}

extension Day {
	
	internal func proto() -> Proto_WeekProfileConfigure.WeeklySetHU.Day {
		switch self {
		case .monday:    return .monday
		case .tuesday:   return .tuesday
		case .wednesday: return .wednesday
		case .thursday:  return .thursday
		case .friday:    return .friday
		case .saturday:  return .saturday
		case .sunday:    return .sunday
		}
	}
	
	internal static func fromTimeProfileDay(timeProfileDay: Proto_TimeProfileDay) -> Day? {
		switch timeProfileDay {
		case .mo: return .monday
		case .tu: return .tuesday
		case .we: return .wednesday
		case .th: return .thursday
		case .fr: return .friday
		case .sa: return .saturday
		case .su: return .sunday
		case .UNRECOGNIZED: return nil
		}
	}
}

extension DepartureTimeConfiguration {
	
	internal func proto() -> Proto_ZEVPreconditioningConfigure.DepartureTimeMode {
		switch self {
		case .disabled: return .disabled
		case .once:     return .singleDeparture
		case .weekly:   return .weeklyDeparture
		}
	}
}

extension PreconditioningType {
	
	internal func proto() -> Proto_ZEVPreconditioningType {
		switch self {
		case .unknown: return .unknownZevPreconditioningCommandType
		case .immediate: return .immediate
		case .departure: return .departure
		case .now: return .now
		case .departureWeekly: return .departureWeekly
		}
	}
}

extension TariffRate {
	
	internal func proto() -> Proto_ChargeOptConfigure.Tariff.Rate {
		switch self {
		case .invalidPrice: return .invalidPrice
		case .lowPrice:     return .lowPrice
		case .normalPrice:  return .normalPrice
		case .highPrice:    return .highPrice
		}
	}
}

extension LightType {
	
	internal func proto() -> Proto_SigPosStart.LightType {
		switch self {
		case .off:             return .lightOff
		case .dippedHeadLight: return .dippedHeadLight
		case .warningLight:    return .warningLight
		}
	}
}

extension SigposType {
	
	internal func proto() -> Proto_SigPosStart.SigposType {
		switch self {
		case .lightOnly:    return .lightOnly
		case .hornOnly:     return .hornOnly
		case .lightAndHorn: return .lightAndHorn
		case .panicAlarm:   return .panicAlarm
		}
	}
}

extension HornType {
	
	internal func proto() -> Proto_SigPosStart.HornType {
		switch self {
		case .off:        return .hornOff
		case .lowVolume:  return .hornLowVolume
		case .highVolume: return .hornHighVolume
		}
	}
}

extension TariffModel {
	
	internal func proto() -> Proto_ChargeOptConfigure.Tariff {
		return Proto_ChargeOptConfigure.Tariff.with {
			$0.rate = self.rate.proto()
			$0.time = Int32(self.time)
		}
	}
}

extension TemperaturePointModel {
	
	internal func proto() -> Proto_TemperatureConfigure.TemperaturePoint {
		return Proto_TemperatureConfigure.TemperaturePoint.with {
			$0.temperatureInCelsius = self.temperatureInCelsius
			$0.zone = self.zone.proto()
		}
	}
}

extension DayTimeModel {
	
	internal func proto() -> Proto_WeekProfileConfigure.WeeklySetHU {
		
		return Proto_WeekProfileConfigure.WeeklySetHU.with {
			$0.day = self.day.proto()
			$0.time = Int32(self.time)
		}
	}
}

extension AutomaticValetParkingDriveType {
	
	internal func proto() -> Proto_DriveType {
		switch self {
		case .dropOff: return .dropOff
		case .pickUp: return .pickUp
		}
	}
}
