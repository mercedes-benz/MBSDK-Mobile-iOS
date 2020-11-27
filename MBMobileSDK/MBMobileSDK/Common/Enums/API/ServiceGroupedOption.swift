//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Options to group the service categories
public enum ServiceGroupedOption: String {
    
    ///  Services are grouped by their category.
	case categoryName
    /// No grouping, every service will be within a single group.
	case none
}
