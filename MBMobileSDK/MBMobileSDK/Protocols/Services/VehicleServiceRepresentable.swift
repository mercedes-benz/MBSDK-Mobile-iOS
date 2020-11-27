//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

public protocol VehicleServiceRepresentable {
    
    /// Gets an acceptance from the user and verifies whether to go ahead with the automatic valet parking drive or not
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - requestModel: AcceptAVPDriveModel
    ///   - completion: Closure with Result object
    func automaticValetParking(finOrVin: String, requestModel: AcceptAVPDriveModel, completion: @escaping VehicleService.AutomaticValetParkingCompletion)
    
    /// Fetch reservation status for automated valet parking by certarin reservation identifiers
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - reservationIds: An array of reservation identifiers
    ///   - completion: Closure with an array of AVPReservationStatusModel
    func avpReservationStatus(finOrVin: String, reservationIds: [String], completion: @escaping VehicleService.AVPReservationStatusCompletion)
    
    /// Fetch the assigned users with basic information (Owner, Subuser)
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - completion: Closure with consumption data of the vehicle
    func fetchVehicleAssignedUsers(finOrVin: String, completion: @escaping VehicleService.VehicleAssignedUserSucceeded)
    
    /// Fetch invitation qr code for vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - profileId: profile id of the vehicle
    ///   - completion: Closure with data of the qr code
    func qrCodeInviteForVehicle(finOrVin: String, profileId: VehicleProfileID, completion: @escaping VehicleService.VehicleQrCodeInvitationCompletion)
    
    /// Fetch the command capabilities of the vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - completion: Closure with a array of command capabilities of the vehcile
    func fetchCommandCapabilities(finOrVin: String, completion: @escaping VehicleService.CommandCapabilitiesResult)
    
    /// Fetch the consumption history and information about the vehicle and the model (Baumuster)
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - completion: Closure with consumption data of the vehicle
    func fetchConsumption(finOrVin: String, completion: @escaping VehicleService.ConsumptionResult)
    
    /// Fetch the vehicle data and update the cache immediately
    ///
    /// - Parameters:
    ///   - completion: Optional closure with vehicle data
    func fetchVehicles(completion: VehicleService.VehiclesCompletion?)
    
    /// Fetch the vehicle data at and select the first vehicle in data set
    ///
    /// - Parameters:
    ///   - completion: Closure with optional vehicle identifier
    func instantSelectVehicle(completion: @escaping (String?) -> Void)
    
    /// Removes the Subuser from the vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - authorizationID: Authorization id from the user to remove
    ///   - completion: Closure with Result object
    func removeUserAuthorization(finOrVin: String, authorizationID: String, completion: @escaping VehicleService.RemoveUserAuthorizationCompletion)
    
    /// Reset damage detection for a vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - completion: Closure
    func resetDamageDetection(finOrVin: String, completion: @escaping VehicleService.DamageDetectionCompletion)
    
    /// Set the profile sync of the vehicle
    ///
    /// - Parameters:
    ///   - enabled: Bool if the profile sync should be enabled or disabled
    ///   - finOrVin: fin or vin of the vehicle
    ///   - completion: Closure with Result object
    func setProfileSync(enabled: Bool, finOrVin: String, completion: @escaping VehicleService.SetProfileSyncCompletion)
    
    /// Get the sync state of pin for vehicle
    ///
    /// - Parameters:
    /// - finOrVin: The fin or vin of the vehicle
    /// - completion: Closure with pin status enum
    func getPinSyncState(finOrVin: String, completion: @escaping VehicleService.PinSyncStatusCompletion)
    
    /// Get the sync state of profile for vehicle
    ///
    /// - Parameters:
    /// - finOrVin: The fin or vin of the vehicle
    /// - completion: Closure with profile status enum
    func getProfileSyncState(finOrVin: String, completion: @escaping VehicleService.ProfileSyncStatusCompletion)
    
    /// Gets information about software updated for given FIN or VIN
    ///
    /// - Parameters:
    /// - finOrVin: The fin or vin of the vehicle
    /// - locale: Format [ISO 639-1]-[ISO 3166 ALPHA2]. Valid examples: de-DE, zh-CN.
    /// - completion: Closure with Result object
    func getSoftwareUpdate(finOrVin: String, locale: String, completion: @escaping (Result<SoftwareUpdateModel, VehicleServiceError>) -> Void)
    
    /// Update the license plate of a given vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: The fin or Vin of the car
    ///   - completion: Closure with Result object
    func updateLicense(finOrVin: String, licensePlate: String, completion: @escaping VehicleService.VehicleUpdateCompletion)
    
    /// Update the preferred dealers of a given vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: The fin or Vin of the car
    ///   - completion: Closure with Result object
    func updatePreferredDealer(finOrVin: String, preferredDealers: [VehicleDealerUpdateModel], completion: @escaping VehicleService.VehicleUpdateCompletion)
    
    /// Upgrades the temporary user to a sub user
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - authorizationID: Authorization id from the user to remove
    ///   - completion: Closure with Result object
    func upgradeTemporaryUser(authorizationID: String, finOrVin: String, completion: @escaping VehicleService.UpgradeTemporaryUserCompletion)
	
	/// Get the status of normalized profile control
    ///
    /// - Parameters:
    ///   - completion: Closure with NormalizedProfileControlModel
	func getNormalizedProfileControl(completion: @escaping VehicleService.NormalizedProfileControlCompletion)
	
	/// Set the status of normalized profile control
    ///
    /// - Parameters:
    ///   - enabled: Bool if the normalized profile control should be enabled or disabled
    ///   - completion: Closure with Result object
	func setNormalizedProfileControl(enabled: Bool, completion: @escaping VehicleService.SetNormalizedProfileControlCompletion)
	
}

public extension VehicleServiceRepresentable {
    
    func automaticValetParking(finOrVin: String, requestModel: AcceptAVPDriveModel, completion: @escaping VehicleService.AutomaticValetParkingCompletion) {}
    func avpReservationStatus(finOrVin: String, reservationIds: [String], completion: @escaping VehicleService.AVPReservationStatusCompletion) {}
    func fetchVehicleAssignedUsers(finOrVin: String, completion: @escaping VehicleService.VehicleAssignedUserSucceeded) {}
    func qrCodeInviteForVehicle(finOrVin: String, profileId: VehicleProfileID, completion: @escaping VehicleService.VehicleQrCodeInvitationCompletion) {}
    func fetchCommandCapabilities(finOrVin: String, completion: @escaping VehicleService.CommandCapabilitiesResult) {}
    func fetchConsumption(finOrVin: String, completion: @escaping VehicleService.ConsumptionResult) {}
    func fetchVehicles(completion: VehicleService.VehiclesCompletion?) {}
    func instantSelectVehicle(completion: @escaping (String?) -> Void) {}
    func removeUserAuthorization(finOrVin: String, authorizationID: String, completion: @escaping VehicleService.RemoveUserAuthorizationCompletion) {}
    func resetDamageDetection(finOrVin: String, completion: @escaping VehicleService.DamageDetectionCompletion) {}
    func setProfileSync(enabled: Bool, finOrVin: String, completion: @escaping VehicleService.SetProfileSyncCompletion) {}
    func getPinSyncState(finOrVin: String, completion: @escaping VehicleService.PinSyncStatusCompletion) {}
    func updateLicense(finOrVin: String, licensePlate: String, completion: @escaping VehicleService.VehicleUpdateCompletion) {}
    func updatePreferredDealer(finOrVin: String, preferredDealers: [VehicleDealerUpdateModel], completion: @escaping VehicleService.VehicleUpdateCompletion) {}
    func upgradeTemporaryUser(authorizationID: String, finOrVin: String, completion: @escaping VehicleService.UpgradeTemporaryUserCompletion) {}
	func getNormalizedProfileControl(completion: @escaping VehicleService.NormalizedProfileControlCompletion) {}
	func setNormalizedProfileControl(enabled: Bool, completion: @escaping VehicleService.SetNormalizedProfileControlCompletion) {}
	
}
