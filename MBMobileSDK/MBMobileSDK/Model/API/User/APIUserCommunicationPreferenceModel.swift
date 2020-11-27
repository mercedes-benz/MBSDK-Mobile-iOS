//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public struct APIUserCommunicationPreferenceModel: Codable {
	
	let contactedByPhone: Bool?
	let contactedByLetter: Bool?
	let contactedByEmail: Bool?
	let contactedBySms: Bool?
	
	init(contactedByPhone: Bool?, contactedByLetter: Bool?, contactedByEmail: Bool?, contactedBySms: Bool?) {
		
		self.contactedByPhone = contactedByPhone
		self.contactedByLetter = contactedByLetter
		self.contactedByEmail = contactedByEmail
		self.contactedBySms = contactedBySms
	}
}
