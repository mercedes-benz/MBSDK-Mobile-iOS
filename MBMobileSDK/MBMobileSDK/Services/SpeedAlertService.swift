//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit
import MBNetworkKit

public class SpeedAlertService: SpeedAlertServiceRepresentable {
    
    // MARK: Typealias
    
    /// Completion for speed alert violations
    public typealias SpeedAlertViolationsResult = (Result<[SpeedAlertViolationModel], MBError>) -> Void
    
    /// Empty completion for delete one speed alert violation data
    public typealias DeleteViolationCompletion = (Result<Void, MBError>) -> Void
    
    /// Empty completion for delete all speed alert violations data
    public typealias DeleteAllViolationsCompletion = (Result<Void, MBError>) -> Void
        
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
    
    public func fetchSpeedAlertViolations(finOrVin: String, unit: SpeedUnit, completion: @escaping SpeedAlertViolationsResult) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let router = BffSpeedAlertRouter.get(accessToken: token.accessToken,
                                                                            finOrVin: finOrVin,
                                                                            unit: unit.queryString)
                self.networking.request(router: router) { (result: Result<[APISpeedAlertViolation], MBError>) in
                    
                    switch result {
                    case .failure(let error):
                        LOG.E(error.localizedDescription)
                        
                        completion(.failure(error))
                        
                    case .success(let apiViolation):
                        LOG.D(apiViolation)
                        
                        let model = NetworkModelMapper.map(apiSpeedAlertViolationModels: apiViolation)
                        completion(.success(model))
                    }
                }
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
    
    public func deleteSpeedAlertViolation(finOrVin: String, id: Int, completion: @escaping DeleteViolationCompletion) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let router = BffSpeedAlertRouter.deleteSpeedAlert(accessToken: token.accessToken,
                                                                           finOrVin: finOrVin,
                                                                           idParameter: id)
                self.request(router: router, completion: completion)
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
    
    public func deleteAllSpeedAlertViolations(finOrVin: String, completion: @escaping DeleteAllViolationsCompletion) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let router = BffSpeedAlertRouter.deleteAll(accessToken: token.accessToken,
                                                                               finOrVin: finOrVin)
                self.request(router: router, completion: completion)
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
    
    
	// MARK: - Helper
	
	private func request(router: BffSpeedAlertRouter, completion: @escaping (Result<Void, MBError>) -> Void) {
		
		self.networking.request(router: router) { (result: Result<Data, MBError>) in
			
			switch result {
			case .failure(let error):
				LOG.E(error.localizedDescription)
				
				completion(.failure(error))
			
			case .success:
				completion(.success(()))
			}
		}
	}
}
