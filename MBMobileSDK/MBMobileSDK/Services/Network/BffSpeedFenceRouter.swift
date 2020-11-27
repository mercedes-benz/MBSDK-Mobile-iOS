//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

enum BffSpeedFenceRouter: EndpointRouter {
    case create(accessToken: String, finOrVin: String, requestModel: [[String: Any]]?)
    case deleteSpeedfences(accessToken: String, finOrVin: String, requestModel: [Int])
    case deleteViolations(accessToken: String, finOrVin: String, requestModel: [Int])
    case getSpeedfences(accessToken: String, finOrVin: String, unit: String)
    case getViolations(accessToken: String, finOrVin: String, unit: String)
    case update(accessToken: String, finOrVin: String, requestModel: [[String: Any]]?)

    // MARK: - Properties
    var baseURL: String {
        guard let baseUrl = CarKit.bffProvider?.urlProvider else {
            fatalError("This is a placeholder implementation. Please implement your own baseURL or use the implementation from MBRSAppfamily")
        }
        return baseUrl.baseUrl
    }
    
    var method: HTTPMethodType {
		switch self {
		case .create:				return .post
		case .deleteSpeedfences:	return .delete
		case .deleteViolations:		return .delete
		case .getSpeedfences:		return .get
		case .getViolations:		return .get
		case .update:				return .put
        }
    }
    
    var path: String {
		switch self {
		case .create(_, let finOrVin, _),
			 .deleteSpeedfences(_, let finOrVin, _),
			 .getSpeedfences(_, let finOrVin, _),
			 .update(_, let finOrVin, _):
            return "/speedfences/vehicles/\(finOrVin)"
			
		case .deleteViolations(_, let finOrVin, _),
			 .getViolations(_, let finOrVin, _):
            return "/speedfences/vehicles/\(finOrVin)/violations"
        }
    }
    
    var parameters: [String: Any]? {
		switch self {
		case .create,
			 .deleteSpeedfences,
			 .deleteViolations,
			 .update:
			return nil
			
		case .getSpeedfences(_, _, let unit),
			 .getViolations(_, _, let unit):
            return [
				"unit": unit
			]
        }
    }
    
    var parameterEncoding: ParameterEncodingType {
		switch self {
		case .create,
			 .deleteSpeedfences,
			 .deleteViolations,
			 .update:
			return .json
			
		case .getSpeedfences,
			 .getViolations:
            return .url(type: .query)
        }
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
		case .create(let accessToken, _, _),
			 .deleteSpeedfences(let accessToken, _, _),
             .deleteViolations(let accessToken, _, _),
			 .getSpeedfences(let accessToken, _, _),
			 .getViolations(let accessToken, _, _),
			 .update(let accessToken, _, _):
            headers[headerParamProvider.authorizationHeaderParamKey] = accessToken.addBearerAuthHeaderPrefix()
            return headers
        }
    }
    
    var bodyParameters: [String: Any]? {
		switch self {
		case .create(_, _, let requestModel),
			 .update(_, _, let requestModel):
			guard let requestModel = requestModel else {
				return nil
			}
            return [
				"speedfences": requestModel
			]
			
		case .deleteSpeedfences(_, _, let requestModel),
			 .deleteViolations(_, _, let requestModel):
			return [
				"ids": requestModel
			]
			
		case .getSpeedfences,
			 .getViolations:
            return nil
        }
    }
    
    var bodyEncoding: ParameterEncodingType {
        return self.parameterEncoding
    }
}
