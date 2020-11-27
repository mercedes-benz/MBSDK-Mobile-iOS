//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

enum BffGeofencingViolationRouter: EndpointRouter {
    case get(accessToken: String, finOrVin: String)
    case deleteGeofencing(accessToken: String, finOrVin: String, idParameter: Int)
    case deleteAll(accessToken: String, finOrVin: String)
    
	
	// MARK: - Properties

    var baseURL: String {
        guard let baseUrl = CarKit.bffProvider?.urlProvider else {
            fatalError("This is a placeholder implementation. Please implement your own baseURL or use the implementation from MBRSAppfamily")
        }
        return baseUrl.baseUrl
    }
    
    var method: HTTPMethodType {
        switch self {
        case .get:				return .get
        case .deleteAll:		return .delete
        case .deleteGeofencing:	return .delete
        }
    }
    
    var path: String {
        switch self {
        case .get(_, let finOrVin),
             .deleteAll(_, let finOrVin):
            return "/geofencing/vehicles/\(finOrVin)/fences/violations"

        case .deleteGeofencing(_, let finOrVin, let idParameter):
            return "/geofencing/vehicles/\(finOrVin)/fences/violations/\(idParameter)"
        }
    }
    
    var parameters: [String: Any]? {
        return  nil
    }
    
    var parameterEncoding: ParameterEncodingType {
        return .url(type: .standard)
    }
    
    var cachePolicy: URLRequest.CachePolicy? {
        return nil
    }
    
    var httpHeaders: [String: String]? {
        
        guard let headerParamProvider = CarKit.bffProvider?.headerParamProvider else {
            fatalError("This is a placeholder implementation. Please implement your own headerParamProvider or use the implementation from MBRSAppfamily")
        }
        var headers = headerParamProvider.defaultHeaderParams
        
        switch self {
        case .get(let accessToken, _),
			 .deleteAll(let accessToken, _),
             .deleteGeofencing(let accessToken, _, _):
            headers[headerParamProvider.authorizationHeaderParamKey] = accessToken.addBearerAuthHeaderPrefix()
            return headers
        }
    }
    
    var bodyParameters: [String: Any]? {
        return nil
    }
    
    var bodyEncoding: ParameterEncodingType {
        return .json
    }
}
