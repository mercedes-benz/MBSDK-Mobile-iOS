//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit
import MBCommonKit
import MBNetworkKit

// swiftlint:disable switch_case_alignment

enum ROPCEndpointRouter: EndpointRouter {
    case login(provider: ROPCAuthenticationProviding, username: String, credential: String)
    case logout(provider: ROPCAuthenticationProviding, token: String)
    case refresh(provider: ROPCAuthenticationProviding, token: String)
	
	
	// MARK: Properties
	var baseURL: String {
        switch self {
        case .login(let provider, _, _),
             .logout(let provider, _),
             .refresh(let provider, _):
            return provider.urlProvider.baseUrl
        }
	}
    
	var httpHeaders: [String: String]? {
        switch self {
        case .login(let provider, _, _):
            var headers = provider.headerParamProvider.defaultHeaderParams
            headers["Stage"] =  provider.stageName
            headers["device-uuid"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
            return headers
            
        case .logout(let provider, _),
             .refresh(let provider, _):
            var headers = provider.headerParamProvider.defaultHeaderParams
            headers["Stage"] =  provider.stageName
            return headers
        }
	}
    
	var method: HTTPMethodType {
		switch self {
		case .login:	return .post
		case .logout:	return .post
		case .refresh:	return .post
		}
	}
    
	var path: String {
		switch self {
        case .login(let provider, _, _),
             .logout(let provider, _),
             .refresh(let provider, _): return path(for: provider.type)
		}
	}
    
	var parameters: [String: Any]? {
		switch self {
        case .login(let provider, let username, let credential):
			return [
                ROPCParamKey.clientId: provider.clientId,
				ROPCParamKey.grantType: ROPCParamValue.password,
                ROPCParamKey.scope: provider.scopes,
				ROPCParamKey.username: username,
				ROPCParamKey.password: credential
			]
			
		case .logout(let provider, let token):
            return [
                ROPCParamKey.clientId: provider.clientId,
				ROPCParamKey.refreshToken: token
			]
			
		case .refresh(let provider, let token):
			return [
				ROPCParamKey.clientId: provider.clientId,
				ROPCParamKey.grantType: ROPCParamValue.refreshToken,
				ROPCParamKey.refreshToken: token
			]
		}
	}
    
	var parameterEncoding: ParameterEncodingType {
		return .url(type: .standard)
	}
    
	var cachePolicy: URLRequest.CachePolicy? {
		return nil
	}
    
	var timeout: TimeInterval {
        switch self {
        case .login(let provider, _, _),
             .logout(let provider, _),
             .refresh(let provider, _):
            return provider.urlProvider.requestTimeout
        }
	}
    
    private func path(for authType: AuthenticationType) -> String {
        switch authType {
        case .keycloak:
            switch self {
            case .login:    return "/protocol/openid-connect/token"
            case .logout:   return "/protocol/openid-connect/logout"
            case .refresh:  return "/protocol/openid-connect/token"
            }
        case .ciam:
            switch self {
            case .login:    return "/as/token.oauth2"
            case .logout:   return "/as/revoke_token.oauth2"
            case .refresh:  return "/as/token.oauth2"
            }
        }
    }
}
