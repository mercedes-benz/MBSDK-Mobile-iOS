//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

public protocol ValetProtectServiceRepresentable {
    
    /// Create a valet protect item for the vehicle
    ///
    /// - Parameters:
    ///   - requestModel: the valet protect model to create
    ///   - finOrVin: fin or vin of the vehicle
    ///   - completion: Closure with enum-based ValetProtectModel
    func createValetProtectItem(_ requestModel: ValetProtectModel, finOrVin: String, completion: @escaping ValetProtectService.ValetProtectCreateCompletion)
    
    /// Delete all valet protect violations for the vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - completion: Closure with Result object
    func deleteAllValetProtectViolations(finOrVin: String, completion: @escaping ValetProtectService.ValetProtectDeleteCompletion)
    
    /// Delete a valet protect item for the vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - completion: Closure with Result object
    func deleteValetProtectItem(finOrVin: String, completion: @escaping ValetProtectService.ValetProtectDeleteCompletion)
    
    /// Delete a valet protect violation
    ///
    /// - Parameters:
    ///   - id: id of the valet protect  violation to delete
    ///   - finOrVin: fin or vin of the vehicle
    ///   - completion: Closure with Result object
    func deleteValetProtectViolation(id: String, finOrVin: String, completion: @escaping ValetProtectService.ValetProtectDeleteCompletion)
    
    /// Fetch all valet protect violations for the vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - unit: unit of the Valet Protect radius (kilometers or miles)
    ///   - completion: Closure with valet protect violations
    func fetchAllValetProtectViolations(finOrVin: String, unit: DistanceUnit, completion: @escaping ValetProtectService.ValetProtectViolationsResult)
    
    /// Fetch the valet protect for the vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - unit: unit of the Valet Protect radius (kilometers or miles)
    ///   - completion: Closure with valet protect item
    func fetchValetProtectItem(finOrVin: String, unit: DistanceUnit, completion: @escaping ValetProtectService.ValetProtectResult)
    
    /// Fetch a valet protect violation
    ///
    /// - Parameters:
    ///   - id: id of the valet protect  violation to fetch
    ///   - finOrVin: fin or vin of the vehicle
    ///   - unit: unit of the Valet Protect radius (kilometers or miles)
    ///   - completion: Closure with valet protect violations
    func fetchValetProtectViolation(id: String, finOrVin: String, unit: DistanceUnit, completion: @escaping ValetProtectService.ValetProtectViolationResult)
}

public extension ValetProtectServiceRepresentable {
    
    func createValetProtectItem(_ requestModel: ValetProtectModel, finOrVin: String, completion: @escaping ValetProtectService.ValetProtectCreateCompletion) {}
    func deleteAllValetProtectViolations(finOrVin: String, completion: @escaping ValetProtectService.ValetProtectDeleteCompletion) {}
    func deleteValetProtectItem(finOrVin: String, completion: @escaping ValetProtectService.ValetProtectDeleteCompletion) {}
    func deleteValetProtectViolation(id: String, finOrVin: String, completion: @escaping ValetProtectService.ValetProtectDeleteCompletion) {}
    func fetchAllValetProtectViolations(finOrVin: String, unit: DistanceUnit, completion: @escaping ValetProtectService.ValetProtectViolationsResult) {}
    func fetchValetProtectItem(finOrVin: String, unit: DistanceUnit, completion: @escaping ValetProtectService.ValetProtectResult) {}
    func fetchValetProtectViolation(id: String, finOrVin: String, unit: DistanceUnit, completion: @escaping ValetProtectService.ValetProtectViolationResult) {}
}
