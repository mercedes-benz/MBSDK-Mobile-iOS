//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

@testable import MBCommonKit

// MARK: - TokenProviding

class MockTokenProvider: TokenProviding {
    func refreshTokenIfNeeded(completion: @escaping (Result<TokenConformable, TokenProvidingError>) -> Void) {
        if let token = self.token {
            completion(.success(token))
        } else {
            completion(.failure(.tokenRefreshFailed))
        }
    }
    

    var token: TokenConformable? = MockToken()
	
	
	// MARK: - TokenProviding
	
	required init() {}
	
	func requestToken(onComplete: @escaping (TokenConformable) -> Void) {
        if let token = self.token {
            onComplete(token)
        }
	}
}


// MARK: - TokenConformable

struct MockToken: TokenConformable {
	
	var accessToken: String = "mock_token"
	var tokenType: TokenType = .keycloak
	var expirationDate: Date = Date().addingTimeInterval(3600)
}
