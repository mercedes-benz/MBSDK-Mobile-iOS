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

extension Array where Element: Hashable {
	
	/// Compare tow arrays and returns the difference elements.
	///
	/// - Parameter other: array of comparable array.
	/// - Returns: Array of elements which are different.
	func difference(from other: [Element]) -> [Element] {
		
		let thisSet = Set(self)
		let otherSet = Set(other)
		return Array(thisSet.symmetricDifference(otherSet))
	}
}
