//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of user preferred communication
public struct UserCommunicationPreferenceModel: Equatable {
	
	public let phone: Bool?
	public let letter: Bool?
	public let email: Bool?
	public let sms: Bool?
	
	
	// MARK: - Init
	
	public init(phone: Bool?, letter: Bool?, email: Bool?, sms: Bool?) {
		
		self.phone = phone
		self.letter = letter
		self.email = email 
		self.sms = sms
	}
}
