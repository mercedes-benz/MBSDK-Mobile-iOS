//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

public protocol SpeedFenceServiceRepresentable {
    
    /// Create speedfences for the given vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle.
    ///   - speedfences: The model of speedfences which shall be created.
    func create(finOrVin: String, speedfences: [SpeedFenceRequestModel], completion: @escaping SpeedFenceService.CreateSpeedfenceSucceeded)
    
    /// Deletes all speedfences for the given vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle.
    ///   - speedfences: optional array of speedfence IDs, which will be deleted. If the array is nil, all speedfences will be deleted.
    func deleteSpeedfences(finOrVin: String, speedfences: [Int]?, completion: @escaping SpeedFenceService.DeleteAllSpeedfencesSucceeded)
    
    /// Deletes all speedfence violations for the given vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle.
    ///   - speedfences: optional array of speedfence IDs, which will be deleted. If the array is nil, all speedfence violations will be deleted.
    func deleteViolations(finOrVin: String, speedfences: [Int]?, completion: @escaping SpeedFenceService.DeleteAllSpeedfencesSucceeded)
    
    /// Get all the speedfences for the given vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle.
    ///   - unit: unit of the speed unit (kilometers or miles)
    func fetchSpeedfences(finOrVin: String, unit: SpeedUnit, completion: @escaping SpeedFenceService.FetchSpeedfencesSucceeded)
    
    /// Get all the speedfence violations for the given vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle.
    ///   - unit: unit of the speed unit (kilometers or miles)
    func fetchViolations(finOrVin: String, unit: SpeedUnit, completion: @escaping SpeedFenceService.FetchSpeedfenceViolationsSucceeded)
    
    /// Update existing speedfences by id for the given vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle.
    ///   - speedfences: The model of speedfences which shall be created.
    func update(finOrVin: String, speedfences: [SpeedFenceRequestModel], completion: @escaping SpeedFenceService.CreateSpeedfenceSucceeded)
}

public extension SpeedFenceServiceRepresentable {
    
    func create(finOrVin: String, speedfences: [SpeedFenceRequestModel], completion: @escaping SpeedFenceService.CreateSpeedfenceSucceeded) {}
    func deleteSpeedfences(finOrVin: String, speedfences: [Int]?, completion: @escaping SpeedFenceService.DeleteAllSpeedfencesSucceeded) {}
    func deleteViolations(finOrVin: String, speedfences: [Int]?, completion: @escaping SpeedFenceService.DeleteAllSpeedfencesSucceeded) {}
    func fetchSpeedfences(finOrVin: String, unit: SpeedUnit, completion: @escaping SpeedFenceService.FetchSpeedfencesSucceeded) {}
    func fetchViolations(finOrVin: String, unit: SpeedUnit, completion: @escaping SpeedFenceService.FetchSpeedfenceViolationsSucceeded) {}
    func update(finOrVin: String, speedfences: [SpeedFenceRequestModel], completion: @escaping SpeedFenceService.CreateSpeedfenceSucceeded) {}
}
