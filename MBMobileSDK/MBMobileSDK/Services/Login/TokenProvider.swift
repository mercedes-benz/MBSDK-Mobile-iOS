//
//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit

class TokenProvider: TokenProviding {
    
    required init() {}
    
    func refreshTokenIfNeeded(completion: @escaping (Result<TokenConformable, TokenProvidingError>) -> Void) {
        IngressKit.loginService.refreshTokenIfNeeded { result in
            switch result {
            case .failure:
                completion(.failure(.tokenRefreshFailed))
            case .success(let token):
                completion(.success(token))
            }
        }
    }
    
    func requestToken(onComplete: @escaping (TokenConformable) -> Void) {
        IngressKit.loginService.refreshTokenIfNeeded { result in
            switch result {
            case .failure(let error):
                LOG.E(error)
            case .success(let token):
                onComplete(token)
            }
        }
    }
}
