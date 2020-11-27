//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of a account linkage item model
public struct AccountLinkageItemModel {
	
	public let accountType: AccountType
	public let actions: [AccountLinkageActionModel]
	public let bannerUrl: URL?
    public let connectionState: ConnectionState
    public let description: String?
	public let descriptionLinks: [String: String]
	public let iconUrl: URL?
	public let isDefault: Bool
	public let legalText: String?
	public let userAccountId: String?
	public let vendorDisplayName: String?
	public let vendorId: String?
}
