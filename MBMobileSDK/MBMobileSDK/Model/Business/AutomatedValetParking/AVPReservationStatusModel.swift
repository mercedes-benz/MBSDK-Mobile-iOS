//
//  Copyright © 2020 Daimler AG. All rights reserved.
//

import Foundation

/// Reservation status model of Automated Valet Parking
public struct AVPReservationStatusModel {
    
    /// Reservation identifier
    public let reservationId: String
    
    /// Drive type of a reservation
    public let driveType: AutomaticValetParkingDriveType?
    
    /// Drive status of a reservation
    public let driveStatus: AutomatedValetParkingDriveStatus
    
    public let errorIds: [String]?
    
    /// Estimated arrival time
    public let estimatedTimeOfArrival: Date?
    
    /// Parked location
    public let parkedLocation: String?
    
    public init(reservationId: String,
                driveType: AutomaticValetParkingDriveType?,
                driveStatus: AutomatedValetParkingDriveStatus,
                errorIds: [String]? = nil,
                estimatedTimeOfArrival: Date? = nil,
                parkedLocation: String? = nil) {
        self.reservationId = reservationId
        self.driveType = driveType
        self.driveStatus = driveStatus
        self.errorIds = errorIds
        self.estimatedTimeOfArrival = estimatedTimeOfArrival
        self.parkedLocation = parkedLocation
    }
    
}
