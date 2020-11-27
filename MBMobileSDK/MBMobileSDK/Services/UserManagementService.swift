//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit
import MBNetworkKit

protocol UserManagementServiceRepresentable {

	func fetchVehicleAssignedUsers(finOrVin: String, completion: @escaping UserManagementService.VehicleAssignedUserSucceeded)
	func fetchInvitationQrCode(finOrVin: String, profileId: VehicleProfileID, completion: @escaping UserManagementService.VehicleQrCodeInvitationCompletion)
	func removeUserAuthorization(finOrVin: String, authorizationID: String, completion: @escaping UserManagementService.RemoveUserAuthorizationCompletion)
	func setProfileSync(enabled: Bool, finOrVin: String, completion: @escaping UserManagementService.SetProfileSyncCompletion)
	func upgradeTemporaryUser(authorizationID: String, finOrVin: String, completion: @escaping UserManagementService.UpgradeTemporaryUserCompletion)
	func fetchNormalizedProfileControl(completion: @escaping UserManagementService.NormalizedProfileControlCompletion)
	func setNormalizedProfileControl(enabled: Bool, completion: @escaping UserManagementService.SetNormalizedProfileControlCompletion)
}

final class UserManagementService: UserManagementServiceRepresentable {
	

	// MARK: - Types

	/// Completion for subuser qr-code invitation
	///
	/// Returns an image data object
	typealias VehicleQrCodeInvitationCompletion = (Result<Data, MBError>) -> Void
	typealias VehicleAssignedUserSucceeded = (Result<APIVehicleUserManagementModel, MBError>) -> Void
    typealias RemoveUserAuthorizationCompletion = (Result<Void, MBError>) -> Void
    typealias SetProfileSyncCompletion = (Result<Void, MBError>) -> Void
    typealias UpgradeTemporaryUserCompletion = (Result<Void, MBError>) -> Void
	typealias NormalizedProfileControlCompletion = (Result<NormalizedProfileControlModel, MBError>) -> Void
	typealias SetNormalizedProfileControlCompletion = (Result<Void, MBError>) -> Void
	
	// MARK: Dependencies
	private let networking: Networking
	private let tokenProviding: TokenProviding?
    private let localeProvider: LocaleProviding

	
	// MARK: - Init
	
	convenience init(networking: Networking) {
		self.init(networking: networking,
				  tokenProviding: nil,
                  localeProvider: MBLocaleProvider())
	}
	
	init(networking: Networking, tokenProviding: TokenProviding?, localeProvider: LocaleProviding) {
		
		self.networking = networking
		self.tokenProviding = tokenProviding
        self.localeProvider = localeProvider
	}
	
	
	// MARK: - Internal Interface

	/// Fetch the assigned users with basic information (Owner, Subuser)
	///
	/// - Parameters:
	///   - finOrVin: fin or vin of the vehicle
	///   - completion: Closure with consumption data of the vehicle
	func fetchVehicleAssignedUsers(finOrVin: String, completion: @escaping VehicleAssignedUserSucceeded) {

		let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
        
            switch result {
            case .success(let token):
                let router = BffUserManagementRouter.get(accessToken: token.accessToken,
                                                         vin: finOrVin,
                                                         locale: self.localeProvider.locale)

                self.networking.request(router: router) { (result: Result<APIVehicleUserManagementModel, MBError>) in

                    switch result {
                    case .failure(let error):
                        LOG.E(error.localizedDescription)

                        completion(.failure(error))

                    case .success(let apiVehicleUserManagement):
                        LOG.D(apiVehicleUserManagement)

                        completion(.success(apiVehicleUserManagement))
                    }
                }
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
	}

	func fetchInvitationQrCode(finOrVin: String, profileId: VehicleProfileID, completion: @escaping VehicleQrCodeInvitationCompletion) {

		let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
        
            switch result {
            case .success(let token):
                let router = BffUserManagementRouter.inviteQR(accessToken: token.accessToken, vin: finOrVin, profileId: profileId)

                self.networking.request(router: router) { (result: Result<Data, MBError>) in

                    switch result {
                    case .failure(let error):
                        LOG.E(error.localizedDescription)

                        completion(.failure(error))

                    case .success(let data):
                        LOG.D(data)

                        completion(.success(data))
                    }
                }
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
	}
    
	func removeUserAuthorization(finOrVin: String, authorizationID: String, completion: @escaping RemoveUserAuthorizationCompletion) {

        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
        
            switch result {
            case .success(let token):
                let router = BffUserManagementRouter.delete(accessToken: token.accessToken,
                                                            vin: finOrVin,
                                                            authorizationID: authorizationID)
                self.request(router: router, completion: completion)
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
    
	func setProfileSync(enabled: Bool, finOrVin: String, completion: @escaping SetProfileSyncCompletion) {

        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
        
            switch result {
            case .success(let token):
                let router = BffUserManagementRouter.setProfileSync(accessToken: token.accessToken,
                                                                    vin: finOrVin,
                                                                    enabled: enabled)
                self.request(router: router, completion: completion)
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
	
	func upgradeTemporaryUser(authorizationID: String, finOrVin: String, completion: @escaping UpgradeTemporaryUserCompletion) {

        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
        
            switch result {
            case .success(let token):
                let router = BffUserManagementRouter.upgradeTemporaryUser(accessToken: token.accessToken,
                                                                          authorizationID: authorizationID,
                                                                          finOrVin: finOrVin)
                self.request(router: router, completion: completion)
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
    
	func fetchNormalizedProfileControl(completion: @escaping NormalizedProfileControlCompletion) {
		
		let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
        
            switch result {
            case .success(let token):
                let router = BffUserManagementRouter.normalizedProfileControl(accessToken: token.accessToken)
                self.networking.request(router: router) { (result: Result<NormalizedProfileControlModel, MBError>) in
                    switch result {
                    case .failure(let error):
                        LOG.E(error.localizedDescription)
                        completion(.failure(error))
                        
                    case .success(let status):
                        completion(.success(status))
                    }
                }
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
	}
	
	func setNormalizedProfileControl(enabled: Bool, completion: @escaping SetNormalizedProfileControlCompletion) {
		
		let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
        
            switch result {
            case .success(let token):
                let router = BffUserManagementRouter.setNormalizedProfileControl(accessToken: token.accessToken,
                                                                                 enabled: enabled)
                self.request(router: router, completion: completion)
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
	}
	
	// MARK: - Helper
	
	private func request(router: BffUserManagementRouter, completion: @escaping (Result<Void, MBError>) -> Void) {
		
		self.networking.request(router: router) { (result: Result<Data, MBError>) in
			
			switch result {
			case .failure(let error):
				LOG.E(error.localizedDescription)
				
				completion(.failure(error))
				
			case .success:
				LOG.D()
				
				completion(.success(()))
			}
		}
	}
}
