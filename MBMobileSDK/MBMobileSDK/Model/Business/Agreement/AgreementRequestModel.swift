//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of a agreement to be requested
public struct AgreementRequestModel: Encodable {
	
	let acceptedByUser: Bool
	let acceptedLocale: String
	let documentId: String
	let version: Int
	
	
	// MARK: - Init
	
	public init(acceptedByUser: Bool, acceptedLocale: String, documentId: String, version: Int) {
		
		self.acceptedByUser  = acceptedByUser
		self.acceptedLocale  = acceptedLocale
		self.documentId      = documentId
		self.version         = version
	}
}
