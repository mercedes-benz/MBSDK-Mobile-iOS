//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - ProtectionStatus

/// State for protection attribute
public enum ProtectionStatus: Int, Codable, CaseIterable {
	case notActiveSelect = 0
	case notActiveNotSelect = 1
	case active = 2
}

extension ProtectionStatus {
	
	public var toString: String {
		switch self {
		case .active:				return "active"
		case .notActiveNotSelect:	return "not ac, not sel"
		case .notActiveSelect:		return "not ac, sel"
		}
	}
}


// MARK: - TheftWarningReason

/// Detail status for theft warning reason
public enum TheftWarningReason: Int, Codable, CaseIterable {
    case noAlarm = 0
    case basisAlarm = 16
    case doorFrontLeft = 17
    case doorFrontRight = 18
    case doorRearLeft = 19
    case doorRearRight = 20
    case hood = 21
    case decklid = 22
    case commonAlmIn = 23
    case panic = 26
    case glovebox = 27
    case centerbox = 28
    case rearbox = 29
    case sensorVta = 32
    case its = 33
    case itsSlv = 34
    case tps = 35
    case siren = 36
    case holdCom = 37
    case remote = 38
    case exitIts1 = 42
    case exitIts2 = 43
    case exitIts3 = 44
    case exitIts4 = 45
}

extension TheftWarningReason {
    
    public var toString: String {
        switch self {
        case .basisAlarm:       return "basis alarm"
        case .centerbox:        return "centerbox"
        case .commonAlmIn:      return "common alm in"
        case .decklid:          return "decklid"
        case .doorFrontLeft:    return "left front door"
        case .doorFrontRight:   return "right front door"
        case .doorRearLeft:     return "rear left door"
        case .doorRearRight:    return "rear right door"
        case .exitIts1:         return "exit ITS 1"
        case .exitIts2:         return "exit ITS 2"
        case .exitIts3:         return "exit ITS 3"
        case .exitIts4:         return "exit ITS 4"
        case .glovebox:         return "glovebox"
        case .holdCom:          return "hold com"
        case .hood:             return "hood"
        case .its:              return "ITS"
        case .itsSlv:           return "ITS SLV"
        case .noAlarm:          return "no alarm"
        case .panic:            return "panic"
        case .rearbox:          return "rearbox"
        case .remote:           return "remote"
        case .sensorVta:        return "sensor VTA"
        case .siren:            return "siren"
        case .tps:              return "TPS"
        }
    }
}
