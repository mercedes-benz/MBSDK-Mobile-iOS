//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

public enum TokenExchangeError: Error {
    case noValidAuthConfigAvailable
    case currentTokenNotAvailable
    case invalidUserAuthenticationIdentifier
    case tokenExchangeFailed
}

/// Functionality to exchange tokens between different authentication systems, e.g.
/// migrates a Keycloak token to a CIAM:NG token
public protocol TokenExchanging {
    
    /// Checks if a token exchange is currently possible, but e.g. looking at the
    /// state of the current token and the availability of multiple authentication
    /// environments
    func isTokenExchangePossible() -> Bool
    
    /// Performs a token exchange and updates the token store on success
    func performTokenExchange(completion: @escaping (Result<Void, TokenExchangeError>) -> Void)
}
