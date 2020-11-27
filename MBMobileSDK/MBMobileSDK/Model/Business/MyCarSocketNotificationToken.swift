//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

/// Representation of the notification token for the my car socket
public class MyCarSocketNotificationToken: NSObject {
	
	// MARK: Typealias
	
	/// Completion for socket based connection status
	///
	/// Returns a MyCarSocketConnectionState
	public typealias MyCarSocketConnectionObserver = (MyCarSocketConnectionState) -> Void

    /// Completion after creating the MyCarSocketNotificationToken
    ///
    /// Returns a MyCarSocketNotificationToken
    public typealias MyCarSocketNotificationTokenCreated = (MyCarSocketNotificationToken?) -> Void
	
	// MARK: Properties
	private let socketConnectionObserver: MyCarSocketConnectionObserver
	

	// MARK: - Init
	
	init(socketConnectionObserver: @escaping MyCarSocketConnectionObserver) {
		self.socketConnectionObserver = socketConnectionObserver
	}
	
	
	// MARK: - Public
	
	func notify(state: MyCarSocketConnectionState) {
		self.socketConnectionObserver(state)
	}
}
