//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit

final class TokenProviderArchetype {

}


// MARK: - TokenProviding

extension TokenProviderArchetype: TokenProviding {
    
    func refreshTokenIfNeeded(completion: (Result<TokenConformable, TokenProvidingError>) -> Void) {
        fatalError("This is a placeholder implementation. Please implement your own Token handling class or use the implementation from MBMobileSDK")
    }

    func requestToken(onComplete: @escaping (TokenConformable) -> Void) {
        fatalError("This is a placeholder implementation. Please implement your own Token handling class or use the implementation from MBMobileSDK")
    }
}
