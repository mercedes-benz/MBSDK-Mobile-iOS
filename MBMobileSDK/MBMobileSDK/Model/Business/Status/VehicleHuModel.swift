//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of head unit related attributes
public struct VehicleHuModel {
	
    /// HeadUnit tracking, on or off
	public let isTrackingEnable: StatusAttributeType<ActiveState, NoUnit>
    /// Language of HeadUnit
	public let language: StatusAttributeType<LanguageState, NoUnit>
    /// Temperature unit of HeadUnit
	public let temperatureType: StatusAttributeType<TemperatureType, NoUnit>
    /// Timeformat of HeadUnit
	public let timeFormatType: StatusAttributeType<TimeFormatType, NoUnit>
    /// Weekly profile for preconditioning.
	public let weeklyProfile: StatusAttributeType<WeeklyProfileModel, NoUnit>
    /// List of 0..21 departure-times currently set in HeadUnit
	public let weeklySetHU: StatusAttributeType<[DayTimeModel], NoUnit>
}
