//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of auxheat warning bitmask
public struct AuxheatWarningBitmask: RawRepresentable {
	
	public let rawValue: Int
	
	
	// MARK: - Public
	
	public var isBudgetEmpty: Bool {
		return self.has(state: .budgetEmpty)
	}
	public var isCommunicationError: Bool {
		return self.has(state: .communicationError)
	}
	public var isFuelOnReserve: Bool {
		return self.has(state: .fuelOnReserve)
	}
	public var isLowVoltage: Bool {
		return self.has(state: .lowVoltage)
	}
	public var isLowVoltageOperation: Bool {
		return self.has(state: .lowVoltageOperation)
	}
	public var isNoBudget: Bool {
		return self.has(state: .noBudget)
	}
	public var isNone: Bool {
		return self.has(state: .none)
	}
	public var isReserveReached: Bool {
		return self.has(state: .reserveReached)
	}
	public var isRunningError: Bool {
		return self.has(state: .runningError)
	}
	public var isSystemError: Bool {
		return self.has(state: .systemError)
	}
	public var state: AuxheatWarningState? {
		return AuxheatWarningState(rawValue: self.rawValue)
	}
	
	
	// MARK: - Init
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	
	// MARK: - Helper
	
	private func has(state: AuxheatWarningState) -> Bool {
		return self.rawValue & state.rawValue == state.rawValue
	}
}
