//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

extension Array {
	
	/// Element at the given index if it exists.
	///
	/// - Parameter index: index of element.
	/// - Returns: optional element (if exists).
	func item(at index: Int) -> Element? {
		
		if 0..<self.count ~= index {
			return self[index]
		}
		
		return nil
	}
}
