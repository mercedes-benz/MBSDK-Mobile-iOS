//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

public protocol ServicesServiceRepresentable {
    
    /// Fetch the vehicle data and update the cache immediately
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the car
    ///   - groupedOption: enum based sort option for the service groups
    ///   - requestsMissingData: requests the missing data of a service. This request need more time. Please use this option pretty rare.
    ///   - services: get status for id based services
    ///   - completion: Closure with ServicesGroupCompletion
	func fetchVehicleServices(finOrVin: String, groupedOption: ServiceGroupedOption, requestsMissingData: Bool, services: [Int]?, completion: @escaping ServicesService.ServicesGroupCompletion)
    
    /// Change the service activation status for given services
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the car
    ///   - models: Array of services to be changed
    ///   - completion: Void closure
    func requestServiceActivationChanges(finOrVin: String, models: [VehicleServiceModel], completion: @escaping ServicesService.ServiceUpdateCompletion)
    
    /// Observe the status of a service
    ///
    /// - Parameters:
    ///   - serviceId: Identifier of the service
    ///   - finOrVin: fin or vin of the car
    ///   - completion: Closure with VehicleServiceModel
    func observeService(by id: Int, finOrVin: String, completion: @escaping ServicesService.ServiceCompletion)
    
    /// Observe the status of multiple services
    ///
    /// - Parameters:
    ///   - serviceIds: Identifiers of the service
    ///   - finOrVin: fin or vin of the car
    ///   - completion: Closure with ResultsServicesProvider
    func observeServices(by serviceIds: [Int], finOrVin: String, completion: @escaping (ResultsServicesProvider) -> Void)
    
    /// Unregister the observer for a service. Do this in the deinitilizer of your class.
    func unregisterServiceObserver()
    
    /// Unregister the observer for multiple services. Do this in the deinitilizer of your class.
    func unregisterServicesObserver()
}

public extension ServicesServiceRepresentable {
    
	func fetchVehicleServices(finOrVin: String, groupedOption: ServiceGroupedOption, requestsMissingData: Bool, services: [Int]?, completion: @escaping ServicesService.ServicesGroupCompletion) {}
    func requestServiceActivationChanges(finOrVin: String, models: [VehicleServiceModel], completion: @escaping ServicesService.ServiceUpdateCompletion) {}
    func observeService(by id: Int, finOrVin: String, completion: @escaping ServicesService.ServiceCompletion) {}
    func unregisterServiceObserver() {}
}
