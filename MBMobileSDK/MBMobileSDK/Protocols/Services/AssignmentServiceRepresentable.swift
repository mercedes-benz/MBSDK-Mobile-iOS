//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

public protocol AssignmentServiceRepresentable {
    
    /// Start a qr-based vehicle assignment
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the car
    ///   - link: Link inkluded from the qr code
    ///   - completion: Completion with AssignmentFinishResult
    ///   - onPreconditionFailed: Precondition fails for this assignment
    func addVehicleQR(link: String, completion: @escaping AssignmentService.AssignmentFinishResult, onPreconditionFailed: @escaping AssignmentService.AssignmentPreconditionResult)
    
    /// Start a vin-based vehicle assignment
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the car
    ///   - completion: Closure with information wheather vehicle rifable
    func addVehicleVIN(finOrVin: String, completion: @escaping AssignmentService.RifResult)
    
    /// Check if the vehicle can receive vac's
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the car
    ///   - completion: Closure with information wheather vehicle rifable
    func canCarReceiveVACs(finOrVin: String, completion: @escaping AssignmentService.RifResult)
    
    /// Confirm the vehicle assignment
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the car
    ///   - vac: VAC of assigment process
    ///   - completion: Completion with AssignmentResult
    ///   - onPreconditionFailed: Precondition fails for this assignment
    func confirmVehicle(finOrVin: String, vac: String, completion: @escaping AssignmentService.AssignmentResult, onPreconditionFailed: @escaping AssignmentService.AssignmentPreconditionResult)
    
    /// Unassign a vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the car
    ///   - completion: Completion with AssignmentResult
    func deleteVehicle(finOrVin: String, completion: @escaping AssignmentService.AssignmentResult)
}

public extension AssignmentServiceRepresentable {
    
    func addVehicleQR(link: String, completion: @escaping AssignmentService.AssignmentFinishResult, onPreconditionFailed: @escaping AssignmentService.AssignmentPreconditionResult) {}
    func addVehicleVIN(finOrVin: String, completion: @escaping AssignmentService.RifResult) {}
    func canCarReceiveVACs(finOrVin: String, completion: @escaping AssignmentService.RifResult) {}
    func confirmVehicle(finOrVin: String, vac: String, completion: @escaping AssignmentService.AssignmentResult, onPreconditionFailed: @escaping AssignmentService.AssignmentPreconditionResult) {}
    func deleteVehicle(finOrVin: String, completion: @escaping AssignmentService.AssignmentResult) {}
}
