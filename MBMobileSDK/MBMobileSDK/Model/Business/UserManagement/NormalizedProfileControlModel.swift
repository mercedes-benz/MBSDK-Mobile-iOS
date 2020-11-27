//
//  Copyright © 2020 Daimler AG. All rights reserved.
//

import Foundation

public struct NormalizedProfileControlModel: Decodable {
	
	public let enabled: Bool
	
	// MARK: - Init
	
	public init(enabled: Bool = false) {
		self.enabled = enabled
	}
	
}
