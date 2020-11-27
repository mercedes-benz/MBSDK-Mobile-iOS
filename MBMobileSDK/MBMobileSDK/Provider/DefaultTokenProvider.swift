//
// Copyright (c) 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit


final public class DefaultTokenProvider {

    public init() {}
}

extension DefaultTokenProvider: TokenProviding {
    
    public func refreshTokenIfNeeded(completion: @escaping (Result<TokenConformable, TokenProvidingError>) -> Void) {
        
        IngressKit.loginService.refreshTokenIfNeeded { result in
            switch result {
            case .failure(let error):
                
                MobileSDK.sessionErrorHandler.handleRefreshError(error)
                completion(.failure(.tokenRefreshFailed))
                
            case .success(let token):
                completion(.success(token))
            }
        }
    }

    public func requestToken(onComplete: @escaping TokenProvidingCompletion) {
		
		IngressKit.loginService.refreshTokenIfNeeded { (result) in
			
			switch result {
			case .failure(let error):
				guard error.type != .unknown else {
					LOG.E("refreshTokenIfNeeded resulted in an unknown error: \(error). Not showing a error dialog to the user.")
					return
				}
				
				MobileSDK.sessionErrorHandler.handleRefreshError(error)
				
			case .success(let token):
				onComplete(token)
			}
		}
    }
}
