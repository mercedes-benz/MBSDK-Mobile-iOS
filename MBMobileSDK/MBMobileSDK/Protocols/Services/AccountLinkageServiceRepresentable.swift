//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import MBNetworkKit

public protocol AccountLinkageServiceRepresentable {
	
	/// Delete account linkages from you Mercedes me ID
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the car
    ///   - accountType: Type of your account linkage (MUSIC, INCAROFFICE)
    ///   - vendorId: Identifier of your account linkage
    ///   - completion: Completion with AccountLinkageDeleteResult
	func deleteAccount(finOrVin: String, accountType: AccountType, vendorId: String, completion: @escaping AccountLinkageService.AccountLinkageResult)
	
	/// Get account linkages for a vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the car
    ///   - serviceIds: Array of service id's that relate to either Entertainment or InCarOffice account config
    ///   - redirectURL: URL scheme which is redirected after account linkage
    ///   - completion: Completion with AccountLinkageResult
	func fetchAccounts(finOrVin: String, serviceIds: [Int]?, redirectURL: String?, completion: @escaping AccountLinkageService.AccountLinkageDataResult)
	
	/// Send consent for a account linkage for a vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the car
    ///   - accountType: Type of your account linkage (CHARGING)
    ///   - vendorId: Identifier of your account linkage
    ///   - completion: Completion with AccountLinkageDeleteResult
	func sendConsent(finOrVin: String, accountType: AccountType, vendorId: String, completion: @escaping AccountLinkageService.AccountLinkageResult)
}


public extension AccountLinkageServiceRepresentable {
	
	func deleteAccount(finOrVin: String, accountType: AccountType, vendorId: String, completion: @escaping AccountLinkageService.AccountLinkageResult) {}
	func fetchAccounts(finOrVin: String, serviceIds: [Int]?, redirectURL: String?, completion: @escaping AccountLinkageService.AccountLinkageDataResult) {}
	func sendConsent(finOrVin: String, accountType: AccountType, vendorId: String, completion: @escaping AccountLinkageService.AccountLinkageResult) {}
}
