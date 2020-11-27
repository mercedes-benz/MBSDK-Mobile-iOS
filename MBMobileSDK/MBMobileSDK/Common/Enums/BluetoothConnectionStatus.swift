//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Bluetooth connection status of the head unit
public enum BluetoothConnectionStatus {
    /// The head unit is not connected
    case notConnected
    /// A connection to the head unit is currently being established
    case connecting
    // The head unit is connected via bluetooth
    case connected
}
