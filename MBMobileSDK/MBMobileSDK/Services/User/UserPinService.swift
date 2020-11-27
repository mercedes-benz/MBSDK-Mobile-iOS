//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import MBNetworkKit

public enum UserPinServiceError: Error {
    case pinIncorrect
    case pinBlocked
    case userRefreshDidFail(UserServiceError)
    
    case invalidInputs([String: Any]?)
    case network(MBError)
    case token(MBError)
}

public protocol UserPinServiceRepresentable {
    typealias PinOperationResult = ((Result<UserModel, UserPinServiceError>) -> Void)
    
    func updateBiometricAuthSettings(pinModel: PinValidationModel, completion: @escaping PinOperationResult)
    func change(currentPin: String, newPin: String, completion: @escaping PinOperationResult)
    func delete(pin: String, completion: @escaping PinOperationResult)
    func reset(completion: @escaping PinOperationResult)
    func set(newPin: String, completion: @escaping PinOperationResult)
}

extension UserPinServiceRepresentable {
    func updateBiometricAuthSettings(pinModel: PinValidationModel, completion: @escaping PinOperationResult) {}
    func change(currentPin: String, newPin: String, completion: @escaping PinOperationResult) {}
    func delete(pin: String, completion: @escaping PinOperationResult) {}
    func reset(completion: @escaping PinOperationResult) {}
    func set(newPin: String, completion: @escaping PinOperationResult) {}
}

public class UserPinService: UserPinServiceRepresentable {
    
    private let loginService: LoginServiceRepresentable
    private let userService: UserServiceRepresentable
    private let networking: Networking
    private let jsonConverter: JsonConvertible
    
    public convenience init() {
        self.init(loginService: IngressKit.loginService,
                  userService: UserService(),
                  networking: NetworkService(),
                  jsonConverter: JsonConverter())
    }
    
    init(loginService: LoginServiceRepresentable,
         userService: UserServiceRepresentable,
         networking: Networking,
         jsonConverter: JsonConvertible) {
        
        self.loginService = loginService
        self.userService = userService
        self.networking = networking
        self.jsonConverter = jsonConverter
    }
    
    public func updateBiometricAuthSettings(pinModel: PinValidationModel, completion: @escaping PinOperationResult) {
        
        self.performPinOperation(completion) { token in
            BffUserRouter.biometric(accessToken: token.accessToken, dict: pinModel.parameters)
        }
    }
        
    public func change(currentPin: String, newPin: String, completion: @escaping PinOperationResult) {
        
        let pinModel = PinModel(currentPin: currentPin, newPin: newPin)
        guard let pinPayload = self.jsonConverter.toJson(pinModel) else {
            completion(.failure(.invalidInputs(["currentPin": currentPin, "newPin": newPin])))
            return
        }
        
        self.performPinOperation(completion) { token in
            BffPinRouter.change(accessToken: token.accessToken, dict: pinPayload)
        }
    }
    
    public func delete(pin: String, completion: @escaping PinOperationResult) {
        
        self.performPinOperation(completion) { token in
            BffPinRouter.delete(accessToken: token.accessToken, pin: pin)
        }
    }
    
    public func reset(completion: @escaping PinOperationResult) {
        
        self.performPinOperation(completion) { token in
            BffPinRouter.reset(accessToken: token.accessToken)
        }
    }
    
    public func set(newPin: String, completion: @escaping PinOperationResult) {
        
        let pinModel = PinModel(currentPin: nil, newPin: newPin)
        guard let pinPayload = self.jsonConverter.toJson(pinModel) else {
            completion(.failure(.invalidInputs(["newPin": newPin])))
            return
        }
        
        self.performPinOperation(completion) { token in
            BffPinRouter.set(accessToken: token.accessToken, dict: pinPayload)
        }
    }
    
    private func performPinOperation(_ completion: @escaping PinOperationResult, routerBuilder: @escaping ((Token) -> EndpointRouter) ) {
        
        self.loginService.refreshTokenIfNeeded { [weak self] result in

            switch result {
            case .success(let token):
                let router = routerBuilder(token)
                self?.performPinRequest(router: router) { [weak self] pinRequestResult in
                    self?.handlePinRequestSuccess(pinRequestResult, completion: completion)
                }
                
            case .failure(let error):
                completion(.failure(.token(error)))
            }
        }
    }
    
    private func handlePinRequestSuccess(_ result: Result<Void, UserPinServiceError>, completion: @escaping PinOperationResult) {
        switch result {
        case .success:
            // refetch the user with its new pin properties
            self.userService.fetch { result in
                switch result {
                case .success(let user):
                    completion(.success(user))
                    
                case .failure(let userServiceError):
                    completion(.failure(.userRefreshDidFail(userServiceError)))
                }
            }
            
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    private func performPinRequest(router: EndpointRouter, completion: @escaping (Result<Void, UserPinServiceError>) -> Void) {
        
        self.networking.request(router: router) { (result: Result<Void, MBError>) in

            switch result {
            case .failure(let error):
                switch error.type {
                case .http(let httpError):
                    if httpError == .forbidden(data: nil) {
                        completion(.failure(.pinIncorrect))
                    } else if httpError == .tooManyRequests(data: httpError.data) {
                        completion(.failure(.pinBlocked))
                    } else {
                        completion(.failure(.network(error)))
                    }

                case .specificError,
                     .network,
                     .unknown:
                    completion(.failure(.network(error)))
                }

            case .success:
                completion(.success(()))
            }
        }
    }
}
