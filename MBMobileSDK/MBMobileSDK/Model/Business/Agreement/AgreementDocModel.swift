//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of a agreement document
public struct AgreementDocModel {
	
	public let acceptedByUser: Bool
	public let acceptedLocale: String
	public let documentId: String
	public let version: Int
}
