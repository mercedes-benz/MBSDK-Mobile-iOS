//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBRealmKit

/// Representation of a service activation
public struct VehicleServiceModel {

	public let activationStatus: ServiceActivationStatus
	public let allowedActions: [ServiceAction]
	public let description: String
	let finOrVin: String
	public let missingData: VehicleServiceMissingDataModel?
    public let name: String
    public let serviceId: Int
    public let shortName: String?
	public let rights: [ServiceRight]
	
	// MARK: - Deprecated
	
	@available(*, deprecated, message: "Please use property missingData instead.")
	public let prerequisites: [VehicleServicePrerequisiteModel]
	
	
	// MARK: - Init
	
	public init(
		activationStatus: ServiceActivationStatus,
		allowedActions: [ServiceAction],
		description: String,
		finOrVin: String,
		id: Int,
		missingData: VehicleServiceMissingDataModel?,
		name: String,
		prerequisites: [VehicleServicePrerequisiteModel],
		shortName: String?,
		rights: [ServiceRight]) {
		
		self.activationStatus = activationStatus
		self.allowedActions = allowedActions
		self.description = description
		self.finOrVin = finOrVin
		self.missingData = missingData
		self.name = name
		self.prerequisites = prerequisites
		self.serviceId = id
		self.shortName = shortName
		self.rights = rights
	}
}


// MARK: - Entity

extension VehicleServiceModel: Entity {
	
	public var id: String {
		return self.finOrVin + "_" + "\(self.serviceId)"
	}
}


// MARK: - Extension

extension VehicleServiceModel {
	
	public var additionalActionHints: String {
		return self.allowedActions.filter({ [.accountLinkage, .setDesiredActive, .setDesiredInactive].contains($0) == false }).reduce("", { "\($0)\($1), " })
	}
	
	public var isActivable: Bool {
		return self.activationStatus == .inactive &&
			self.allowedActions.contains(.setDesiredActive) &&
			self.rights.contains(.activate)
	}
	
	public var isActive: Bool {
		return [.active, .activationPending].contains(self.activationStatus)
	}
	
	public var isDeactivable: Bool {
		return self.activationStatus == .active &&
			self.allowedActions.contains(.setDesiredInactive) &&
			self.rights.contains(.deactivate)
	}
	
	public var needsAdditionalAction: Bool {
		return self.allowedActions.contains {
			switch $0 {
			case .accountLinkage:		return false
			case .editUserProfile:		return true
			case .purchaseLicense:		return true
			case .removeFuseboxEntry:	return true
			case .setCustomProperty:	return true
			case .setDesiredActive:		return false
			case .setDesiredInactive:	return false
			case .signUserAgreement:	return true
			case .updateTrustLevel:		return true
			}
		}
	}
	
	public var pendingState: ServicePendingState {
		switch self.activationStatus {
		case .activationPending:			return .activation
		case .active:						return .none
		case .deactivationPending:			return .deactivation
		case .inactive:						return .none
		case .unknown:						return .none
		}
	}

	public var hasPreconditions: Bool {
		return self.prerequisites.first(where: { $0.name != .consent }) != nil
	}
}
