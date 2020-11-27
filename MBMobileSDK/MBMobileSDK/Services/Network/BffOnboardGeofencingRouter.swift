//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

enum BffOnboardGeofencingRouter: EndpointRouter {
    // Customerfences
    case getCustomerFences(accessToken: String, finOrVin: String)
    case createCustomerFences(accessToken: String, finOrVin: String, requestModel: [[String: Any]]?)
    case updateCustomerFences(accessToken: String, finOrVin: String, requestModel: [[String: Any]]?)
    case deleteCustomerFences(accessToken: String, finOrVin: String, requestModel: [Int]?)
    
    // Customerfences Violations
    case getCustomerFencesViolations(accessToken: String, finOrVin: String)
    case deleteCustomerFencesViolations(accessToken: String, finOrVin: String, requestModel: [Int]?)
    
    // Onboard
    case getOnboardFences(accessToken: String, finOrVin: String)
    case createOnboardFences(accessToken: String, finOrVin: String, requestModel: [[String: Any]]?)
    case updateOnboardFences(accessToken: String, finOrVin: String, requestModel: [[String: Any]]?)
    case deleteOnboardFences(accessToken: String, finOrVin: String, requestModel: [Int]?)
    
    // MARK: - Properties
    
    var baseURL: String {
        guard let baseUrl = CarKit.bffProvider?.urlProvider else {
            fatalError("This is a placeholder implementation. Please implement your own baseURL or use the implementation from MBRSAppfamily")
        }
        return baseUrl.baseUrl
    }
    
    var method: HTTPMethodType {
        switch self {
        case .getOnboardFences:                  return .get
        case .createOnboardFences:                return .post
        case .updateOnboardFences:                return .put
        case .deleteOnboardFences:                return .delete
        case .getCustomerFences:                    return .get
        case .createCustomerFences:                 return .post
        case .updateCustomerFences:                 return .put
        case .deleteCustomerFences:                 return .delete
        case .getCustomerFencesViolations:          return .get
        case .deleteCustomerFencesViolations:    return .delete
        }
    }
    
    var path: String {
        switch self {
        case .getCustomerFences(_, let finOrVin),
             .createCustomerFences(_, let finOrVin, _),
             .updateCustomerFences(_, let finOrVin, _),
             .deleteCustomerFences(_, let finOrVin, _):
            return "customerfences/vehicles/\(finOrVin)"
        case .getCustomerFencesViolations(_, let finOrVin),
             .deleteCustomerFencesViolations(_, let finOrVin, _):
            return "customerfences/vehicles/\(finOrVin)/violations"
        case .getOnboardFences(_, let finOrVin),
             .createOnboardFences(_, let finOrVin, _),
             .updateOnboardFences(_, let finOrVin, _),
             .deleteOnboardFences(_, let finOrVin, _):
            return "onboardfences/vehicles/\(finOrVin)"
        }
    }
    
    var parameters: [String: Any]? {
        return nil
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
        case .getCustomerFences(let accessToken, _),
             .createCustomerFences(let accessToken, _, _),
             .updateCustomerFences(let accessToken, _, _),
             .deleteCustomerFences(let accessToken, _, _),
             .getCustomerFencesViolations(let accessToken, _),
             .deleteCustomerFencesViolations(let accessToken, _, _),
             .getOnboardFences(let accessToken, _),
             .createOnboardFences(let accessToken, _, _),
             .updateOnboardFences(let accessToken, _, _),
             .deleteOnboardFences(let accessToken, _, _):
            
            headers[headerParamProvider.authorizationHeaderParamKey] = accessToken.addBearerAuthHeaderPrefix()
            return headers
        }
    }
    
    var bodyParameters: [String: Any]? {
        switch self {
        case .createCustomerFences(_, _, let requestModel),
             .updateCustomerFences(_, _, let requestModel):
            guard let requestModel = requestModel else {
                return nil
            }
            return [
                "customerfences": requestModel
            ]
        case .deleteCustomerFences(_, _, let requestModel),
             .deleteCustomerFencesViolations(_, _, let requestModel),
             .deleteOnboardFences(_, _, let requestModel):
            guard let requestModel = requestModel else {
                return nil
            }
            return [
                "ids": requestModel
            ]
        case .createOnboardFences(_, _, let requestModel),
             .updateOnboardFences(_, _, let requestModel):
            guard let requestModel = requestModel else {
                return nil
            }
            return [
                "onboardfences": requestModel
            ]
        default:
            return nil
        }
    }
    
    var bodyEncoding: ParameterEncodingType {
        return .json
    }
    
}
