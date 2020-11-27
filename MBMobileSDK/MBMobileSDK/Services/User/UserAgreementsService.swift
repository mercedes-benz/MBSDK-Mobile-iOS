//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import MBNetworkKit
import MBCommonKit

public enum UserAgreementsServiceError: Error {
    
    case invalidInputs(Any?)
    case network(MBError)
    case token
}

public protocol UserAgreementsServiceRepresentable {
    typealias AgreementsOperationResult = (Result<AgreementsModel, UserAgreementsServiceError>) -> Void
    
    func fetchAgreementsForCurrentUser(completion: @escaping AgreementsOperationResult)
    func fetchAgreements(forCountryCode: String, locale: String, completion: @escaping AgreementsOperationResult)
    func checkAgreementsUpdateStatusForCurrentUser(completion: @escaping AgreementsOperationResult)
    
    func submitForCurrentUser(agreements: AgreementsSubmitModel, completion: @escaping (Result<AgreementsPartialContentModel?, UserAgreementsServiceError>) -> Void)
}

public class UserAgreementsService: UserAgreementsServiceRepresentable {
    
    private let tokenProviding: TokenProviding?
    private let userService: UserServiceRepresentable
    private let networking: Networking
    private let jsonConverter: JsonConvertible
    private let userRegionHelper: UserRegionHelping
    
    public convenience init() {
        self.init(tokenProviding: nil)
    }
    
    init(tokenProviding: TokenProviding?,
         userService: UserServiceRepresentable = UserService(),
         networking: Networking = NetworkService(),
         jsonConverter: JsonConvertible = JsonConverter(),
         userRegionHelper: UserRegionHelping = UserRegionHelper()) {
        
        self.tokenProviding = tokenProviding
        self.userService = userService
        self.networking = networking
        self.jsonConverter = jsonConverter
        self.userRegionHelper = userRegionHelper
    }
    
    public func fetchAgreementsForCurrentUser(completion: @escaping AgreementsOperationResult) {

        self.fetchAgreementsForCurrentUser(checkForNewVersions: false, completion: completion)
    }
    
    public func fetchAgreements(forCountryCode countryCode: String, locale: String, completion: @escaping AgreementsOperationResult) {
        
        let route = BffAgreementRouter.get(accessToken: nil,
                                           countryCode: countryCode,
                                           locale: locale,
                                           checkForNewVersions: false)
        
        self.performNetworkRequest(router: route) { (result: Result<APIAgreementsModel, UserAgreementsServiceError>) in
            switch result {
            case .success(let apiAgreements):
                let agreements = NetworkModelMapper.map(apiAgreementsModel: apiAgreements)
                completion(.success(agreements))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func checkAgreementsUpdateStatusForCurrentUser(completion: @escaping AgreementsOperationResult) {
        
        self.fetchAgreementsForCurrentUser(checkForNewVersions: true, completion: completion)
    }
    
    public func submitForCurrentUser(agreements: AgreementsSubmitModel, completion: @escaping (Result<AgreementsPartialContentModel?, UserAgreementsServiceError>) -> Void) {
        
        guard let agreementsPayload = self.jsonConverter.toJson(agreements) else {
            completion(.failure(.invalidInputs(agreements)))
            return
        }
        
        let locale = self.userRegionHelper.locale(for: self.userService.currentUser)
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { [weak self] result in

            switch result {
            case .success(let token):
                let router = BffAgreementRouter.update(accessToken: token.accessToken,
                                                       locale: locale,
                                                       requestModel: agreementsPayload)
                
                self?.networking.request(router: router) { (result: Result<APIAgreementsPartialContentModel?, MBError>) in
                    
                    switch result {
                    case .success(let partialContentModel):
                        if let model = partialContentModel {
                            completion(.success(NetworkModelMapper.map(apiAgreementsModel: model)))
                        } else {
                            completion(.success(nil))
                        }
                        
                    case .failure(let error):
                        completion(.failure(.network(error)))
                    }
                }
                
            case .failure:
                completion(.failure(.token))
            }
        }
    }
    
    private func fetchAgreementsForCurrentUser(checkForNewVersions: Bool, completion: @escaping AgreementsOperationResult) {

        self.performAgreementsFetch(completion: completion) { token in
            
            return BffAgreementRouter.get(accessToken: token.accessToken,
                                          countryCode: self.userRegionHelper.countryCode(for: self.userService.currentUser),
                                          locale: self.userRegionHelper.locale(for: self.userService.currentUser),
                                          checkForNewVersions: checkForNewVersions)
        }
    }
    
    private func performAgreementsFetch(completion: @escaping AgreementsOperationResult, routerBuilder: @escaping ((TokenConformable) -> EndpointRouter)) {

        self.performRouterOperation(routerBuilder: routerBuilder, completion: { (result: Result<APIAgreementsModel, UserAgreementsServiceError>) in

            switch result {
            case .success(let apiAgreements):
                let agreements = NetworkModelMapper.map(apiAgreementsModel: apiAgreements)
                completion(.success(agreements))

            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    private func performRouterOperation<T: Decodable>(routerBuilder: @escaping ((TokenConformable) -> EndpointRouter), completion: @escaping ((Result<T, UserAgreementsServiceError>) -> Void)) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { [weak self] result in

            switch result {
            case .success(let token):
                let router = routerBuilder(token)
                self?.performNetworkRequest(router: router, completion: completion)
                
            case .failure:
                completion(.failure(.token))
            }
        }
    }
    
    private func performNetworkRequest<T: Decodable>(router: EndpointRouter, completion: @escaping ((Result<T, UserAgreementsServiceError>) -> Void)) {
        
        self.networking.request(router: router) { (result: Result<T, MBError>) in
            
            switch result {
            case .success(let obj):
                completion(.success(obj))
                
            case .failure(let error):
                completion(.failure(.network(error)))
            }
        }
    }
}
