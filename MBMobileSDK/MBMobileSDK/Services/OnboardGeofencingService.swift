//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import MBNetworkKit
import MBCommonKit

public enum OnboardGeofencingError: Error {
    case network
    case commandInProgress
    case invalidInputs(Any?)
    case tokenRefreshFailed
    case unknown
}

public class OnboardGeofencingService: OnboardGeofencingServiceRepresentable {
    
    private let networking: Networking
    private let loginService: LoginServiceRepresentable
    
    public convenience init() {
        self.init(networking: NetworkService())
    }
    
    
    init(networking: Networking,
         loginService: LoginServiceRepresentable = IngressKit.loginService) {
        
        self.networking = networking
        self.loginService = loginService
    }
    
    public func fetchCustomerFences(finOrVin: String, completion: @escaping (Result<[CustomerFenceModel], OnboardGeofencingError>) -> Void) {
        
        self.performRouterOperation(routerBuilder: { (token) -> EndpointRouter in
            BffOnboardGeofencingRouter.getCustomerFences(accessToken: token.accessToken, finOrVin: finOrVin)
        }, completion: { (result: Result<[APICustomerFenceModel], OnboardGeofencingError>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let apiModel):
                let model = NetworkModelMapper.map(apiCustomerFenceModel: apiModel)
                completion(.success(model))
            }
        })
    }
    
    public func createCustomerFences(finOrVin: String, customerFences: [CustomerFenceModel], completion: @escaping (Result<Void, OnboardGeofencingError>) -> Void) {
        
        let apiModel = NetworkModelMapper.map(customerFenceModel: customerFences)
        
        guard let json = try? apiModel.toJson(),
              let requestDict = json as? [[String: Any]] else {
            completion(.failure(.invalidInputs(customerFences)))
            return
        }
        
        self.performRouterOperation(routerBuilder: { (token) -> EndpointRouter in
            BffOnboardGeofencingRouter.createCustomerFences(accessToken: token.accessToken,
                                                                         finOrVin: finOrVin,
                                                                         requestModel: requestDict)
        }, completion: completion)
    }
    
    public func updateCustomerFences(finOrVin: String, customerFences: [CustomerFenceModel], completion: @escaping (Result<Void, OnboardGeofencingError>) -> Void) {
        
        let apiModel = NetworkModelMapper.map(customerFenceModel: customerFences)
        
        guard let json = try? apiModel.toJson(),
              let requestDict = json as? [[String: Any]] else {
            completion(.failure(.invalidInputs(customerFences)))
            return
        }
        
        self.performRouterOperation(routerBuilder: { (token) -> EndpointRouter in
            BffOnboardGeofencingRouter.updateCustomerFences(accessToken: token.accessToken,
                                                                         finOrVin: finOrVin,
                                                                         requestModel: requestDict)
        }, completion: completion)
    }
    
    public func deleteCustomerFences(finOrVin: String, ids: [Int], completion: @escaping (Result<Void, OnboardGeofencingError>) -> Void) {
        
        guard let json = try? ids.toJson(),
              let requestDict = json as? [Int] else {
            completion(.failure(.invalidInputs(ids)))
            return
        }
        
        self.performRouterOperation(routerBuilder: { (token) -> EndpointRouter in
            BffOnboardGeofencingRouter.deleteCustomerFences(accessToken: token.accessToken,
                                                                         finOrVin: finOrVin,
                                                                         requestModel: requestDict)
        }, completion: completion)
    }
    
    public func fetchCustomerFenceViolations(finOrVin: String, completion: @escaping (Result<[CustomerFenceViolationModel], OnboardGeofencingError>) -> Void) {
        
        self.performRouterOperation(routerBuilder: { (token) -> EndpointRouter in
            BffOnboardGeofencingRouter.getCustomerFencesViolations(accessToken: token.accessToken,
                                                                                finOrVin: finOrVin)
        }, completion: { (result: Result<[APICustomerFenceViolationModel], OnboardGeofencingError>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let apiModel):
                let model = NetworkModelMapper.map(apiCustomerFenceViolationModel: apiModel)
                completion(.success(model))
            }
        })
    }
    
    public func deleteCustomerFenceViolations(finOrVin: String, ids: [Int], completion: @escaping (Result<Void, OnboardGeofencingError>) -> Void) {
        
        guard let json = try? ids.toJson(),
              let requestDict = json as? [Int] else {
            completion(.failure(.invalidInputs(ids)))
            return
        }
        
        self.performRouterOperation(routerBuilder: { (token) -> EndpointRouter in
            BffOnboardGeofencingRouter.deleteCustomerFencesViolations(accessToken: token.accessToken,
                                                                                   finOrVin: finOrVin,
                                                                                   requestModel: requestDict)
        }, completion: completion)
    }
    
    public func fetchOnboardFences(finOrVin: String, completion: @escaping (Result<[OnboardFenceModel], OnboardGeofencingError>) -> Void) {
        
        self.performRouterOperation(routerBuilder: { (token) -> EndpointRouter in
            BffOnboardGeofencingRouter.getOnboardFences(accessToken: token.accessToken,
                                                        finOrVin: finOrVin)
        }, completion: { (result: Result<[APIOnboardFenceModel], OnboardGeofencingError>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let apiModel):
                let model = NetworkModelMapper.map(apiOnboardFenceModel: apiModel)
                completion(.success(model))
            }
        })
    }
    
    public func createOnboardFences(finOrVin: String, onboardFences: [OnboardFenceModel], completion: @escaping (Result<Void, OnboardGeofencingError>) -> Void) {
        
        let apiModel = NetworkModelMapper.map(onboardFenceModel: onboardFences)
        
        guard let json = try? apiModel.toJson(),
              let requestDict = json as? [[String: Any]] else {
            completion(.failure(.invalidInputs(onboardFences)))
            return
        }
        
        self.performRouterOperation(routerBuilder: { (token) -> EndpointRouter in
            BffOnboardGeofencingRouter.createOnboardFences(accessToken: token.accessToken,
                                                                               finOrVin: finOrVin,
                                                                               requestModel: requestDict)
        }, completion: completion)
    }
    
    public func updateOnboardFences(finOrVin: String, onboardFences: [OnboardFenceModel], completion: @escaping (Result<Void, OnboardGeofencingError>) -> Void) {
        
        let apiModel = NetworkModelMapper.map(onboardFenceModel: onboardFences)
        
        guard let json = try? apiModel.toJson(),
              let requestDict = json as? [[String: Any]] else {
            completion(.failure(.invalidInputs(onboardFences)))
            return
        }
        
        self.performRouterOperation(routerBuilder: { (token) -> EndpointRouter in
            BffOnboardGeofencingRouter.updateOnboardFences(accessToken: token.accessToken,
                                                                          finOrVin: finOrVin,
                                                                          requestModel: requestDict)
        }, completion: completion)
    }
    
    public func deleteOnboardFences(finOrVin: String, ids: [Int], completion: @escaping (Result<Void, OnboardGeofencingError>) -> Void) {
        
        guard let json = try? ids.toJson(),
              let requestDict = json as? [Int] else {
            completion(.failure(.invalidInputs(ids)))
            return
        }
        
        self.performRouterOperation(routerBuilder: { (token) -> EndpointRouter in
            BffOnboardGeofencingRouter.deleteOnboardFences(accessToken: token.accessToken,
                                                                          finOrVin: finOrVin,
                                                                          requestModel: requestDict)
        }, completion: completion)
    }
    
    // MARK: - Helpers
    
    private func performRouterOperation(routerBuilder: @escaping ((TokenConformable) -> EndpointRouter), completion: @escaping  (Result<Void, OnboardGeofencingError>) -> Void) {
        
        self.loginService.refreshTokenIfNeeded { [weak self] result in
            switch result {
            case .success(let token):
                let router = routerBuilder(token)
                self?.performRouterRequest(router: router, completion: completion)
            case .failure:
                completion(.failure(.tokenRefreshFailed))
            }
        }
    }
    
    private func performRouterRequest(router: EndpointRouter, completion: @escaping (Result<Void, OnboardGeofencingError>) -> Void) {
        
        self.networking.request(router: router) { (result: Result<Void, MBError>) in
            
            switch result {
            case .failure(let error):
                let error = self.handle(error: error)
                completion(.failure(error))
            case .success:
                completion(.success(()))
            }
        }
    }
    
    private func performRouterOperation<T: Decodable>(routerBuilder: @escaping ((TokenConformable) -> EndpointRouter), completion: @escaping ((Result<T, OnboardGeofencingError>) -> Void)) {
        self.loginService.refreshTokenIfNeeded { [weak self] result in
            switch result {
            case .failure:
                completion(.failure(.tokenRefreshFailed))
            case .success(let token):
                let router = routerBuilder(token)
                self?.performNetworkRequest(router: router, completion: completion)
            }
        }
    }
    
    private func performNetworkRequest<T: Decodable>(router: EndpointRouter, completion: @escaping ((Result<T, OnboardGeofencingError>) -> Void)) {
        
        self.networking.request(router: router) { (result: Result<T, MBError>) in
            switch result {
            case .failure(let error):
                let error = self.handle(error: error)
                completion(.failure(error))
            case .success(let model):
                completion(.success(model))
            }
        }
    }
    
    private func handle(error: MBError) -> OnboardGeofencingError {
        switch error.type {
        case .http(let httpError):
            switch httpError {
            case .badRequest(data: _):
                return .invalidInputs(nil)
            case .locked(data: _):
                return .commandInProgress
            default:
                return .network
            }
        default:
            return .network
        }
    }
}
