//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

enum BffVerificationRouter: EndpointRouter {
    case transaction(accessToken: String, dict: [String: Any]?)
    case verification(accessToken: String, dict: [String: Any]?)
    
    // MARK: Properties
    var baseURL: String {
        guard let urlProvider = IngressKit.bffProvider?.urlProvider else {
            fatalError("This is a placeholder implementation. Please implement your own bffProvider or use the implementation from MBMobileSDK")
        }
        return urlProvider.baseUrl
    }
    
    var httpHeaders: [String: String]? {
        guard let headerParamProvider = IngressKit.bffProvider?.headerParamProvider else {
            fatalError("This is a placeholder implementation. Please implement your own headerParamProvider or use the implementation from MBMobileSDK")
        }

        var headers = headerParamProvider.defaultHeaderParams
        for param in headerParamProvider.ldssoAppHeaderParams {
            headers[param.key] = param.value
        }
        
        switch self {
        case .transaction(let accessToken, _), .verification(let accessToken, _):
            headers[headerParamProvider.authorizationHeaderParamKey] = accessToken.addBearerAuthHeaderPrefix()
            headers[headerParamProvider.countryCodeHeaderParamKey] = IngressKit.countryCode
        }
        
        return headers
    }
    
    var method: HTTPMethodType {
        switch self {
        case .transaction:  return .post
        case .verification: return .post
        }
    }
    
    var path: String {
        switch self {
        case .transaction:  return "/verification/transaction"
        case .verification: return "/verification/confirmation"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .transaction(_, let dict),
             .verification(_, let dict):
            return dict
        }
    }
    
    var parameterEncoding: ParameterEncodingType {
        switch self {
        case .transaction,
             .verification:        return .json
        }
    }
    
    var cachePolicy: URLRequest.CachePolicy? {
        return nil
    }
}
