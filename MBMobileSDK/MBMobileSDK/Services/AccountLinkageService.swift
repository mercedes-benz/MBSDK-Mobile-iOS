//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit
import MBNetworkKit

public class AccountLinkageService: AccountLinkageServiceRepresentable {
	
	/// Completion for account linkage request
	public typealias AccountLinkageDataResult = (Result<[AccountLinkageModel], MBError>) -> Void
	
	/// Completion for account linkage request 204
    public typealias AccountLinkageResult = (Result<Void, MBError>) -> Void
	
	// MARK: Dependencies
	private let networking: Networking
	private let tokenProviding: TokenProviding?
	
	
	// MARK: - Init
	
	convenience init(networking: Networking) {
		self.init(networking: networking,
				  tokenProviding: nil)
	}
	
	init(networking: Networking, tokenProviding: TokenProviding?) {
		
		self.networking = networking
		self.tokenProviding = tokenProviding
	}
	
	
    // MARK: - Public
	
	public func deleteAccount(finOrVin: String, accountType: AccountType, vendorId: String, completion: @escaping AccountLinkageResult) {
		
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let router = BffAccountLinkageRouter.delete(accessToken: token.accessToken,
                                                            finOrVin: finOrVin,
                                                            accountType: accountType.rawValue,
                                                            vendorId: vendorId)
                
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
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
	}
	
	public func fetchAccounts(finOrVin: String, serviceIds: [Int]?, redirectURL: String?, completion: @escaping AccountLinkageDataResult) {
		
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let router = BffAccountLinkageRouter.get(accessToken: token.accessToken,
                                                         finOrVin: finOrVin,
                                                         serviceIds: serviceIds,
                                                         redirectUrl: redirectURL)
                
                self.networking.request(router: router, keyPath: "accountTypes") { (result: Result<[APIAccountLinkageModel], MBError>) in
                    
                    switch result {
                    case .failure(let error):
                        LOG.E(error.localizedDescription)
                        
                        completion(.failure(error))
                        
                    case .success(let apiAccountLinkages):
                        LOG.D(apiAccountLinkages)
                        
                        let models = NetworkModelMapper.map(apiAccountLinkages)
                        completion(.success(models))
                    }
                }
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
	}
	
	public func sendConsent(finOrVin: String, accountType: AccountType, vendorId: String, completion: @escaping AccountLinkageResult) {
		
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let router = BffAccountLinkageRouter.consent(accessToken: token.accessToken,
                                                             finOrVin: finOrVin,
                                                             accountType: accountType.rawValue,
                                                             vendorId: vendorId)
                
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
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
	}
}
