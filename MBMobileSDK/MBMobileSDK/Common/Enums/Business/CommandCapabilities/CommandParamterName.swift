//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// The parameter name of a command capability
public enum CommandParameterName: String {
	// Auxheat configure parameters
	case timeSelection = "TIME_SELECTION"
	case paramTime1 = "PARAM_TIME_1"
	case paramTime2 = "PARAM_TIME_2"
	case paramTime3 = "PARAM_TIME_3"
	// Battery
	case chargePpogram = "CHARGE_PROGRAM"
	case maxSoc = "MAX_SOC"
	// ChargeOptConfigure
	case weekdayTariffRate = "WEEKDAY_TARIFF_RATE"
	case weekdayTariffTime = "WEEKDAY_TARIFF_TIME"
	// ChargeProgramConfigure
	case autoUnlock = "AUTO_UNLOCK"
	case locationBasedCharging = "LOCATION_BASED_CHARGING"
	case weeklyProfile = "WEEKLY_PROFILE"
	// Door lock/unlock
	case doors = "DOORS"
	// SigposStart parameters
	case hornRepeat = "HORN_REPEAT"
	case hornType = "HORN_TYPE"
	case lightType = "LIGHT_TYPE"
	case sigposDuration = "SIGPOS_DURATION"
	case sigposType = "SIGPOS_TYPE"
	// SpeedalertStart
	case threshold = "THRESHOLD"
	case alertEndTime = "ALERT_END_TIME"
	// TemperatureConfigure parameters
	case temperaturePointsTemperature = "TEMPERATURE_POINTS_TEMPERATURE"
	case temperaturePointsZone = "TEMPERATURE_POINTS_ZONE"
	// WeekProfileConfigure
	case weeklySetHuDate = "WEEKLY_SET_HU_DAY"
	case weeklySetHuTime = "WEEKLY_SET_HU_TIME"
	// ZEV
	case departureTimeMode = "DEPARTURE_TIME_MODE"
	case departureTime = "DEPARTURE_TIME"
	case frontLeftSeat = "FRONT_LEFT_SEAT"
	case frontRightSeat = "FRONT_RIGHT_SEAT"
	case rearLeftSeat = "REAR_LEFT_SEAT"
	case rearRightSeat = "REAR_RIGHT_SEAT"
	case type = "TYPE"
	case unknown
}
