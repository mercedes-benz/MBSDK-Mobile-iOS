//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of a agreement to be confirmed
public struct AgreementConfirmModel {
	
	public let agreementConsents: Bool
	public let unsuccessfulIds: [String]
}
