//
//
// Copyright © 2020 Mercedes-Benz AG. All rights reserved.
//

import MBNetworkKit

/// Error cases for vehicle services
public enum VehicleServiceError: Error {
  
    /// vehicle for given VIN not found in DB
    case vehicleForVinNotFound
    
    /// an invalid assignment on vehicle selection
    case invalidAssignment
    
    /// an error duing database operations
    case dbOperationError
    
    /// token refresh was not successful
    case tokenRefreshError
    
    /// network operation failed
    case network(MBError?)
    
}
