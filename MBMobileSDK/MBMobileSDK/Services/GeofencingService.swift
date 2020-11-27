//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit
import MBNetworkKit

public class GeofencingService: GeofencingServiceRepresentable {
    
    // MARK: Typealias
    
    /// Completion for geofences
    public typealias GeofencesResult = (Result<[GeofenceModel], MBError>) -> Void
    
    /// Completion for geofence
    public typealias GeofenceResult = (Result<GeofenceModel, MBError>) -> Void
    
    /// Empty completion for create geofence data
    public typealias CreateGeofenceResult = (Result<Void, MBError>) -> Void
    
    /// Empty completion for update geofence data
    public typealias UpdateGeofenceResult = (Result<Void, MBError>) -> Void
    
    /// Empty completion for delete geofence data
    public typealias DeleteGeofenceResult = (Result<Void, MBError>) -> Void
    
    
    typealias GeofenceAPIResult = NetworkResult<APIGeofence>
    
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
    public func fetchGeofences(finOrVin: String, completion: @escaping GeofencesResult) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let router = BffGeofencingRouter.getGeofences(accessToken: token.accessToken,
                                                              finOrVin: finOrVin)
                self.networking.request(router: router) { (result: Result<[APIGeofence], MBError>) in
                    
                    switch result {
                    case .failure(let error):
                        completion(.failure(error))
                        
                    case .success(let apiGeofence):
                        let model = NetworkModelMapper.map(apiGeofenceModels: apiGeofence)
                        completion(.success(model))
                    }
                }
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
    
    public func createGeofence(finOrVin: String, geofence: GeofenceModel, completion: @escaping CreateGeofenceResult) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let bodyDictParams = geofence.params()
                let router = BffGeofencingRouter.createGeofence(accessToken: token.accessToken,
                                                                finOrVin: finOrVin,
                                                                requestModel: bodyDictParams)
                self.request(router: router, completion: completion)
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
	
    public func fetchGeofence(id: Int, completion: @escaping GeofenceResult) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let router = BffGeofencingRouter.getGeofence(accessToken: token.accessToken,
                                                             idParameter: id)
                self.networking.request(router: router) { (result: Result<APIGeofence, MBError>) in
                    
                    switch result {
                    case .failure(let error):
                        LOG.E(error.localizedDescription)
                        
                        completion(.failure(error))
                        
                    case .success(let apiGeofence):
                        LOG.D(apiGeofence)
                        
                        let model = NetworkModelMapper.map(apiGeofenceModel: apiGeofence)
                        completion(.success(model))
                    }
                }
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
    
    public func updateGeofence(id: Int, geofence: GeofenceModel, completion: @escaping UpdateGeofenceResult) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let bodyDictParams = geofence.params()
                let router = BffGeofencingRouter.updateGeofence(accessToken: token.accessToken,
                                                                idParameter: id,
                                                                requestModel: bodyDictParams)
                self.request(router: router, completion: completion)
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
    
    public func deleteGeofence(id: Int, completion: @escaping DeleteGeofenceResult) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let router = BffGeofencingRouter.deleteGeofence(accessToken: token.accessToken,
                                                                idParameter: id)
                self.request(router: router, completion: completion)
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
    
    public func activateGeofenceForVehicle(id: Int, finOrVin: String, completion: @escaping UpdateGeofenceResult) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let router = BffGeofencingRouter.activateGeofencingForVehicle(accessToken: token.accessToken,
                                                                              finOrVin: finOrVin,
                                                                              idParameter: id)
                self.request(router: router, completion: completion)
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
    
    public func deleteGeofenceForVehicle(id: Int, finOrVin: String, completion: @escaping DeleteGeofenceResult) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            
            switch result {
            case .success(let token):
                let router = BffGeofencingRouter.deleteGeofenceForVehicle(accessToken: token.accessToken,
                                                                          finOrVin: finOrVin,
                                                                          idParameter: id)
                self.request(router: router, completion: completion)
                
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
    
	
	// MARK: - Helper
	
	private func request(router: BffGeofencingRouter, completion: @escaping (Result<Void, MBError>) -> Void) {
		
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
