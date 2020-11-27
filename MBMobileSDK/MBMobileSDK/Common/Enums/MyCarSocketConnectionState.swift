//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Socket connection state for the my car socket connection
public enum MyCarSocketConnectionState {
	
	/// Socket is closed and has no listener
	case closed
	/// Socket is connected
	case connected
	/// The setup of the socket connection has started
	case connecting
	/// Socket lost the connection with the indication of wheter a refresh of the jwt is needed
	case connectionLost(needsTokenUpdate: Bool)
	/// Socket is disconnected with all available listeners
	case disconnected
}
