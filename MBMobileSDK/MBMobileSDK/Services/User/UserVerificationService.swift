//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit
import MBNetworkKit

public protocol UserVerificationServiceRepresentable {
    func initiateUserVerificationTransaction(userVerificationTransaction: UserVerificationTransactionModel, completion: @escaping (Result<Void, UserVerificationServiceError>) -> Void)
    func confirmUserVerification(userVerificationConfirmationModel: UserVerificationConfirmationModel, completion: @escaping (Result<UserModel, UserVerificationServiceError>) -> Void)
}

public enum UserVerificationServiceError: Error {
    case tokenRefreshFailed
    case wrongConfirmationCode
    case identifierAlreadyTaken
    case networkError
    case invalidInputs(Any?)
    case unknown
}

public class UserVerificationService: UserVerificationServiceRepresentable {
    
    private let networking: Networking
    private let loginService: LoginServiceRepresentable
    private let userService: UserServiceRepresentable
    
    public convenience init() {
        self.init(networking: NetworkService())
    }
    
    
    init(networking: Networking,
         loginService: LoginServiceRepresentable = IngressKit.loginService,
         userService: UserServiceRepresentable = UserService()) {
        
        self.networking = networking
        self.loginService = loginService
        self.userService = userService
    }
    
    
    public func initiateUserVerificationTransaction(userVerificationTransaction: UserVerificationTransactionModel, completion: @escaping (Result<Void, UserVerificationServiceError>) -> Void) {
        
        self.loginService.refreshTokenIfNeeded { [weak self] (result) in
            switch result {
            case .failure:
                completion(.failure(.tokenRefreshFailed))
                
            case .success(let token):
                
                guard let json = try? userVerificationTransaction.toJson(),
                    let requestDict = json as? [String: Any] else {
                        completion(.failure(.invalidInputs(userVerificationTransaction)))
                        return
                }
                
                let router = BffVerificationRouter.transaction(accessToken: token.accessToken, dict: requestDict)
                
                self?.networking.request(router: router) { (result: Result<Data, MBError>) in
                    LOG.D(result)
                    switch result {
                    case .failure(let error):
                        let userVerificationServiceError = self?.handle(error: error) ?? .unknown
                        completion(.failure(userVerificationServiceError))
                    case .success:
                        completion(.success(()))
                    }
                }
            }
        }
    }
    
    public func confirmUserVerification(userVerificationConfirmationModel: UserVerificationConfirmationModel, completion: @escaping (Result<UserModel, UserVerificationServiceError>) -> Void) {
        
        self.loginService.refreshTokenIfNeeded { [weak self] (result) in
            switch result {
            case .failure:
                completion(.failure(.tokenRefreshFailed))
                
            case .success(let token):
                
                guard let json = try? userVerificationConfirmationModel.toJson(),
                    let requestDict = json as? [String: Any] else {
                        completion(.failure(.invalidInputs(userVerificationConfirmationModel)))
                        return
                }
                
                let router = BffVerificationRouter.verification(accessToken: token.accessToken, dict: requestDict)
                
                self?.networking.request(router: router) { (result: Result<Data, MBError>) in
                    LOG.D(result)
                    switch result {
                    case .failure(let error):
                        let userVerificationServiceError = self?.handle(error: error) ?? .unknown
                        completion(.failure(userVerificationServiceError))
                    case .success:
                        self?.userService.fetch { result in
                            switch result {
                            case .failure(let error):
                                let userVerificationServiceError = self?.handle(error: error) ?? .unknown
                                completion(.failure(userVerificationServiceError))
                            case .success(let model):
                                completion(.success(model))
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func handle(error: UserServiceError) -> UserVerificationServiceError {
        LOG.E("encountered error during user fetch after successful verification: \(error)")
        return .unknown
    }
    
    private func handle(error: MBError) -> UserVerificationServiceError {
        switch error.type {
        case .http(let httpError):
            switch httpError {
            case .forbidden, .notFound:
                return .wrongConfirmationCode
            case .conflict:
                return .identifierAlreadyTaken
            case .badRequest(data: _):
                return .invalidInputs(nil)
            default:
                return .networkError
            }
        default:
            return .networkError
        }
    }
}
