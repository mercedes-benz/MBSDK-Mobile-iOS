//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

public protocol SendToCarServiceV2Representable {
    
    /// Fetches a list of capabilities of the vehicle
    /// It always tries to get the latest version from bff and only if request fails it returns from cache
    ///
    /// The local cache is updated if the capabililties were fetched from the backend.
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin from the car
    ///   - completion: Callback with the result of SendToCarCapabilitiesModel and  FetchSendToCarCapabilitiesError
	func fetchCapabilities(finOrVin: String,
                           completion: @escaping (Result<SendToCarCapabilitiesModel, FetchSendToCarCapabilitiesError>) -> Void)
    
    /// Sends a poi or route with waypoints to the vehicle.
    ///
    /// Depending on the available capabilities of the vehicle and the bluetooth connection
    /// one of the following mechanisms is used:
    /// * Sending the route via bluetooth and sending via backend as fallback
    /// * Sending the route via bluetooth only and failing otherwise
    /// * Sending the route via backend only and failing otherwise
    ///
    ///  It is *not* necessary to manually call fetchCapabilities(vin:completion:) before, this is completely handled internally by this API.
    ///
    /// - Parameters:
    ///   - finOrVin:   fin or vin of the vehicle
    ///   - routeModel: route that will be send to the car
    ///   - completion: callback with the result of Void and  SendRouteError
    func sendPoiOrRoute(finOrVin: String,
                        routeModel: SendToCarRouteModel,
                        completion: @escaping (Result<Void, SendRouteError>) -> Void)
    
    /// Sends a poi or route with waypoints to the vehicle.
    ///
    /// Depending on the available capabilities of the vehicle and the bluetooth connection
    /// one of the following mechanisms is used:
    /// * Sending the route via bluetooth and sending via backend as fallback
    /// * Sending the route via bluetooth only and failing otherwise
    /// * Sending the route via backend only and failing otherwise
    ///
    /// - Warning:
    ///  This method requires fetching of capabilities via `fetchCapabilities(vin:completion:)` before and is only intended
    ///  to be used when there is no cache available like e.g. in a share extension.
    ///  In almost all other cases it is better to use `sendPoiOrRoute(vin:routeModel:completion:)` instead
    ///
    /// - Parameters:
    ///   - finOrVin:   fin or vin of the vehicle
    ///   - routeModel: route that will be send to the car
    ///   - prefetchedCapabilities: capabilities for this car
    ///   - completion: callback with the result of Void and  SendRouteError
    func sendPoiOrRoute(finOrVin: String,
                        routeModel: SendToCarRouteModel,
                        prefetchedCapabilities: SendToCarCapabilitiesModel,
                        completion: @escaping (Result<Void, SendRouteError>) -> Void)
}
