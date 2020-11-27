//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Windows lift count of the vehicle
public enum WindowsLiftCount: String, Codable, CaseIterable {
	case four = "FourLift"
	case none = "NoLift"
	case two = "TwoLift"
}
