//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Dealer opening status
public enum DealerOpeningStatus {
	case closed
	/// Dealer has opened with the opening time as a string
	case open(from: String?, until: String?)
}
