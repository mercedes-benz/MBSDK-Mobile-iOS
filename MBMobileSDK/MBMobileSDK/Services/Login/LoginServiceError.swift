//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import MBNetworkKit
import MBCommonKit

/// An Error that can occur during the login, logout, or other
/// login related functionality.
public enum LoginServiceError: Error {
    
    /// errors during registration
    case registration(RegistrationError)
    
    /// error when asking the back-end of the user does exist
    case userNotFound(UserExistModel, AuthenticationType)
    
    /// error when trying to initiate a login (e.g. check if user exists)
    case initiateLoginDidFail(Error?)
    
    case fetchUserError(UserServiceError)
    
    /// the user login did fail
    case loginDidFail(Error?)
    
    /// the user login did fail because the given pin was invalid
    case loginDidFailWithInvalidPin
    
    /// trying to login with a required pin, but the pin was not available or was malformed
    case loginWithoutRequiredPin(String?)
    
    /// the user logout did fail
    case logoutDidFail(Error?)
    
    /// logout at bff was successfuly but deleting user from store failed
    case logoutDeleteUserFromDB
    
    /// a logout flow is already in progress
    case logoutAlreadyInProgress
    
    case noValidLoginProviderAvailable(AuthenticationType?, [AuthenticationType])
    
    /// an unknown error occured
    case unknown
}
