//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit
import MBNetworkKit

public enum SpeedFenceServiceError: Error {
    case token
    case network(MBError?)
    case unknown
}

public class SpeedFenceService: SpeedFenceServiceRepresentable {
    
    // MARK: - Typealias
    
    /// Completion for fetch speedfence
    public typealias FetchSpeedfencesSucceeded = (Result<[SpeedFenceModel], SpeedFenceServiceError>) -> Void
    
    /// Completion for fetch speedfence
    public typealias FetchSpeedfenceViolationsSucceeded = (Result<[SpeedFenceViolationModel], SpeedFenceServiceError>) -> Void
    
    /// Completion for creeate speedfence
    public typealias CreateSpeedfenceSucceeded = (Result<Void, SpeedFenceServiceError>) -> Void
    
    /// Completion for delete all speedfences
    public typealias DeleteAllSpeedfencesSucceeded = (Result<Void, SpeedFenceServiceError>) -> Void
    
    /// Completion for delete speedfence
    public typealias DeleteSpeedfenceSucceeded = (Result<Void, SpeedFenceServiceError>) -> Void
    
    // MARK: Dependencies
    private let networking: Networking
    private let tokenProvider: TokenProviding?
    
    
    // MARK: - Init
    
    convenience init(networking: Networking) {
        self.init(networking: networking, tokenProvider: nil)
    }
    
    init(networking: Networking, tokenProvider: TokenProviding?) {
        self.networking = networking
        self.tokenProvider = tokenProvider
    }
    
    
    // MARK: - Public
    
    public func create(finOrVin: String, speedfences: [SpeedFenceRequestModel], completion: @escaping CreateSpeedfenceSucceeded) {
        
        let tokenProvider = self.tokenProvider ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            switch result {
            case .failure:
                completion(.failure(.token))
            case .success(let token):
                let encodable = NetworkModelMapper.map(speedfenceRequestModels: speedfences)
                let json = try? encodable.toJson()
                let router = BffSpeedFenceRouter.create(accessToken: token.accessToken,
                                                        finOrVin: finOrVin,
                                                        requestModel: json as? [[String: Any]])
                self.request(router: router, completion: completion)
            }
        }
    }
    
    public func deleteSpeedfences(finOrVin: String, speedfences: [Int]?, completion: @escaping DeleteAllSpeedfencesSucceeded) {
        
        let tokenProvider = self.tokenProvider ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            switch result {
            case .failure:
                completion(.failure(.token))
            case .success(let token):
                let json = try? speedfences?.toJson()
                let router = BffSpeedFenceRouter.deleteSpeedfences(accessToken: token.accessToken,
                                                                   finOrVin: finOrVin,
                                                                   requestModel: json as? [Int] ?? [])
                self.request(router: router, completion: completion)
            }
        }
    }
    
    public func deleteViolations(finOrVin: String, speedfences: [Int]?, completion: @escaping DeleteAllSpeedfencesSucceeded) {
        
        let tokenProvider = self.tokenProvider ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            switch result {
            case .failure:
                completion(.failure(.token))
            case .success(let token):
                let json = try? speedfences?.toJson()
                let router = BffSpeedFenceRouter.deleteViolations(accessToken: token.accessToken,
                                                                  finOrVin: finOrVin,
                                                                  requestModel: json as? [Int] ?? [])
                self.request(router: router, completion: completion)
            }
        }
    }
    
    public func fetchSpeedfences(finOrVin: String, unit: SpeedUnit, completion: @escaping FetchSpeedfencesSucceeded) {
        
        let tokenProvider = self.tokenProvider ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            switch result {
            case .failure:
                completion(.failure(.token))
            case .success(let token):
                let router = BffSpeedFenceRouter.getSpeedfences(accessToken: token.accessToken,
                                                                finOrVin: finOrVin,
                                                                unit: unit.queryString)
                self.networking.request(router: router, keyPath: "speedfences") { (result: Result<[APISpeedFenceModel], MBError>) in
                    
                    switch result {
                    case .failure(let error):
                        LOG.E(error.localizedDescription)
                        
                        completion(.failure(.network(error)))
                        
                    case .success(let model):
                        let resultModel = NetworkModelMapper.map(apiSpeedfenceModels: model)
                        completion(.success(resultModel))
                    }
                }
            }
        }
    }
    
    public func fetchViolations(finOrVin: String, unit: SpeedUnit, completion: @escaping FetchSpeedfenceViolationsSucceeded) {
        
        let tokenProvider = self.tokenProvider ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            switch result {
            case .failure:
                completion(.failure(.token))
            case .success(let token):
                let router = BffSpeedFenceRouter.getViolations(accessToken: token.accessToken,
                                                               finOrVin: finOrVin,
                                                               unit: unit.queryString)
                self.networking.request(router: router, keyPath: "violations") { (result: Result<[APISpeedFenceViolationModel], MBError>) in
                    
                    switch result {
                    case .failure(let error):
                        LOG.E(error.localizedDescription)
                        
                        completion(.failure(.network(error)))
                        
                    case .success(let model):
                        let resultModel = NetworkModelMapper.map(apiSpeedfenceViolationModels: model)
                        completion(.success(resultModel))
                    }
                }
            }
        }
    }
    
    public func update(finOrVin: String, speedfences: [SpeedFenceRequestModel], completion: @escaping CreateSpeedfenceSucceeded) {
        
        let tokenProvider = self.tokenProvider ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { (result) in
            switch result {
            case .failure:
                completion(.failure(.token))
            case .success(let token):
                let encodable = NetworkModelMapper.map(speedfenceRequestModels: speedfences)
                let json = try? encodable.toJson()
                let router = BffSpeedFenceRouter.update(accessToken: token.accessToken,
                                                        finOrVin: finOrVin,
                                                        requestModel: json as? [[String: Any]])
                self.request(router: router, completion: completion)
            }
        }
    }
    
    
    // MARK: - Helper
    
    private func request(router: BffSpeedFenceRouter, completion: @escaping (Result<Void, SpeedFenceServiceError>) -> Void) {
        
        self.networking.request(router: router) { (result: Result<Data, MBError>) in
            
            switch result {
            case .failure(let error):
                LOG.E(error.localizedDescription)
                
                completion(.failure(.network(error)))
                
            case .success:
                completion(.success(()))
            }
        }
    }
}
