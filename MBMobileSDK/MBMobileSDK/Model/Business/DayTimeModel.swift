//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of day and time model
public struct DayTimeModel {
	
	public let day: Day
	
	/// time in minutes after midnight
	public let time: Int
	
	
	// MARK: - Init
	
	public init(day: Day, time: Int) {
		
		self.day = day
		self.time = time
	}
}
