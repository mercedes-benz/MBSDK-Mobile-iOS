//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Nimble
import Quick

@testable import MBMobileSDK

class MockUserService: UserServiceRepresentable {

    var currentUser: UserModel?
    var fetchUserWasCalled = false
    
    func fetch(completion: @escaping (Result<UserModel, UserServiceError>) -> Void) {
        fetchUserWasCalled = true
        if let currentUser = currentUser {
            completion(.success(currentUser))
        } else {
            completion(.failure(.network(nil)))
        }
    }
    
}
