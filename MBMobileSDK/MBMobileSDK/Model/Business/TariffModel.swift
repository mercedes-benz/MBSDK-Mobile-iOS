//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of tariff model
public struct TariffModel {
	
	public let rate: TariffRate
	public let time: Int
	
	
	// MARK: - Init
	
	public init(rate: TariffRate, time: Int) {
		
		self.rate = rate
		self.time = time
	}
	
}
