//
//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import MBNetworkKit
import MBCommonKit

@testable import MBMobileSDK

class MockUserLoginFunctions: UserLoginFunctions {
    
    var onInitiateLogin: ((String, String, AuthenticationType) -> (model: (UserExistModel, AuthenticationType)?, error: LoginServiceError?))!
    
    func initiateLogin(username: String, nonce: String, preferredAuthType: AuthenticationType, completion: @escaping (Result<(UserExistModel, AuthenticationType), LoginServiceError>) -> Void) {
        
        let result = onInitiateLogin(username, nonce, preferredAuthType)
        if let error = result.error {
            completion(.failure(error))
        } else if let model = result.model {
            completion(.success(model))
        }
    }
}
