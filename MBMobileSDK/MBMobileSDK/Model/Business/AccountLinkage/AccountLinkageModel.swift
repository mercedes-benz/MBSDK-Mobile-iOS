//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of a account linkage model
public struct AccountLinkageModel {
	
	public let accounts: [AccountLinkageItemModel]
	public let accountType: AccountType
	public let bannerUrl: URL?
    public let description: String?
	public let iconUrl: URL?
	public let isVisible: Bool
	public let name: String?
	public let title: String?
}
