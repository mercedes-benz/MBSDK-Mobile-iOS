//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit
import MBNetworkKit


public class GeofencingViolationService: GeofencingViolationServiceRepresentable {
    
    // MARK: Typealias
    
    /// Completion for violations
    public typealias ViolationsResult = (Result<[ViolationModel], MBError>) -> Void

    /// Empty completion for delete one violation data
    public typealias DeleteViolationResult = (Result<Void, MBError>) -> Void
    
    /// Empty completion for delete all violations data
    public typealias DeleteAllViolationsResult = (Result<Void, MBError>) -> Void
    
    
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
    
    public func fetchGeofencingViolations(finOrVin: String, completion: @escaping ViolationsResult) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
        
            switch result {
            case .success(let token):
                let router = BffGeofencingViolationRouter.get(accessToken: token.accessToken, finOrVin: finOrVin)
                self.networking.request(router: router) { (result: Result<[APIViolation], MBError>) in
                    
                    switch result {
                    case .failure(let error):
                        LOG.E(error.localizedDescription)
                        
                        completion(.failure(error))
                        
                    case .success(let apiViolation):
                        LOG.D(apiViolation)
                        
                        let model = NetworkModelMapper.map(apiViolationModels: apiViolation)
                        completion(.success(model))
                    }
                }
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
    
    public func deleteGeofencingViolation(finOrVin: String, id: Int, completion: @escaping DeleteViolationResult) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
        
            switch result {
            case .success(let token):
                let router = BffGeofencingViolationRouter.deleteGeofencing(accessToken: token.accessToken,
                                                                                    finOrVin: finOrVin,
                                                                                    idParameter: id)
                self.request(router: router, completion: completion)
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
    
    public func deleteAllGeofencingViolations(finOrVin: String, completion: @escaping DeleteAllViolationsResult) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
        
            switch result {
            case .success(let token):
                let router = BffGeofencingViolationRouter.deleteAll(accessToken: token.accessToken,
                                                                                        finOrVin: finOrVin)
                self.request(router: router, completion: completion)
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
    
	
	// MARK: - Helper
	
	private func request(router: BffGeofencingViolationRouter, completion: @escaping (Result<Void, MBError>) -> Void) {
		
		self.networking.request(router: router) { (result: Result<Data, MBError>) in
			
			switch result {
			case .failure(let error):
				completion(.failure(error))
				
			case .success:
				completion(.success(()))
			}
		}
	}
}
