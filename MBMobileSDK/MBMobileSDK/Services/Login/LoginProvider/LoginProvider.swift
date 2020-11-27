//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import MBNetworkKit
import MBCommonKit

protocol LoginProvider {
    
    typealias TokenResult = (Result<Token, MBError>) -> Void
    
    var type: AuthenticationType { get }
    var token: Token? { get }
    
    func login(username: String, credential: String, completion: @escaping (Result<Void, LoginServiceError>) -> Void)
    func logout(completion: @escaping (Result<Void, LoginServiceError>) -> Void)

    func refreshTokenIfNeeded(completion: @escaping TokenResult)
}
