//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

extension Bool {
	
	var toInt: Int {
		return self ? 1 : 0
	}
}


// MARK: - ExpressibleByIntegerLiteral

extension Bool: ExpressibleByIntegerLiteral {
	
	public init(integerLiteral value: Int) {
		self = value != 0
	}
}
