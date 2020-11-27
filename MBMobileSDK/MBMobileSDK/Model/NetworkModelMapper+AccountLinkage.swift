//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - Assignment

extension NetworkModelMapper {
	
	// MARK: - BusinessModel
	
	static func map(_ apiAccountLinkageActionModel: APIAccountLinkageActionModel) -> AccountLinkageActionModel? {
		
		guard let action = AccountLinkageAction(rawValue: apiAccountLinkageActionModel.action ?? "") else {
			return nil
		}
		
		return AccountLinkageActionModel(action: action,
										 title: apiAccountLinkageActionModel.label ?? "",
										 url: URL(string: apiAccountLinkageActionModel.url ?? ""))
	}
	
	static func map(_ apiAccountLinkageActionModels: [APIAccountLinkageActionModel]) -> [AccountLinkageActionModel] {
		return apiAccountLinkageActionModels.compactMap { self.map($0) }
	}
	
	static func map(_ apiAccountLinkageItemModel: APIAccountLinkageItemModel) -> AccountLinkageItemModel? {
		
		guard let accountType = AccountType(rawValue: apiAccountLinkageItemModel.accountType ?? ""),
			let connectionState = ConnectionState(rawValue: apiAccountLinkageItemModel.connectionState) else {
				return nil
		}
		
		return AccountLinkageItemModel(accountType: accountType,
									   actions: self.map(apiAccountLinkageItemModel.possibleActions ?? []),
									   bannerUrl: URL(string: apiAccountLinkageItemModel.bannerUrl ?? ""),
									   connectionState: connectionState,
									   description: apiAccountLinkageItemModel.description,
									   descriptionLinks: apiAccountLinkageItemModel.descriptionLinks ?? [:],
									   iconUrl: URL(string: apiAccountLinkageItemModel.iconUrl ?? ""),
									   isDefault: apiAccountLinkageItemModel.isDefault ?? false,
									   legalText: apiAccountLinkageItemModel.legalTextUrl,
									   userAccountId: apiAccountLinkageItemModel.userAccountId,
									   vendorDisplayName: apiAccountLinkageItemModel.vendorDisplayName,
									   vendorId: apiAccountLinkageItemModel.vendorId)
	}
	
	static func map(_ apiAccountLinkageItemModels: [APIAccountLinkageItemModel]) -> [AccountLinkageItemModel] {
		return apiAccountLinkageItemModels.compactMap { self.map($0) }
	}
	
	static func map(_ apiAccountLinkageModel: APIAccountLinkageModel) -> AccountLinkageModel? {
		
		guard let accountType = AccountType(rawValue: apiAccountLinkageModel.accountType ?? "") else {
			return nil
		}
		
		return AccountLinkageModel(accounts: self.map(apiAccountLinkageModel.accounts ?? []),
								   accountType: accountType,
								   bannerUrl: URL(string: apiAccountLinkageModel.bannerImageUrl ?? ""),
								   description: apiAccountLinkageModel.description,
								   iconUrl: URL(string: apiAccountLinkageModel.iconUrl ?? ""),
								   isVisible: apiAccountLinkageModel.visible ?? false,
								   name: apiAccountLinkageModel.name,
								   title: apiAccountLinkageModel.heading)
	}
	
	static func map(_ apiAccountLinkageModels: [APIAccountLinkageModel]) -> [AccountLinkageModel] {
		return apiAccountLinkageModels.compactMap { self.map($0) }
	}
}
