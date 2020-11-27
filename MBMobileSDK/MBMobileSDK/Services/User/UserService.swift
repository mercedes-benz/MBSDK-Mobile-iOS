//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import UIKit
import MBCommonKit
import MBNetworkKit

public enum UserServiceError: Error {
    case savingUserToStore
    case fetchingUserFromStore
    case deletingUserFromStore
    case savingTokenToStore
    case userAlreadyRegistered
    case registration(RegistrationError)
    case toasNotReached
    case encoding(Encodable)
    case imageEncoding
    case network(MBError?)
    case token
}

public protocol UserServiceRepresentable {
    typealias UserOperationEmptyResult = ((Result<Void, UserServiceError>) -> Void)
    
    /// The cached user from DB
    var currentUser: UserModel? { get }
    
    /// Fetches the user currently logged in from bff and saves it into DB
    func fetch(completion: @escaping (Result<UserModel, UserServiceError>) -> Void)
    
    /// Deletes the current user from bff and DB
    ///
    /// If delete from bff fails, user remains in DB.
    func delete(completion: @escaping (Result<Void, UserServiceError>) -> Void)
    
    /// Creates a new user at bff and saves it into Realm cache
    func create(user: UserModel, completion: @escaping (Result<RegistrationUserModel, UserServiceError>) -> Void)
    
    /// Updates the user at bff and in DB.
    ///
    /// If update at bff fails, user will not be updated locally as well.
    func update(user: UserModel, completion: @escaping (Result<UserModel, UserServiceError>) -> Void)
    
    /// Updates the unit preferences of a user at bff and in DB
    ///
    /// If update at bff fails, user will not be updated locally as well.
    func update(unitPreference: UserUnitPreferenceModel, completion: @escaping (Result<UserModel, UserServiceError>) -> Void)
    
    /// Updates the adaption values of a user at bff and in DB
    ///
    /// If update at bff fails, user will not be updated locally as well.
    func update(adaptionValues: UserAdaptionValuesModel, completion: @escaping (Result<UserModel, UserServiceError>) -> Void)
    
    /// Uploads a new profile image to bff and stores it locally
    ///
    /// If upload to bff fails, user will not be updated locally as well.
    func upload(profileImageData: Data, completion: @escaping (Result<Void, UserServiceError>) -> Void)
    
    /// Fetches the profile image of the current user from bff and stores it locally
    ///
    /// If fetch from bff fails, image will not be updated locally as well. HTTP caching is enabled
    func fetchProfileImage(completion: @escaping (Result<UIImage?, UserServiceError>) -> Void)
    
    /// Registers a scanReference (uuid) for the current user
    func register(scanReference: String, completion: @escaping (Result<Void, UserServiceError>) -> Void)
}

extension UserServiceRepresentable {
    func fetch(completion: @escaping (Result<UserModel, UserServiceError>) -> Void) {}
    func delete(completion: @escaping (Result<Void, UserServiceError>) -> Void) {}
    func create(user: UserModel, completion: @escaping (Result<RegistrationUserModel, UserServiceError>) -> Void) {}
    
    func update(user: UserModel, completion: @escaping (Result<UserModel, UserServiceError>) -> Void) {}
    func update(unitPreference: UserUnitPreferenceModel, completion: @escaping (Result<UserModel, UserServiceError>) -> Void) {}
    func update(adaptionValues: UserAdaptionValuesModel, completion: @escaping (Result<UserModel, UserServiceError>) -> Void) {}
    
    func upload(profileImageData: Data, completion: @escaping (Result<Void, UserServiceError>) -> Void) {}
    func fetchProfileImage(completion: @escaping (Result<UIImage?, UserServiceError>) -> Void) {}
    
    // ????
    func register(scanReference: String, completion: @escaping (Result<Void, UserServiceError>) -> Void) {}
}

// swiftlint:disable type_body_length
public class UserService: UserServiceRepresentable {
    
    public var currentUser: UserModel? {
        return self.dbStore.currentUser
    }
    
    private let dbStore: UserDbStoreRepresentable
    private let tokenProviding: TokenProviding?
    private let tokenStore: TokenStore
    private let networking: Networking & NetworkingImage & NetworkingUpload
    private let notificationSending: NotificationSending
    private let jsonConverter: JsonConvertible
    private let nonceStore: NonceRepository
    private let nonceHelper: NonceHelping
    
    // property injected dependency
    internal var loginService: LoginServiceRepresentable?
    
    public convenience init() {
        self.init(networking: NetworkService())
    }
    
    init(
        dbStore: UserDbStoreRepresentable = UserDbStore(),
        tokenProviding: TokenProviding = TokenProvider(),
        tokenStore: TokenStore = KeychainTokenStoreFactory().build(),
        networking: Networking & NetworkingImage & NetworkingUpload,
        notificationSending: NotificationSending = NotificationHelper(),
        jsonConverter: JsonConvertible = JsonConverter(),
        nonceStore: NonceRepository = NonceStore(),
        nonceHelper: NonceHelping = NonceHelper()) {
        
        self.dbStore = dbStore
        self.tokenProviding = tokenProviding
        self.networking = networking
        self.tokenStore = tokenStore
        self.notificationSending = notificationSending
        self.jsonConverter = jsonConverter
        self.nonceStore = nonceStore
        self.nonceHelper = nonceHelper
    }
    
    public func fetch(completion: @escaping (Result<UserModel, UserServiceError>) -> Void) {
        
        self.performRouterOperation(routerBuilder: { token in
            return BffUserRouter.get(accessToken: token.accessToken)
        }, completion: { [weak self] (result: Result<APIUserModel, UserServiceError>) in
            
            LOG.D(result)
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let apiUser):
                LOG.D(apiUser)
                
                var user = NetworkModelMapper.map(apiUser: apiUser)
                let currentUser = self?.currentUser
                
                if currentUser?.ciamId == user.ciamId {
                    user.profileImageData = currentUser?.profileImageData
                    user.profileImageEtag = currentUser?.profileImageEtag
                    // swiftlint:disable line_length
                    LOG.D("Migrated profileImageData \(String(describing: user.profileImageData)) and eTag \(String(describing: user.profileImageEtag)) from currentUser: \(String(describing: currentUser))")
                    // swiftlint:enable line_length
                }
                
                self?.dbStore.save(user: user) { result in
                    switch result {
                    case .failure:
                        completion(.failure(.savingUserToStore))
                    case .success(let userModel):
                        self?.sendRegionLanguageChangeNotificationIfNeeded(oldUser: currentUser, newUser: user)
                        
                        completion(.success(userModel))
                    }
                }
            }
        })
    }
    
    public func delete(completion: @escaping (Result<Void, UserServiceError>) -> Void) {
        
        self.performRouterOperation(routerBuilder: { token in
            BffUserRouter.delete(accessToken: token.accessToken)
        }, completion: { [weak self] result in
            
            switch result {
            case .success:
                
                self?.dbStore.deleteCurrentUser(completion: { result in
                    switch result {
                    case .failure:
                        LOG.E("Deleting user from bff succeeded but deleting local user failed")
                        completion(.failure(.deletingUserFromStore))
                    case .success:
                        
                        if self?.tokenStore.save(nil) == true {
                            completion(.success(()))
                        } else {
                            LOG.E("Deleting user succeeded but deleting token from keychain failed")
                            completion(.failure(.savingTokenToStore))
                        }
                    }
                })
            case .failure:
                completion(result)
            }
        })
    }
    
    public func create(user: UserModel, completion: @escaping (Result<RegistrationUserModel, UserServiceError>) -> Void) {
        
        let nonce = self.nonceHelper.getNonce()
        self.nonceStore.save(nonce: nonce)
        
        let apiUser = NetworkModelMapper.map(user: user, nonce: nonce)
        guard let json = jsonConverter.toJson(apiUser) else {
            
            completion(.failure(.encoding(apiUser)))
            return
        }
        
        let router = BffUserRouter.create(countryCode: user.accountCountryCode,
                                          locale: user.preferredLanguageCode,
                                          dict: json,
                                          authType: self.loginService?.authenticationType ?? IngressKit.preferredAuthenticationType)
        
        self.networking.request(router: router) { (result: Result<APIRegistrationUserModel, MBError>) in
            
            switch result {
            case .failure(let error):
                LOG.E(error.localizedDescription)
                switch error.type {
                    
                case .http(let httpError):
					switch httpError {
					case .conflict(data: _):
						completion(.failure(.network(MBError(description: nil, type: .http(httpError)))))
					case .badGateway(data: _):
						completion(.failure(.toasNotReached))
					default:
						if let data = httpError.data,
                            let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                            
                            let registrationError = NetworkModelMapper.map(apiError: apiError)
                            completion(.failure(.registration(registrationError)))
                        } else {
                            
                            let registrationError = NetworkModelMapper.map(apiError: error)
                            completion(.failure(.registration(registrationError)))
                        }
					}
                    
                case .specificError,
                     .network,
                     .unknown:
                    
                    let registrationError = NetworkModelMapper.map(apiError: error)
                    completion(.failure(.registration(registrationError)))
                }
                
            case .success(let apiRegistrationUser):
                
                LOG.D(apiRegistrationUser)
                let registerUserModel = NetworkModelMapper.map(apiRegistrationUser: apiRegistrationUser)
                completion(.success(registerUserModel))
            }
        }
    }
    
    public func update(user: UserModel, completion: @escaping (Result<UserModel, UserServiceError>) -> Void) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { [weak self] tokenResult in
            
            switch tokenResult {
                
            case .failure:
                completion(.failure(.token))
            case .success(let token):
                
                let apiUser = NetworkModelMapper.map(user: user, nonce: self?.nonceStore.nonce())
                guard let json = self?.jsonConverter.toJson(apiUser) else {
                    return
                }
                
                let router = BffUserRouter.update(accessToken: token.accessToken, dict: json)
                self?.networking.request(router: router) { (result: Result<Data, MBError>) in
                    
                    switch result {
                    case .failure(let error):
                        
                        LOG.E(error.localizedDescription)
                        
                        switch error.type {
                        case .http(let httpError):
                            
                            if let data = httpError.data,
                                let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                                
                                let registrationError = NetworkModelMapper.map(apiError: apiError)
                                completion(.failure(.registration(registrationError)))
                            } else {
                                
                                let registrationError = NetworkModelMapper.map(apiError: error)
                                completion(.failure(.registration(registrationError)))
                            }
                            
                        case .network,
                             .specificError,
                             .unknown:
                            
                            let registrationError = NetworkModelMapper.map(apiError: error)
                            completion(.failure(.registration(registrationError)))
                        }
                        
                    case .success:
                        
                        self?.dbStore.save(user: user, completion: { result in
                            
                            switch result {
                            case .failure:
                                completion(.failure(.savingUserToStore))
                            case .success(let user):
                                
                                LOG.D("update succeeded")
                                completion(.success(user))
                            }
                        })
                    }
                }
            }
        }
    }
    
    public func update(unitPreference: UserUnitPreferenceModel, completion: @escaping (Result<UserModel, UserServiceError>) -> Void) {
        
        let apiUserUnitPreference = NetworkModelMapper.map(preference: unitPreference)
        guard let json = jsonConverter.toJson(apiUserUnitPreference) else {
            return
        }
        
        self.performRouterOperation(routerBuilder: { token in
            BffUserRouter.updateUnitPreferences(accessToken: token.accessToken, dict: json)
        }, completion: { [weak self] (result: Result<Void, UserServiceError>) in
            
            LOG.D(result)
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success:
                
                guard var user = self?.dbStore.currentUser else {
                    LOG.E("Could not fetch current user to update values. Aborting")
                    // state mismatch between client and server for user preferences. How to recover?
                    // Fetching user here again? Probably not necessary since next time fetching user he will have correct preferences
                    completion(.failure(.fetchingUserFromStore))
                    return
                }
                
                user.unitPreferences = unitPreference
                
                self?.dbStore.save(user: user, completion: { result in
                    
                    switch result {
                    case .failure:
                        completion(.failure(.savingUserToStore))
                    case .success(let userModel):
                        completion(.success(userModel))
                    }
                })
            }
        })
    }
    
    public func update(adaptionValues: UserAdaptionValuesModel, completion: @escaping (Result<UserModel, UserServiceError>) -> Void) {
        
        let apiAdaptionValues = NetworkModelMapper.map(adaptionValues: adaptionValues)
        guard let json = jsonConverter.toJson(apiAdaptionValues) else {
            completion(.failure(.encoding(apiAdaptionValues)))
            return
        }
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { [weak self] tokenResult in
            switch tokenResult {
            case .failure:
                completion(.failure(.token))
            case .success(let token):
                let router = BffUserRouter.adaptionValues(accessToken: token.accessToken, dict: json)
                
                self?.networking.request(router: router, completion: { (result: Result<Data, MBError>) in
                    switch result {
                    case .failure(let error):
                        completion(.failure(.network(error)))
                    case .success:
                        guard var user = self?.dbStore.currentUser else {
                            LOG.E("Could not fetch current user to update values. Aborting")
                            // state mismatch between client and server for user preferences. How to recover?
                            // Fetching user here again? Probably not necessary since next time fetching user he will have correct preferences
                            completion(.failure(.fetchingUserFromStore))
                            return
                        }
                        
                        user.adaptionValues = adaptionValues
                        
                        self?.dbStore.save(user: user, completion: { result in
                            
                            switch result {
                            case .failure:
                                completion(.failure(.savingUserToStore))
                            case .success(let userModel):
                                completion(.success(userModel))
                            }
                        })
                    }
                })
            }
        }
    }
    
    public func upload(profileImageData: Data, completion: @escaping (Result<Void, UserServiceError>) -> Void) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { [weak self] tokenResult in
            switch tokenResult {
            case .failure:
                completion(.failure(.token))
            case .success(let token):
                
                let router  = BffImageRouter.upload(accessToken: token.accessToken)
                
                guard var urlRequest = router.urlRequest else {
                    completion(.failure(.network(nil)))
                    return
                }
                
                urlRequest.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
                
                self?.networking.upload(urlReqeust: urlRequest, data: profileImageData) { (result) in
                    
                    switch result {
                    case .success:
                        guard var user = self?.dbStore.currentUser else {
                            LOG.E("Could not fetch current user to update values. Aborting")
                            // state mismatch between client and server for user preferences. How to recover?
                            // Fetching user here again? Probably not necessary since next time fetching user he will have correct preferences
                            completion(.failure(.fetchingUserFromStore))
                            return
                        }
                        
                        user.profileImageData = profileImageData
                        
                        self?.dbStore.save(user: user, completion: { result in
                            
                            switch result {
                            case .failure(let error):
                                LOG.E("Error saving profile image to store: \(error)")
                                completion(.failure(.savingUserToStore))
                            case .success:
                                LOG.D("Profile image saved successfully")
                                completion(.success(()))
                            }
                        })
                    case .failure(let error):
                        LOG.E("Profile image upload failed: \(error)")
                        completion(.failure(.network(error)))
                    }
                }
            }
        }
    }
    
    public func fetchProfileImage(completion: @escaping (Result<UIImage?, UserServiceError>) -> Void) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { [weak self] tokenResult in
            switch tokenResult {
            case .failure:
                completion(.failure(.token))
            case .success(let token):
                
                let router = BffImageRouter.getCached(accessToken: token.accessToken, eTag: self?.currentUser?.profileImageEtag)
                
                LOG.D("Requesting /profilePicture with eTag \(String(describing: self?.currentUser?.profileImageEtag))")
                
                self?.networking.request(router: router, completion: { (result: Result<(value: Data, eTag: String?), MBError>) in
                    switch result {
                    case .failure(let error):
                        
                        LOG.E(error.localizedDescription)
                        completion(.failure(.network(error)))
                    case .success(let imageResult):
                        
                        guard let image = UIImage(data: imageResult.value), let imageDataData = image.jpegData(compressionQuality: 1.0) ?? image.pngData() else {
                            completion(.failure(.imageEncoding))
                            return
                        }
                        
                        guard var user = self?.dbStore.currentUser else {
                            
                            LOG.E("Could not fetch current user to update values. Aborting")
                            // state mismatch between client and server for user preferences. How to recover?
                            // Fetching user here again? Probably not necessary since next time fetching user he will have correct preferences
                            completion(.failure(.fetchingUserFromStore))
                            return
                        }
                        
                        user.profileImageData = imageDataData
                        
                        if let eTag = imageResult.eTag {
                            LOG.D("Received image with eTag: \(eTag)")
                            user.profileImageEtag = eTag
                        }
                        
                        self?.dbStore.save(user: user, completion: { result in
                            
                            switch result {
                            case .failure:
                                completion(.failure(.savingUserToStore))
                            case .success:
                                completion(.success(image))
                            }
                        })
                    }
                })
            }
        }
    }
    
    public func register(scanReference: String, completion: @escaping (Result<Void, UserServiceError>) -> Void) {
        
        self.performRouterOperation(routerBuilder: { token in
            BffUserRouter.verification(accessToken: token.accessToken, scanReference: scanReference)
        }, completion: completion)
    }
    
    // MARK: - convenience router operations with generic error handling
    
    private func performRouterOperation(routerBuilder: @escaping ((TokenConformable) -> EndpointRouter), completion: @escaping  UserOperationEmptyResult) {
        
        let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { [weak self] result in
            
            switch result {
            case .success(let token):
                let router = routerBuilder(token)
                self?.performRouterRequest(router: router, completion: completion)
				
            case .failure:
                completion(.failure(.token))
            }
        }
    }
    
    private func performRouterRequest(router: EndpointRouter, completion: @escaping UserOperationEmptyResult) {
        
        self.networking.request(router: router) { (result: Result<Void, MBError>) in
            
            switch result {
            case .failure(let error):
                completion(.failure(.network(error)))
            case .success:
                completion(.success(()))
            }
        }
    }
    
    private func performRouterOperation<T: Decodable>(routerBuilder: @escaping ((TokenConformable) -> EndpointRouter), completion: @escaping ((Result<T, UserServiceError>) -> Void)) {
        
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
    
    private func performNetworkRequest<T: Decodable>(router: EndpointRouter, completion: @escaping ((Result<T, UserServiceError>) -> Void)) {
        
        self.networking.request(router: router) { (result: Result<T, MBError>) in
            
            switch result {
            case .success(let obj):
                completion(.success(obj))
            case .failure(let error):
                completion(.failure(.network(error)))
            }
        }
    }
    
    // MARK: - private methods
    
    private func sendRegionLanguageChangeNotificationIfNeeded(oldUser: UserModel?, newUser: UserModel) {
        
        if self.didUserRegionLanguageChange(oldUser: oldUser, newUser: newUser) {
            self.notificationSending.sendDidUpdateUserRegionLanguage(newUser)
        }
    }
    
    private func didUserRegionLanguageChange(oldUser: UserModel?, newUser: UserModel) -> Bool {
        
        guard let oldUser = oldUser else {
            
            // if we dont have an old user, we consider it as updated region/language
            LOG.V("No old user, so user did change")
            return true
        }
        
        if (oldUser.preferredLanguageCode != newUser.preferredLanguageCode) ||
            (oldUser.accountCountryCode != newUser.accountCountryCode) {
            
            LOG.V("user region or language did change. \noldUser: \(oldUser)\nnewUser: \(newUser)")
            return true
        } else {
            return false
        }
    }
}
