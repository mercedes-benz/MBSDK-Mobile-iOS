//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Additional information about the command state
public enum CommandState: String {
	case unknown

	/// Command execution request is accepted and an asynchronous process is
	/// being initialized.
	case initiation

	/// Another process for the same vehicle and queue is active, the request has
	/// been queued for later execution.
	case enqueued

	/// The process is currently being processed by the backend.
	case processing

	/// The backend currently waits for the vehicle to respond to the request.
	case waiting

	/// The process has finished successfully.
	case finished

	/// There was an error while executing the command process.
	case failed
}
