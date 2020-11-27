//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import MBRealmKit

enum UserDbStoreError: Error {
    case userNotFound
    case dbError
    case unknown
}

protocol UserDbStoreRepresentable {
    var currentUser: UserModel? { get }
    func save(user: UserModel, completion: @escaping ((Result<UserModel, UserDbStoreError>) -> Void))
    func deleteCurrentUser(completion: @escaping ((Result<Void, UserDbStoreError>) -> Void))
}

class UserDbStore: UserDbStoreRepresentable {
    
    let store: DbStore<UserModel, DBUserModel, UserDbModelMapper>
    
    init() {
        self.store = DbStore(config: DatabaseUserConfig(), mapper: UserDbModelMapper())
    }
    
    var currentUser: UserModel? {
        return self.store.fetchAll().first
    }
    
    func save(user: UserModel, completion: @escaping ((Result<UserModel, UserDbStoreError>) -> Void)) {
        self.store.save(user, update: true) { result in
            
            switch result {
            case .success(let user):
                completion(.success(user))
                
            case .failure(let error):
                completion(.failure(self.map(error)))
            }
        }
    }
    
    func deleteCurrentUser(completion: @escaping ((Result<Void, UserDbStoreError>) -> Void)) {
        guard let user = currentUser else {
            completion(.failure(.userNotFound))
            return
        }
        
        self.store.delete(user) { [weak self] result in
            switch result {
            case .failure(let dbError):
                completion(.failure(self?.map(dbError) ?? .unknown))
            case .success:
                completion(.success(()))
            }
        }
    }
 
    private func map(_ error: DbError) -> UserDbStoreError {
        switch error {
        case .unknown:
            return .unknown
        default:
            return .dbError
        }
    }
}
