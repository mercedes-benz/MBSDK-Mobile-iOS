//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBNetworkKit

public struct APIError: Decodable {
	
	/// Localized error message
	public let description: String?
	
	/// Form related errors
	public let errors: [APIErrorDescription]?
}


// MARK: - MBErrorConformable

extension APIError: MBErrorConformable {
	
	public var errorDescription: String? {
		return self.description ?? self.errors?.first?.description
	}
}


// MARK: - APIErrorDescription

public struct APIErrorDescription: Decodable {
	
	public let description: String
	public let fieldName: String?
}
