//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import MBNetworkKit

public protocol OnboardGeofencingServiceRepresentable {
    
    /// Get all the customerfences for given FIN or VIN
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    func fetchCustomerFences(finOrVin: String, completion: @escaping (Result<[CustomerFenceModel], OnboardGeofencingError>) -> Void)
    
    /// Creates customerfences for given FIN or VIN
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - customerFences: array of customerfence to create
    func createCustomerFences(finOrVin: String, customerFences: [CustomerFenceModel], completion: @escaping (Result<Void, OnboardGeofencingError>) -> Void)
    
    /// Updates customerfences for given FIN or VIN
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - customerFences: array of customerfence to update
    func updateCustomerFences(finOrVin: String, customerFences: [CustomerFenceModel], completion: @escaping (Result<Void, OnboardGeofencingError>) -> Void)
    
    /// Deletes customerfences for given FIN or VIN
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - ids: ids of customerfence to delete
    func deleteCustomerFences(finOrVin: String, ids: [Int], completion: @escaping (Result<Void, OnboardGeofencingError>) -> Void)
    
    /// Get all the customerfences violations for given FIN or VIN
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    func fetchCustomerFenceViolations(finOrVin: String, completion: @escaping (Result<[CustomerFenceViolationModel], OnboardGeofencingError>) -> Void)
    
    /// Deletes customerfences violations for given FIN or VIN
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - ids: ids of customerfence violations to delete
    func deleteCustomerFenceViolations(finOrVin: String, ids: [Int], completion: @escaping (Result<Void, OnboardGeofencingError>) -> Void)
    
    /// Get all the onboardfences for given FIN or VIN
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    func fetchOnboardFences(finOrVin: String, completion: @escaping (Result<[OnboardFenceModel], OnboardGeofencingError>) -> Void)
    
    /// Creates onboardfences for given FIN or VIN
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - onboardFences: array of customerfence to create
    func createOnboardFences(finOrVin: String, onboardFences: [OnboardFenceModel], completion: @escaping (Result<Void, OnboardGeofencingError>) -> Void)
    
    /// Updates onboardfences for given FIN or VIN
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - onboardFences: array of customerfence to update
    func updateOnboardFences(finOrVin: String, onboardFences: [OnboardFenceModel], completion: @escaping (Result<Void, OnboardGeofencingError>) -> Void)
    
    /// Deletes onboardfences for given FIN or VIN
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - ids: ids of customerfence to delete
    func deleteOnboardFences(finOrVin: String, ids: [Int], completion: @escaping (Result<Void, OnboardGeofencingError>) -> Void)
}
