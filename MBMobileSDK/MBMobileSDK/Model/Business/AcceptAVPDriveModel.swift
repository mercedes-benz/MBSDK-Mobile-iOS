//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

/// Front-end confirms to go ahead after the remote engine starts
public struct AcceptAVPDriveModel: Encodable {
	
	/// the booking ID for the drive to start
	public let bookingId: String
	
	/// indication for whether to start the drive or not
	public let startDrive: Bool
	
	
	// MARK: - Init
	
	public init(bookingId: String, startDrive: Bool) {
		
		self.bookingId = bookingId
		self.startDrive = startDrive
	}
}
