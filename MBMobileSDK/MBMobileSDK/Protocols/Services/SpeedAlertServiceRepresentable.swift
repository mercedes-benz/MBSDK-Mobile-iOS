//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

public protocol SpeedAlertServiceRepresentable {
    
    /// Get all the speed alert violations for the currently selected vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - unit: unit of the speed unit (kilometers or miles)
    func fetchSpeedAlertViolations(finOrVin: String, unit: SpeedUnit, completion: @escaping SpeedAlertService.SpeedAlertViolationsResult)
    
    /// Delete a speed alert violation with id for the currently selected vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - id: the id of the speed alert violation that shall be deleted

    func deleteSpeedAlertViolation(finOrVin: String, id: Int, completion: @escaping SpeedAlertService.DeleteViolationCompletion)
    
    /// Delete all speed alert violations for the currently selected vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    func deleteAllSpeedAlertViolations(finOrVin: String, completion: @escaping SpeedAlertService.DeleteAllViolationsCompletion)
}

public extension SpeedAlertServiceRepresentable {
    
    func fetchSpeedAlertViolations(finOrVin: String, unit: SpeedUnit, completion: @escaping SpeedAlertService.SpeedAlertViolationsResult) {}
    func deleteSpeedAlertViolation(finOrVin: String, id: Int, completion: @escaping SpeedAlertService.DeleteViolationCompletion) {}
    func deleteAllSpeedAlertViolations(finOrVin: String, completion: @escaping SpeedAlertService.DeleteAllViolationsCompletion) {}
}
