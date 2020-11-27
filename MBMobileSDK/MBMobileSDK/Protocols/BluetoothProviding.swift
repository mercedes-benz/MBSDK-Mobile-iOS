//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public enum BluetoothConnectResult {
    case failure(Error?)
    case statusChange(BluetoothConnectionStatus)
}

public enum BluetoothSendResult {
    case failure(Error?)
    case success
}

public typealias OnConnectStateChange<T: AnyObject> = ((_ observer: T, _ connectionUpdate: BluetoothConnectResult) -> Void)
public typealias OnSendCompletion = ((BluetoothSendResult) -> Void)

public protocol BluetoothProviding {
    
    /// The currently connected FIN or VIN
    var connectedFinOrVin: String? { get }

    /// The current bluetooth connection status
    var connectionStatus: BluetoothConnectionStatus { get }
    
    /// Sending a POI to the vehicle via Bluetooth
    ///
    /// Sending a POI does not automatically establish a BT connection. Please check
    /// the connection state before sending and - if needed - connect to the HU first.
    ///
    /// - Parameters:
    ///    - poi: The POI that is to be send to the vehicle
    ///    - finOrVin: The FIN or VIN to witch the POI should be sended
    ///    - allowedQueuing: Determines if send requests should be queued if the bluetooth connection is
    ///         temporarily unavailable. If true requests will be queued, if false requests will not
    ///         be queued and send requests fail if a connection is not temporarily available.
    ///    - onComplete: Callback that is invoked when the send requests finishes
    func send<T: BluetoothPoiMappable>(poi: T, to finOrVin: String?, allowedQueuing: Bool, onComplete: @escaping OnSendCompletion)
}

public protocol BluetoothPoiMappable {
    /// latitude of the co-ordinate
    var latitude: Double { get }
    /// longitude of the co-ordinate
    var longitude: Double { get }
    /// Name of the POI
    var title: String? { get }
    /// House number of the POI
    var houseNumber: String? { get }
    /// Street name of the POI
    var street: String? { get }
    /// City name for the POI
    var city: String? { get }
    /// Administrative state for the POI
    var state: String? { get }
    /// Country name of the POI
    var country: String? { get }
    /// Postal code of the POI
    var postalCode: String? { get }
}
