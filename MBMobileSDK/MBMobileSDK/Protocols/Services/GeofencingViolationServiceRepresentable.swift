//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

public protocol GeofencingViolationServiceRepresentable {
    
    /// Get all the geofencing violations for the currently selected vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    func fetchGeofencingViolations(finOrVin: String, completion: @escaping GeofencingViolationService.ViolationsResult)
    
    /// Delete a geofencing violation with id for the currently selected vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - id: the id of the violation that shall be deleted
    func deleteGeofencingViolation(finOrVin: String, id: Int, completion: @escaping GeofencingViolationService.DeleteViolationResult)
    
    /// Delete all geofencing violations for the currently selected vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    func deleteAllGeofencingViolations(finOrVin: String, completion: @escaping GeofencingViolationService.DeleteAllViolationsResult)
}

public extension GeofencingViolationServiceRepresentable {
    
    func fetchGeofencingViolations(finOrVin: String, completion: @escaping GeofencingViolationService.ViolationsResult) {}
    func deleteGeofencingViolation(finOrVin: String, id: Int, completion: @escaping GeofencingViolationService.DeleteViolationResult) {}
    func deleteAllGeofencingViolations(finOrVin: String, completion: @escaping GeofencingViolationService.DeleteAllViolationsResult) {}
}
