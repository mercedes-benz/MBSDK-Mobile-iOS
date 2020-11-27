//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// The allowed enum of a command capability
public enum CommandAllowedEnum: String {
	// Auxheat configure
	case noSelection = "NO_SELECTION"
	case time1 = "TIME_1"
	case time2 = "TIME_2"
	case time3 = "TIME_3"
	// Battery Chargeprogram
	case `default` = "DEFAULT"
	case instant = "INSTANT"
	// ChargeOpt configure
	case priceLow = "LOW_PRICE"
	case priceNormal = "NORMAL_PRICE"
	case priceHigh = "HIGH_PRICE"
	// Chargeprogram Configure
	case defaultChargeProgram = "DEFAULT_CHARGEPROGRAM"
	case instantChargeProgram = "INSTANT_CHARGEPROGRAM"
	case homeChargeProgram = "HOME_CHARGEPROGRAM"
	case workChargeProgram = "WORK_CHARGEPROGRAM"
	// Doors
	case trunk = "TRUNK"
	case fuelFlap = "FUEL_FLAP"
	case chargeFlap = "CHARGE_FLAP"
	case chargeCoupler = "CHARGE_COUPLER"
	// SigposStart enums
	case hornOff = "HORN_OFF"
	case hornLowVolume = "HORN_LOW_VOLUME"
	case hornHighVolume = "HORN_HIGH_VOLUME"
	case lightOff = "LIGHT_OFF"
	case dippedHeadLight = "DIPPED_HEAD_LIGHT"
	case warningLight = "WARNING_LIGHT"
	case lightOnly = "LIGHT_ONLY"
	case hornOnly = "HORN_ONLY"
	case lightAndHorn = "LIGHT_AND_HORN"
	case panicAlarm = "PANIC_ALARM"
	// TemperatureConfigure enums
	case frontLeft = "FRONT_LEFT"
	case frontRight = "FRONT_RIGHT"
	case frontCenter = "FRONT_CENTER"
	case rearLeft = "REAR_LEFT"
	case rearRight = "REAR_RIGHT"
	case rearCenter = "REAR_CENTER"
	case rear2Left = "REAR_2_LEFT"
	case rear2Right = "REAR_2_RIGHT"
	case rear2Center = "REAR_2_CENTER"
	// Week profile configure
	case monday = "MONDAY"
	case tuesday = "TUESDAY"
	case wednesday = "WEDNESDAY"
	case thursday = "THURSDAY"
	case friday = "FRIDAY"
	case saturday = "SATURDAY"
	case sunday = "SUNDAY"
	// ZEV Precondition
	case immediate = "IMMEDIATE"
	case departure = "DEPARTURE"
	case now = "NOW"
	case departureWeekly = "DEPARTURE_WEEKLY"
	case disabled = "DISABLED"
	case singleDeparture = "SINGLE_DEPARTURE"
	case weeklyDeparture = "WEEKLY_DEPARTURE"
	case unknown
}
