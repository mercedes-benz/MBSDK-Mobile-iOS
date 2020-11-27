//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

public protocol GeofencingServiceRepresentable {
    
    /// Get all the geofences that are associated with the user
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - completion: Closure with geofences data of the user
    func fetchGeofences(finOrVin: String, completion: @escaping GeofencingService.GeofencesResult)
    
    /// Create a new geofence for the user
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - geofence: the model data of the geofence
    ///   - completion: Closure with CreateGeofenceResult
    func createGeofence(finOrVin: String, geofence: GeofenceModel, completion: @escaping GeofencingService.CreateGeofenceResult)
    
    /// Get one specific geofence by id
    ///
    /// - Parameters:
    ///   - id: id of the geofence to fetch
    ///   - completion: Closure with geofence data of the user
    func fetchGeofence(id: Int, completion: @escaping GeofencingService.GeofenceResult)
    
    /// Update a geofence
    ///
    /// - Parameters:
    ///   - id: id of the geofence to update
    ///   - geofence: the updated model of the geofence
    ///   - onSuccess: Closure with UpdateGeofenceResult
    func updateGeofence(id: Int, geofence: GeofenceModel, completion: @escaping GeofencingService.UpdateGeofenceResult)
    
    /// Delete a geofence with the id
    ///
    /// - Parameters:
    ///   - id: the id of the fence that shall be deleted
    ///   - completion: Closure with DeleteGeofenceResult
    func deleteGeofence(id: Int, completion: @escaping GeofencingService.DeleteGeofenceResult)
    
    /// Activate a geofence with the id for the vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - id: the id of the fence that shall be activated or deactivated
    ///   - completion: Closure with UpdateGeofenceResult
    func activateGeofenceForVehicle(id: Int, finOrVin: String, completion: @escaping GeofencingService.UpdateGeofenceResult)
    
    /// Delete a geofence with the id for the vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - id: the id of the fence that shall be deleted
    ///   - completion: Closure with DeleteGeofenceResult
    func deleteGeofenceForVehicle(id: Int, finOrVin: String, completion: @escaping GeofencingService.DeleteGeofenceResult)
}

public extension GeofencingServiceRepresentable {
    
    func fetchGeofences(finOrVin: String, completion: @escaping GeofencingService.GeofencesResult) {}
    func createGeofence(finOrVin: String, geofence: GeofenceModel, completion: @escaping GeofencingService.CreateGeofenceResult) {}
    func fetchGeofence(id: Int, completion: @escaping GeofencingService.GeofenceResult) {}
    func updateGeofence(id: Int, geofence: GeofenceModel, completion: @escaping GeofencingService.UpdateGeofenceResult) {}
    func deleteGeofence(id: Int, completion: @escaping GeofencingService.DeleteGeofenceResult) {}
    func activateGeofenceForVehicle(id: Int, finOrVin: String, completion: @escaping GeofencingService.UpdateGeofenceResult) {}
    func deleteGeofenceForVehicle(id: Int, finOrVin: String, completion: @escaping GeofencingService.DeleteGeofenceResult) {}
}
