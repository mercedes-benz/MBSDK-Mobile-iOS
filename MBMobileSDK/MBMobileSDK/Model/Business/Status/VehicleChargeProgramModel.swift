//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of a charge program
public struct VehicleChargeProgramModel {
    
    /// Denotes whether the charge cable should be unlocked automatically
    /// if the HV battery is fully charged resp. charged until [maxSoc] value.
    public let autoUnlock: Bool
    /// The charging program.
    public let chargeProgram: ChargingProgram
    public let clockTimer: Bool
    /// True if ECO charging mode is activated.
    public let ecoCharging: Bool
    /// Automatically switch between home and work program, based on the location of the car.
    public let locationBasedCharging: Bool
    /// Current max charging amount.
    public let maxChargingCurrent: Int
    /// Values need to be between 50 and 100 and divisible by ten.
    /// Maximum value for the state of charge of the HV battery [in %].
    /// Valid value range = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100].
    public let maxSoc: Int
    public let weeklyProfile: Bool
}
