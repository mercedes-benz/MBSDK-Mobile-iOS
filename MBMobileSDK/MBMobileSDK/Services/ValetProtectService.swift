//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit
import MBNetworkKit

/// Service to call all vale protect data related requests
public class ValetProtectService: ValetProtectServiceRepresentable {

    // MARK: Typealias
    
    /// Completion for valet protect item
    public typealias ValetProtectResult = (Result<ValetProtectModel, MBError>) -> Void
    
    /// Empty completion for create vale protect data
    public typealias ValetProtectCreateCompletion = (Result<ValetProtectModel, MBError>) -> Void
    
    /// Empty completion for delete valet protect data
    public typealias ValetProtectDeleteCompletion = (Result<Void, MBError>) -> Void
	
    /// Completion for valet protect violations
    public typealias ValetProtectViolationsResult = (Result<[ValetProtectViolationModel], MBError>) -> Void

    /// Completion for valet protect violation
    public typealias ValetProtectViolationResult = (Result<ValetProtectViolationModel, MBError>) -> Void
    
    
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
    
    public func fetchValetProtectItem(finOrVin: String, unit: DistanceUnit, completion: @escaping ValetProtectResult) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let router = BffValetProtectRouter.getValetProtectItem(finOrVin: finOrVin,
                                                                       unit: unit.mapToString(),
                                                                       accessToken: token.accessToken)
                
                self.networking.request(router: router) { (result: Result<APIValetProtect, MBError>) in
                    
                    switch result {
                    case .failure(let error):
                        completion(.failure(error))
                        
                    case .success(let apiValetProtect):
                        LOG.D(apiValetProtect)
                        
                        let model = NetworkModelMapper.map(apiValetProtectModel: apiValetProtect)
                        completion(.success(model))
                    }
                }
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
    
    public func createValetProtectItem(_ requestModel: ValetProtectModel, finOrVin: String, completion: @escaping ValetProtectCreateCompletion) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let json        = try? requestModel.toJson()
                let requestDict = json as? [String: Any]
                let router = BffValetProtectRouter.createValetProtectItem(finOrVin: finOrVin,
                                                                          requestModel: requestDict,
                                                                          accessToken: token.accessToken)
                
                self.networking.request(router: router) { (result: Result<APIValetProtect, MBError>) in
                    
                    switch result {
                    case .failure(let error):
                        completion(.failure(error))
                        
                    case .success(let apiValetProtect):
                        LOG.D(apiValetProtect)
                        
                        let model = NetworkModelMapper.map(apiValetProtectModel: apiValetProtect)
                        completion(.success(model))
                    }
                }
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
    
    public func deleteValetProtectItem(finOrVin: String, completion: @escaping ValetProtectDeleteCompletion) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let router = BffValetProtectRouter.deleteValetProtectItem(finOrVin: finOrVin,
                                                                          accessToken: token.accessToken)
                self.request(router: router, completion: completion)
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
    
    public func fetchAllValetProtectViolations(finOrVin: String, unit: DistanceUnit, completion: @escaping ValetProtectViolationsResult) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let router = BffValetProtectRouter.getAllViolations(finOrVin: finOrVin,
                                                                    unit: unit.mapToString(),
                                                                    accessToken: token.accessToken)
                
                self.networking.request(router: router) { (result: Result<[APIValetProtectViolation], MBError>) in
                    
                    switch result {
                    case .failure(let error):
                        completion(.failure(error))

                    case .success(let apiValetProtectViolations):
                         let model = NetworkModelMapper.map(apiValetProtectViolationModels: apiValetProtectViolations)
                         completion(.success(model))
                    }
                }

                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
    
    public func deleteAllValetProtectViolations(finOrVin: String, completion: @escaping ValetProtectDeleteCompletion) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let router = BffValetProtectRouter.deleteAllViolations(finOrVin: finOrVin,
                                                                       accessToken: token.accessToken)
                self.request(router: router, completion: completion)
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
    
    public func fetchValetProtectViolation(id: String, finOrVin: String, unit: DistanceUnit, completion: @escaping ValetProtectViolationResult) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let router = BffValetProtectRouter.getViolation(finOrVin: finOrVin,
                                                                id: id,
                                                                unit: unit.mapToString(),
                                                                accessToken: token.accessToken)
                
                self.networking.request(router: router) { (result: Result<APIValetProtectViolation, MBError>) in
                    
                    switch result {
                    case .failure(let error):
                        completion(.failure(error))

                    case .success(let apiValetProtectViolation):
                         let model = NetworkModelMapper.map(apiValetProtectViolationModel: apiValetProtectViolation)
                         completion(.success(model))
                    }
                }
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
    
    public func deleteValetProtectViolation(id: String, finOrVin: String, completion: @escaping ValetProtectDeleteCompletion) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let router = BffValetProtectRouter.deleteViolation(finOrVin: finOrVin,
                                                                   id: id,
                                                                   accessToken: token.accessToken)
                self.request(router: router, completion: completion)
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
    
    
	// MARK: - Helper
	
	private func request(router: BffValetProtectRouter, completion: @escaping (Result<Void, MBError>) -> Void) {
		
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
