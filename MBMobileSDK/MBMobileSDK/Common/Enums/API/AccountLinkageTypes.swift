//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

/// Account action type of a account linkage
public enum AccountActionType: String, CaseIterable {
	case connect = "CONNECT"
	case connectWithVoucher = "CONNECT_WITH_VOUCHER"
	case delete = "DELETE"
	case setDefault = "SET_DEFAULT"
}

/// Account type of a account linkage
public enum AccountType: String, CaseIterable {
	case charging = "CHARGING"
	case inCarOffice = "IN_CAR_OFFICE"
	case music = "MUSIC"
	case smartHome = "SMART_HOME"
}


/// Connection state of a account linkage
public enum ConnectionState: String, CaseIterable {
	case connected = "CONNECTED"
	case disconnected = "DISCONNECTED"
}
