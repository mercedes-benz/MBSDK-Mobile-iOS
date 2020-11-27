//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

public protocol SocketServiceRepresentable {
    
    /// Close the my car socket connection and remove all observables
    func closeConnection()
    
    /// Connect the my car socket service with the socket
    ///
    /// - Returns: A tuple consisting of MyCarSocketConnectionState and SocketObservableProtocol
    ///      - socketConnectionState: Status of the socket connection as MyCarSocketConnectionState
    ///      - socketObservable: Status of the observable based on the SocketObservableProtocol
    /// - Parameters:
    ///   - notificationTokenCreated: A block that returns the token that you later remove from the socket status updates watcher list.
    ///    The token should be saved until the end of session.
    ///   - socketConnectionState: A block that is executed when a status of the connection changed
    func connect(
    notificationTokenCreated: @escaping MyCarSocketNotificationToken.MyCarSocketNotificationTokenCreated,
    socketConnectionState: @escaping MyCarSocketNotificationToken.MyCarSocketConnectionObserver) -> (socketConnectionState: MyCarSocketConnectionState, socketObservable: SocketObservableProtocol)
    
    /// Disconnect the my car socket
    func disconnect()
    
    /// Reconnect the my car socket
    ///
    /// - Parameters: user-based interaction (true) to reconnect the socket connection
    func reconnect(manually: Bool)
    
    /// Send a command to the currently selected vehicle. Beware that the service for the specified command must be
    /// be activated. You can find valid commands as nested structs in the `Command`-struct.
    ///
    /// - Parameters:
    ///   - command: The command to be sent. All valid commands are nested under the `Command`-struct
    ///   - completion: A completion callback that is called multiple times for every status update. The
    ///                `failed` and `finished` states are final updates and the callback won't be called afterwards
    func send<T>(command: T, completion: @escaping CarKit.CommandUpdateCallback<T.Error>) where T: BaseCommandProtocol, T: CommandTypeProtocol
    
    /// Send logout message
    func sendLogoutMessage()
    
    /// Update the my car socket enviroment
    ///
    /// - Parameters: user-based interaction (true) to reconnect the socket connection
    func update(reconnectManually: Bool)
    
    /// Update the current my car observables
    func updateObservables()
    
    /// Update the current my car values without notify of observers
    func updateObservablesWithoutNotifyObserver()
    
    /// This method is used to unregister a my car socket connection token from the observation of the socket connection status
    ///
    /// - Parameters: Optional MyCarSocketNotificationToken
    func unregister(token: MyCarSocketNotificationToken?)
    
    /// This method is used to unregister a my car socket connection token from the observation of the socket connection status and try to disconnect the socket connection
    ///
    /// - Parameters: Optional MyCarSocketNotificationToken
    func unregisterAndDisconnectIfPossible(token: MyCarSocketNotificationToken?)
}

public extension SocketServiceRepresentable {
    
    func closeConnection() {}
    func disconnect() {}
    func reconnect(manually: Bool) {}
    func send<T>(command: T, completion: @escaping CarKit.CommandUpdateCallback<T.Error>) where T: BaseCommandProtocol, T: CommandTypeProtocol {}
    func sendLogoutMessage() {}
    func update(reconnectManually: Bool) {}
    func updateObservables() {}
    func updateObservablesWithoutNotifyObserver() {}
    func unregister(token: MyCarSocketNotificationToken?) {}
    func unregisterAndDisconnectIfPossible(token: MyCarSocketNotificationToken?) {}
}
