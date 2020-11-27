//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

enum BffGeofencingRouter: EndpointRouter {
    case getGeofences(accessToken: String, finOrVin: String)
    case createGeofence(accessToken: String, finOrVin: String, requestModel: [String: Any]?)
    case getGeofence(accessToken: String, idParameter: Int)
    case updateGeofence(accessToken: String, idParameter: Int, requestModel: [String: Any]?)
    case deleteGeofence(accessToken: String, idParameter: Int)
    case getGeofencesForVehicle(accessToken: String, finOrVin: String)
    case activateGeofencingForVehicle(accessToken: String, finOrVin: String, idParameter: Int)
    case deleteGeofenceForVehicle(accessToken: String, finOrVin: String, idParameter: Int)
    
	// MARK: - Properties

    var baseURL: String {
        guard let baseUrl = CarKit.bffProvider?.urlProvider else {
            fatalError("This is a placeholder implementation. Please implement your own baseURL or use the implementation from MBRSAppfamily")
        }
        return baseUrl.baseUrl
    }
    
    var method: HTTPMethodType {
        switch self {
        case .getGeofences:					return .get
        case .createGeofence:				return .post
        case .getGeofence:					return .get
        case .updateGeofence:				return .put
        case .deleteGeofence:				return .delete
        case .getGeofencesForVehicle:		return .get
        case .activateGeofencingForVehicle:	return .put
        case .deleteGeofenceForVehicle:		return .delete
        }
    }
    
    var path: String {
        switch self {
        case .getGeofences,
             .createGeofence:
            return "geofencing/fences/"

        case .getGeofence(_, let idParameter),
             .updateGeofence(_, let idParameter, _),
             .deleteGeofence(_, let idParameter):
            return "geofencing/fences/\(idParameter)"

        case .getGeofencesForVehicle(_, let finOrVin):
            return "geofencing/vehicles/\(finOrVin)/fences"

        case .activateGeofencingForVehicle(_, let finOrVin, let idParameter),
             .deleteGeofenceForVehicle(_, let finOrVin, let idParameter):
            return "geofencing/vehicles/\(finOrVin)/fences/\(idParameter)"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getGeofences(_, let finOrVin):
            return ["vin": finOrVin]

        case .createGeofence(_, let finOrVin, _):
            return ["FinOrVin": finOrVin]

        default:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncodingType {
        switch self {
        case .createGeofence:
            return .url(type: .query)
        default:
            return .url(type: .standard)
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
        case .getGeofences(let accessToken, _),
             .createGeofence(let accessToken, _, _),
             .getGeofence(let accessToken, _),
             .updateGeofence(let accessToken, _, _),
             .deleteGeofence(let accessToken, _),
             .getGeofencesForVehicle(let accessToken, _),
             .activateGeofencingForVehicle(let accessToken, _, _),
             .deleteGeofenceForVehicle(let accessToken, _, _):
            headers[headerParamProvider.authorizationHeaderParamKey] = accessToken.addBearerAuthHeaderPrefix()
            return headers
        }
    }
    
    var bodyParameters: [String: Any]? {
        switch self {
        case .createGeofence(_, _, let requestModel):
            return requestModel

        case .updateGeofence(_, _, let requestModel):
            return requestModel

        default:
            return nil
        }
    }
    
    var bodyEncoding: ParameterEncodingType {
        return .json
    }
    
}
