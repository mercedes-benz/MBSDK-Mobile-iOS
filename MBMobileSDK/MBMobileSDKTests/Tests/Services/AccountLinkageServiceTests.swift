//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Nimble
import Quick

import MBCommonKit
import MBNetworkKit

@testable import MBMobileSDK

class AccountLinkageServiceTests: QuickSpec {

	override func spec() {
		
		var accountLinkageService: AccountLinkageServiceRepresentable!
		var networkService: MockNetworkService!
		
		let finOrVin = "MOCKVIN871Z000099"
		
		beforeEach {
			
			networkService = MockNetworkService()
			accountLinkageService = AccountLinkageService(networking: networkService,
														  tokenProviding: MockTokenProvider())
		}
		
		describe(".deleteAccount") {
			beforeEach {
				networkService.reset()
			}
			
			it("should complete with error") {

				let returnedError = MBError(description: "mockError", type: .unknown)
				networkService.returnedError = returnedError
				
				accountLinkageService.deleteAccount(finOrVin: finOrVin, accountType: .music, vendorId: "") { (result) in
					
					switch result {
					case .failure(let error):
						expect(error).to(matchError(returnedError))
					
					case .success:
						fail()
					}
				}
			}
			
			it("should complete with success") {
				
				networkService.returnedData = Data()
				accountLinkageService.deleteAccount(finOrVin: finOrVin, accountType: .music, vendorId: "") { (result) in
					
					switch result {
					case .failure:
						fail()
					
					case .success:
						_ = succeed()
					}
				}
			}
		}
		
		describe(".fetchAccounts") {
			beforeEach {
				networkService.reset()
			}
			
			it("should complete with error") {
				
				let returnedError = MBError(description: "mockError", type: .unknown)
				networkService.returnedError = returnedError
				
				accountLinkageService.fetchAccounts(finOrVin: finOrVin, serviceIds: nil, redirectURL: nil) { (result) in
					
					switch result {
					case .failure(let error):
						expect(error).to(matchError(returnedError))
					
					case .success:
						fail()
					}
				}
			}
			
			it("should complete with success") {
				
				networkService.returnedDecodable = [
					APIAccountLinkageModel(accounts: [APIAccountLinkageItemModel(accountType: AccountType.music.rawValue,
																				 bannerUrl: nil,
																				 connectionState: ConnectionState.connected.rawValue,
																				 description: nil,
																				 descriptionLinks: nil,
																				 iconUrl: nil,
																				 isDefault: false,
																				 legalTextUrl: nil,
																				 possibleActions: [APIAccountLinkageActionModel(action: AccountLinkageAction.delete.rawValue,
																																label: nil,
																																url: nil),
																								   APIAccountLinkageActionModel(action: nil,
																																label: nil,
																																url: nil)],
																				 userAccountId: nil,
																				 vendorDisplayName: nil,
																				 vendorId: nil),
													  APIAccountLinkageItemModel(accountType: AccountType.music.rawValue,
																				 bannerUrl: nil,
																				 connectionState: ConnectionState.connected.rawValue,
																				 description: nil,
																				 descriptionLinks: nil,
																				 iconUrl: nil,
																				 isDefault: nil,
																				 legalTextUrl: nil,
																				 possibleActions: nil,
																				 userAccountId: nil,
																				 vendorDisplayName: nil,
																				 vendorId: nil),
													  APIAccountLinkageItemModel(accountType: nil,
																				 bannerUrl: nil,
																				 connectionState: ConnectionState.connected.rawValue,
																				 description: nil,
																				 descriptionLinks: nil,
																				 iconUrl: nil,
																				 isDefault: false,
																				 legalTextUrl: nil,
																				 possibleActions: [APIAccountLinkageActionModel(action: AccountLinkageAction.delete.rawValue,
																																label: nil,
																																url: nil)],
																				 userAccountId: nil,
																				 vendorDisplayName: nil,
																				 vendorId: nil)],
										   accountType: AccountType.music.rawValue,
										   bannerImageUrl: nil,
										   description: nil,
										   iconUrl: nil,
										   heading: nil,
										   name: nil,
										   visible: true),
					APIAccountLinkageModel(accounts: [APIAccountLinkageItemModel(accountType: AccountType.music.rawValue,
																				 bannerUrl: nil,
																				 connectionState: ConnectionState.connected.rawValue,
																				 description: nil,
																				 descriptionLinks: nil,
																				 iconUrl: nil,
																				 isDefault: false,
																				 legalTextUrl: nil,
																				 possibleActions: [APIAccountLinkageActionModel(action: AccountLinkageAction.delete.rawValue,
																																label: nil,
																																url: nil)],
																				 userAccountId: nil,
																				 vendorDisplayName: nil,
																				 vendorId: nil)],
										   accountType: nil,
										   bannerImageUrl: nil,
										   description: nil,
										   iconUrl: nil,
										   heading: nil,
										   name: nil,
										   visible: true),
					APIAccountLinkageModel(accounts: nil,
										   accountType: AccountType.music.rawValue,
										   bannerImageUrl: nil,
										   description: nil,
										   iconUrl: nil,
										   heading: nil,
										   name: nil,
										   visible: nil)
				]
				
				accountLinkageService.fetchAccounts(finOrVin: finOrVin, serviceIds: nil, redirectURL: nil) { (result) in
					
					switch result {
					case .failure:
						fail()
					
					case .success(let accountLinkageModels):
						expect(accountLinkageModels.count) == 2
						expect(accountLinkageModels.first?.accountType) == .music
						expect(accountLinkageModels.first?.accounts.first?.connectionState) == .connected
						expect(accountLinkageModels.first?.accounts.first?.actions.count) == 1
						expect(accountLinkageModels.first?.accounts.first?.actions.first?.url).to(beNil())
					}
				}
			}
		}
		
		describe(".sendConsent") {
			beforeEach {
				networkService.reset()
			}
			
			it("should complete with error") {

				let returnedError = MBError(description: "mockError", type: .unknown)
				networkService.returnedError = returnedError
				
				accountLinkageService.sendConsent(finOrVin: finOrVin, accountType: .charging, vendorId: "") { (result) in
					
					switch result {
					case .failure(let error):
						expect(error).to(matchError(returnedError))
					
					case .success:
						fail()
					}
				}
			}
			
			it("should complete with success") {
				
				networkService.returnedData = Data()
				accountLinkageService.sendConsent(finOrVin: finOrVin, accountType: .charging, vendorId: "") { (result) in
					
					switch result {
					case .failure:
						fail()
					
					case .success:
						_ = succeed()
					}
				}
			}
		}
	}
}
