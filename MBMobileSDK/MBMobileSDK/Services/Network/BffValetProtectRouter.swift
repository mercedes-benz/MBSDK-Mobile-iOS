//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

enum BffValetProtectRouter: EndpointRouter {
    case getValetProtectItem(finOrVin: String, unit: String, accessToken: String)
    case createValetProtectItem(finOrVin: String, requestModel: [String: Any]?, accessToken: String)
    case deleteValetProtectItem(finOrVin: String, accessToken: String)
    case getAllViolations(finOrVin: String, unit: String, accessToken: String)
    case deleteAllViolations(finOrVin: String, accessToken: String)
    case getViolation(finOrVin: String, id: String, unit: String, accessToken: String)
    case deleteViolation(finOrVin: String, id: String, accessToken: String)
    
	
    // MARK: - Properties

    var baseURL: String {
        guard let urlProvider = CarKit.bffProvider?.urlProvider else {
            fatalError("This is a placeholder implementation. Please implement your own bffProvider or use the implementation from MBMobileSDK")
        }
        return urlProvider.baseUrl
    }
    
    var httpHeaders: [String: String]? {

        guard let headerParamProvider = CarKit.bffProvider?.headerParamProvider else {
            fatalError("This is a placeholder implementation. Please implement your own headerParamProvider or use the implementation from MBMobileSDK")
        }
        var headers = headerParamProvider.defaultHeaderParams

        switch self {
        case .getValetProtectItem(_, _, let accessToken),
             .createValetProtectItem(_, _, let accessToken),
             .deleteValetProtectItem(_, let accessToken),
             .getAllViolations(_, _, let accessToken),
             .deleteAllViolations(_, let accessToken),
             .getViolation(_, _, _, let accessToken),
             .deleteViolation(_, _, let accessToken):
            headers[headerParamProvider.authorizationHeaderParamKey] = accessToken.addBearerAuthHeaderPrefix()
        }
        return headers
    }

    var method: HTTPMethodType {
        switch self {
        case .getValetProtectItem:		return .get
        case .createValetProtectItem:	return .post
        case .deleteValetProtectItem:	return .delete
        case .getAllViolations:			return .get
        case .deleteAllViolations:		return.delete
        case .getViolation:				return .get
        case .deleteViolation:			return .delete
        }
    }

    var path: String {
        switch self {
        case .getValetProtectItem(let finOrVin, _, _),
             .createValetProtectItem(let finOrVin, _, _),
             .deleteValetProtectItem(let finOrVin, _):
            return "valetprotect/vehicles/\(finOrVin)/protectitem"

        case .getAllViolations(let finOrVin, _, _),
             .deleteAllViolations(let finOrVin, _):
            return "/valetprotect/vehicles/\(finOrVin)/violations"

        case .getViolation(let finOrVin, let id, _, _),
             .deleteViolation(let finOrVin, let id, _):
            return "/valetprotect/vehicles/\(finOrVin)/violations/\(id)"

        }
    }

    var bodyParameters: [String: Any]? {
        switch self {
        case .createValetProtectItem(_, let requestModel, _):
            return requestModel

        default:
            return nil
        }
    }

    var bodyEncoding: ParameterEncodingType {
        return .json
    }

    var parameters: [String: Any]? {
        switch self {
        case .getValetProtectItem(_, let unit, _),
             .getAllViolations(_, let unit, _),
             .getViolation(_, _, let unit, _):
            return ["unit": unit]

        default:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncodingType {
        return .url(type: .standard)
    }
    
    var cachePolicy: URLRequest.CachePolicy? {
        return nil
    }
}
