//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// The possible service actions for service activation
public enum ServiceAction: String, CaseIterable {
	case accountLinkage = "ACCOUNT_LINKAGE"
	case editUserProfile = "EDIT_USER_PROFILE"
	case purchaseLicense = "PURCHASE_LICENSE"
	case removeFuseboxEntry = "REMOVE_FUSEBOX_ENTRY"
	case setCustomProperty = "SET_CUSTOM_PROPERTY"
	case setDesiredInactive = "SET_DESIRED_INACTIVE"
	case setDesiredActive = "SET_DESIRED_ACTIVE"
	case signUserAgreement = "SIGN_USER_AGREEMENT"
	case updateTrustLevel = "UPDATE_TRUST_LEVEL"
}


// MARK: - Extension

extension ServiceAction {
	
	var actionHint: String {
		return self.rawValue
	}
}
