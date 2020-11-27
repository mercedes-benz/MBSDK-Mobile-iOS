// THIS FILE IS GENERATED - DO NOT EDIT!
// The generator can be found at https://git.daimler.com/RisingStars/commons-go-lib/tree/master/gen
//
// swiftlint:disable all

import Foundation
import SwiftProtobuf

/// GenericCommandError represents errors that are relevant to all commands
public enum GenericCommandError: CustomStringConvertible, CommandErrorProtocol {
    
    /// Command failed. Normally, there should be additional business errors detailing what exactly went wrong
    case commandFailed
    
    /// The command is not available for the specified vehicle
    case commandUnavailable
    
    /// a general error and the `message` field of the VehicleAPIError struct should be checked for more information
    case couldNotSendCommand
    
    /// returned if the service(s) for the requested command are not active
	/// - serviceId: The id of the service which needs to be activated. 
    case inactiveServices(serviceId: Int)
    
    /// Received an invalid condition
    case invalidCondition
    
    /// Should never happen due to migration guide
    case invalidStatus
    
    /// The client does not have an internet connection and therefore the command could not be sent.
    case noInternetConnection
    
    /// No vehicle was selected
    case noVehicleSelected
    
    /// Command was overwritten in queue
    case overwritten
    
    /// The user cancelled the PIN input. The command is therefore not transmitted and not executed.
    case pinInputCancelled
    
    /// returned if the given PIN does not match the one saved in CPD
	/// - attempt: Count of the attempt to enter the valid user PIN. Will be set to zero if the user has provided a valid PIN. 
    case pinInvalid(attempt: Int)
    
    /// The pin provider was not configured, but a PIN is needed for this command.
    case pinProviderMissing
    
    /// returned if the user tried to send a sensitive command that requires a PIN but didn't provide one
    case pinRequired
    
    /// Command was rejected due to a blocked command queue. This can happen if another user is executing a similar command.
    case rejectedByQueue
    
    /// Command was forcefully terminated
    case terminated
    
    /// Failed due to timeout
    case timeout
    
    /// returned if an unknown error has occurred. Should never happen, so let us know if you see this error
	/// - message: A message which might have more details 
    case unknownError(message: String)
    
    /// The status of the command is unknown. returned if the state of a given command could not be polled. When polling for the state of a command only the last running or currently running command status is returned. If the app is interested in the status of a previous command for any reason and the state cannot be determined this error is returned
    case unknownStatus
    
    /// is returned if there was an error in polling the command state. E.g. 4xx/5xx response codes from the vehicleAPI
    case unknownStatusDueToPollError
    
    /// returned if the command request contains a command type that is not yet supported by the AppTwin
    case unsupportedCommand
    
    /// command is not supported by the currently selected environment
    case unsupportedStage
    
    /// returned if the CIAM ID is currently blocked from sending sensitive commands e.g. Doors Unlock due to too many PIN attempts
	/// - attempt: Count of the attempt to enter the valid user PIN. Will be set to zero if the user has provided a valid PIN. 
	/// - blockedUntil: Unix timestamp in seconds indicating the moment in time from when the user is allowed to try another PIN. 
    case userBlocked(attempt: Int, blockedUntil: Int)
    
    /// Returned if the input parameters of the command did not pass validation. The payload should indicate what went wrong
	/// - fields: A map from fields that did not pass validation 
    case validationFailed(fields: [String: String])
    
    /// returned if a command request is received for a VIN that is not assigned to the ciam id of the current user
    case vehicleNotAssigned
    
	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> GenericCommandError {
	    switch code { 
        case "CMD_FAILED": return .commandFailed
        case "CMD_INVALID_CONDITION": return .invalidCondition
        case "CMD_INVALID_STATUS": return .invalidStatus
        case "CMD_OVERWRITTEN": return .overwritten
        case "CMD_REJECTED_BY_QUEUE": return .rejectedByQueue
        case "CMD_TERMINATED": return .terminated
        case "CMD_TIMEOUT": return .timeout
        case "COMMAND_UNAVAILABLE": return .commandUnavailable
        case "NO_INTERNET_CONNECTION": return .noInternetConnection
        case "NO_VEHICLE_SELECTED": return .noVehicleSelected
        case "PIN_INPUT_CANCELLED": return .pinInputCancelled
        case "PIN_PROVIDER_MISSING": return .pinProviderMissing
        case "RIS_CIAM_ID_BLOCKED": return .userBlocked(attempt: Int(attributes["attempt"]?.numberValue ?? 0), blockedUntil: Int(attributes["blocked_until"]?.numberValue ?? 0))
        case "RIS_COULD_NOT_SEND_COMMAND": return .couldNotSendCommand
        case "RIS_EMPTY_VEHICLE_API_QUEUE": return .unknownStatus
        case "RIS_FORBIDDEN_VIN": return .vehicleNotAssigned
        case "RIS_INACTIVE_SERVICES": return .inactiveServices(serviceId: Int(attributes["serviceId"]?.numberValue ?? 0))
        case "RIS_PIN_INVALID": return .pinInvalid(attempt: Int(attributes["attempt"]?.numberValue ?? 0))
        case "RIS_PIN_REQUIRED": return .pinRequired
        case "RIS_UNKNOWN_ERROR": return .unknownError(message: attributes["message"]?.stringValue ?? "")
        case "RIS_UNSUPPORTED_COMMAND": return .unsupportedCommand
        case "RIS_UNSUPPORTED_ENVIRONMENT": return .unsupportedStage
        case "RIS_VALIDATION_FAILED": return .validationFailed(fields: attributes.mapValues{ $0.stringValue })
        case "RIS_VEHICLE_API_POLLING": return .unknownStatusDueToPollError
        default: return .unknownError(message: message)
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		return self
	}

	public var description: String {
		switch self { 
        case .commandFailed: return "commandFailed"
        case .commandUnavailable: return "commandUnavailable"
        case .couldNotSendCommand: return "couldNotSendCommand"
        case .inactiveServices(_): return "inactiveServices"
        case .invalidCondition: return "invalidCondition"
        case .invalidStatus: return "invalidStatus"
        case .noInternetConnection: return "noInternetConnection"
        case .noVehicleSelected: return "noVehicleSelected"
        case .overwritten: return "overwritten"
        case .pinInputCancelled: return "pinInputCancelled"
        case .pinInvalid(_): return "pinInvalid"
        case .pinProviderMissing: return "pinProviderMissing"
        case .pinRequired: return "pinRequired"
        case .rejectedByQueue: return "rejectedByQueue"
        case .terminated: return "terminated"
        case .timeout: return "timeout"
        case .unknownError(_): return "unknownError"
        case .unknownStatus: return "unknownStatus"
        case .unknownStatusDueToPollError: return "unknownStatusDueToPollError"
        case .unsupportedCommand: return "unsupportedCommand"
        case .unsupportedStage: return "unsupportedStage"
        case .userBlocked(_, _): return "userBlocked"
        case .validationFailed(_): return "validationFailed"
        case .vehicleNotAssigned: return "vehicleNotAssigned"
        }
	}
}


/// All possible error codes for the AuxHeatConfigure command version v1
public enum AuxHeatConfigureError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Processing of auxheat command failed
    case auxheatCommandFailed

    /// Fastpath timeout
    case fastpathTimeout

    /// Incomplete values
    case incompleteValues

    /// NULL/INF values
    case nullOrInfiniteValues

    /// Service not authorized
    case serviceNotAuthorized

    /// Syntax error
    case syntaxError

    /// Value out of range
    case valueOutOfRange

    /// Value overflow
    case valueOverflow

    /// Wrong data type
    case wrongDataType

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> AuxHeatConfigureError {
	    switch code { 
        case "100": return .valueOutOfRange
        case "105": return .wrongDataType
        case "110": return .valueOverflow
        case "115": return .incompleteValues
        case "120": return .syntaxError
        case "125": return .nullOrInfiniteValues
        case "4061": return .auxheatCommandFailed
        case "4062": return .serviceNotAuthorized
        case "42": return .fastpathTimeout
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .auxheatCommandFailed: return "auxheatCommandFailed"
        case .fastpathTimeout: return "fastpathTimeout"
        case .incompleteValues: return "incompleteValues"
        case .nullOrInfiniteValues: return "nullOrInfiniteValues"
        case .serviceNotAuthorized: return "serviceNotAuthorized"
        case .syntaxError: return "syntaxError"
        case .valueOutOfRange: return "valueOutOfRange"
        case .valueOverflow: return "valueOverflow"
        case .wrongDataType: return "wrongDataType"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.AuxHeatConfigure: BaseCommandProtocol {

	public typealias Error = AuxHeatConfigureError

	public func createGenericError(error: GenericCommandError) -> AuxHeatConfigureError {
		return AuxHeatConfigureError.genericError(error: error)
	}
}

extension Command.AuxHeatConfigure: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the AuxHeatStart command version v1
public enum AuxHeatStartError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Processing of auxheat command failed
    case auxheatCommandFailed

    /// Fastpath timeout
    case fastpathTimeout

    /// Service not authorized
    case serviceNotAuthorized

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> AuxHeatStartError {
	    switch code { 
        case "4061": return .auxheatCommandFailed
        case "4062": return .serviceNotAuthorized
        case "42": return .fastpathTimeout
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .auxheatCommandFailed: return "auxheatCommandFailed"
        case .fastpathTimeout: return "fastpathTimeout"
        case .serviceNotAuthorized: return "serviceNotAuthorized"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.AuxHeatStart: BaseCommandProtocol {

	public typealias Error = AuxHeatStartError

	public func createGenericError(error: GenericCommandError) -> AuxHeatStartError {
		return AuxHeatStartError.genericError(error: error)
	}
}

extension Command.AuxHeatStart: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the AuxHeatStop command version v1
public enum AuxHeatStopError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Processing of auxheat command failed
    case auxheatCommandFailed

    /// Fastpath timeout
    case fastpathTimeout

    /// Service not authorized
    case serviceNotAuthorized

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> AuxHeatStopError {
	    switch code { 
        case "4061": return .auxheatCommandFailed
        case "4062": return .serviceNotAuthorized
        case "42": return .fastpathTimeout
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .auxheatCommandFailed: return "auxheatCommandFailed"
        case .fastpathTimeout: return "fastpathTimeout"
        case .serviceNotAuthorized: return "serviceNotAuthorized"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.AuxHeatStop: BaseCommandProtocol {

	public typealias Error = AuxHeatStopError

	public func createGenericError(error: GenericCommandError) -> AuxHeatStopError {
		return AuxHeatStopError.genericError(error: error)
	}
}

extension Command.AuxHeatStop: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the AutomaticValetParkingActivate command version v1
public enum AutomaticValetParkingActivateError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Failed due to another car steered by system currently
    case anotherCarSteeredCurrently

    /// Failed due to brake fluid lamp on during drive
    case brakeFluid

    /// Failed due to not locked car
    case carNotLocked

    /// Failed due to charging cable plugged
    case chargingCablePlugged

    /// Failed due to door is open
    case doorOpen

    /// The gear is not in Parking position
    case gearNotInPark

    /// Failed due to hood is open
    case hoodOpen

    /// Failed due to ignition is on
    case ignitionOn

    /// Failed due to key button pressed during drive
    case keyButtonPressed

    /// Lock request not authorized
    case lockNotAuthorized

    /// Maintance planned
    case maintenance

    /// Failed due to no user acceptence
    case noUserAcceptance

    /// Failed due to vehicle not on drop off zone
    case notInDropOffZone

    /// Failed due to someone detected inside vehicle
    case personDetected

    /// Failed due to reservation already used
    case reservationAlreadyUsed

    /// Failed due to reservation in the past
    case reservationInPast

    /// Service not authorized
    case serviceNotAuthorized

    /// Service currently not available
    case serviceUnavailable

    /// Failed due to detection of snow chains
    case snowChainsDetected

    /// Failed due to sunroof is open
    case sunroofOpen

    /// Failed due to tank level too low
    case tankLevelLow

    /// Failed due to too low tank level during drive
    case tankLevelLowDrive

    /// Technical error, retry possible
    case technicalError

    /// Severe technical error, no retries
    case technicalErrorNoRetry

    /// Failed due to too low tire pressure
    case tirePressureLow

    /// Failed due to convertible top is open
    case topOpen

    /// Failed due to detection of trailor
    case trailerDetected

    /// Failed due to detection of trailer hitch
    case trailerHitchDetected

    /// Failed due to trunk lid is open
    case trunkOpen

    /// Failed due to vehicle movement
    case vehicleMovement

    /// Failed due to window is open
    case windowOpen

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> AutomaticValetParkingActivateError {
	    switch code { 
        case "2001": return .technicalError
        case "2002": return .technicalErrorNoRetry
        case "2004": return .serviceNotAuthorized
        case "2005": return .reservationAlreadyUsed
        case "2006": return .reservationInPast
        case "2010": return .sunroofOpen
        case "2011": return .topOpen
        case "2012": return .personDetected
        case "2013": return .ignitionOn
        case "2014": return .gearNotInPark
        case "2015": return .trailerDetected
        case "2016": return .doorOpen
        case "2017": return .trunkOpen
        case "2018": return .hoodOpen
        case "2019": return .windowOpen
        case "2020": return .snowChainsDetected
        case "2021": return .trailerHitchDetected
        case "2022": return .tirePressureLow
        case "2023": return .vehicleMovement
        case "2024": return .carNotLocked
        case "2025": return .chargingCablePlugged
        case "2026": return .tankLevelLow
        case "3001": return .notInDropOffZone
        case "3002": return .anotherCarSteeredCurrently
        case "3003": return .maintenance
        case "3004": return .serviceUnavailable
        case "3051": return .personDetected
        case "3052": return .brakeFluid
        case "3053": return .keyButtonPressed
        case "3054": return .lockNotAuthorized
        case "3055": return .tankLevelLowDrive
        case "3056": return .noUserAcceptance
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .anotherCarSteeredCurrently: return "anotherCarSteeredCurrently"
        case .brakeFluid: return "brakeFluid"
        case .carNotLocked: return "carNotLocked"
        case .chargingCablePlugged: return "chargingCablePlugged"
        case .doorOpen: return "doorOpen"
        case .gearNotInPark: return "gearNotInPark"
        case .hoodOpen: return "hoodOpen"
        case .ignitionOn: return "ignitionOn"
        case .keyButtonPressed: return "keyButtonPressed"
        case .lockNotAuthorized: return "lockNotAuthorized"
        case .maintenance: return "maintenance"
        case .noUserAcceptance: return "noUserAcceptance"
        case .notInDropOffZone: return "notInDropOffZone"
        case .personDetected: return "personDetected"
        case .reservationAlreadyUsed: return "reservationAlreadyUsed"
        case .reservationInPast: return "reservationInPast"
        case .serviceNotAuthorized: return "serviceNotAuthorized"
        case .serviceUnavailable: return "serviceUnavailable"
        case .snowChainsDetected: return "snowChainsDetected"
        case .sunroofOpen: return "sunroofOpen"
        case .tankLevelLow: return "tankLevelLow"
        case .tankLevelLowDrive: return "tankLevelLowDrive"
        case .technicalError: return "technicalError"
        case .technicalErrorNoRetry: return "technicalErrorNoRetry"
        case .tirePressureLow: return "tirePressureLow"
        case .topOpen: return "topOpen"
        case .trailerDetected: return "trailerDetected"
        case .trailerHitchDetected: return "trailerHitchDetected"
        case .trunkOpen: return "trunkOpen"
        case .vehicleMovement: return "vehicleMovement"
        case .windowOpen: return "windowOpen"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.AutomaticValetParkingActivate: BaseCommandProtocol {

	public typealias Error = AutomaticValetParkingActivateError

	public func createGenericError(error: GenericCommandError) -> AutomaticValetParkingActivateError {
		return AutomaticValetParkingActivateError.genericError(error: error)
	}
}

extension Command.AutomaticValetParkingActivate: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the BatteryMaxStateOfChargeConfigure command version v1
public enum BatteryMaxStateOfChargeConfigureError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Charge Configuration failed
    case chargeConfigurationFailed

    /// Charge Configuration failed because passed max soc value is below vehicle threshold
    case chargeConfigurationFailedSocBelowTreshold

    /// Charge Configuration not authorized
    case chargeConfigurationNotAuthorized

    /// Charge Configuration not possible since INSTANT CHARGING is already activated
    case chargeConfigurationNotPossibleSinceInstantChargingIsActive

    /// Fastpath timeout
    case fastpathTimeout

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> BatteryMaxStateOfChargeConfigureError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "7401": return .chargeConfigurationFailed
        case "7402": return .chargeConfigurationFailedSocBelowTreshold
        case "7403": return .chargeConfigurationNotAuthorized
        case "7404": return .chargeConfigurationNotPossibleSinceInstantChargingIsActive
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .chargeConfigurationFailed: return "chargeConfigurationFailed"
        case .chargeConfigurationFailedSocBelowTreshold: return "chargeConfigurationFailedSocBelowTreshold"
        case .chargeConfigurationNotAuthorized: return "chargeConfigurationNotAuthorized"
        case .chargeConfigurationNotPossibleSinceInstantChargingIsActive: return "chargeConfigurationNotPossibleSinceInstantChargingIsActive"
        case .fastpathTimeout: return "fastpathTimeout"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.BatteryMaxStateOfChargeConfigure: BaseCommandProtocol {

	public typealias Error = BatteryMaxStateOfChargeConfigureError

	public func createGenericError(error: GenericCommandError) -> BatteryMaxStateOfChargeConfigureError {
		return BatteryMaxStateOfChargeConfigureError.genericError(error: error)
	}
}

extension Command.BatteryMaxStateOfChargeConfigure: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the ChargeControlConfigure command version v1
public enum ChargeControlConfigureError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Charge Control failed
    case chargeControlConfigFaild

    /// Charge Control not authorized
    case chargeControlNotAuthorized

    /// Charge Control failed due to external charging problem 1
    case externalChargingProblem1

    /// Charge Control failed due to external charging problem 10
    case externalChargingProblem10

    /// Charge Control failed due to external charging problem 11
    case externalChargingProblem11

    /// Charge Control failed due to external charging problem 12
    case externalChargingProblem12

    /// Charge Control failed due to external charging problem 13
    case externalChargingProblem13

    /// Charge Control failed due to external charging problem 14
    case externalChargingProblem14

    /// Charge Control failed due to external charging problem 2
    case externalChargingProblem2

    /// Charge Control failed due to external charging problem 3
    case externalChargingProblem3

    /// Charge Control failed due to external charging problem 4
    case externalChargingProblem4

    /// Charge Control failed due to external charging problem 5
    case externalChargingProblem5

    /// Charge Control failed due to external charging problem 6
    case externalChargingProblem6

    /// Charge Control failed due to external charging problem 7
    case externalChargingProblem7

    /// Charge Control failed due to external charging problem 8
    case externalChargingProblem8

    /// Charge Control failed due to external charging problem 9
    case externalChargingProblem9

    /// not possible since either INSTANT CHARGING is already activated or INSTANT CHARGING command is currently in progress
    case instantChargingActiveOrInProgress

    /// Min. SOC not possible since VVR value of either minSocLowerLimit or minSocUpperLimit is missing
    case minSocLimitMissing

    /// Min. SOC setting not possible since minSOC value is not in range of minSocLowerLimit & minSocUpperLimit
    case minSocNotInRange

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> ChargeControlConfigureError {
	    switch code { 
        case "8501": return .chargeControlConfigFaild
        case "8502": return .chargeControlNotAuthorized
        case "8504": return .instantChargingActiveOrInProgress
        case "8505": return .minSocLimitMissing
        case "8506": return .minSocNotInRange
        case "8511": return .externalChargingProblem1
        case "8512": return .externalChargingProblem2
        case "8513": return .externalChargingProblem3
        case "8514": return .externalChargingProblem4
        case "8515": return .externalChargingProblem5
        case "8516": return .externalChargingProblem6
        case "8517": return .externalChargingProblem7
        case "8518": return .externalChargingProblem8
        case "8519": return .externalChargingProblem9
        case "8520": return .externalChargingProblem10
        case "8521": return .externalChargingProblem11
        case "8522": return .externalChargingProblem12
        case "8523": return .externalChargingProblem13
        case "8524": return .externalChargingProblem14
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .chargeControlConfigFaild: return "chargeControlConfigFaild"
        case .chargeControlNotAuthorized: return "chargeControlNotAuthorized"
        case .externalChargingProblem1: return "externalChargingProblem1"
        case .externalChargingProblem10: return "externalChargingProblem10"
        case .externalChargingProblem11: return "externalChargingProblem11"
        case .externalChargingProblem12: return "externalChargingProblem12"
        case .externalChargingProblem13: return "externalChargingProblem13"
        case .externalChargingProblem14: return "externalChargingProblem14"
        case .externalChargingProblem2: return "externalChargingProblem2"
        case .externalChargingProblem3: return "externalChargingProblem3"
        case .externalChargingProblem4: return "externalChargingProblem4"
        case .externalChargingProblem5: return "externalChargingProblem5"
        case .externalChargingProblem6: return "externalChargingProblem6"
        case .externalChargingProblem7: return "externalChargingProblem7"
        case .externalChargingProblem8: return "externalChargingProblem8"
        case .externalChargingProblem9: return "externalChargingProblem9"
        case .instantChargingActiveOrInProgress: return "instantChargingActiveOrInProgress"
        case .minSocLimitMissing: return "minSocLimitMissing"
        case .minSocNotInRange: return "minSocNotInRange"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.ChargeControlConfigure: BaseCommandProtocol {

	public typealias Error = ChargeControlConfigureError

	public func createGenericError(error: GenericCommandError) -> ChargeControlConfigureError {
		return ChargeControlConfigureError.genericError(error: error)
	}
}

extension Command.ChargeControlConfigure: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the ChargeCouplerUnlock command version v1
public enum ChargeCouplerUnlockError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Failed due to charge coupler still locked
    case chargeCouplerStillLocked

    /// Failed due to charging system not awake
    case chargingSystemNotAwake

    /// Failed
    case failed

    /// Failed due to general error in charge coupler system
    case generalErrorChargeCoupler

    /// Failed due to ignition is on
    case ignitionOn

    /// Request is not authorized
    case notAuthorized

    /// Service not authorized
    case serviceNotAuthorized

    /// Failed due to timeout
    case timeout

    /// Failed due to unknown state of charging system
    case unknownChargingSystemState

    /// Failed due to unlock error in charge coupler system
    case unlockErrorChargeCoupler

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> ChargeCouplerUnlockError {
	    switch code { 
        case "4100": return .serviceNotAuthorized
        case "4101": return .ignitionOn
        case "4126": return .unlockErrorChargeCoupler
        case "4127": return .generalErrorChargeCoupler
        case "4410": return .failed
        case "4411": return .ignitionOn
        case "4412": return .unknownChargingSystemState
        case "4413": return .chargeCouplerStillLocked
        case "4414": return .chargingSystemNotAwake
        case "4415": return .unknownChargingSystemState
        case "4416": return .timeout
        case "4417": return .notAuthorized
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .chargeCouplerStillLocked: return "chargeCouplerStillLocked"
        case .chargingSystemNotAwake: return "chargingSystemNotAwake"
        case .failed: return "failed"
        case .generalErrorChargeCoupler: return "generalErrorChargeCoupler"
        case .ignitionOn: return "ignitionOn"
        case .notAuthorized: return "notAuthorized"
        case .serviceNotAuthorized: return "serviceNotAuthorized"
        case .timeout: return "timeout"
        case .unknownChargingSystemState: return "unknownChargingSystemState"
        case .unlockErrorChargeCoupler: return "unlockErrorChargeCoupler"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.ChargeCouplerUnlock: BaseCommandProtocol {

	public typealias Error = ChargeCouplerUnlockError

	public func createGenericError(error: GenericCommandError) -> ChargeCouplerUnlockError {
		return ChargeCouplerUnlockError.genericError(error: error)
	}
}

extension Command.ChargeCouplerUnlock: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the ChargeFlapUnlock command version v1
public enum ChargeFlapUnlockError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Failed due to charging system not awake
    case chargingSystemNotAwake

    /// Failed
    case failed

    /// Failed due to general error in charge flap system
    case generalErrorChargeFlap

    /// Failed due to ignition is on
    case ignitionOn

    /// Request is not authorized
    case notAuthorized

    /// Failed due to vehicle not in parking gear selection
    case notInPark

    /// Failed due to vehicle not in parking gear selection
    case notInParkingGear

    /// Service not authorized
    case serviceNotAuthorized

    /// Failed due to timeout
    case timeout

    /// Failed due to unknown state of charging system
    case unknownChargingSystemState

    /// Failed due to vehicle in ready state
    case vehicleInReadyState

    /// Failed due to vehicle in ready state
    case vehicleReady

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> ChargeFlapUnlockError {
	    switch code { 
        case "4100": return .serviceNotAuthorized
        case "4101": return .ignitionOn
        case "4123": return .notInPark
        case "4124": return .vehicleReady
        case "4125": return .generalErrorChargeFlap
        case "4400": return .failed
        case "4401": return .ignitionOn
        case "4402": return .notInParkingGear
        case "4403": return .vehicleInReadyState
        case "4404": return .chargingSystemNotAwake
        case "4405": return .unknownChargingSystemState
        case "4406": return .timeout
        case "4407": return .notAuthorized
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .chargingSystemNotAwake: return "chargingSystemNotAwake"
        case .failed: return "failed"
        case .generalErrorChargeFlap: return "generalErrorChargeFlap"
        case .ignitionOn: return "ignitionOn"
        case .notAuthorized: return "notAuthorized"
        case .notInPark: return "notInPark"
        case .notInParkingGear: return "notInParkingGear"
        case .serviceNotAuthorized: return "serviceNotAuthorized"
        case .timeout: return "timeout"
        case .unknownChargingSystemState: return "unknownChargingSystemState"
        case .vehicleInReadyState: return "vehicleInReadyState"
        case .vehicleReady: return "vehicleReady"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.ChargeFlapUnlock: BaseCommandProtocol {

	public typealias Error = ChargeFlapUnlockError

	public func createGenericError(error: GenericCommandError) -> ChargeFlapUnlockError {
		return ChargeFlapUnlockError.genericError(error: error)
	}
}

extension Command.ChargeFlapUnlock: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the ChargeOptimizationConfigure command version v1
public enum ChargeOptimizationConfigureError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Charge optimization failed
    case chargeOptimizationFailed

    /// Charge optimization not authorized
    case chargeOptimizationNotAuthorized

    /// Charge optimization not possible since either INSTANT CHARGING is already activated or INSTANT CHARGING ACP command is currently in progress
    case chargeOptimizationNotPossible

    /// Charge optimization overwritten
    case chargeOptimizationOverwritten

    /// Fastpath timeout
    case fastpathTimeout

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> ChargeOptimizationConfigureError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "5015": return .chargeOptimizationFailed
        case "5016": return .chargeOptimizationOverwritten
        case "5017": return .chargeOptimizationNotAuthorized
        case "5018": return .chargeOptimizationNotPossible
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .chargeOptimizationFailed: return "chargeOptimizationFailed"
        case .chargeOptimizationNotAuthorized: return "chargeOptimizationNotAuthorized"
        case .chargeOptimizationNotPossible: return "chargeOptimizationNotPossible"
        case .chargeOptimizationOverwritten: return "chargeOptimizationOverwritten"
        case .fastpathTimeout: return "fastpathTimeout"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.ChargeOptimizationConfigure: BaseCommandProtocol {

	public typealias Error = ChargeOptimizationConfigureError

	public func createGenericError(error: GenericCommandError) -> ChargeOptimizationConfigureError {
		return ChargeOptimizationConfigureError.genericError(error: error)
	}
}

extension Command.ChargeOptimizationConfigure: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the ChargeOptimizationStart command version v1
public enum ChargeOptimizationStartError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> ChargeOptimizationStartError {
	    switch code { 
        case "42": return .fastpathTimeout
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.ChargeOptimizationStart: BaseCommandProtocol {

	public typealias Error = ChargeOptimizationStartError

	public func createGenericError(error: GenericCommandError) -> ChargeOptimizationStartError {
		return ChargeOptimizationStartError.genericError(error: error)
	}
}

extension Command.ChargeOptimizationStart: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the ChargeOptimizationStop command version v1
public enum ChargeOptimizationStopError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> ChargeOptimizationStopError {
	    switch code { 
        case "42": return .fastpathTimeout
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.ChargeOptimizationStop: BaseCommandProtocol {

	public typealias Error = ChargeOptimizationStopError

	public func createGenericError(error: GenericCommandError) -> ChargeOptimizationStopError {
		return ChargeOptimizationStopError.genericError(error: error)
	}
}

extension Command.ChargeOptimizationStop: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the ChargeProgramConfigure command version v1
public enum ChargeProgramConfigureError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Charge Configuration failed
    case chargeConfigurationFailed

    /// Charge Configuration failed because passed max soc value is below vehicle threshold
    case chargeConfigurationFailedSocBelowTreshold

    /// Charge Configuration not authorized
    case chargeConfigurationNotAuthorized

    /// Charge Configuration not possible since INSTANT CHARGING is already activated
    case chargeConfigurationNotPossibleSinceInstantChargingIsActive

    /// Charge programs not supported by vehicle
    case chargeProgramsNotSupportedByVehicle

    /// Fastpath timeout
    case fastpathTimeout

    /// Max. SOC setting not possible since VVR value of either maxSocLowerLimit or maxSocUpperLimit is missing
    case maxSocLimitMissing

    /// Max. SOC setting not possible since maxSOC value is not in range of maxSocLowerLimit & maxSocUpperLimit
    case maxSocNotInRange

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> ChargeProgramConfigureError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "7401": return .chargeConfigurationFailed
        case "7402": return .chargeConfigurationFailedSocBelowTreshold
        case "7403": return .chargeConfigurationNotAuthorized
        case "7404": return .chargeConfigurationNotPossibleSinceInstantChargingIsActive
        case "7405": return .chargeProgramsNotSupportedByVehicle
        case "7406": return .maxSocLimitMissing
        case "7407": return .maxSocNotInRange
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .chargeConfigurationFailed: return "chargeConfigurationFailed"
        case .chargeConfigurationFailedSocBelowTreshold: return "chargeConfigurationFailedSocBelowTreshold"
        case .chargeConfigurationNotAuthorized: return "chargeConfigurationNotAuthorized"
        case .chargeConfigurationNotPossibleSinceInstantChargingIsActive: return "chargeConfigurationNotPossibleSinceInstantChargingIsActive"
        case .chargeProgramsNotSupportedByVehicle: return "chargeProgramsNotSupportedByVehicle"
        case .fastpathTimeout: return "fastpathTimeout"
        case .maxSocLimitMissing: return "maxSocLimitMissing"
        case .maxSocNotInRange: return "maxSocNotInRange"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.ChargeProgramConfigure: BaseCommandProtocol {

	public typealias Error = ChargeProgramConfigureError

	public func createGenericError(error: GenericCommandError) -> ChargeProgramConfigureError {
		return ChargeProgramConfigureError.genericError(error: error)
	}
}

extension Command.ChargeProgramConfigure: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the DoorsLock command version v1
public enum DoorsLockError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Failed due to central locking disabled
    case centralLockingDisabled

    /// Failed due to decklid not closed
    case decklidNotClosed

    /// Failed due to decklid not locked
    case decklidNotLocked

    /// Failed due to front left door not closed
    case doorFrontLeftNotClosed

    /// Failed due to front left door not locked
    case doorFrontLeftNotLocked

    /// Failed due to front right door not closed
    case doorFrontRightNotClosed

    /// Failed due to front right door not locked
    case doorFrontRightNotLocked

    /// Failed due to one or more doors not closed
    case doorNotClosed

    /// Failed due to door is open
    case doorOpen

    /// Failed due to rear left door not closed
    case doorRearLeftNotClosed

    /// Failed due to rear left door not locked
    case doorRearLeftNotLocked

    /// Failed due to rear right door not closed
    case doorRearRightNotClosed

    /// Failed due to rear right door not locked
    case doorRearRightNotLocked

    /// Failed due to one or more doors not locked
    case doorsNotLocked

    /// Failed due to driver door open
    case driverDoorOpen

    /// Failed due to driver in vehicle
    case driverIsInVehicle

    /// Failed due to vehicle already external locked
    case externallyLocked

    /// Failed
    case failed

    /// Fastpath timeout
    case fastpathTimeout

    /// Failed due to flip window not closed
    case flipWindowNotClosed

    /// Failed due to flip window not locked
    case flipWindowNotLocked

    /// Failed due to fuel flap not closed
    case fuelFlapNotClosed

    /// Failed due to fuel flap not locked
    case fuelFlapNotLocked

    /// Failed due to gas alarm active
    case gasAlarmActive

    /// Failed due to general error in charge coupler system
    case generalErrorChargeCoupler

    /// Failed due to general error in charge flap system
    case generalErrorChargeFlap

    /// Failed due to general error in locking system
    case generalErrorLocking

    /// Failed due to HOLD-function active
    case holdActive

    /// Failed due to ignition state active
    case ignitionActive

    /// Failed due to ignition is on
    case ignitionOn

    /// Lock request not authorized
    case lockNotAuthorized

    /// Failed due to request to central locking system cancelled
    case lockingRequestCancelled

    /// Energy level in Battery is too low
    case lowBatteryLevel

    /// Failed due to low battery level 1
    case lowBatteryLevel1

    /// Failed due to low battery level 2
    case lowBatteryLevel2

    /// Failed due to vehicle not external locked
    case notExternallyLocked

    /// Failed due to vehicle not in parking gear selection
    case notInPark

    /// Failed due to parallel request to central locking system
    case parallelRequestToLocking

    /// Failed due to parameter not allowed
    case parameterNotAllowed

    /// Failed due to RDL inactive
    case rdlInactive

    /// Failed due to RDU decklid inactive
    case rduDecklidInactive

    /// Failed due to RDU fuel flap inactive
    case rduFuelFlapInactive

    /// Failed due to RDU global inactive
    case rduGlobalInactive

    /// Failed due to RDU selective inactive
    case rduSelectionInactive

    /// Failed due to rear charge flap not closed
    case rearChargeFlapNotClosed

    /// Failed due to remote engine start is active
    case remoteEngineStartIsActive

    /// Failed due to request not allowed
    case requestNotAllowed

    /// Failed due to restricted info parameter
    case restrictedInfoParameter

    /// Service not authorized
    case serviceNotAuthorized

    /// Failed due to side charge flap not closed
    case sideChargeFlapNotClosed

    /// Failed due to too many requests to central locking system
    case tooManyRequestsToLocking

    /// Failed due to transport mode active
    case transportModeActive

    /// Failed due to unknown reason
    case unknownReason

    /// Failed due to unlock error in charge coupler system
    case unlockErrorChargeCoupler

    /// Failed due to valet parking active
    case valetParkingActive

    /// Failed due to vehicle in ready state
    case vehicleReady

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> DoorsLockError {
	    switch code { 
        case "21": return .lowBatteryLevel
        case "4001": return .failed
        case "4002": return .doorOpen
        case "4003": return .ignitionOn
        case "4004": return .lockNotAuthorized
        case "4100": return .serviceNotAuthorized
        case "4101": return .ignitionOn
        case "4102": return .remoteEngineStartIsActive
        case "4103": return .driverIsInVehicle
        case "4104": return .notExternallyLocked
        case "4105": return .lowBatteryLevel1
        case "4106": return .lowBatteryLevel2
        case "4107": return .doorsNotLocked
        case "4108": return .doorFrontLeftNotLocked
        case "4109": return .doorFrontRightNotLocked
        case "4110": return .doorRearLeftNotLocked
        case "4111": return .doorRearRightNotLocked
        case "4112": return .decklidNotLocked
        case "4113": return .flipWindowNotLocked
        case "4114": return .fuelFlapNotLocked
        case "4115": return .driverDoorOpen
        case "4116": return .ignitionActive
        case "4117": return .parallelRequestToLocking
        case "4118": return .tooManyRequestsToLocking
        case "4119": return .holdActive
        case "4120": return .externallyLocked
        case "4121": return .valetParkingActive
        case "4122": return .generalErrorLocking
        case "4123": return .notInPark
        case "4124": return .vehicleReady
        case "4125": return .generalErrorChargeFlap
        case "4126": return .unlockErrorChargeCoupler
        case "4127": return .generalErrorChargeCoupler
        case "4128": return .doorNotClosed
        case "4129": return .doorFrontLeftNotClosed
        case "4130": return .doorFrontRightNotClosed
        case "4131": return .doorRearLeftNotClosed
        case "4132": return .doorRearRightNotClosed
        case "4133": return .decklidNotClosed
        case "4134": return .flipWindowNotClosed
        case "4135": return .sideChargeFlapNotClosed
        case "4136": return .rearChargeFlapNotClosed
        case "4137": return .fuelFlapNotClosed
        case "4138": return .lockingRequestCancelled
        case "4139": return .rduGlobalInactive
        case "4140": return .rduSelectionInactive
        case "4141": return .rdlInactive
        case "4142": return .rduDecklidInactive
        case "4143": return .rduFuelFlapInactive
        case "4144": return .requestNotAllowed
        case "4145": return .parameterNotAllowed
        case "4146": return .restrictedInfoParameter
        case "4147": return .transportModeActive
        case "4148": return .centralLockingDisabled
        case "4149": return .gasAlarmActive
        case "4150": return .unknownReason
        case "42": return .fastpathTimeout
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .centralLockingDisabled: return "centralLockingDisabled"
        case .decklidNotClosed: return "decklidNotClosed"
        case .decklidNotLocked: return "decklidNotLocked"
        case .doorFrontLeftNotClosed: return "doorFrontLeftNotClosed"
        case .doorFrontLeftNotLocked: return "doorFrontLeftNotLocked"
        case .doorFrontRightNotClosed: return "doorFrontRightNotClosed"
        case .doorFrontRightNotLocked: return "doorFrontRightNotLocked"
        case .doorNotClosed: return "doorNotClosed"
        case .doorOpen: return "doorOpen"
        case .doorRearLeftNotClosed: return "doorRearLeftNotClosed"
        case .doorRearLeftNotLocked: return "doorRearLeftNotLocked"
        case .doorRearRightNotClosed: return "doorRearRightNotClosed"
        case .doorRearRightNotLocked: return "doorRearRightNotLocked"
        case .doorsNotLocked: return "doorsNotLocked"
        case .driverDoorOpen: return "driverDoorOpen"
        case .driverIsInVehicle: return "driverIsInVehicle"
        case .externallyLocked: return "externallyLocked"
        case .failed: return "failed"
        case .fastpathTimeout: return "fastpathTimeout"
        case .flipWindowNotClosed: return "flipWindowNotClosed"
        case .flipWindowNotLocked: return "flipWindowNotLocked"
        case .fuelFlapNotClosed: return "fuelFlapNotClosed"
        case .fuelFlapNotLocked: return "fuelFlapNotLocked"
        case .gasAlarmActive: return "gasAlarmActive"
        case .generalErrorChargeCoupler: return "generalErrorChargeCoupler"
        case .generalErrorChargeFlap: return "generalErrorChargeFlap"
        case .generalErrorLocking: return "generalErrorLocking"
        case .holdActive: return "holdActive"
        case .ignitionActive: return "ignitionActive"
        case .ignitionOn: return "ignitionOn"
        case .lockNotAuthorized: return "lockNotAuthorized"
        case .lockingRequestCancelled: return "lockingRequestCancelled"
        case .lowBatteryLevel: return "lowBatteryLevel"
        case .lowBatteryLevel1: return "lowBatteryLevel1"
        case .lowBatteryLevel2: return "lowBatteryLevel2"
        case .notExternallyLocked: return "notExternallyLocked"
        case .notInPark: return "notInPark"
        case .parallelRequestToLocking: return "parallelRequestToLocking"
        case .parameterNotAllowed: return "parameterNotAllowed"
        case .rdlInactive: return "rdlInactive"
        case .rduDecklidInactive: return "rduDecklidInactive"
        case .rduFuelFlapInactive: return "rduFuelFlapInactive"
        case .rduGlobalInactive: return "rduGlobalInactive"
        case .rduSelectionInactive: return "rduSelectionInactive"
        case .rearChargeFlapNotClosed: return "rearChargeFlapNotClosed"
        case .remoteEngineStartIsActive: return "remoteEngineStartIsActive"
        case .requestNotAllowed: return "requestNotAllowed"
        case .restrictedInfoParameter: return "restrictedInfoParameter"
        case .serviceNotAuthorized: return "serviceNotAuthorized"
        case .sideChargeFlapNotClosed: return "sideChargeFlapNotClosed"
        case .tooManyRequestsToLocking: return "tooManyRequestsToLocking"
        case .transportModeActive: return "transportModeActive"
        case .unknownReason: return "unknownReason"
        case .unlockErrorChargeCoupler: return "unlockErrorChargeCoupler"
        case .valetParkingActive: return "valetParkingActive"
        case .vehicleReady: return "vehicleReady"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.DoorsLock: BaseCommandProtocol {

	public typealias Error = DoorsLockError

	public func createGenericError(error: GenericCommandError) -> DoorsLockError {
		return DoorsLockError.genericError(error: error)
	}
}

extension Command.DoorsLock: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the DoorsUnlock command version v1
public enum DoorsUnlockError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Failed due to central locking disabled
    case centralLockingDisabled

    /// Failed due to decklid not closed
    case decklidNotClosed

    /// Failed due to decklid not locked
    case decklidNotLocked

    /// Failed due to front left door not closed
    case doorFrontLeftNotClosed

    /// Failed due to front left door not locked
    case doorFrontLeftNotLocked

    /// Failed due to front right door not closed
    case doorFrontRightNotClosed

    /// Failed due to front right door not locked
    case doorFrontRightNotLocked

    /// Failed due to one or more doors not closed
    case doorNotClosed

    /// Failed due to rear left door not closed
    case doorRearLeftNotClosed

    /// Failed due to rear left door not locked
    case doorRearLeftNotLocked

    /// Failed due to rear right door not closed
    case doorRearRightNotClosed

    /// Failed due to rear right door not locked
    case doorRearRightNotLocked

    /// Failed due to one or more doors not locked
    case doorsNotLocked

    /// Failed due to driver door open
    case driverDoorOpen

    /// Failed due to driver in vehicle
    case driverIsInVehicle

    /// Failed due to vehicle already external locked
    case externallyLocked

    /// Failed
    case failed

    /// Fastpath timeout
    case fastpathTimeout

    /// Failed due to flip window not closed
    case flipWindowNotClosed

    /// Failed due to flip window not locked
    case flipWindowNotLocked

    /// Failed due to fuel flap not closed
    case fuelFlapNotClosed

    /// Failed due to fuel flap not locked
    case fuelFlapNotLocked

    /// Failed due to gas alarm active
    case gasAlarmActive

    /// Failed due to general error in charge coupler system
    case generalErrorChargeCoupler

    /// Failed due to general error in charge flap system
    case generalErrorChargeFlap

    /// Failed due to general error in locking system
    case generalErrorLocking

    /// Failed due to HOLD-function active
    case holdActive

    /// Failed due to ignition state active
    case ignitionActive

    /// Failed due to ignition transition
    case ignitionInTransition

    /// Failed due to ignition is on
    case ignitionOn

    /// Failed due to invalid SMS time
    case invalidSmsTime

    /// Failed due to request to central locking system cancelled
    case lockingRequestCancelled

    /// Energy level in Battery is too low
    case lowBatteryLevel

    /// Failed due to low battery level 1
    case lowBatteryLevel1

    /// Failed due to low battery level 2
    case lowBatteryLevel2

    /// Failed due to vehicle not external locked
    case notExternallyLocked

    /// Failed due to vehicle not in parking gear selection
    case notInPark

    /// Failed due to parallel request to central locking system
    case parallelRequestToLocking

    /// Failed due to parameter not allowed
    case parameterNotAllowed

    /// Failed due to RDL inactive
    case rdlInactive

    /// Failed due to RDU decklid inactive
    case rduDecklidInactive

    /// Failed due to RDU fuel flap inactive
    case rduFuelFlapInactive

    /// Failed due to RDU global inactive
    case rduGlobalInactive

    /// Failed due to RDU selective inactive
    case rduSelectionInactive

    /// Failed due to rear charge flap not closed
    case rearChargeFlapNotClosed

    /// Failed due to remote engine start is active
    case remoteEngineStartIsActive

    /// Failed due to request not allowed
    case requestNotAllowed

    /// Failed due to restricted info parameter
    case restrictedInfoParameter

    /// Service not authorized
    case serviceNotAuthorized

    /// Failed due to side charge flap not closed
    case sideChargeFlapNotClosed

    /// Failed due to timeout
    case timeout

    /// Failed due to too many requests to central locking system
    case tooManyRequestsToLocking

    /// Failed due to transport mode active
    case transportModeActive

    /// Failed due to unknown reason
    case unknownReason

    /// Failed due to unlock error in charge coupler system
    case unlockErrorChargeCoupler

    /// Unlock request not authorized
    case unlockNotAuthorized

    /// Failed due to valet parking active
    case valetParkingActive

    /// Failed because vehicle is in motion
    case vehicleInMotion

    /// Failed due to vehicle in ready state
    case vehicleReady

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> DoorsUnlockError {
	    switch code { 
        case "21": return .lowBatteryLevel
        case "4011": return .failed
        case "4012": return .timeout
        case "4013": return .invalidSmsTime
        case "4014": return .vehicleInMotion
        case "4015": return .ignitionInTransition
        case "4016": return .unlockNotAuthorized
        case "4100": return .serviceNotAuthorized
        case "4101": return .ignitionOn
        case "4102": return .remoteEngineStartIsActive
        case "4103": return .driverIsInVehicle
        case "4104": return .notExternallyLocked
        case "4105": return .lowBatteryLevel1
        case "4106": return .lowBatteryLevel2
        case "4107": return .doorsNotLocked
        case "4108": return .doorFrontLeftNotLocked
        case "4109": return .doorFrontRightNotLocked
        case "4110": return .doorRearLeftNotLocked
        case "4111": return .doorRearRightNotLocked
        case "4112": return .decklidNotLocked
        case "4113": return .flipWindowNotLocked
        case "4114": return .fuelFlapNotLocked
        case "4115": return .driverDoorOpen
        case "4116": return .ignitionActive
        case "4117": return .parallelRequestToLocking
        case "4118": return .tooManyRequestsToLocking
        case "4119": return .holdActive
        case "4120": return .externallyLocked
        case "4121": return .valetParkingActive
        case "4122": return .generalErrorLocking
        case "4123": return .notInPark
        case "4124": return .vehicleReady
        case "4125": return .generalErrorChargeFlap
        case "4126": return .unlockErrorChargeCoupler
        case "4127": return .generalErrorChargeCoupler
        case "4128": return .doorNotClosed
        case "4129": return .doorFrontLeftNotClosed
        case "4130": return .doorFrontRightNotClosed
        case "4131": return .doorRearLeftNotClosed
        case "4132": return .doorRearRightNotClosed
        case "4133": return .decklidNotClosed
        case "4134": return .flipWindowNotClosed
        case "4135": return .sideChargeFlapNotClosed
        case "4136": return .rearChargeFlapNotClosed
        case "4137": return .fuelFlapNotClosed
        case "4138": return .lockingRequestCancelled
        case "4139": return .rduGlobalInactive
        case "4140": return .rduSelectionInactive
        case "4141": return .rdlInactive
        case "4142": return .rduDecklidInactive
        case "4143": return .rduFuelFlapInactive
        case "4144": return .requestNotAllowed
        case "4145": return .parameterNotAllowed
        case "4146": return .restrictedInfoParameter
        case "4147": return .transportModeActive
        case "4148": return .centralLockingDisabled
        case "4149": return .gasAlarmActive
        case "4150": return .unknownReason
        case "42": return .fastpathTimeout
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .centralLockingDisabled: return "centralLockingDisabled"
        case .decklidNotClosed: return "decklidNotClosed"
        case .decklidNotLocked: return "decklidNotLocked"
        case .doorFrontLeftNotClosed: return "doorFrontLeftNotClosed"
        case .doorFrontLeftNotLocked: return "doorFrontLeftNotLocked"
        case .doorFrontRightNotClosed: return "doorFrontRightNotClosed"
        case .doorFrontRightNotLocked: return "doorFrontRightNotLocked"
        case .doorNotClosed: return "doorNotClosed"
        case .doorRearLeftNotClosed: return "doorRearLeftNotClosed"
        case .doorRearLeftNotLocked: return "doorRearLeftNotLocked"
        case .doorRearRightNotClosed: return "doorRearRightNotClosed"
        case .doorRearRightNotLocked: return "doorRearRightNotLocked"
        case .doorsNotLocked: return "doorsNotLocked"
        case .driverDoorOpen: return "driverDoorOpen"
        case .driverIsInVehicle: return "driverIsInVehicle"
        case .externallyLocked: return "externallyLocked"
        case .failed: return "failed"
        case .fastpathTimeout: return "fastpathTimeout"
        case .flipWindowNotClosed: return "flipWindowNotClosed"
        case .flipWindowNotLocked: return "flipWindowNotLocked"
        case .fuelFlapNotClosed: return "fuelFlapNotClosed"
        case .fuelFlapNotLocked: return "fuelFlapNotLocked"
        case .gasAlarmActive: return "gasAlarmActive"
        case .generalErrorChargeCoupler: return "generalErrorChargeCoupler"
        case .generalErrorChargeFlap: return "generalErrorChargeFlap"
        case .generalErrorLocking: return "generalErrorLocking"
        case .holdActive: return "holdActive"
        case .ignitionActive: return "ignitionActive"
        case .ignitionInTransition: return "ignitionInTransition"
        case .ignitionOn: return "ignitionOn"
        case .invalidSmsTime: return "invalidSmsTime"
        case .lockingRequestCancelled: return "lockingRequestCancelled"
        case .lowBatteryLevel: return "lowBatteryLevel"
        case .lowBatteryLevel1: return "lowBatteryLevel1"
        case .lowBatteryLevel2: return "lowBatteryLevel2"
        case .notExternallyLocked: return "notExternallyLocked"
        case .notInPark: return "notInPark"
        case .parallelRequestToLocking: return "parallelRequestToLocking"
        case .parameterNotAllowed: return "parameterNotAllowed"
        case .rdlInactive: return "rdlInactive"
        case .rduDecklidInactive: return "rduDecklidInactive"
        case .rduFuelFlapInactive: return "rduFuelFlapInactive"
        case .rduGlobalInactive: return "rduGlobalInactive"
        case .rduSelectionInactive: return "rduSelectionInactive"
        case .rearChargeFlapNotClosed: return "rearChargeFlapNotClosed"
        case .remoteEngineStartIsActive: return "remoteEngineStartIsActive"
        case .requestNotAllowed: return "requestNotAllowed"
        case .restrictedInfoParameter: return "restrictedInfoParameter"
        case .serviceNotAuthorized: return "serviceNotAuthorized"
        case .sideChargeFlapNotClosed: return "sideChargeFlapNotClosed"
        case .timeout: return "timeout"
        case .tooManyRequestsToLocking: return "tooManyRequestsToLocking"
        case .transportModeActive: return "transportModeActive"
        case .unknownReason: return "unknownReason"
        case .unlockErrorChargeCoupler: return "unlockErrorChargeCoupler"
        case .unlockNotAuthorized: return "unlockNotAuthorized"
        case .valetParkingActive: return "valetParkingActive"
        case .vehicleInMotion: return "vehicleInMotion"
        case .vehicleReady: return "vehicleReady"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.DoorsUnlock: BaseCommandProtocol {

	public typealias Error = DoorsUnlockError

	public func createGenericError(error: GenericCommandError) -> DoorsUnlockError {
		return DoorsUnlockError.genericError(error: error)
	}
}

extension Command.DoorsUnlock: CommandPinProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String, pin: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self, pin: pin)
	}
}


/// All possible error codes for the EngineStart command version v1
public enum EngineStartError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Accelerator pressed
    case acceleratorPressed

    /// Alarm, panic alarm and/or warning blinker active
    case alarmActive

    /// theft alarm /panic alarm / emergency flashers got triggered
    case alarmTriggered

    /// Charge cable is plugged
    case chargeCablePlugged

    /// Check engine light is on
    case checkEngineLightOn

    /// cryptologic error
    case cryptoError

    /// Failed due to one or more doors not locked
    case doorsNotLocked

    /// Doors open
    case doorsOpen

    /// doors were opened
    case doorsOpened

    /// Engine control module unexpecedely shuts off
    case engineControlShutsOff

    /// Engine Hood open
    case engineHoodOpen

    /// engine hood was opened
    case engineHoodOpened

    /// engine unexpected shut off
    case engineShutOff

    /// engine shut off - doors became unlocked
    case engineShutOffByDoorsUnlocked

    /// engine shut off - either by timeout or by user request
    case engineShutOffByTimeoutOrUser

    /// engine successfully started
    case engineSuccessfullyStarted

    /// Fastpath timeout
    case fastpathTimeout

    /// FBS general error for challengeResponse generation
    case fsbChallengeResponseError

    /// FBS is not able to create a valid challengeResponse for the given VIN
    case fsbUnableToCreateChallengeResponse

    /// FBS is not reachable due to maintenance
    case fsbUnreachable

    /// fuel got low
    case fuelLow

    /// Fuel tank too low (less than 25% volume)
    case fuelTankTooLow

    /// gas pedal was pressed
    case gasPedalPressed

    /// The gear is not in Parking position
    case gearNotInPark

    /// vehicle key plugged in the ignition mechanism
    case keyPluggedIn

    /// Vehicle key plugged in while engine is running
    case keyPluggedInWhileEngineIsRunning

    /// new RS requested within operational timewindow (default 15 min.)
    case newRsRequested

    /// DaiVB does not receive asynchronous callback within MAX_RES_CALLBACK_TIME
    case noCallbackReceived

    /// Remote start is blocked due to parallel FBS workflow
    case remoteStartBlocked

    /// request received and processed twice by EIS, within the same IGN cycle rsAbortedRequestRefus
    case requestReceivedTwice

    /// TCU exhausted all retries on CAN and did not get a valid response from EIS
    case tcuCanError

    /// TCU has remote start service deauthorized
    case tcuNoRemoteService

    /// Windows and/or roof open
    case windowsOrRoofOpen

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> EngineStartError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "6801": return .engineSuccessfullyStarted
        case "6802": return .engineShutOffByTimeoutOrUser
        case "6803": return .engineShutOffByDoorsUnlocked
        case "6804": return .doorsOpened
        case "6805": return .engineHoodOpened
        case "6806": return .alarmTriggered
        case "6807": return .fuelLow
        case "6808": return .gasPedalPressed
        case "6809": return .keyPluggedInWhileEngineIsRunning
        case "6810": return .engineControlShutsOff
        case "6811": return .keyPluggedIn
        case "6812": return .gearNotInPark
        case "6813": return .doorsNotLocked
        case "6814": return .doorsOpen
        case "6815": return .windowsOrRoofOpen
        case "6816": return .engineHoodOpen
        case "6817": return .alarmActive
        case "6818": return .fuelTankTooLow
        case "6819": return .acceleratorPressed
        case "6820": return .newRsRequested
        case "6821": return .cryptoError
        case "6822": return .requestReceivedTwice
        case "6823": return .engineShutOff
        case "6824": return .tcuCanError
        case "6825": return .tcuNoRemoteService
        case "6826": return .chargeCablePlugged
        case "6827": return .fsbUnableToCreateChallengeResponse
        case "6828": return .fsbUnreachable
        case "6829": return .noCallbackReceived
        case "6830": return .fsbChallengeResponseError
        case "6831": return .remoteStartBlocked
        case "6832": return .checkEngineLightOn
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .acceleratorPressed: return "acceleratorPressed"
        case .alarmActive: return "alarmActive"
        case .alarmTriggered: return "alarmTriggered"
        case .chargeCablePlugged: return "chargeCablePlugged"
        case .checkEngineLightOn: return "checkEngineLightOn"
        case .cryptoError: return "cryptoError"
        case .doorsNotLocked: return "doorsNotLocked"
        case .doorsOpen: return "doorsOpen"
        case .doorsOpened: return "doorsOpened"
        case .engineControlShutsOff: return "engineControlShutsOff"
        case .engineHoodOpen: return "engineHoodOpen"
        case .engineHoodOpened: return "engineHoodOpened"
        case .engineShutOff: return "engineShutOff"
        case .engineShutOffByDoorsUnlocked: return "engineShutOffByDoorsUnlocked"
        case .engineShutOffByTimeoutOrUser: return "engineShutOffByTimeoutOrUser"
        case .engineSuccessfullyStarted: return "engineSuccessfullyStarted"
        case .fastpathTimeout: return "fastpathTimeout"
        case .fsbChallengeResponseError: return "fsbChallengeResponseError"
        case .fsbUnableToCreateChallengeResponse: return "fsbUnableToCreateChallengeResponse"
        case .fsbUnreachable: return "fsbUnreachable"
        case .fuelLow: return "fuelLow"
        case .fuelTankTooLow: return "fuelTankTooLow"
        case .gasPedalPressed: return "gasPedalPressed"
        case .gearNotInPark: return "gearNotInPark"
        case .keyPluggedIn: return "keyPluggedIn"
        case .keyPluggedInWhileEngineIsRunning: return "keyPluggedInWhileEngineIsRunning"
        case .newRsRequested: return "newRsRequested"
        case .noCallbackReceived: return "noCallbackReceived"
        case .remoteStartBlocked: return "remoteStartBlocked"
        case .requestReceivedTwice: return "requestReceivedTwice"
        case .tcuCanError: return "tcuCanError"
        case .tcuNoRemoteService: return "tcuNoRemoteService"
        case .windowsOrRoofOpen: return "windowsOrRoofOpen"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.EngineStart: BaseCommandProtocol {

	public typealias Error = EngineStartError

	public func createGenericError(error: GenericCommandError) -> EngineStartError {
		return EngineStartError.genericError(error: error)
	}
}

extension Command.EngineStart: CommandPinProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String, pin: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self, pin: pin)
	}
}


/// All possible error codes for the EngineStop command version v1
public enum EngineStopError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Accelerator pressed
    case acceleratorPressed

    /// Alarm, panic alarm and/or warning blinker active
    case alarmActive

    /// theft alarm /panic alarm / emergency flashers got triggered
    case alarmTriggered

    /// Charge cable is plugged
    case chargeCablePlugged

    /// Check engine light is on
    case checkEngineLightOn

    /// cryptologic error
    case cryptoError

    /// Failed due to one or more doors not locked
    case doorsNotLocked

    /// Doors open
    case doorsOpen

    /// doors were opened
    case doorsOpened

    /// Engine control module unexpecedely shuts off
    case engineControlShutsOff

    /// Engine Hood open
    case engineHoodOpen

    /// engine hood was opened
    case engineHoodOpened

    /// engine unexpected shut off
    case engineShutOff

    /// engine shut off - doors became unlocked
    case engineShutOffByDoorsUnlocked

    /// engine shut off - either by timeout or by user request
    case engineShutOffByTimeoutOrUser

    /// engine successfully started
    case engineSuccessfullyStarted

    /// Fastpath timeout
    case fastpathTimeout

    /// FBS general error for challengeResponse generation
    case fsbChallengeResponseError

    /// FBS is not able to create a valid challengeResponse for the given VIN
    case fsbUnableToCreateChallengeResponse

    /// FBS is not reachable due to maintenance
    case fsbUnreachable

    /// fuel got low
    case fuelLow

    /// Fuel tank too low (less than 25% volume)
    case fuelTankTooLow

    /// gas pedal was pressed
    case gasPedalPressed

    /// The gear is not in Parking position
    case gearNotInPark

    /// vehicle key plugged in the ignition mechanism
    case keyPluggedIn

    /// Vehicle key plugged in while engine is running
    case keyPluggedInWhileEngineIsRunning

    /// new RS requested within operational timewindow (default 15 min.)
    case newRsRequested

    /// DaiVB does not receive asynchronous callback within MAX_RES_CALLBACK_TIME
    case noCallbackReceived

    /// Remote start is blocked due to parallel FBS workflow
    case remoteStartBlocked

    /// request received and processed twice by EIS, within the same IGN cycle rsAbortedRequestRefus
    case requestReceivedTwice

    /// TCU exhausted all retries on CAN and did not get a valid response from EIS
    case tcuCanError

    /// TCU has remote start service deauthorized
    case tcuNoRemoteService

    /// Windows and/or roof open
    case windowsOrRoofOpen

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> EngineStopError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "6801": return .engineSuccessfullyStarted
        case "6802": return .engineShutOffByTimeoutOrUser
        case "6803": return .engineShutOffByDoorsUnlocked
        case "6804": return .doorsOpened
        case "6805": return .engineHoodOpened
        case "6806": return .alarmTriggered
        case "6807": return .fuelLow
        case "6808": return .gasPedalPressed
        case "6809": return .keyPluggedInWhileEngineIsRunning
        case "6810": return .engineControlShutsOff
        case "6811": return .keyPluggedIn
        case "6812": return .gearNotInPark
        case "6813": return .doorsNotLocked
        case "6814": return .doorsOpen
        case "6815": return .windowsOrRoofOpen
        case "6816": return .engineHoodOpen
        case "6817": return .alarmActive
        case "6818": return .fuelTankTooLow
        case "6819": return .acceleratorPressed
        case "6820": return .newRsRequested
        case "6821": return .cryptoError
        case "6822": return .requestReceivedTwice
        case "6823": return .engineShutOff
        case "6824": return .tcuCanError
        case "6825": return .tcuNoRemoteService
        case "6826": return .chargeCablePlugged
        case "6827": return .fsbUnableToCreateChallengeResponse
        case "6828": return .fsbUnreachable
        case "6829": return .noCallbackReceived
        case "6830": return .fsbChallengeResponseError
        case "6831": return .remoteStartBlocked
        case "6832": return .checkEngineLightOn
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .acceleratorPressed: return "acceleratorPressed"
        case .alarmActive: return "alarmActive"
        case .alarmTriggered: return "alarmTriggered"
        case .chargeCablePlugged: return "chargeCablePlugged"
        case .checkEngineLightOn: return "checkEngineLightOn"
        case .cryptoError: return "cryptoError"
        case .doorsNotLocked: return "doorsNotLocked"
        case .doorsOpen: return "doorsOpen"
        case .doorsOpened: return "doorsOpened"
        case .engineControlShutsOff: return "engineControlShutsOff"
        case .engineHoodOpen: return "engineHoodOpen"
        case .engineHoodOpened: return "engineHoodOpened"
        case .engineShutOff: return "engineShutOff"
        case .engineShutOffByDoorsUnlocked: return "engineShutOffByDoorsUnlocked"
        case .engineShutOffByTimeoutOrUser: return "engineShutOffByTimeoutOrUser"
        case .engineSuccessfullyStarted: return "engineSuccessfullyStarted"
        case .fastpathTimeout: return "fastpathTimeout"
        case .fsbChallengeResponseError: return "fsbChallengeResponseError"
        case .fsbUnableToCreateChallengeResponse: return "fsbUnableToCreateChallengeResponse"
        case .fsbUnreachable: return "fsbUnreachable"
        case .fuelLow: return "fuelLow"
        case .fuelTankTooLow: return "fuelTankTooLow"
        case .gasPedalPressed: return "gasPedalPressed"
        case .gearNotInPark: return "gearNotInPark"
        case .keyPluggedIn: return "keyPluggedIn"
        case .keyPluggedInWhileEngineIsRunning: return "keyPluggedInWhileEngineIsRunning"
        case .newRsRequested: return "newRsRequested"
        case .noCallbackReceived: return "noCallbackReceived"
        case .remoteStartBlocked: return "remoteStartBlocked"
        case .requestReceivedTwice: return "requestReceivedTwice"
        case .tcuCanError: return "tcuCanError"
        case .tcuNoRemoteService: return "tcuNoRemoteService"
        case .windowsOrRoofOpen: return "windowsOrRoofOpen"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.EngineStop: BaseCommandProtocol {

	public typealias Error = EngineStopError

	public func createGenericError(error: GenericCommandError) -> EngineStopError {
		return EngineStopError.genericError(error: error)
	}
}

extension Command.EngineStop: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the DeactivateVehicleKeys command version v2
public enum DeactivateVehicleKeysError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// cryptologic error
    case cryptoError

    /// Command failed: Doors failed
    case doorsFailed

    /// Command expired
    case expired

    /// Fastpath timeout
    case fastpathTimeout

    /// Command failed: Function disabled.
    case functionDisabled

    /// Command failed: Function not authorized.
    case functionNotAuthorized

    /// The ignition is not switched off
    case ignitionNotSwitchedOff

    /// Failed due to ignition is on
    case ignitionOn

    /// Command failed: Immobilizer failed
    case immobilizerFailed

    /// Get Challenge Failed: General Error
    case immobilizerGetChallengeFailed

    /// Command failed: Incompatible response from vehicle
    case immobilizerIncompatibleResponseFromVehicle

    /// Command failed: Vehicle states
    case immobilizerParkingBrakeNotSet

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> DeactivateVehicleKeysError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "7307": return .immobilizerFailed
        case "7308": return .doorsFailed
        case "7309": return .immobilizerParkingBrakeNotSet
        case "7310": return .ignitionOn
        case "7316": return .expired
        case "7317": return .immobilizerIncompatibleResponseFromVehicle
        case "7323": return .ignitionNotSwitchedOff
        case "7324": return .cryptoError
        case "7325": return .immobilizerGetChallengeFailed
        case "7328": return .functionDisabled
        case "7329": return .functionNotAuthorized
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .cryptoError: return "cryptoError"
        case .doorsFailed: return "doorsFailed"
        case .expired: return "expired"
        case .fastpathTimeout: return "fastpathTimeout"
        case .functionDisabled: return "functionDisabled"
        case .functionNotAuthorized: return "functionNotAuthorized"
        case .ignitionNotSwitchedOff: return "ignitionNotSwitchedOff"
        case .ignitionOn: return "ignitionOn"
        case .immobilizerFailed: return "immobilizerFailed"
        case .immobilizerGetChallengeFailed: return "immobilizerGetChallengeFailed"
        case .immobilizerIncompatibleResponseFromVehicle: return "immobilizerIncompatibleResponseFromVehicle"
        case .immobilizerParkingBrakeNotSet: return "immobilizerParkingBrakeNotSet"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.DeactivateVehicleKeys: BaseCommandProtocol {

	public typealias Error = DeactivateVehicleKeysError

	public func createGenericError(error: GenericCommandError) -> DeactivateVehicleKeysError {
		return DeactivateVehicleKeysError.genericError(error: error)
	}
}

extension Command.DeactivateVehicleKeys: CommandPinProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String, pin: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self, pin: pin)
	}
}


/// All possible error codes for the ActivateVehicleKeys command version v2
public enum ActivateVehicleKeysError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// cryptologic error
    case cryptoError

    /// Command expired
    case expired

    /// Fastpath timeout
    case fastpathTimeout

    /// Command failed: Function disabled.
    case functionDisabled

    /// Command failed: Function not authorized.
    case functionNotAuthorized

    /// Command failed: Ignition failed
    case ignitionFailed

    /// The ignition is not switched off
    case ignitionNotSwitchedOff

    /// Command failed
    case immobilizerCommandFailed

    /// Get Challenge Failed: General Error
    case immobilizerGetChallengeFailed

    /// Command failed: Incompatible response from vehicle
    case immobilizerIncompatibleResponseFromVehicle

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> ActivateVehicleKeysError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "7301": return .immobilizerCommandFailed
        case "7303": return .ignitionFailed
        case "7316": return .expired
        case "7317": return .immobilizerIncompatibleResponseFromVehicle
        case "7323": return .ignitionNotSwitchedOff
        case "7324": return .cryptoError
        case "7325": return .immobilizerGetChallengeFailed
        case "7328": return .functionDisabled
        case "7329": return .functionNotAuthorized
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .cryptoError: return "cryptoError"
        case .expired: return "expired"
        case .fastpathTimeout: return "fastpathTimeout"
        case .functionDisabled: return "functionDisabled"
        case .functionNotAuthorized: return "functionNotAuthorized"
        case .ignitionFailed: return "ignitionFailed"
        case .ignitionNotSwitchedOff: return "ignitionNotSwitchedOff"
        case .immobilizerCommandFailed: return "immobilizerCommandFailed"
        case .immobilizerGetChallengeFailed: return "immobilizerGetChallengeFailed"
        case .immobilizerIncompatibleResponseFromVehicle: return "immobilizerIncompatibleResponseFromVehicle"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.ActivateVehicleKeys: BaseCommandProtocol {

	public typealias Error = ActivateVehicleKeysError

	public func createGenericError(error: GenericCommandError) -> ActivateVehicleKeysError {
		return ActivateVehicleKeysError.genericError(error: error)
	}
}

extension Command.ActivateVehicleKeys: CommandPinProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String, pin: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self, pin: pin)
	}
}


/// All possible error codes for the ZevPreconditioningStart command version v1
public enum ZevPreconditioningStartError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// PreConditioning not possible, charging not finished
    case chargingNotFinished

    /// Fastpath timeout
    case fastpathTimeout

    /// not possible since either INSTANT CHARGING is already activated or INSTANT CHARGING command is currently in progress
    case instantChargingActiveOrInProgress

    /// Energy level in Battery is too low
    case lowBatteryLevel

    /// PreConditioning not possible, General error
    case preConditionGeneralError

    /// Processing of zev command failed
    case processingFailed

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> ZevPreconditioningStartError {
	    switch code { 
        case "4051": return .processingFailed
        case "4052": return .lowBatteryLevel
        case "4053": return .chargingNotFinished
        case "4054": return .instantChargingActiveOrInProgress
        case "4055": return .preConditionGeneralError
        case "42": return .fastpathTimeout
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .chargingNotFinished: return "chargingNotFinished"
        case .fastpathTimeout: return "fastpathTimeout"
        case .instantChargingActiveOrInProgress: return "instantChargingActiveOrInProgress"
        case .lowBatteryLevel: return "lowBatteryLevel"
        case .preConditionGeneralError: return "preConditionGeneralError"
        case .processingFailed: return "processingFailed"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.ZevPreconditioningStart: BaseCommandProtocol {

	public typealias Error = ZevPreconditioningStartError

	public func createGenericError(error: GenericCommandError) -> ZevPreconditioningStartError {
		return ZevPreconditioningStartError.genericError(error: error)
	}
}

extension Command.ZevPreconditioningStart: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the SunroofClose command version v1
public enum SunroofCloseError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Failed due to afterrun active
    case afterRunActive

    /// Failed due to afterrun active on front roof roller blind
    case afterRunActiveFrontRoofRollerBlind

    /// Failed due to afterrun active on rear roof roller blind
    case afterRunActiveRearRoofRollerBlind

    /// Failed due to afterrun active on sunroof
    case afterRunActiveSunroof

    /// Failed due to anti-trap protection active
    case antiTrapProtectionActive

    /// Failed due to anti-trap protection active on front roof roller blind
    case antiTrapProtectionActiveFrontRoofRollerBlind

    /// Failed due to anti-trap protection active on rear roof roller blind
    case antiTrapProtectionActiveRearRoofRollerBlind

    /// Failed due to anti-trap protection active on sunroof
    case antiTrapProtectionActiveSunroof

    /// Failed due to manual cancellation inside vehicle
    case cancelledManuallyInVehicle

    /// Failed due to manual cancellation inside vehicle on front roof roller blind
    case cancelledManuallyInVehicleFrontRoofRollerBlind

    /// Failed due to position not reached within timeout on rear roller blind
    case cancelledManuallyInVehicleRearRollerBlind

    /// Failed due to manual cancellation inside vehicle on rear roof roller blind
    case cancelledManuallyInVehicleRearRoofRollerBlind

    /// Failed due to drive motor overheated
    case driveMotorOverheated

    /// Failed due to drive motor overheated on front roof roller blind
    case driveMotorOverheatedFrontRoofRollerBlind

    /// Failed due to drive motor overheated on rear roof roller blind
    case driveMotorOverheatedRearRoofRollerBlind

    /// Failed due to drive motor overheated on sunroof
    case driveMotorOverheatedSunroof

    /// Fastpath timeout
    case fastpathTimeout

    /// Failed due to feature not available on front roof roller blind
    case featureNotAvailableFrontRoofRollerBlind

    /// Failed due to feature not available on rear roof roller blind
    case featureNotAvailableRearRoofRollerBlind

    /// Failed due to feature not available on sunroof
    case featureNotAvailableSunroof

    /// Failed due to front roof roller blind in motion
    case frontRoofRollerBlindInMotion

    /// Failed due to ignition is on
    case ignitionOn

    /// Failed due to internal system error
    case internalSystemError

    /// Failed due to invalid ignition state
    case invalidIgnitionState

    /// Failed due to invalid ignition state on front roof roller blind
    case invalidIgnitionStateFrontRoofRollerBlind

    /// Failed due to invalid ignition state on rear roof roller blind
    case invalidIgnitionStateRearRoofRollerBlind

    /// Failed due to invalid ignition state on sunroof
    case invalidIgnitionStateSunroof

    /// Failed due to invalid number on front roof roller blind
    case invalidNumberFrontRoofRollerBlind

    /// Failed due to invalid number on rear roof roller blind
    case invalidNumberRearRoofRollerBlind

    /// Failed due to invalid number on sunroof
    case invalidNumberSunroof

    /// Failed due to invalid position on front roof roller blind
    case invalidPositionFrontRoofRollerBlind

    /// Failed due to invalid position on rear roof roller blind
    case invalidPositionRearRoofRollerBlind

    /// Failed due to invalid position on sunroof
    case invalidPositionSunroof

    /// Failed due to invalid power status
    case invalidPowerStatus

    /// Failed due to invalid power status on front roof roller blind
    case invalidPowerStatusFrontRoofRollerBlind

    /// Failed due to invalid power status on rear roof roller blind
    case invalidPowerStatusRearRoofRollerBlind

    /// Failed due to invalid power status on sunroof
    case invalidPowerStatusSunroof

    /// Energy level in Battery is too low
    case lowBatteryLevel

    /// Failed due to low battery level 1
    case lowBatteryLevel1

    /// Failed due to low battery level 2
    case lowBatteryLevel2

    /// Failed due to mounted roof box
    case mountedRoofBox

    /// Failed due to multiple anti-trap protection activations
    case multiAntiTrapProtections

    /// Failed due to multiple anti-trap protection activations on front roof roller blind
    case multiAntiTrapProtectionsFrontRoofRollerBlind

    /// Failed due to multiple anti-trap protection activations on rear roof roller blind
    case multiAntiTrapProtectionsRearRoofRollerBlind

    /// Failed due to multiple anti-trap protection activations on sunroof
    case multiAntiTrapProtectionsSunroof

    /// Failed due to rear roof roller blind in motion
    case rearRoofRollerBlindInMotion

    /// Failed due to remote engine start is active
    case remoteEngineStartIsActive

    /// Failed due to roof in motion
    case roofInMotion

    /// Failed due to roof or roller blind in motion
    case roofOrRollerBlindInMotion

    /// Service not authorized
    case serviceNotAuthorized

    /// Failed due to system could not be normed
    case systemCouldNotBeNormed

    /// Failed due to system could not be normed on front roof roller blind
    case systemCouldNotBeNormedFrontRoofRollerBlind

    /// Failed due to system could not be normed on rear roof roller blind
    case systemCouldNotBeNormedRearRoofRollerBlind

    /// Failed due to system could not be normed on sunroof
    case systemCouldNotBeNormedSunroof

    /// Failed due to system malfunction
    case systemMalfunction

    /// Failed due to system malfunction on front roof roller blind
    case systemMalfunctionFrontRoofRollerBlind

    /// Failed due to system malfunction on rear roof roller blind
    case systemMalfunctionRearRoofRollerBlind

    /// Failed due to system malfunction on sunroof
    case systemMalfunctionSunroof

    /// Failed due to system not normed
    case systemNotNormed

    /// Failed due to system not normed on front roof roller blind
    case systemNotNormedFrontRoofRollerBlind

    /// Failed due to system not normed on rear roof roller blind
    case systemNotNormedRearRoofRollerBlind

    /// Failed due to system not normed on sunroof
    case systemNotNormedSunroof

    /// Failed due to UI handler not available on front roof roller blind
    case unavailableUiHandlerFrontRoofRollerBlind

    /// Failed due to UI handler not available on rear roof roller blind
    case unavailableUiHandlerRearRoofRollerBlind

    /// Failed due to UI handler not available on sunroof
    case unavailableUiHandlerSunroof

    /// Failed because vehicle is in motion
    case vehicleInMotion

    /// Remote window/roof command failed
    case windowRoofCommandFailed

    /// Remote window/roof command failed (vehicle state in IGN)
    case windowRoofCommandFailedIgnState

    /// Remote window/roof command failed (service not activated in HERMES)
    case windowRoofCommandServiceNotActive

    /// Remote window/roof command failed (window not normed)
    case windowRoofCommandWindowNotNormed

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> SunroofCloseError {
	    switch code { 
        case "21": return .lowBatteryLevel
        case "42": return .fastpathTimeout
        case "4200": return .serviceNotAuthorized
        case "4201": return .remoteEngineStartIsActive
        case "4202": return .ignitionOn
        case "4203": return .lowBatteryLevel2
        case "4204": return .lowBatteryLevel1
        case "4205": return .antiTrapProtectionActive
        case "4212": return .antiTrapProtectionActiveSunroof
        case "4213": return .antiTrapProtectionActiveFrontRoofRollerBlind
        case "4214": return .antiTrapProtectionActiveRearRoofRollerBlind
        case "4216": return .multiAntiTrapProtections
        case "4223": return .multiAntiTrapProtectionsSunroof
        case "4224": return .multiAntiTrapProtectionsFrontRoofRollerBlind
        case "4225": return .multiAntiTrapProtectionsRearRoofRollerBlind
        case "4227": return .cancelledManuallyInVehicle
        case "4235": return .cancelledManuallyInVehicleFrontRoofRollerBlind
        case "4236": return .cancelledManuallyInVehicleRearRoofRollerBlind
        case "4237": return .cancelledManuallyInVehicleRearRollerBlind
        case "4238": return .roofOrRollerBlindInMotion
        case "4239": return .roofInMotion
        case "4240": return .frontRoofRollerBlindInMotion
        case "4241": return .rearRoofRollerBlindInMotion
        case "4242": return .driveMotorOverheated
        case "4249": return .driveMotorOverheatedSunroof
        case "4250": return .driveMotorOverheatedFrontRoofRollerBlind
        case "4251": return .driveMotorOverheatedRearRoofRollerBlind
        case "4253": return .systemNotNormed
        case "4260": return .systemNotNormedSunroof
        case "4261": return .systemNotNormedFrontRoofRollerBlind
        case "4262": return .systemNotNormedRearRoofRollerBlind
        case "4264": return .mountedRoofBox
        case "4265": return .invalidPowerStatus
        case "4272": return .invalidPowerStatusSunroof
        case "4273": return .invalidPowerStatusFrontRoofRollerBlind
        case "4274": return .invalidPowerStatusRearRoofRollerBlind
        case "4276": return .afterRunActive
        case "4283": return .afterRunActiveSunroof
        case "4284": return .afterRunActiveFrontRoofRollerBlind
        case "4285": return .afterRunActiveRearRoofRollerBlind
        case "4287": return .invalidIgnitionState
        case "4294": return .invalidIgnitionStateSunroof
        case "4295": return .invalidIgnitionStateFrontRoofRollerBlind
        case "4296": return .invalidIgnitionStateRearRoofRollerBlind
        case "4298": return .vehicleInMotion
        case "4299": return .vehicleInMotion
        case "4300": return .vehicleInMotion
        case "4301": return .vehicleInMotion
        case "4303": return .systemCouldNotBeNormed
        case "4310": return .systemCouldNotBeNormedSunroof
        case "4311": return .systemCouldNotBeNormedFrontRoofRollerBlind
        case "4312": return .systemCouldNotBeNormedRearRoofRollerBlind
        case "4314": return .systemMalfunction
        case "4321": return .systemMalfunctionSunroof
        case "4322": return .systemMalfunctionFrontRoofRollerBlind
        case "4323": return .systemMalfunctionRearRoofRollerBlind
        case "4325": return .internalSystemError
        case "4334": return .invalidNumberSunroof
        case "4335": return .featureNotAvailableSunroof
        case "4340": return .invalidNumberFrontRoofRollerBlind
        case "4341": return .featureNotAvailableFrontRoofRollerBlind
        case "4342": return .invalidNumberRearRoofRollerBlind
        case "4343": return .featureNotAvailableRearRoofRollerBlind
        case "4358": return .invalidPositionSunroof
        case "4359": return .unavailableUiHandlerSunroof
        case "4360": return .invalidPositionFrontRoofRollerBlind
        case "4361": return .unavailableUiHandlerFrontRoofRollerBlind
        case "4362": return .invalidPositionRearRoofRollerBlind
        case "4363": return .unavailableUiHandlerRearRoofRollerBlind
        case "6901": return .windowRoofCommandFailed
        case "6902": return .windowRoofCommandFailedIgnState
        case "6903": return .windowRoofCommandWindowNotNormed
        case "6904": return .windowRoofCommandServiceNotActive
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .afterRunActive: return "afterRunActive"
        case .afterRunActiveFrontRoofRollerBlind: return "afterRunActiveFrontRoofRollerBlind"
        case .afterRunActiveRearRoofRollerBlind: return "afterRunActiveRearRoofRollerBlind"
        case .afterRunActiveSunroof: return "afterRunActiveSunroof"
        case .antiTrapProtectionActive: return "antiTrapProtectionActive"
        case .antiTrapProtectionActiveFrontRoofRollerBlind: return "antiTrapProtectionActiveFrontRoofRollerBlind"
        case .antiTrapProtectionActiveRearRoofRollerBlind: return "antiTrapProtectionActiveRearRoofRollerBlind"
        case .antiTrapProtectionActiveSunroof: return "antiTrapProtectionActiveSunroof"
        case .cancelledManuallyInVehicle: return "cancelledManuallyInVehicle"
        case .cancelledManuallyInVehicleFrontRoofRollerBlind: return "cancelledManuallyInVehicleFrontRoofRollerBlind"
        case .cancelledManuallyInVehicleRearRollerBlind: return "cancelledManuallyInVehicleRearRollerBlind"
        case .cancelledManuallyInVehicleRearRoofRollerBlind: return "cancelledManuallyInVehicleRearRoofRollerBlind"
        case .driveMotorOverheated: return "driveMotorOverheated"
        case .driveMotorOverheatedFrontRoofRollerBlind: return "driveMotorOverheatedFrontRoofRollerBlind"
        case .driveMotorOverheatedRearRoofRollerBlind: return "driveMotorOverheatedRearRoofRollerBlind"
        case .driveMotorOverheatedSunroof: return "driveMotorOverheatedSunroof"
        case .fastpathTimeout: return "fastpathTimeout"
        case .featureNotAvailableFrontRoofRollerBlind: return "featureNotAvailableFrontRoofRollerBlind"
        case .featureNotAvailableRearRoofRollerBlind: return "featureNotAvailableRearRoofRollerBlind"
        case .featureNotAvailableSunroof: return "featureNotAvailableSunroof"
        case .frontRoofRollerBlindInMotion: return "frontRoofRollerBlindInMotion"
        case .ignitionOn: return "ignitionOn"
        case .internalSystemError: return "internalSystemError"
        case .invalidIgnitionState: return "invalidIgnitionState"
        case .invalidIgnitionStateFrontRoofRollerBlind: return "invalidIgnitionStateFrontRoofRollerBlind"
        case .invalidIgnitionStateRearRoofRollerBlind: return "invalidIgnitionStateRearRoofRollerBlind"
        case .invalidIgnitionStateSunroof: return "invalidIgnitionStateSunroof"
        case .invalidNumberFrontRoofRollerBlind: return "invalidNumberFrontRoofRollerBlind"
        case .invalidNumberRearRoofRollerBlind: return "invalidNumberRearRoofRollerBlind"
        case .invalidNumberSunroof: return "invalidNumberSunroof"
        case .invalidPositionFrontRoofRollerBlind: return "invalidPositionFrontRoofRollerBlind"
        case .invalidPositionRearRoofRollerBlind: return "invalidPositionRearRoofRollerBlind"
        case .invalidPositionSunroof: return "invalidPositionSunroof"
        case .invalidPowerStatus: return "invalidPowerStatus"
        case .invalidPowerStatusFrontRoofRollerBlind: return "invalidPowerStatusFrontRoofRollerBlind"
        case .invalidPowerStatusRearRoofRollerBlind: return "invalidPowerStatusRearRoofRollerBlind"
        case .invalidPowerStatusSunroof: return "invalidPowerStatusSunroof"
        case .lowBatteryLevel: return "lowBatteryLevel"
        case .lowBatteryLevel1: return "lowBatteryLevel1"
        case .lowBatteryLevel2: return "lowBatteryLevel2"
        case .mountedRoofBox: return "mountedRoofBox"
        case .multiAntiTrapProtections: return "multiAntiTrapProtections"
        case .multiAntiTrapProtectionsFrontRoofRollerBlind: return "multiAntiTrapProtectionsFrontRoofRollerBlind"
        case .multiAntiTrapProtectionsRearRoofRollerBlind: return "multiAntiTrapProtectionsRearRoofRollerBlind"
        case .multiAntiTrapProtectionsSunroof: return "multiAntiTrapProtectionsSunroof"
        case .rearRoofRollerBlindInMotion: return "rearRoofRollerBlindInMotion"
        case .remoteEngineStartIsActive: return "remoteEngineStartIsActive"
        case .roofInMotion: return "roofInMotion"
        case .roofOrRollerBlindInMotion: return "roofOrRollerBlindInMotion"
        case .serviceNotAuthorized: return "serviceNotAuthorized"
        case .systemCouldNotBeNormed: return "systemCouldNotBeNormed"
        case .systemCouldNotBeNormedFrontRoofRollerBlind: return "systemCouldNotBeNormedFrontRoofRollerBlind"
        case .systemCouldNotBeNormedRearRoofRollerBlind: return "systemCouldNotBeNormedRearRoofRollerBlind"
        case .systemCouldNotBeNormedSunroof: return "systemCouldNotBeNormedSunroof"
        case .systemMalfunction: return "systemMalfunction"
        case .systemMalfunctionFrontRoofRollerBlind: return "systemMalfunctionFrontRoofRollerBlind"
        case .systemMalfunctionRearRoofRollerBlind: return "systemMalfunctionRearRoofRollerBlind"
        case .systemMalfunctionSunroof: return "systemMalfunctionSunroof"
        case .systemNotNormed: return "systemNotNormed"
        case .systemNotNormedFrontRoofRollerBlind: return "systemNotNormedFrontRoofRollerBlind"
        case .systemNotNormedRearRoofRollerBlind: return "systemNotNormedRearRoofRollerBlind"
        case .systemNotNormedSunroof: return "systemNotNormedSunroof"
        case .unavailableUiHandlerFrontRoofRollerBlind: return "unavailableUiHandlerFrontRoofRollerBlind"
        case .unavailableUiHandlerRearRoofRollerBlind: return "unavailableUiHandlerRearRoofRollerBlind"
        case .unavailableUiHandlerSunroof: return "unavailableUiHandlerSunroof"
        case .vehicleInMotion: return "vehicleInMotion"
        case .windowRoofCommandFailed: return "windowRoofCommandFailed"
        case .windowRoofCommandFailedIgnState: return "windowRoofCommandFailedIgnState"
        case .windowRoofCommandServiceNotActive: return "windowRoofCommandServiceNotActive"
        case .windowRoofCommandWindowNotNormed: return "windowRoofCommandWindowNotNormed"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.SunroofClose: BaseCommandProtocol {

	public typealias Error = SunroofCloseError

	public func createGenericError(error: GenericCommandError) -> SunroofCloseError {
		return SunroofCloseError.genericError(error: error)
	}
}

extension Command.SunroofClose: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the SunroofLift command version v1
public enum SunroofLiftError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Failed due to afterrun active
    case afterRunActive

    /// Failed due to afterrun active on front roof roller blind
    case afterRunActiveFrontRoofRollerBlind

    /// Failed due to afterrun active on rear roof roller blind
    case afterRunActiveRearRoofRollerBlind

    /// Failed due to afterrun active on sunroof
    case afterRunActiveSunroof

    /// Failed due to anti-trap protection active
    case antiTrapProtectionActive

    /// Failed due to anti-trap protection active on front roof roller blind
    case antiTrapProtectionActiveFrontRoofRollerBlind

    /// Failed due to anti-trap protection active on rear roof roller blind
    case antiTrapProtectionActiveRearRoofRollerBlind

    /// Failed due to anti-trap protection active on sunroof
    case antiTrapProtectionActiveSunroof

    /// Failed due to manual cancellation inside vehicle
    case cancelledManuallyInVehicle

    /// Failed due to manual cancellation inside vehicle on front roof roller blind
    case cancelledManuallyInVehicleFrontRoofRollerBlind

    /// Failed due to position not reached within timeout on rear roller blind
    case cancelledManuallyInVehicleRearRollerBlind

    /// Failed due to manual cancellation inside vehicle on rear roof roller blind
    case cancelledManuallyInVehicleRearRoofRollerBlind

    /// Failed due to drive motor overheated
    case driveMotorOverheated

    /// Failed due to drive motor overheated on front roof roller blind
    case driveMotorOverheatedFrontRoofRollerBlind

    /// Failed due to drive motor overheated on rear roof roller blind
    case driveMotorOverheatedRearRoofRollerBlind

    /// Failed due to drive motor overheated on sunroof
    case driveMotorOverheatedSunroof

    /// Fastpath timeout
    case fastpathTimeout

    /// Failed due to feature not available on front roof roller blind
    case featureNotAvailableFrontRoofRollerBlind

    /// Failed due to feature not available on rear roof roller blind
    case featureNotAvailableRearRoofRollerBlind

    /// Failed due to feature not available on sunroof
    case featureNotAvailableSunroof

    /// Failed due to front roof roller blind in motion
    case frontRoofRollerBlindInMotion

    /// Failed due to ignition is on
    case ignitionOn

    /// Failed due to internal system error
    case internalSystemError

    /// Failed due to invalid ignition state
    case invalidIgnitionState

    /// Failed due to invalid ignition state on front roof roller blind
    case invalidIgnitionStateFrontRoofRollerBlind

    /// Failed due to invalid ignition state on rear roof roller blind
    case invalidIgnitionStateRearRoofRollerBlind

    /// Failed due to invalid ignition state on sunroof
    case invalidIgnitionStateSunroof

    /// Failed due to invalid number on front roof roller blind
    case invalidNumberFrontRoofRollerBlind

    /// Failed due to invalid number on rear roof roller blind
    case invalidNumberRearRoofRollerBlind

    /// Failed due to invalid number on sunroof
    case invalidNumberSunroof

    /// Failed due to invalid position on front roof roller blind
    case invalidPositionFrontRoofRollerBlind

    /// Failed due to invalid position on rear roof roller blind
    case invalidPositionRearRoofRollerBlind

    /// Failed due to invalid position on sunroof
    case invalidPositionSunroof

    /// Failed due to invalid power status
    case invalidPowerStatus

    /// Failed due to invalid power status on front roof roller blind
    case invalidPowerStatusFrontRoofRollerBlind

    /// Failed due to invalid power status on rear roof roller blind
    case invalidPowerStatusRearRoofRollerBlind

    /// Failed due to invalid power status on sunroof
    case invalidPowerStatusSunroof

    /// Energy level in Battery is too low
    case lowBatteryLevel

    /// Failed due to low battery level 1
    case lowBatteryLevel1

    /// Failed due to low battery level 2
    case lowBatteryLevel2

    /// Failed due to mounted roof box
    case mountedRoofBox

    /// Failed due to multiple anti-trap protection activations
    case multiAntiTrapProtections

    /// Failed due to multiple anti-trap protection activations on front roof roller blind
    case multiAntiTrapProtectionsFrontRoofRollerBlind

    /// Failed due to multiple anti-trap protection activations on rear roof roller blind
    case multiAntiTrapProtectionsRearRoofRollerBlind

    /// Failed due to multiple anti-trap protection activations on sunroof
    case multiAntiTrapProtectionsSunroof

    /// Failed due to rear roof roller blind in motion
    case rearRoofRollerBlindInMotion

    /// Failed due to remote engine start is active
    case remoteEngineStartIsActive

    /// Failed due to roof in motion
    case roofInMotion

    /// Failed due to roof or roller blind in motion
    case roofOrRollerBlindInMotion

    /// Service not authorized
    case serviceNotAuthorized

    /// Failed due to system could not be normed
    case systemCouldNotBeNormed

    /// Failed due to system could not be normed on front roof roller blind
    case systemCouldNotBeNormedFrontRoofRollerBlind

    /// Failed due to system could not be normed on rear roof roller blind
    case systemCouldNotBeNormedRearRoofRollerBlind

    /// Failed due to system could not be normed on sunroof
    case systemCouldNotBeNormedSunroof

    /// Failed due to system malfunction
    case systemMalfunction

    /// Failed due to system malfunction on front roof roller blind
    case systemMalfunctionFrontRoofRollerBlind

    /// Failed due to system malfunction on rear roof roller blind
    case systemMalfunctionRearRoofRollerBlind

    /// Failed due to system malfunction on sunroof
    case systemMalfunctionSunroof

    /// Failed due to system not normed
    case systemNotNormed

    /// Failed due to system not normed on front roof roller blind
    case systemNotNormedFrontRoofRollerBlind

    /// Failed due to system not normed on rear roof roller blind
    case systemNotNormedRearRoofRollerBlind

    /// Failed due to system not normed on sunroof
    case systemNotNormedSunroof

    /// Failed due to UI handler not available on front roof roller blind
    case unavailableUiHandlerFrontRoofRollerBlind

    /// Failed due to UI handler not available on rear roof roller blind
    case unavailableUiHandlerRearRoofRollerBlind

    /// Failed due to UI handler not available on sunroof
    case unavailableUiHandlerSunroof

    /// Failed because vehicle is in motion
    case vehicleInMotion

    /// Remote window/roof command failed
    case windowRoofCommandFailed

    /// Remote window/roof command failed (vehicle state in IGN)
    case windowRoofCommandFailedIgnState

    /// Remote window/roof command failed (service not activated in HERMES)
    case windowRoofCommandServiceNotActive

    /// Remote window/roof command failed (window not normed)
    case windowRoofCommandWindowNotNormed

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> SunroofLiftError {
	    switch code { 
        case "21": return .lowBatteryLevel
        case "42": return .fastpathTimeout
        case "4200": return .serviceNotAuthorized
        case "4201": return .remoteEngineStartIsActive
        case "4202": return .ignitionOn
        case "4203": return .lowBatteryLevel2
        case "4204": return .lowBatteryLevel1
        case "4205": return .antiTrapProtectionActive
        case "4212": return .antiTrapProtectionActiveSunroof
        case "4213": return .antiTrapProtectionActiveFrontRoofRollerBlind
        case "4214": return .antiTrapProtectionActiveRearRoofRollerBlind
        case "4216": return .multiAntiTrapProtections
        case "4223": return .multiAntiTrapProtectionsSunroof
        case "4224": return .multiAntiTrapProtectionsFrontRoofRollerBlind
        case "4225": return .multiAntiTrapProtectionsRearRoofRollerBlind
        case "4227": return .cancelledManuallyInVehicle
        case "4235": return .cancelledManuallyInVehicleFrontRoofRollerBlind
        case "4236": return .cancelledManuallyInVehicleRearRoofRollerBlind
        case "4237": return .cancelledManuallyInVehicleRearRollerBlind
        case "4238": return .roofOrRollerBlindInMotion
        case "4239": return .roofInMotion
        case "4240": return .frontRoofRollerBlindInMotion
        case "4241": return .rearRoofRollerBlindInMotion
        case "4242": return .driveMotorOverheated
        case "4249": return .driveMotorOverheatedSunroof
        case "4250": return .driveMotorOverheatedFrontRoofRollerBlind
        case "4251": return .driveMotorOverheatedRearRoofRollerBlind
        case "4253": return .systemNotNormed
        case "4260": return .systemNotNormedSunroof
        case "4261": return .systemNotNormedFrontRoofRollerBlind
        case "4262": return .systemNotNormedRearRoofRollerBlind
        case "4264": return .mountedRoofBox
        case "4265": return .invalidPowerStatus
        case "4272": return .invalidPowerStatusSunroof
        case "4273": return .invalidPowerStatusFrontRoofRollerBlind
        case "4274": return .invalidPowerStatusRearRoofRollerBlind
        case "4276": return .afterRunActive
        case "4283": return .afterRunActiveSunroof
        case "4284": return .afterRunActiveFrontRoofRollerBlind
        case "4285": return .afterRunActiveRearRoofRollerBlind
        case "4287": return .invalidIgnitionState
        case "4294": return .invalidIgnitionStateSunroof
        case "4295": return .invalidIgnitionStateFrontRoofRollerBlind
        case "4296": return .invalidIgnitionStateRearRoofRollerBlind
        case "4298": return .vehicleInMotion
        case "4299": return .vehicleInMotion
        case "4300": return .vehicleInMotion
        case "4301": return .vehicleInMotion
        case "4303": return .systemCouldNotBeNormed
        case "4310": return .systemCouldNotBeNormedSunroof
        case "4311": return .systemCouldNotBeNormedFrontRoofRollerBlind
        case "4312": return .systemCouldNotBeNormedRearRoofRollerBlind
        case "4314": return .systemMalfunction
        case "4321": return .systemMalfunctionSunroof
        case "4322": return .systemMalfunctionFrontRoofRollerBlind
        case "4323": return .systemMalfunctionRearRoofRollerBlind
        case "4325": return .internalSystemError
        case "4334": return .invalidNumberSunroof
        case "4335": return .featureNotAvailableSunroof
        case "4340": return .invalidNumberFrontRoofRollerBlind
        case "4341": return .featureNotAvailableFrontRoofRollerBlind
        case "4342": return .invalidNumberRearRoofRollerBlind
        case "4343": return .featureNotAvailableRearRoofRollerBlind
        case "4358": return .invalidPositionSunroof
        case "4359": return .unavailableUiHandlerSunroof
        case "4360": return .invalidPositionFrontRoofRollerBlind
        case "4361": return .unavailableUiHandlerFrontRoofRollerBlind
        case "4362": return .invalidPositionRearRoofRollerBlind
        case "4363": return .unavailableUiHandlerRearRoofRollerBlind
        case "6901": return .windowRoofCommandFailed
        case "6902": return .windowRoofCommandFailedIgnState
        case "6903": return .windowRoofCommandWindowNotNormed
        case "6904": return .windowRoofCommandServiceNotActive
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .afterRunActive: return "afterRunActive"
        case .afterRunActiveFrontRoofRollerBlind: return "afterRunActiveFrontRoofRollerBlind"
        case .afterRunActiveRearRoofRollerBlind: return "afterRunActiveRearRoofRollerBlind"
        case .afterRunActiveSunroof: return "afterRunActiveSunroof"
        case .antiTrapProtectionActive: return "antiTrapProtectionActive"
        case .antiTrapProtectionActiveFrontRoofRollerBlind: return "antiTrapProtectionActiveFrontRoofRollerBlind"
        case .antiTrapProtectionActiveRearRoofRollerBlind: return "antiTrapProtectionActiveRearRoofRollerBlind"
        case .antiTrapProtectionActiveSunroof: return "antiTrapProtectionActiveSunroof"
        case .cancelledManuallyInVehicle: return "cancelledManuallyInVehicle"
        case .cancelledManuallyInVehicleFrontRoofRollerBlind: return "cancelledManuallyInVehicleFrontRoofRollerBlind"
        case .cancelledManuallyInVehicleRearRollerBlind: return "cancelledManuallyInVehicleRearRollerBlind"
        case .cancelledManuallyInVehicleRearRoofRollerBlind: return "cancelledManuallyInVehicleRearRoofRollerBlind"
        case .driveMotorOverheated: return "driveMotorOverheated"
        case .driveMotorOverheatedFrontRoofRollerBlind: return "driveMotorOverheatedFrontRoofRollerBlind"
        case .driveMotorOverheatedRearRoofRollerBlind: return "driveMotorOverheatedRearRoofRollerBlind"
        case .driveMotorOverheatedSunroof: return "driveMotorOverheatedSunroof"
        case .fastpathTimeout: return "fastpathTimeout"
        case .featureNotAvailableFrontRoofRollerBlind: return "featureNotAvailableFrontRoofRollerBlind"
        case .featureNotAvailableRearRoofRollerBlind: return "featureNotAvailableRearRoofRollerBlind"
        case .featureNotAvailableSunroof: return "featureNotAvailableSunroof"
        case .frontRoofRollerBlindInMotion: return "frontRoofRollerBlindInMotion"
        case .ignitionOn: return "ignitionOn"
        case .internalSystemError: return "internalSystemError"
        case .invalidIgnitionState: return "invalidIgnitionState"
        case .invalidIgnitionStateFrontRoofRollerBlind: return "invalidIgnitionStateFrontRoofRollerBlind"
        case .invalidIgnitionStateRearRoofRollerBlind: return "invalidIgnitionStateRearRoofRollerBlind"
        case .invalidIgnitionStateSunroof: return "invalidIgnitionStateSunroof"
        case .invalidNumberFrontRoofRollerBlind: return "invalidNumberFrontRoofRollerBlind"
        case .invalidNumberRearRoofRollerBlind: return "invalidNumberRearRoofRollerBlind"
        case .invalidNumberSunroof: return "invalidNumberSunroof"
        case .invalidPositionFrontRoofRollerBlind: return "invalidPositionFrontRoofRollerBlind"
        case .invalidPositionRearRoofRollerBlind: return "invalidPositionRearRoofRollerBlind"
        case .invalidPositionSunroof: return "invalidPositionSunroof"
        case .invalidPowerStatus: return "invalidPowerStatus"
        case .invalidPowerStatusFrontRoofRollerBlind: return "invalidPowerStatusFrontRoofRollerBlind"
        case .invalidPowerStatusRearRoofRollerBlind: return "invalidPowerStatusRearRoofRollerBlind"
        case .invalidPowerStatusSunroof: return "invalidPowerStatusSunroof"
        case .lowBatteryLevel: return "lowBatteryLevel"
        case .lowBatteryLevel1: return "lowBatteryLevel1"
        case .lowBatteryLevel2: return "lowBatteryLevel2"
        case .mountedRoofBox: return "mountedRoofBox"
        case .multiAntiTrapProtections: return "multiAntiTrapProtections"
        case .multiAntiTrapProtectionsFrontRoofRollerBlind: return "multiAntiTrapProtectionsFrontRoofRollerBlind"
        case .multiAntiTrapProtectionsRearRoofRollerBlind: return "multiAntiTrapProtectionsRearRoofRollerBlind"
        case .multiAntiTrapProtectionsSunroof: return "multiAntiTrapProtectionsSunroof"
        case .rearRoofRollerBlindInMotion: return "rearRoofRollerBlindInMotion"
        case .remoteEngineStartIsActive: return "remoteEngineStartIsActive"
        case .roofInMotion: return "roofInMotion"
        case .roofOrRollerBlindInMotion: return "roofOrRollerBlindInMotion"
        case .serviceNotAuthorized: return "serviceNotAuthorized"
        case .systemCouldNotBeNormed: return "systemCouldNotBeNormed"
        case .systemCouldNotBeNormedFrontRoofRollerBlind: return "systemCouldNotBeNormedFrontRoofRollerBlind"
        case .systemCouldNotBeNormedRearRoofRollerBlind: return "systemCouldNotBeNormedRearRoofRollerBlind"
        case .systemCouldNotBeNormedSunroof: return "systemCouldNotBeNormedSunroof"
        case .systemMalfunction: return "systemMalfunction"
        case .systemMalfunctionFrontRoofRollerBlind: return "systemMalfunctionFrontRoofRollerBlind"
        case .systemMalfunctionRearRoofRollerBlind: return "systemMalfunctionRearRoofRollerBlind"
        case .systemMalfunctionSunroof: return "systemMalfunctionSunroof"
        case .systemNotNormed: return "systemNotNormed"
        case .systemNotNormedFrontRoofRollerBlind: return "systemNotNormedFrontRoofRollerBlind"
        case .systemNotNormedRearRoofRollerBlind: return "systemNotNormedRearRoofRollerBlind"
        case .systemNotNormedSunroof: return "systemNotNormedSunroof"
        case .unavailableUiHandlerFrontRoofRollerBlind: return "unavailableUiHandlerFrontRoofRollerBlind"
        case .unavailableUiHandlerRearRoofRollerBlind: return "unavailableUiHandlerRearRoofRollerBlind"
        case .unavailableUiHandlerSunroof: return "unavailableUiHandlerSunroof"
        case .vehicleInMotion: return "vehicleInMotion"
        case .windowRoofCommandFailed: return "windowRoofCommandFailed"
        case .windowRoofCommandFailedIgnState: return "windowRoofCommandFailedIgnState"
        case .windowRoofCommandServiceNotActive: return "windowRoofCommandServiceNotActive"
        case .windowRoofCommandWindowNotNormed: return "windowRoofCommandWindowNotNormed"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.SunroofLift: BaseCommandProtocol {

	public typealias Error = SunroofLiftError

	public func createGenericError(error: GenericCommandError) -> SunroofLiftError {
		return SunroofLiftError.genericError(error: error)
	}
}

extension Command.SunroofLift: CommandPinProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String, pin: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self, pin: pin)
	}
}


/// All possible error codes for the SunroofMove command version v1
public enum SunroofMoveError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Failed due to afterrun active
    case afterRunActive

    /// Failed due to afterrun active on front roof roller blind
    case afterRunActiveFrontRoofRollerBlind

    /// Failed due to afterrun active on rear roof roller blind
    case afterRunActiveRearRoofRollerBlind

    /// Failed due to afterrun active on sunroof
    case afterRunActiveSunroof

    /// Failed due to anti-trap protection active
    case antiTrapProtectionActive

    /// Failed due to anti-trap protection active on front roof roller blind
    case antiTrapProtectionActiveFrontRoofRollerBlind

    /// Failed due to anti-trap protection active on rear roof roller blind
    case antiTrapProtectionActiveRearRoofRollerBlind

    /// Failed due to anti-trap protection active on sunroof
    case antiTrapProtectionActiveSunroof

    /// Failed due to manual cancellation inside vehicle
    case cancelledManuallyInVehicle

    /// Failed due to manual cancellation inside vehicle on front roof roller blind
    case cancelledManuallyInVehicleFrontRoofRollerBlind

    /// Failed due to position not reached within timeout on rear roller blind
    case cancelledManuallyInVehicleRearRollerBlind

    /// Failed due to manual cancellation inside vehicle on rear roof roller blind
    case cancelledManuallyInVehicleRearRoofRollerBlind

    /// Failed due to drive motor overheated
    case driveMotorOverheated

    /// Failed due to drive motor overheated on front roof roller blind
    case driveMotorOverheatedFrontRoofRollerBlind

    /// Failed due to drive motor overheated on rear roof roller blind
    case driveMotorOverheatedRearRoofRollerBlind

    /// Failed due to drive motor overheated on sunroof
    case driveMotorOverheatedSunroof

    /// Failed due to feature not available on front roof roller blind
    case featureNotAvailableFrontRoofRollerBlind

    /// Failed due to feature not available on rear roof roller blind
    case featureNotAvailableRearRoofRollerBlind

    /// Failed due to feature not available on sunroof
    case featureNotAvailableSunroof

    /// Failed due to front roof roller blind in motion
    case frontRoofRollerBlindInMotion

    /// Failed due to ignition is on
    case ignitionOn

    /// Failed due to internal system error
    case internalSystemError

    /// Failed due to invalid ignition state
    case invalidIgnitionState

    /// Failed due to invalid ignition state on front roof roller blind
    case invalidIgnitionStateFrontRoofRollerBlind

    /// Failed due to invalid ignition state on rear roof roller blind
    case invalidIgnitionStateRearRoofRollerBlind

    /// Failed due to invalid ignition state on sunroof
    case invalidIgnitionStateSunroof

    /// Failed due to invalid number on front roof roller blind
    case invalidNumberFrontRoofRollerBlind

    /// Failed due to invalid number on rear roof roller blind
    case invalidNumberRearRoofRollerBlind

    /// Failed due to invalid number on sunroof
    case invalidNumberSunroof

    /// Failed due to invalid position on front roof roller blind
    case invalidPositionFrontRoofRollerBlind

    /// Failed due to invalid position on rear roof roller blind
    case invalidPositionRearRoofRollerBlind

    /// Failed due to invalid position on sunroof
    case invalidPositionSunroof

    /// Failed due to invalid power status
    case invalidPowerStatus

    /// Failed due to invalid power status on front roof roller blind
    case invalidPowerStatusFrontRoofRollerBlind

    /// Failed due to invalid power status on rear roof roller blind
    case invalidPowerStatusRearRoofRollerBlind

    /// Failed due to invalid power status on sunroof
    case invalidPowerStatusSunroof

    /// Failed due to low battery level 1
    case lowBatteryLevel1

    /// Failed due to low battery level 2
    case lowBatteryLevel2

    /// Failed due to mounted roof box
    case mountedRoofBox

    /// Failed due to multiple anti-trap protection activations
    case multiAntiTrapProtections

    /// Failed due to multiple anti-trap protection activations on front roof roller blind
    case multiAntiTrapProtectionsFrontRoofRollerBlind

    /// Failed due to multiple anti-trap protection activations on rear roof roller blind
    case multiAntiTrapProtectionsRearRoofRollerBlind

    /// Failed due to multiple anti-trap protection activations on sunroof
    case multiAntiTrapProtectionsSunroof

    /// Failed due to rear roof roller blind in motion
    case rearRoofRollerBlindInMotion

    /// Failed due to remote engine start is active
    case remoteEngineStartIsActive

    /// Failed due to roof in motion
    case roofInMotion

    /// Failed due to roof or roller blind in motion
    case roofOrRollerBlindInMotion

    /// Service not authorized
    case serviceNotAuthorized

    /// Failed due to system could not be normed
    case systemCouldNotBeNormed

    /// Failed due to system could not be normed on front roof roller blind
    case systemCouldNotBeNormedFrontRoofRollerBlind

    /// Failed due to system could not be normed on rear roof roller blind
    case systemCouldNotBeNormedRearRoofRollerBlind

    /// Failed due to system could not be normed on sunroof
    case systemCouldNotBeNormedSunroof

    /// Failed due to system malfunction
    case systemMalfunction

    /// Failed due to system malfunction on front roof roller blind
    case systemMalfunctionFrontRoofRollerBlind

    /// Failed due to system malfunction on rear roof roller blind
    case systemMalfunctionRearRoofRollerBlind

    /// Failed due to system malfunction on sunroof
    case systemMalfunctionSunroof

    /// Failed due to system not normed
    case systemNotNormed

    /// Failed due to system not normed on front roof roller blind
    case systemNotNormedFrontRoofRollerBlind

    /// Failed due to system not normed on rear roof roller blind
    case systemNotNormedRearRoofRollerBlind

    /// Failed due to system not normed on sunroof
    case systemNotNormedSunroof

    /// Failed due to UI handler not available on front roof roller blind
    case unavailableUiHandlerFrontRoofRollerBlind

    /// Failed due to UI handler not available on rear roof roller blind
    case unavailableUiHandlerRearRoofRollerBlind

    /// Failed due to UI handler not available on sunroof
    case unavailableUiHandlerSunroof

    /// Failed because vehicle is in motion
    case vehicleInMotion

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> SunroofMoveError {
	    switch code { 
        case "4200": return .serviceNotAuthorized
        case "4201": return .remoteEngineStartIsActive
        case "4202": return .ignitionOn
        case "4203": return .lowBatteryLevel2
        case "4204": return .lowBatteryLevel1
        case "4205": return .antiTrapProtectionActive
        case "4212": return .antiTrapProtectionActiveSunroof
        case "4213": return .antiTrapProtectionActiveFrontRoofRollerBlind
        case "4214": return .antiTrapProtectionActiveRearRoofRollerBlind
        case "4216": return .multiAntiTrapProtections
        case "4223": return .multiAntiTrapProtectionsSunroof
        case "4224": return .multiAntiTrapProtectionsFrontRoofRollerBlind
        case "4225": return .multiAntiTrapProtectionsRearRoofRollerBlind
        case "4227": return .cancelledManuallyInVehicle
        case "4235": return .cancelledManuallyInVehicleFrontRoofRollerBlind
        case "4236": return .cancelledManuallyInVehicleRearRoofRollerBlind
        case "4237": return .cancelledManuallyInVehicleRearRollerBlind
        case "4238": return .roofOrRollerBlindInMotion
        case "4239": return .roofInMotion
        case "4240": return .frontRoofRollerBlindInMotion
        case "4241": return .rearRoofRollerBlindInMotion
        case "4242": return .driveMotorOverheated
        case "4249": return .driveMotorOverheatedSunroof
        case "4250": return .driveMotorOverheatedFrontRoofRollerBlind
        case "4251": return .driveMotorOverheatedRearRoofRollerBlind
        case "4253": return .systemNotNormed
        case "4260": return .systemNotNormedSunroof
        case "4261": return .systemNotNormedFrontRoofRollerBlind
        case "4262": return .systemNotNormedRearRoofRollerBlind
        case "4264": return .mountedRoofBox
        case "4265": return .invalidPowerStatus
        case "4272": return .invalidPowerStatusSunroof
        case "4273": return .invalidPowerStatusFrontRoofRollerBlind
        case "4274": return .invalidPowerStatusRearRoofRollerBlind
        case "4276": return .afterRunActive
        case "4283": return .afterRunActiveSunroof
        case "4284": return .afterRunActiveFrontRoofRollerBlind
        case "4285": return .afterRunActiveRearRoofRollerBlind
        case "4287": return .invalidIgnitionState
        case "4294": return .invalidIgnitionStateSunroof
        case "4295": return .invalidIgnitionStateFrontRoofRollerBlind
        case "4296": return .invalidIgnitionStateRearRoofRollerBlind
        case "4298": return .vehicleInMotion
        case "4299": return .vehicleInMotion
        case "4300": return .vehicleInMotion
        case "4301": return .vehicleInMotion
        case "4303": return .systemCouldNotBeNormed
        case "4310": return .systemCouldNotBeNormedSunroof
        case "4311": return .systemCouldNotBeNormedFrontRoofRollerBlind
        case "4312": return .systemCouldNotBeNormedRearRoofRollerBlind
        case "4314": return .systemMalfunction
        case "4321": return .systemMalfunctionSunroof
        case "4322": return .systemMalfunctionFrontRoofRollerBlind
        case "4323": return .systemMalfunctionRearRoofRollerBlind
        case "4325": return .internalSystemError
        case "4334": return .invalidNumberSunroof
        case "4335": return .featureNotAvailableSunroof
        case "4340": return .invalidNumberFrontRoofRollerBlind
        case "4341": return .featureNotAvailableFrontRoofRollerBlind
        case "4342": return .invalidNumberRearRoofRollerBlind
        case "4343": return .featureNotAvailableRearRoofRollerBlind
        case "4358": return .invalidPositionSunroof
        case "4359": return .unavailableUiHandlerSunroof
        case "4360": return .invalidPositionFrontRoofRollerBlind
        case "4361": return .unavailableUiHandlerFrontRoofRollerBlind
        case "4362": return .invalidPositionRearRoofRollerBlind
        case "4363": return .unavailableUiHandlerRearRoofRollerBlind
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .afterRunActive: return "afterRunActive"
        case .afterRunActiveFrontRoofRollerBlind: return "afterRunActiveFrontRoofRollerBlind"
        case .afterRunActiveRearRoofRollerBlind: return "afterRunActiveRearRoofRollerBlind"
        case .afterRunActiveSunroof: return "afterRunActiveSunroof"
        case .antiTrapProtectionActive: return "antiTrapProtectionActive"
        case .antiTrapProtectionActiveFrontRoofRollerBlind: return "antiTrapProtectionActiveFrontRoofRollerBlind"
        case .antiTrapProtectionActiveRearRoofRollerBlind: return "antiTrapProtectionActiveRearRoofRollerBlind"
        case .antiTrapProtectionActiveSunroof: return "antiTrapProtectionActiveSunroof"
        case .cancelledManuallyInVehicle: return "cancelledManuallyInVehicle"
        case .cancelledManuallyInVehicleFrontRoofRollerBlind: return "cancelledManuallyInVehicleFrontRoofRollerBlind"
        case .cancelledManuallyInVehicleRearRollerBlind: return "cancelledManuallyInVehicleRearRollerBlind"
        case .cancelledManuallyInVehicleRearRoofRollerBlind: return "cancelledManuallyInVehicleRearRoofRollerBlind"
        case .driveMotorOverheated: return "driveMotorOverheated"
        case .driveMotorOverheatedFrontRoofRollerBlind: return "driveMotorOverheatedFrontRoofRollerBlind"
        case .driveMotorOverheatedRearRoofRollerBlind: return "driveMotorOverheatedRearRoofRollerBlind"
        case .driveMotorOverheatedSunroof: return "driveMotorOverheatedSunroof"
        case .featureNotAvailableFrontRoofRollerBlind: return "featureNotAvailableFrontRoofRollerBlind"
        case .featureNotAvailableRearRoofRollerBlind: return "featureNotAvailableRearRoofRollerBlind"
        case .featureNotAvailableSunroof: return "featureNotAvailableSunroof"
        case .frontRoofRollerBlindInMotion: return "frontRoofRollerBlindInMotion"
        case .ignitionOn: return "ignitionOn"
        case .internalSystemError: return "internalSystemError"
        case .invalidIgnitionState: return "invalidIgnitionState"
        case .invalidIgnitionStateFrontRoofRollerBlind: return "invalidIgnitionStateFrontRoofRollerBlind"
        case .invalidIgnitionStateRearRoofRollerBlind: return "invalidIgnitionStateRearRoofRollerBlind"
        case .invalidIgnitionStateSunroof: return "invalidIgnitionStateSunroof"
        case .invalidNumberFrontRoofRollerBlind: return "invalidNumberFrontRoofRollerBlind"
        case .invalidNumberRearRoofRollerBlind: return "invalidNumberRearRoofRollerBlind"
        case .invalidNumberSunroof: return "invalidNumberSunroof"
        case .invalidPositionFrontRoofRollerBlind: return "invalidPositionFrontRoofRollerBlind"
        case .invalidPositionRearRoofRollerBlind: return "invalidPositionRearRoofRollerBlind"
        case .invalidPositionSunroof: return "invalidPositionSunroof"
        case .invalidPowerStatus: return "invalidPowerStatus"
        case .invalidPowerStatusFrontRoofRollerBlind: return "invalidPowerStatusFrontRoofRollerBlind"
        case .invalidPowerStatusRearRoofRollerBlind: return "invalidPowerStatusRearRoofRollerBlind"
        case .invalidPowerStatusSunroof: return "invalidPowerStatusSunroof"
        case .lowBatteryLevel1: return "lowBatteryLevel1"
        case .lowBatteryLevel2: return "lowBatteryLevel2"
        case .mountedRoofBox: return "mountedRoofBox"
        case .multiAntiTrapProtections: return "multiAntiTrapProtections"
        case .multiAntiTrapProtectionsFrontRoofRollerBlind: return "multiAntiTrapProtectionsFrontRoofRollerBlind"
        case .multiAntiTrapProtectionsRearRoofRollerBlind: return "multiAntiTrapProtectionsRearRoofRollerBlind"
        case .multiAntiTrapProtectionsSunroof: return "multiAntiTrapProtectionsSunroof"
        case .rearRoofRollerBlindInMotion: return "rearRoofRollerBlindInMotion"
        case .remoteEngineStartIsActive: return "remoteEngineStartIsActive"
        case .roofInMotion: return "roofInMotion"
        case .roofOrRollerBlindInMotion: return "roofOrRollerBlindInMotion"
        case .serviceNotAuthorized: return "serviceNotAuthorized"
        case .systemCouldNotBeNormed: return "systemCouldNotBeNormed"
        case .systemCouldNotBeNormedFrontRoofRollerBlind: return "systemCouldNotBeNormedFrontRoofRollerBlind"
        case .systemCouldNotBeNormedRearRoofRollerBlind: return "systemCouldNotBeNormedRearRoofRollerBlind"
        case .systemCouldNotBeNormedSunroof: return "systemCouldNotBeNormedSunroof"
        case .systemMalfunction: return "systemMalfunction"
        case .systemMalfunctionFrontRoofRollerBlind: return "systemMalfunctionFrontRoofRollerBlind"
        case .systemMalfunctionRearRoofRollerBlind: return "systemMalfunctionRearRoofRollerBlind"
        case .systemMalfunctionSunroof: return "systemMalfunctionSunroof"
        case .systemNotNormed: return "systemNotNormed"
        case .systemNotNormedFrontRoofRollerBlind: return "systemNotNormedFrontRoofRollerBlind"
        case .systemNotNormedRearRoofRollerBlind: return "systemNotNormedRearRoofRollerBlind"
        case .systemNotNormedSunroof: return "systemNotNormedSunroof"
        case .unavailableUiHandlerFrontRoofRollerBlind: return "unavailableUiHandlerFrontRoofRollerBlind"
        case .unavailableUiHandlerRearRoofRollerBlind: return "unavailableUiHandlerRearRoofRollerBlind"
        case .unavailableUiHandlerSunroof: return "unavailableUiHandlerSunroof"
        case .vehicleInMotion: return "vehicleInMotion"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.SunroofMove: BaseCommandProtocol {

	public typealias Error = SunroofMoveError

	public func createGenericError(error: GenericCommandError) -> SunroofMoveError {
		return SunroofMoveError.genericError(error: error)
	}
}

extension Command.SunroofMove: CommandPinProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String, pin: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self, pin: pin)
	}
}


/// All possible error codes for the SunroofOpen command version v1
public enum SunroofOpenError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Failed due to afterrun active
    case afterRunActive

    /// Failed due to afterrun active on front roof roller blind
    case afterRunActiveFrontRoofRollerBlind

    /// Failed due to afterrun active on rear roof roller blind
    case afterRunActiveRearRoofRollerBlind

    /// Failed due to afterrun active on sunroof
    case afterRunActiveSunroof

    /// Failed due to anti-trap protection active
    case antiTrapProtectionActive

    /// Failed due to anti-trap protection active on front roof roller blind
    case antiTrapProtectionActiveFrontRoofRollerBlind

    /// Failed due to anti-trap protection active on rear roof roller blind
    case antiTrapProtectionActiveRearRoofRollerBlind

    /// Failed due to anti-trap protection active on sunroof
    case antiTrapProtectionActiveSunroof

    /// Failed due to manual cancellation inside vehicle
    case cancelledManuallyInVehicle

    /// Failed due to manual cancellation inside vehicle on front roof roller blind
    case cancelledManuallyInVehicleFrontRoofRollerBlind

    /// Failed due to position not reached within timeout on rear roller blind
    case cancelledManuallyInVehicleRearRollerBlind

    /// Failed due to manual cancellation inside vehicle on rear roof roller blind
    case cancelledManuallyInVehicleRearRoofRollerBlind

    /// Failed due to drive motor overheated
    case driveMotorOverheated

    /// Failed due to drive motor overheated on front roof roller blind
    case driveMotorOverheatedFrontRoofRollerBlind

    /// Failed due to drive motor overheated on rear roof roller blind
    case driveMotorOverheatedRearRoofRollerBlind

    /// Failed due to drive motor overheated on sunroof
    case driveMotorOverheatedSunroof

    /// Fastpath timeout
    case fastpathTimeout

    /// Failed due to feature not available on front roof roller blind
    case featureNotAvailableFrontRoofRollerBlind

    /// Failed due to feature not available on rear roof roller blind
    case featureNotAvailableRearRoofRollerBlind

    /// Failed due to feature not available on sunroof
    case featureNotAvailableSunroof

    /// Failed due to front roof roller blind in motion
    case frontRoofRollerBlindInMotion

    /// Failed due to ignition is on
    case ignitionOn

    /// Failed due to internal system error
    case internalSystemError

    /// Failed due to invalid ignition state
    case invalidIgnitionState

    /// Failed due to invalid ignition state on front roof roller blind
    case invalidIgnitionStateFrontRoofRollerBlind

    /// Failed due to invalid ignition state on rear roof roller blind
    case invalidIgnitionStateRearRoofRollerBlind

    /// Failed due to invalid ignition state on sunroof
    case invalidIgnitionStateSunroof

    /// Failed due to invalid number on front roof roller blind
    case invalidNumberFrontRoofRollerBlind

    /// Failed due to invalid number on rear roof roller blind
    case invalidNumberRearRoofRollerBlind

    /// Failed due to invalid number on sunroof
    case invalidNumberSunroof

    /// Failed due to invalid position on front roof roller blind
    case invalidPositionFrontRoofRollerBlind

    /// Failed due to invalid position on rear roof roller blind
    case invalidPositionRearRoofRollerBlind

    /// Failed due to invalid position on sunroof
    case invalidPositionSunroof

    /// Failed due to invalid power status
    case invalidPowerStatus

    /// Failed due to invalid power status on front roof roller blind
    case invalidPowerStatusFrontRoofRollerBlind

    /// Failed due to invalid power status on rear roof roller blind
    case invalidPowerStatusRearRoofRollerBlind

    /// Failed due to invalid power status on sunroof
    case invalidPowerStatusSunroof

    /// Energy level in Battery is too low
    case lowBatteryLevel

    /// Failed due to low battery level 1
    case lowBatteryLevel1

    /// Failed due to low battery level 2
    case lowBatteryLevel2

    /// Failed due to mounted roof box
    case mountedRoofBox

    /// Failed due to multiple anti-trap protection activations
    case multiAntiTrapProtections

    /// Failed due to multiple anti-trap protection activations on front roof roller blind
    case multiAntiTrapProtectionsFrontRoofRollerBlind

    /// Failed due to multiple anti-trap protection activations on rear roof roller blind
    case multiAntiTrapProtectionsRearRoofRollerBlind

    /// Failed due to multiple anti-trap protection activations on sunroof
    case multiAntiTrapProtectionsSunroof

    /// Failed due to rear roof roller blind in motion
    case rearRoofRollerBlindInMotion

    /// Failed due to remote engine start is active
    case remoteEngineStartIsActive

    /// Failed due to roof in motion
    case roofInMotion

    /// Failed due to roof or roller blind in motion
    case roofOrRollerBlindInMotion

    /// Service not authorized
    case serviceNotAuthorized

    /// Failed due to system could not be normed
    case systemCouldNotBeNormed

    /// Failed due to system could not be normed on front roof roller blind
    case systemCouldNotBeNormedFrontRoofRollerBlind

    /// Failed due to system could not be normed on rear roof roller blind
    case systemCouldNotBeNormedRearRoofRollerBlind

    /// Failed due to system could not be normed on sunroof
    case systemCouldNotBeNormedSunroof

    /// Failed due to system malfunction
    case systemMalfunction

    /// Failed due to system malfunction on front roof roller blind
    case systemMalfunctionFrontRoofRollerBlind

    /// Failed due to system malfunction on rear roof roller blind
    case systemMalfunctionRearRoofRollerBlind

    /// Failed due to system malfunction on sunroof
    case systemMalfunctionSunroof

    /// Failed due to system not normed
    case systemNotNormed

    /// Failed due to system not normed on front roof roller blind
    case systemNotNormedFrontRoofRollerBlind

    /// Failed due to system not normed on rear roof roller blind
    case systemNotNormedRearRoofRollerBlind

    /// Failed due to system not normed on sunroof
    case systemNotNormedSunroof

    /// Failed due to UI handler not available on front roof roller blind
    case unavailableUiHandlerFrontRoofRollerBlind

    /// Failed due to UI handler not available on rear roof roller blind
    case unavailableUiHandlerRearRoofRollerBlind

    /// Failed due to UI handler not available on sunroof
    case unavailableUiHandlerSunroof

    /// Failed because vehicle is in motion
    case vehicleInMotion

    /// Remote window/roof command failed
    case windowRoofCommandFailed

    /// Remote window/roof command failed (vehicle state in IGN)
    case windowRoofCommandFailedIgnState

    /// Remote window/roof command failed (service not activated in HERMES)
    case windowRoofCommandServiceNotActive

    /// Remote window/roof command failed (window not normed)
    case windowRoofCommandWindowNotNormed

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> SunroofOpenError {
	    switch code { 
        case "21": return .lowBatteryLevel
        case "42": return .fastpathTimeout
        case "4200": return .serviceNotAuthorized
        case "4201": return .remoteEngineStartIsActive
        case "4202": return .ignitionOn
        case "4203": return .lowBatteryLevel2
        case "4204": return .lowBatteryLevel1
        case "4205": return .antiTrapProtectionActive
        case "4212": return .antiTrapProtectionActiveSunroof
        case "4213": return .antiTrapProtectionActiveFrontRoofRollerBlind
        case "4214": return .antiTrapProtectionActiveRearRoofRollerBlind
        case "4216": return .multiAntiTrapProtections
        case "4223": return .multiAntiTrapProtectionsSunroof
        case "4224": return .multiAntiTrapProtectionsFrontRoofRollerBlind
        case "4225": return .multiAntiTrapProtectionsRearRoofRollerBlind
        case "4227": return .cancelledManuallyInVehicle
        case "4235": return .cancelledManuallyInVehicleFrontRoofRollerBlind
        case "4236": return .cancelledManuallyInVehicleRearRoofRollerBlind
        case "4237": return .cancelledManuallyInVehicleRearRollerBlind
        case "4238": return .roofOrRollerBlindInMotion
        case "4239": return .roofInMotion
        case "4240": return .frontRoofRollerBlindInMotion
        case "4241": return .rearRoofRollerBlindInMotion
        case "4242": return .driveMotorOverheated
        case "4249": return .driveMotorOverheatedSunroof
        case "4250": return .driveMotorOverheatedFrontRoofRollerBlind
        case "4251": return .driveMotorOverheatedRearRoofRollerBlind
        case "4253": return .systemNotNormed
        case "4260": return .systemNotNormedSunroof
        case "4261": return .systemNotNormedFrontRoofRollerBlind
        case "4262": return .systemNotNormedRearRoofRollerBlind
        case "4264": return .mountedRoofBox
        case "4265": return .invalidPowerStatus
        case "4272": return .invalidPowerStatusSunroof
        case "4273": return .invalidPowerStatusFrontRoofRollerBlind
        case "4274": return .invalidPowerStatusRearRoofRollerBlind
        case "4276": return .afterRunActive
        case "4283": return .afterRunActiveSunroof
        case "4284": return .afterRunActiveFrontRoofRollerBlind
        case "4285": return .afterRunActiveRearRoofRollerBlind
        case "4287": return .invalidIgnitionState
        case "4294": return .invalidIgnitionStateSunroof
        case "4295": return .invalidIgnitionStateFrontRoofRollerBlind
        case "4296": return .invalidIgnitionStateRearRoofRollerBlind
        case "4298": return .vehicleInMotion
        case "4299": return .vehicleInMotion
        case "4300": return .vehicleInMotion
        case "4301": return .vehicleInMotion
        case "4303": return .systemCouldNotBeNormed
        case "4310": return .systemCouldNotBeNormedSunroof
        case "4311": return .systemCouldNotBeNormedFrontRoofRollerBlind
        case "4312": return .systemCouldNotBeNormedRearRoofRollerBlind
        case "4314": return .systemMalfunction
        case "4321": return .systemMalfunctionSunroof
        case "4322": return .systemMalfunctionFrontRoofRollerBlind
        case "4323": return .systemMalfunctionRearRoofRollerBlind
        case "4325": return .internalSystemError
        case "4334": return .invalidNumberSunroof
        case "4335": return .featureNotAvailableSunroof
        case "4340": return .invalidNumberFrontRoofRollerBlind
        case "4341": return .featureNotAvailableFrontRoofRollerBlind
        case "4342": return .invalidNumberRearRoofRollerBlind
        case "4343": return .featureNotAvailableRearRoofRollerBlind
        case "4358": return .invalidPositionSunroof
        case "4359": return .unavailableUiHandlerSunroof
        case "4360": return .invalidPositionFrontRoofRollerBlind
        case "4361": return .unavailableUiHandlerFrontRoofRollerBlind
        case "4362": return .invalidPositionRearRoofRollerBlind
        case "4363": return .unavailableUiHandlerRearRoofRollerBlind
        case "6901": return .windowRoofCommandFailed
        case "6902": return .windowRoofCommandFailedIgnState
        case "6903": return .windowRoofCommandWindowNotNormed
        case "6904": return .windowRoofCommandServiceNotActive
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .afterRunActive: return "afterRunActive"
        case .afterRunActiveFrontRoofRollerBlind: return "afterRunActiveFrontRoofRollerBlind"
        case .afterRunActiveRearRoofRollerBlind: return "afterRunActiveRearRoofRollerBlind"
        case .afterRunActiveSunroof: return "afterRunActiveSunroof"
        case .antiTrapProtectionActive: return "antiTrapProtectionActive"
        case .antiTrapProtectionActiveFrontRoofRollerBlind: return "antiTrapProtectionActiveFrontRoofRollerBlind"
        case .antiTrapProtectionActiveRearRoofRollerBlind: return "antiTrapProtectionActiveRearRoofRollerBlind"
        case .antiTrapProtectionActiveSunroof: return "antiTrapProtectionActiveSunroof"
        case .cancelledManuallyInVehicle: return "cancelledManuallyInVehicle"
        case .cancelledManuallyInVehicleFrontRoofRollerBlind: return "cancelledManuallyInVehicleFrontRoofRollerBlind"
        case .cancelledManuallyInVehicleRearRollerBlind: return "cancelledManuallyInVehicleRearRollerBlind"
        case .cancelledManuallyInVehicleRearRoofRollerBlind: return "cancelledManuallyInVehicleRearRoofRollerBlind"
        case .driveMotorOverheated: return "driveMotorOverheated"
        case .driveMotorOverheatedFrontRoofRollerBlind: return "driveMotorOverheatedFrontRoofRollerBlind"
        case .driveMotorOverheatedRearRoofRollerBlind: return "driveMotorOverheatedRearRoofRollerBlind"
        case .driveMotorOverheatedSunroof: return "driveMotorOverheatedSunroof"
        case .fastpathTimeout: return "fastpathTimeout"
        case .featureNotAvailableFrontRoofRollerBlind: return "featureNotAvailableFrontRoofRollerBlind"
        case .featureNotAvailableRearRoofRollerBlind: return "featureNotAvailableRearRoofRollerBlind"
        case .featureNotAvailableSunroof: return "featureNotAvailableSunroof"
        case .frontRoofRollerBlindInMotion: return "frontRoofRollerBlindInMotion"
        case .ignitionOn: return "ignitionOn"
        case .internalSystemError: return "internalSystemError"
        case .invalidIgnitionState: return "invalidIgnitionState"
        case .invalidIgnitionStateFrontRoofRollerBlind: return "invalidIgnitionStateFrontRoofRollerBlind"
        case .invalidIgnitionStateRearRoofRollerBlind: return "invalidIgnitionStateRearRoofRollerBlind"
        case .invalidIgnitionStateSunroof: return "invalidIgnitionStateSunroof"
        case .invalidNumberFrontRoofRollerBlind: return "invalidNumberFrontRoofRollerBlind"
        case .invalidNumberRearRoofRollerBlind: return "invalidNumberRearRoofRollerBlind"
        case .invalidNumberSunroof: return "invalidNumberSunroof"
        case .invalidPositionFrontRoofRollerBlind: return "invalidPositionFrontRoofRollerBlind"
        case .invalidPositionRearRoofRollerBlind: return "invalidPositionRearRoofRollerBlind"
        case .invalidPositionSunroof: return "invalidPositionSunroof"
        case .invalidPowerStatus: return "invalidPowerStatus"
        case .invalidPowerStatusFrontRoofRollerBlind: return "invalidPowerStatusFrontRoofRollerBlind"
        case .invalidPowerStatusRearRoofRollerBlind: return "invalidPowerStatusRearRoofRollerBlind"
        case .invalidPowerStatusSunroof: return "invalidPowerStatusSunroof"
        case .lowBatteryLevel: return "lowBatteryLevel"
        case .lowBatteryLevel1: return "lowBatteryLevel1"
        case .lowBatteryLevel2: return "lowBatteryLevel2"
        case .mountedRoofBox: return "mountedRoofBox"
        case .multiAntiTrapProtections: return "multiAntiTrapProtections"
        case .multiAntiTrapProtectionsFrontRoofRollerBlind: return "multiAntiTrapProtectionsFrontRoofRollerBlind"
        case .multiAntiTrapProtectionsRearRoofRollerBlind: return "multiAntiTrapProtectionsRearRoofRollerBlind"
        case .multiAntiTrapProtectionsSunroof: return "multiAntiTrapProtectionsSunroof"
        case .rearRoofRollerBlindInMotion: return "rearRoofRollerBlindInMotion"
        case .remoteEngineStartIsActive: return "remoteEngineStartIsActive"
        case .roofInMotion: return "roofInMotion"
        case .roofOrRollerBlindInMotion: return "roofOrRollerBlindInMotion"
        case .serviceNotAuthorized: return "serviceNotAuthorized"
        case .systemCouldNotBeNormed: return "systemCouldNotBeNormed"
        case .systemCouldNotBeNormedFrontRoofRollerBlind: return "systemCouldNotBeNormedFrontRoofRollerBlind"
        case .systemCouldNotBeNormedRearRoofRollerBlind: return "systemCouldNotBeNormedRearRoofRollerBlind"
        case .systemCouldNotBeNormedSunroof: return "systemCouldNotBeNormedSunroof"
        case .systemMalfunction: return "systemMalfunction"
        case .systemMalfunctionFrontRoofRollerBlind: return "systemMalfunctionFrontRoofRollerBlind"
        case .systemMalfunctionRearRoofRollerBlind: return "systemMalfunctionRearRoofRollerBlind"
        case .systemMalfunctionSunroof: return "systemMalfunctionSunroof"
        case .systemNotNormed: return "systemNotNormed"
        case .systemNotNormedFrontRoofRollerBlind: return "systemNotNormedFrontRoofRollerBlind"
        case .systemNotNormedRearRoofRollerBlind: return "systemNotNormedRearRoofRollerBlind"
        case .systemNotNormedSunroof: return "systemNotNormedSunroof"
        case .unavailableUiHandlerFrontRoofRollerBlind: return "unavailableUiHandlerFrontRoofRollerBlind"
        case .unavailableUiHandlerRearRoofRollerBlind: return "unavailableUiHandlerRearRoofRollerBlind"
        case .unavailableUiHandlerSunroof: return "unavailableUiHandlerSunroof"
        case .vehicleInMotion: return "vehicleInMotion"
        case .windowRoofCommandFailed: return "windowRoofCommandFailed"
        case .windowRoofCommandFailedIgnState: return "windowRoofCommandFailedIgnState"
        case .windowRoofCommandServiceNotActive: return "windowRoofCommandServiceNotActive"
        case .windowRoofCommandWindowNotNormed: return "windowRoofCommandWindowNotNormed"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.SunroofOpen: BaseCommandProtocol {

	public typealias Error = SunroofOpenError

	public func createGenericError(error: GenericCommandError) -> SunroofOpenError {
		return SunroofOpenError.genericError(error: error)
	}
}

extension Command.SunroofOpen: CommandPinProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String, pin: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self, pin: pin)
	}
}


/// All possible error codes for the SignalPosition command version v1
public enum SignalPositionError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Failed due to error in horn control system
    case errorInHornControlSystem

    /// Failed due to error in light control system
    case errorInLightControlSystem

    /// Failed due to error in light or horn control system
    case errorInLightOrHornControlSystem

    /// Fastpath timeout
    case fastpathTimeout

    /// Failed due to invalid horn repeat
    case invalidHornRepeat

    /// Energy level in Battery is too low
    case lowBatteryLevel

    /// Failed due to low battery level 1
    case lowBatteryLevel1

    /// Failed due to low battery level 2
    case lowBatteryLevel2

    /// RVF (sigpos) failed
    case rvfFailed

    /// RVF (sigpos) failed due to not authorized
    case rvfFailedNotAuthorized

    /// RVF (sigpos) failed due to ignition is on
    case rvfFailedVehicleStageInIgn

    /// Failed due to too many requests to horn control system
    case tooManyRequestsToHornControlSystem

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> SignalPositionError {
	    switch code { 
        case "21": return .lowBatteryLevel
        case "42": return .fastpathTimeout
        case "6401": return .rvfFailed
        case "6402": return .rvfFailedVehicleStageInIgn
        case "6403": return .rvfFailedNotAuthorized
        case "6404": return .lowBatteryLevel2
        case "6405": return .lowBatteryLevel1
        case "6406": return .invalidHornRepeat
        case "6407": return .errorInLightOrHornControlSystem
        case "6408": return .errorInHornControlSystem
        case "6409": return .errorInLightControlSystem
        case "6410": return .tooManyRequestsToHornControlSystem
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .errorInHornControlSystem: return "errorInHornControlSystem"
        case .errorInLightControlSystem: return "errorInLightControlSystem"
        case .errorInLightOrHornControlSystem: return "errorInLightOrHornControlSystem"
        case .fastpathTimeout: return "fastpathTimeout"
        case .invalidHornRepeat: return "invalidHornRepeat"
        case .lowBatteryLevel: return "lowBatteryLevel"
        case .lowBatteryLevel1: return "lowBatteryLevel1"
        case .lowBatteryLevel2: return "lowBatteryLevel2"
        case .rvfFailed: return "rvfFailed"
        case .rvfFailedNotAuthorized: return "rvfFailedNotAuthorized"
        case .rvfFailedVehicleStageInIgn: return "rvfFailedVehicleStageInIgn"
        case .tooManyRequestsToHornControlSystem: return "tooManyRequestsToHornControlSystem"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.SignalPosition: BaseCommandProtocol {

	public typealias Error = SignalPositionError

	public func createGenericError(error: GenericCommandError) -> SignalPositionError {
		return SignalPositionError.genericError(error: error)
	}
}

extension Command.SignalPosition: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the SpeedAlertStart command version v2
public enum SpeedAlertStartError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

    /// Speed alert not authorized
    case speedAlertNotAuthorized

    /// Unexpected respons
    case unexpectedResponse

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> SpeedAlertStartError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "6101": return .unexpectedResponse
        case "6102": return .speedAlertNotAuthorized
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .speedAlertNotAuthorized: return "speedAlertNotAuthorized"
        case .unexpectedResponse: return "unexpectedResponse"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.SpeedAlertStart: BaseCommandProtocol {

	public typealias Error = SpeedAlertStartError

	public func createGenericError(error: GenericCommandError) -> SpeedAlertStartError {
		return SpeedAlertStartError.genericError(error: error)
	}
}

extension Command.SpeedAlertStart: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the SpeedAlertStop command version v2
public enum SpeedAlertStopError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Speed alert not authorized
    case speedAlertNotAuthorized

    /// Unexpected respons
    case unexpectedResponse

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> SpeedAlertStopError {
	    switch code { 
        case "6101": return .unexpectedResponse
        case "6102": return .speedAlertNotAuthorized
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .speedAlertNotAuthorized: return "speedAlertNotAuthorized"
        case .unexpectedResponse: return "unexpectedResponse"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.SpeedAlertStop: BaseCommandProtocol {

	public typealias Error = SpeedAlertStopError

	public func createGenericError(error: GenericCommandError) -> SpeedAlertStopError {
		return SpeedAlertStopError.genericError(error: error)
	}
}

extension Command.SpeedAlertStop: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the TeenageDrivingModeActivate command version 
public enum TeenageDrivingModeActivateError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> TeenageDrivingModeActivateError {
	    switch code { 
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.TeenageDrivingModeActivate: BaseCommandProtocol {

	public typealias Error = TeenageDrivingModeActivateError

	public func createGenericError(error: GenericCommandError) -> TeenageDrivingModeActivateError {
		return TeenageDrivingModeActivateError.genericError(error: error)
	}
}

extension Command.TeenageDrivingModeActivate: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the TeenageDrivingModeDeactivate command version 
public enum TeenageDrivingModeDeactivateError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> TeenageDrivingModeDeactivateError {
	    switch code { 
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.TeenageDrivingModeDeactivate: BaseCommandProtocol {

	public typealias Error = TeenageDrivingModeDeactivateError

	public func createGenericError(error: GenericCommandError) -> TeenageDrivingModeDeactivateError {
		return TeenageDrivingModeDeactivateError.genericError(error: error)
	}
}

extension Command.TeenageDrivingModeDeactivate: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the TemperatureConfigure command version v1
public enum TemperatureConfigureError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Failed
    case failed

    /// failedCANCom
    case failedCanCom

    /// failedIgnOn
    case failedIgnOn

    /// Fastpath timeout
    case fastpathTimeout

    /// Request is not authorized
    case notAuthorized

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> TemperatureConfigureError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "6501": return .failed
        case "6502": return .failedCanCom
        case "6503": return .failedIgnOn
        case "6504": return .notAuthorized
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .failed: return "failed"
        case .failedCanCom: return "failedCanCom"
        case .failedIgnOn: return "failedIgnOn"
        case .fastpathTimeout: return "fastpathTimeout"
        case .notAuthorized: return "notAuthorized"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.TemperatureConfigure: BaseCommandProtocol {

	public typealias Error = TemperatureConfigureError

	public func createGenericError(error: GenericCommandError) -> TemperatureConfigureError {
		return TemperatureConfigureError.genericError(error: error)
	}
}

extension Command.TemperatureConfigure: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the TheftAlarmConfirmDamageDetection command version v3
public enum TheftAlarmConfirmDamageDetectionError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

    /// Remote VTA failed
    case remoteVtaFailed

    /// Remote VTA ignition not locked
    case remoteVtaIgnitionLocked

    /// Remote VTA VVR not allowed
    case remoteVtaNotAllowed

    /// Remote VTA service not authorized
    case remoteVtaNotAuthorized

    /// Remote VTA VVR value not set
    case remoteVtaValueNotSet

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> TheftAlarmConfirmDamageDetectionError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "5301": return .remoteVtaFailed
        case "5302": return .remoteVtaNotAuthorized
        case "5303": return .remoteVtaIgnitionLocked
        case "5304": return .remoteVtaValueNotSet
        case "5305": return .remoteVtaNotAllowed
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .remoteVtaFailed: return "remoteVtaFailed"
        case .remoteVtaIgnitionLocked: return "remoteVtaIgnitionLocked"
        case .remoteVtaNotAllowed: return "remoteVtaNotAllowed"
        case .remoteVtaNotAuthorized: return "remoteVtaNotAuthorized"
        case .remoteVtaValueNotSet: return "remoteVtaValueNotSet"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.TheftAlarmConfirmDamageDetection: BaseCommandProtocol {

	public typealias Error = TheftAlarmConfirmDamageDetectionError

	public func createGenericError(error: GenericCommandError) -> TheftAlarmConfirmDamageDetectionError {
		return TheftAlarmConfirmDamageDetectionError.genericError(error: error)
	}
}

extension Command.TheftAlarmConfirmDamageDetection: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the TheftAlarmDeselectDamageDetection command version v3
public enum TheftAlarmDeselectDamageDetectionError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

    /// Remote VTA failed
    case remoteVtaFailed

    /// Remote VTA ignition not locked
    case remoteVtaIgnitionLocked

    /// Remote VTA VVR not allowed
    case remoteVtaNotAllowed

    /// Remote VTA service not authorized
    case remoteVtaNotAuthorized

    /// Remote VTA VVR value not set
    case remoteVtaValueNotSet

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> TheftAlarmDeselectDamageDetectionError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "5301": return .remoteVtaFailed
        case "5302": return .remoteVtaNotAuthorized
        case "5303": return .remoteVtaIgnitionLocked
        case "5304": return .remoteVtaValueNotSet
        case "5305": return .remoteVtaNotAllowed
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .remoteVtaFailed: return "remoteVtaFailed"
        case .remoteVtaIgnitionLocked: return "remoteVtaIgnitionLocked"
        case .remoteVtaNotAllowed: return "remoteVtaNotAllowed"
        case .remoteVtaNotAuthorized: return "remoteVtaNotAuthorized"
        case .remoteVtaValueNotSet: return "remoteVtaValueNotSet"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.TheftAlarmDeselectDamageDetection: BaseCommandProtocol {

	public typealias Error = TheftAlarmDeselectDamageDetectionError

	public func createGenericError(error: GenericCommandError) -> TheftAlarmDeselectDamageDetectionError {
		return TheftAlarmDeselectDamageDetectionError.genericError(error: error)
	}
}

extension Command.TheftAlarmDeselectDamageDetection: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the TheftAlarmDeselectInterior command version v3
public enum TheftAlarmDeselectInteriorError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

    /// Remote VTA failed
    case remoteVtaFailed

    /// Remote VTA ignition not locked
    case remoteVtaIgnitionLocked

    /// Remote VTA VVR not allowed
    case remoteVtaNotAllowed

    /// Remote VTA service not authorized
    case remoteVtaNotAuthorized

    /// Remote VTA VVR value not set
    case remoteVtaValueNotSet

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> TheftAlarmDeselectInteriorError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "5301": return .remoteVtaFailed
        case "5302": return .remoteVtaNotAuthorized
        case "5303": return .remoteVtaIgnitionLocked
        case "5304": return .remoteVtaValueNotSet
        case "5305": return .remoteVtaNotAllowed
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .remoteVtaFailed: return "remoteVtaFailed"
        case .remoteVtaIgnitionLocked: return "remoteVtaIgnitionLocked"
        case .remoteVtaNotAllowed: return "remoteVtaNotAllowed"
        case .remoteVtaNotAuthorized: return "remoteVtaNotAuthorized"
        case .remoteVtaValueNotSet: return "remoteVtaValueNotSet"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.TheftAlarmDeselectInterior: BaseCommandProtocol {

	public typealias Error = TheftAlarmDeselectInteriorError

	public func createGenericError(error: GenericCommandError) -> TheftAlarmDeselectInteriorError {
		return TheftAlarmDeselectInteriorError.genericError(error: error)
	}
}

extension Command.TheftAlarmDeselectInterior: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the TheftAlarmDeselectTow command version v3
public enum TheftAlarmDeselectTowError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

    /// Remote VTA failed
    case remoteVtaFailed

    /// Remote VTA ignition not locked
    case remoteVtaIgnitionLocked

    /// Remote VTA VVR not allowed
    case remoteVtaNotAllowed

    /// Remote VTA service not authorized
    case remoteVtaNotAuthorized

    /// Remote VTA VVR value not set
    case remoteVtaValueNotSet

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> TheftAlarmDeselectTowError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "5301": return .remoteVtaFailed
        case "5302": return .remoteVtaNotAuthorized
        case "5303": return .remoteVtaIgnitionLocked
        case "5304": return .remoteVtaValueNotSet
        case "5305": return .remoteVtaNotAllowed
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .remoteVtaFailed: return "remoteVtaFailed"
        case .remoteVtaIgnitionLocked: return "remoteVtaIgnitionLocked"
        case .remoteVtaNotAllowed: return "remoteVtaNotAllowed"
        case .remoteVtaNotAuthorized: return "remoteVtaNotAuthorized"
        case .remoteVtaValueNotSet: return "remoteVtaValueNotSet"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.TheftAlarmDeselectTow: BaseCommandProtocol {

	public typealias Error = TheftAlarmDeselectTowError

	public func createGenericError(error: GenericCommandError) -> TheftAlarmDeselectTowError {
		return TheftAlarmDeselectTowError.genericError(error: error)
	}
}

extension Command.TheftAlarmDeselectTow: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the TheftAlarmSelectDamageDetection command version v3
public enum TheftAlarmSelectDamageDetectionError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

    /// Remote VTA failed
    case remoteVtaFailed

    /// Remote VTA ignition not locked
    case remoteVtaIgnitionLocked

    /// Remote VTA VVR not allowed
    case remoteVtaNotAllowed

    /// Remote VTA service not authorized
    case remoteVtaNotAuthorized

    /// Remote VTA VVR value not set
    case remoteVtaValueNotSet

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> TheftAlarmSelectDamageDetectionError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "5301": return .remoteVtaFailed
        case "5302": return .remoteVtaNotAuthorized
        case "5303": return .remoteVtaIgnitionLocked
        case "5304": return .remoteVtaValueNotSet
        case "5305": return .remoteVtaNotAllowed
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .remoteVtaFailed: return "remoteVtaFailed"
        case .remoteVtaIgnitionLocked: return "remoteVtaIgnitionLocked"
        case .remoteVtaNotAllowed: return "remoteVtaNotAllowed"
        case .remoteVtaNotAuthorized: return "remoteVtaNotAuthorized"
        case .remoteVtaValueNotSet: return "remoteVtaValueNotSet"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.TheftAlarmSelectDamageDetection: BaseCommandProtocol {

	public typealias Error = TheftAlarmSelectDamageDetectionError

	public func createGenericError(error: GenericCommandError) -> TheftAlarmSelectDamageDetectionError {
		return TheftAlarmSelectDamageDetectionError.genericError(error: error)
	}
}

extension Command.TheftAlarmSelectDamageDetection: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the TheftAlarmSelectInterior command version v3
public enum TheftAlarmSelectInteriorError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

    /// Remote VTA failed
    case remoteVtaFailed

    /// Remote VTA ignition not locked
    case remoteVtaIgnitionLocked

    /// Remote VTA VVR not allowed
    case remoteVtaNotAllowed

    /// Remote VTA service not authorized
    case remoteVtaNotAuthorized

    /// Remote VTA VVR value not set
    case remoteVtaValueNotSet

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> TheftAlarmSelectInteriorError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "5301": return .remoteVtaFailed
        case "5302": return .remoteVtaNotAuthorized
        case "5303": return .remoteVtaIgnitionLocked
        case "5304": return .remoteVtaValueNotSet
        case "5305": return .remoteVtaNotAllowed
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .remoteVtaFailed: return "remoteVtaFailed"
        case .remoteVtaIgnitionLocked: return "remoteVtaIgnitionLocked"
        case .remoteVtaNotAllowed: return "remoteVtaNotAllowed"
        case .remoteVtaNotAuthorized: return "remoteVtaNotAuthorized"
        case .remoteVtaValueNotSet: return "remoteVtaValueNotSet"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.TheftAlarmSelectInterior: BaseCommandProtocol {

	public typealias Error = TheftAlarmSelectInteriorError

	public func createGenericError(error: GenericCommandError) -> TheftAlarmSelectInteriorError {
		return TheftAlarmSelectInteriorError.genericError(error: error)
	}
}

extension Command.TheftAlarmSelectInterior: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the TheftAlarmSelectTow command version v3
public enum TheftAlarmSelectTowError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

    /// Remote VTA failed
    case remoteVtaFailed

    /// Remote VTA ignition not locked
    case remoteVtaIgnitionLocked

    /// Remote VTA VVR not allowed
    case remoteVtaNotAllowed

    /// Remote VTA service not authorized
    case remoteVtaNotAuthorized

    /// Remote VTA VVR value not set
    case remoteVtaValueNotSet

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> TheftAlarmSelectTowError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "5301": return .remoteVtaFailed
        case "5302": return .remoteVtaNotAuthorized
        case "5303": return .remoteVtaIgnitionLocked
        case "5304": return .remoteVtaValueNotSet
        case "5305": return .remoteVtaNotAllowed
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .remoteVtaFailed: return "remoteVtaFailed"
        case .remoteVtaIgnitionLocked: return "remoteVtaIgnitionLocked"
        case .remoteVtaNotAllowed: return "remoteVtaNotAllowed"
        case .remoteVtaNotAuthorized: return "remoteVtaNotAuthorized"
        case .remoteVtaValueNotSet: return "remoteVtaValueNotSet"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.TheftAlarmSelectTow: BaseCommandProtocol {

	public typealias Error = TheftAlarmSelectTowError

	public func createGenericError(error: GenericCommandError) -> TheftAlarmSelectTowError {
		return TheftAlarmSelectTowError.genericError(error: error)
	}
}

extension Command.TheftAlarmSelectTow: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the TheftAlarmStart command version v3
public enum TheftAlarmStartError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

    /// Remote VTA failed
    case remoteVtaFailed

    /// Remote VTA ignition not locked
    case remoteVtaIgnitionLocked

    /// Remote VTA VVR not allowed
    case remoteVtaNotAllowed

    /// Remote VTA service not authorized
    case remoteVtaNotAuthorized

    /// Remote VTA VVR value not set
    case remoteVtaValueNotSet

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> TheftAlarmStartError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "5301": return .remoteVtaFailed
        case "5302": return .remoteVtaNotAuthorized
        case "5303": return .remoteVtaIgnitionLocked
        case "5304": return .remoteVtaValueNotSet
        case "5305": return .remoteVtaNotAllowed
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .remoteVtaFailed: return "remoteVtaFailed"
        case .remoteVtaIgnitionLocked: return "remoteVtaIgnitionLocked"
        case .remoteVtaNotAllowed: return "remoteVtaNotAllowed"
        case .remoteVtaNotAuthorized: return "remoteVtaNotAuthorized"
        case .remoteVtaValueNotSet: return "remoteVtaValueNotSet"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.TheftAlarmStart: BaseCommandProtocol {

	public typealias Error = TheftAlarmStartError

	public func createGenericError(error: GenericCommandError) -> TheftAlarmStartError {
		return TheftAlarmStartError.genericError(error: error)
	}
}

extension Command.TheftAlarmStart: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the TheftAlarmStop command version v3
public enum TheftAlarmStopError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

    /// Remote VTA failed
    case remoteVtaFailed

    /// Remote VTA ignition not locked
    case remoteVtaIgnitionLocked

    /// Remote VTA VVR not allowed
    case remoteVtaNotAllowed

    /// Remote VTA service not authorized
    case remoteVtaNotAuthorized

    /// Remote VTA VVR value not set
    case remoteVtaValueNotSet

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> TheftAlarmStopError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "5301": return .remoteVtaFailed
        case "5302": return .remoteVtaNotAuthorized
        case "5303": return .remoteVtaIgnitionLocked
        case "5304": return .remoteVtaValueNotSet
        case "5305": return .remoteVtaNotAllowed
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .remoteVtaFailed: return "remoteVtaFailed"
        case .remoteVtaIgnitionLocked: return "remoteVtaIgnitionLocked"
        case .remoteVtaNotAllowed: return "remoteVtaNotAllowed"
        case .remoteVtaNotAuthorized: return "remoteVtaNotAuthorized"
        case .remoteVtaValueNotSet: return "remoteVtaValueNotSet"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.TheftAlarmStop: BaseCommandProtocol {

	public typealias Error = TheftAlarmStopError

	public func createGenericError(error: GenericCommandError) -> TheftAlarmStopError {
		return TheftAlarmStopError.genericError(error: error)
	}
}

extension Command.TheftAlarmStop: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the ValetDrivingModeActivate command version 
public enum ValetDrivingModeActivateError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> ValetDrivingModeActivateError {
	    switch code { 
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.ValetDrivingModeActivate: BaseCommandProtocol {

	public typealias Error = ValetDrivingModeActivateError

	public func createGenericError(error: GenericCommandError) -> ValetDrivingModeActivateError {
		return ValetDrivingModeActivateError.genericError(error: error)
	}
}

extension Command.ValetDrivingModeActivate: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the ValetDrivingModeDeactivate command version 
public enum ValetDrivingModeDeactivateError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> ValetDrivingModeDeactivateError {
	    switch code { 
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.ValetDrivingModeDeactivate: BaseCommandProtocol {

	public typealias Error = ValetDrivingModeDeactivateError

	public func createGenericError(error: GenericCommandError) -> ValetDrivingModeDeactivateError {
		return ValetDrivingModeDeactivateError.genericError(error: error)
	}
}

extension Command.ValetDrivingModeDeactivate: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the WeekProfileConfigure command version v1
public enum WeekProfileConfigureError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// ZEV WeekDeptSet processing failed as incorrect AppId passed
    case appIdIncorrect

    /// ZEV WeekDeptSet processing failed as AsppId is not present
    case appIdMissing

    /// ZEV WeekDeptSet processing failed as AppId not matching
    case appIdNotMatching

    /// Fastpath timeout
    case fastpathTimeout

    /// ZEV WeekDeptSet not authorized
    case zevWeekDeptSetNotAuthorized

    /// ZEV WeekDeptSet not possible since either INSTANT CHARGING is already activated or INSTANT CHARGING ACP command is currently in progress
    case zevWeekDeptSetProcessingDeptSetNotPossible

    /// ZEV WeekDeptSet processing failed
    case zevWeekDeptSetProcessingFailed

    /// ZEV WeekDeptSet processing overwritten
    case zevWeekDeptSetProcessingOverwritten

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> WeekProfileConfigureError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "6601": return .zevWeekDeptSetProcessingFailed
        case "6602": return .zevWeekDeptSetNotAuthorized
        case "6603": return .zevWeekDeptSetProcessingOverwritten
        case "6604": return .zevWeekDeptSetProcessingDeptSetNotPossible
        case "6611": return .appIdMissing
        case "6612": return .appIdIncorrect
        case "6613": return .appIdNotMatching
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .appIdIncorrect: return "appIdIncorrect"
        case .appIdMissing: return "appIdMissing"
        case .appIdNotMatching: return "appIdNotMatching"
        case .fastpathTimeout: return "fastpathTimeout"
        case .zevWeekDeptSetNotAuthorized: return "zevWeekDeptSetNotAuthorized"
        case .zevWeekDeptSetProcessingDeptSetNotPossible: return "zevWeekDeptSetProcessingDeptSetNotPossible"
        case .zevWeekDeptSetProcessingFailed: return "zevWeekDeptSetProcessingFailed"
        case .zevWeekDeptSetProcessingOverwritten: return "zevWeekDeptSetProcessingOverwritten"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.WeekProfileConfigure: BaseCommandProtocol {

	public typealias Error = WeekProfileConfigureError

	public func createGenericError(error: GenericCommandError) -> WeekProfileConfigureError {
		return WeekProfileConfigureError.genericError(error: error)
	}
}

extension Command.WeekProfileConfigure: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the WeekProfileConfigureV2 command version v2
public enum WeekProfileConfigureV2Error: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// ZEV WeekDeptSet processing failed as incorrect AppId passed
    case appIdIncorrect

    /// ZEV WeekDeptSet processing failed as AsppId is not present
    case appIdMissing

    /// ZEV WeekDeptSet processing failed as AppId not matching
    case appIdNotMatching

    /// Fastpath timeout
    case fastpathTimeout

    /// ZEV WeekDeptSet not authorized
    case zevWeekDeptSetNotAuthorized

    /// ZEV WeekDeptSet not possible since either INSTANT CHARGING is already activated or INSTANT CHARGING ACP command is currently in progress
    case zevWeekDeptSetProcessingDeptSetNotPossible

    /// ZEV WeekDeptSet processing failed
    case zevWeekDeptSetProcessingFailed

    /// ZEV WeekDeptSet processing overwritten
    case zevWeekDeptSetProcessingOverwritten

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> WeekProfileConfigureV2Error {
	    switch code { 
        case "42": return .fastpathTimeout
        case "6601": return .zevWeekDeptSetProcessingFailed
        case "6602": return .zevWeekDeptSetNotAuthorized
        case "6603": return .zevWeekDeptSetProcessingOverwritten
        case "6604": return .zevWeekDeptSetProcessingDeptSetNotPossible
        case "6611": return .appIdMissing
        case "6612": return .appIdIncorrect
        case "6613": return .appIdNotMatching
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .appIdIncorrect: return "appIdIncorrect"
        case .appIdMissing: return "appIdMissing"
        case .appIdNotMatching: return "appIdNotMatching"
        case .fastpathTimeout: return "fastpathTimeout"
        case .zevWeekDeptSetNotAuthorized: return "zevWeekDeptSetNotAuthorized"
        case .zevWeekDeptSetProcessingDeptSetNotPossible: return "zevWeekDeptSetProcessingDeptSetNotPossible"
        case .zevWeekDeptSetProcessingFailed: return "zevWeekDeptSetProcessingFailed"
        case .zevWeekDeptSetProcessingOverwritten: return "zevWeekDeptSetProcessingOverwritten"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.WeekProfileConfigureV2: BaseCommandProtocol {

	public typealias Error = WeekProfileConfigureV2Error

	public func createGenericError(error: GenericCommandError) -> WeekProfileConfigureV2Error {
		return WeekProfileConfigureV2Error.genericError(error: error)
	}
}

extension Command.WeekProfileConfigureV2: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the WindowsClose command version v1
public enum WindowsCloseError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Failed due to afterrun active
    case afterRunActive

    /// Failed due to afterrun active on front left window
    case afterRunActiveFrontLeftWindow

    /// Failed due to afterrun active on front right window
    case afterRunActiveFrontRightWindow

    /// Failed due to afterrun active on rear left roller blind
    case afterRunActiveRearLeftRollerBlind

    /// Failed due to afterrun active on rear left window
    case afterRunActiveRearLeftWindow

    /// Failed due to afterrun active on rear right roller blind
    case afterRunActiveRearRightRollerBlind

    /// Failed due to afterrun active on rear right window
    case afterRunActiveRearRightWindow

    /// Failed due to anti-trap protection active
    case antiTrapProtectionActive

    /// Failed due to anti-trap protection active on front left window
    case antiTrapProtectionActiveFrontLeftWindow

    /// Failed due to anti-trap protection active on front right window
    case antiTrapProtectionActiveFrontRightWindow

    /// Failed due to anti-trap protection active on rear left roller blind
    case antiTrapProtectionActiveRearLeftRollerBlind

    /// Failed due to anti-trap protection active on rear left window
    case antiTrapProtectionActiveRearLeftWindow

    /// Failed due to anti-trap protection active on rear right roller blind
    case antiTrapProtectionActiveRearRightRollerBlind

    /// Failed due to anti-trap protection active on rear right window
    case antiTrapProtectionActiveRearRightWindow

    /// Failed due to manual cancellation inside vehicle
    case cancelledManuallyInVehicle

    /// Failed due to manual cancellation inside vehicle on front left window
    case cancelledManuallyInVehicleFrontLeftWindow

    /// Failed due to manual cancellation inside vehicle on front right window
    case cancelledManuallyInVehicleFrontRightWindow

    /// Failed due to manual cancellation inside vehicle on rear left roller blind
    case cancelledManuallyInVehicleRearLeftRollerBlind

    /// Failed due to manual cancellation inside vehicle on rear left window
    case cancelledManuallyInVehicleRearLeftWindow

    /// Failed due to manual cancellation inside vehicle on rear right roller blind
    case cancelledManuallyInVehicleRearRightRollerBlind

    /// Failed due to manual cancellation inside vehicle on rear right window
    case cancelledManuallyInVehicleRearRightWindow

    /// Failed due to manual cancellation inside vehicle on sunroof
    case cancelledManuallyInVehicleSunroof

    /// Failed due to drive motor overheated
    case driveMotorOverheated

    /// Failed due to drive motor overheated on front left window
    case driveMotorOverheatedFrontLeftWindow

    /// Failed due to drive motor overheated on front right window
    case driveMotorOverheatedFrontRightWindow

    /// Failed due to drive motor overheated on rear left roller blind
    case driveMotorOverheatedRearLeftRollerBlind

    /// Failed due to drive motor overheated on rear left window
    case driveMotorOverheatedRearLeftWindow

    /// Failed due to drive motor overheated on rear right roller blind
    case driveMotorOverheatedRearRightRollerBlind

    /// Failed due to drive motor overheated on rear right window
    case driveMotorOverheatedRearRightWindow

    /// Fastpath timeout
    case fastpathTimeout

    /// Failed due to feature not available on front left window
    case featureNotAvailableFrontLeftWindow

    /// Failed due to feature not available on front right window
    case featureNotAvailableFrontRightWindow

    /// Failed due to feature not available on rear left roller blind
    case featureNotAvailableRearLeftRollerBlind

    /// Failed due to feature not available on rear left window
    case featureNotAvailableRearLeftWindow

    /// Failed due to feature not available on rear right roller blind
    case featureNotAvailableRearRightRollerBlind

    /// Failed due to feature not available on rear right window
    case featureNotAvailableRearRightWindow

    /// Failed due to feature not available on rear roller blind
    case featureNotAvailableRearRollerBlind

    /// Failed due to ignition is on
    case ignitionOn

    /// Failed due to internal system error
    case internalSystemError

    /// Failed due to invalid ignition state
    case invalidIgnitionState

    /// Failed due to invalid ignition state on front left window
    case invalidIgnitionStateFrontLeftWindow

    /// Failed due to invalid ignition state on front right window
    case invalidIgnitionStateFrontRightWindow

    /// Failed due to invalid ignition state on rear left roller blind
    case invalidIgnitionStateRearLeftRollerBlind

    /// Failed due to invalid ignition state on rear left window
    case invalidIgnitionStateRearLeftWindow

    /// Failed due to invalid ignition state on rear right roller blind
    case invalidIgnitionStateRearRightRollerBlind

    /// Failed due to invalid ignition state on rear right window
    case invalidIgnitionStateRearRightWindow

    /// Failed due to invalid number on front left window
    case invalidNumberFrontLeftWindow

    /// Failed due to invalid number on front right window
    case invalidNumberFrontRightWindow

    /// Failed due to invalid number on rear left roller blind
    case invalidNumberRearLeftRollerBlind

    /// Failed due to invalid number on rear left window
    case invalidNumberRearLeftWindow

    /// Failed due to invalid number on rear right roller blind
    case invalidNumberRearRightRollerBlind

    /// Failed due to invalid number on rear right window
    case invalidNumberRearRightWindow

    /// Failed due to invalid position on front left window
    case invalidPositionFrontLeftWindow

    /// Failed due to invalid position on front right window
    case invalidPositionFrontRightWindow

    /// Failed due to invalid position on rear left roller blind
    case invalidPositionRearLeftRollerBlind

    /// Failed due to invalid position on rear left window
    case invalidPositionRearLeftWindow

    /// Failed due to invalid position on rear right roller blind
    case invalidPositionRearRightRollerBlind

    /// Failed due to invalid position on rear right window
    case invalidPositionRearRightWindow

    /// Failed due to invalid position on rear roller blind
    case invalidPositionRearRollerBlind

    /// Failed due to invalid power status
    case invalidPowerStatus

    /// Failed due to invalid power status on front left window
    case invalidPowerStatusFrontLeftWindow

    /// Failed due to invalid power status on front right window
    case invalidPowerStatusFrontRightWindow

    /// Failed due to invalid power status on rear left roller blind
    case invalidPowerStatusRearLeftRollerBlind

    /// Failed due to invalid power status on rear left window
    case invalidPowerStatusRearLeftWindow

    /// Failed due to invalid power status on rear right roller blind
    case invalidPowerStatusRearRightRollerBlind

    /// Failed due to invalid power status on rear right window
    case invalidPowerStatusRearRightWindow

    /// Failed due to low or high voltage on rear roller blind
    case invalidPowerStatusRearRollerBlind

    /// Energy level in Battery is too low
    case lowBatteryLevel

    /// Failed due to low battery level 1
    case lowBatteryLevel1

    /// Failed due to low battery level 2
    case lowBatteryLevel2

    /// Failed due to mechanical problem on rear roller blind
    case mechanicalProblemRearRollerBlind

    /// Failed due to multiple anti-trap protection activations
    case multiAntiTrapProtections

    /// Failed due to multiple anti-trap protection activations on front left window
    case multiAntiTrapProtectionsFrontLeftWindow

    /// Failed due to multiple anti-trap protection activations on front right window
    case multiAntiTrapProtectionsFrontRightWindow

    /// Failed due to multiple anti-trap protection activations on rear left roller blind
    case multiAntiTrapProtectionsRearLeftRollerBlind

    /// Failed due to multiple anti-trap protection activations on rear left window
    case multiAntiTrapProtectionsRearLeftWindow

    /// Failed due to multiple anti-trap protection activations on rear right roller blind
    case multiAntiTrapProtectionsRearRightRollerBlind

    /// Failed due to multiple anti-trap protection activations on rear right window
    case multiAntiTrapProtectionsRearRightWindow

    /// Failed due to open load on rear roller blind
    case openLoadRearRollerBlind

    /// Failed due to remote engine start is active
    case remoteEngineStartIsActive

    /// Failed due to hall sensor signal problem on rear roller blind
    case sensorProblemRearRollerBlind

    /// Service not authorized
    case serviceNotAuthorized

    /// Failed due to system is blocked on rear roller blind
    case systemBlockedRearRollerBlind

    /// Failed due to system could not be normed
    case systemCouldNotBeNormed

    /// Failed due to system could not be normed on front left window
    case systemCouldNotBeNormedFrontLeftWindow

    /// Failed due to system could not be normed on front right window
    case systemCouldNotBeNormedFrontRightWindow

    /// Failed due to system could not be normed on rear left roller blind
    case systemCouldNotBeNormedRearLeftRollerBlind

    /// Failed due to system could not be normed on rear left window
    case systemCouldNotBeNormedRearLeftWindow

    /// Failed due to system could not be normed on rear right roller blind
    case systemCouldNotBeNormedRearRightRollerBlind

    /// Failed due to system could not be normed on rear right window
    case systemCouldNotBeNormedRearRightWindow

    /// Failed due to system malfunction
    case systemMalfunction

    /// Failed due to system malfunction on front left window
    case systemMalfunctionFrontLeftWindow

    /// Failed due to system malfunction on front right window
    case systemMalfunctionFrontRightWindow

    /// Failed due to system malfunction on rear left roller blind
    case systemMalfunctionRearLeftRollerBlind

    /// Failed due to system malfunction on rear left window
    case systemMalfunctionRearLeftWindow

    /// Failed due to system malfunction on rear right roller blind
    case systemMalfunctionRearRightRollerBlind

    /// Failed due to system malfunction on rear right window
    case systemMalfunctionRearRightWindow

    /// Failed due to system malfunction on rear roller blind
    case systemMalfunctionRearRollerBlind

    /// Failed due to system not normed
    case systemNotNormed

    /// Failed due to system not normed  on front left window
    case systemNotNormedFrontLeftWindow

    /// Failed due to system not normed  on front right window
    case systemNotNormedFrontRightWindow

    /// Failed due to system not normed on rear left roller blind
    case systemNotNormedRearLeftRollerBlind

    /// Failed due to system not normed  on rear left window
    case systemNotNormedRearLeftWindow

    /// Failed due to system not normed on rear right roller blind
    case systemNotNormedRearRightRollerBlind

    /// Failed due to system not normed  on rear right window
    case systemNotNormedRearRightWindow

    /// Failed due to temperature too low on rear roller blind
    case temperatureTooLowRearRollerBlind

    /// Failed due to thermal protection active on rear roller blind
    case thermalProtectionActiveRearRollerBlind

    /// Failed due to UI handler not available on front left window
    case unavailableUiHandlerFrontLeftWindow

    /// Failed due to UI handler not available on front right window
    case unavailableUiHandlerFrontRightWindow

    /// Failed due to UI handler not available on rear left roller blind
    case unavailableUiHandlerRearLeftRollerBlind

    /// Failed due to UI handler not available on rear left window
    case unavailableUiHandlerRearLeftWindow

    /// Failed due to UI handler not available on rear right roller blind
    case unavailableUiHandlerRearRightRollerBlind

    /// Failed due to UI handler not available on rear right window
    case unavailableUiHandlerRearRightWindow

    /// Failed due to UI handler not available on rear roller blind
    case unavailableUiHandlerRearRollerBlind

    /// Failed due to unknown error on rear roller blind
    case unknownErrorRearRollerBlind

    /// Failed because vehicle is in motion
    case vehicleInMotion

    /// Remote window/roof command failed
    case windowRoofCommandFailed

    /// Remote window/roof command failed (vehicle state in IGN)
    case windowRoofCommandFailedIgnState

    /// Remote window/roof command failed (service not activated in HERMES)
    case windowRoofCommandServiceNotActive

    /// Remote window/roof command failed (window not normed)
    case windowRoofCommandWindowNotNormed

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> WindowsCloseError {
	    switch code { 
        case "21": return .lowBatteryLevel
        case "42": return .fastpathTimeout
        case "4200": return .serviceNotAuthorized
        case "4201": return .remoteEngineStartIsActive
        case "4202": return .ignitionOn
        case "4203": return .lowBatteryLevel2
        case "4204": return .lowBatteryLevel1
        case "4205": return .antiTrapProtectionActive
        case "4206": return .antiTrapProtectionActiveFrontLeftWindow
        case "4207": return .antiTrapProtectionActiveFrontRightWindow
        case "4208": return .antiTrapProtectionActiveRearLeftWindow
        case "4209": return .antiTrapProtectionActiveRearRightWindow
        case "4210": return .antiTrapProtectionActiveRearLeftRollerBlind
        case "4211": return .antiTrapProtectionActiveRearRightRollerBlind
        case "4215": return .systemBlockedRearRollerBlind
        case "4216": return .multiAntiTrapProtections
        case "4217": return .multiAntiTrapProtectionsFrontLeftWindow
        case "4218": return .multiAntiTrapProtectionsFrontRightWindow
        case "4219": return .multiAntiTrapProtectionsRearLeftWindow
        case "4220": return .multiAntiTrapProtectionsRearRightWindow
        case "4221": return .multiAntiTrapProtectionsRearLeftRollerBlind
        case "4222": return .multiAntiTrapProtectionsRearRightRollerBlind
        case "4226": return .sensorProblemRearRollerBlind
        case "4227": return .cancelledManuallyInVehicle
        case "4228": return .cancelledManuallyInVehicleFrontLeftWindow
        case "4229": return .cancelledManuallyInVehicleFrontRightWindow
        case "4230": return .cancelledManuallyInVehicleRearLeftWindow
        case "4231": return .cancelledManuallyInVehicleRearRightWindow
        case "4232": return .cancelledManuallyInVehicleRearLeftRollerBlind
        case "4233": return .cancelledManuallyInVehicleRearRightRollerBlind
        case "4234": return .cancelledManuallyInVehicleSunroof
        case "4242": return .driveMotorOverheated
        case "4243": return .driveMotorOverheatedFrontLeftWindow
        case "4244": return .driveMotorOverheatedFrontRightWindow
        case "4245": return .driveMotorOverheatedRearLeftWindow
        case "4246": return .driveMotorOverheatedRearRightWindow
        case "4247": return .driveMotorOverheatedRearLeftRollerBlind
        case "4248": return .driveMotorOverheatedRearRightRollerBlind
        case "4253": return .systemNotNormed
        case "4254": return .systemNotNormedFrontLeftWindow
        case "4255": return .systemNotNormedFrontRightWindow
        case "4256": return .systemNotNormedRearLeftWindow
        case "4257": return .systemNotNormedRearRightWindow
        case "4258": return .systemNotNormedRearLeftRollerBlind
        case "4259": return .systemNotNormedRearRightRollerBlind
        case "4263": return .featureNotAvailableRearRollerBlind
        case "4265": return .invalidPowerStatus
        case "4266": return .invalidPowerStatusFrontLeftWindow
        case "4267": return .invalidPowerStatusFrontRightWindow
        case "4268": return .invalidPowerStatusRearLeftWindow
        case "4269": return .invalidPowerStatusRearRightWindow
        case "4270": return .invalidPowerStatusRearLeftRollerBlind
        case "4271": return .invalidPowerStatusRearRightRollerBlind
        case "4275": return .invalidPowerStatusRearRollerBlind
        case "4276": return .afterRunActive
        case "4277": return .afterRunActiveFrontLeftWindow
        case "4278": return .afterRunActiveFrontRightWindow
        case "4279": return .afterRunActiveRearLeftWindow
        case "4280": return .afterRunActiveRearRightWindow
        case "4281": return .afterRunActiveRearLeftRollerBlind
        case "4282": return .afterRunActiveRearRightRollerBlind
        case "4286": return .mechanicalProblemRearRollerBlind
        case "4287": return .invalidIgnitionState
        case "4288": return .invalidIgnitionStateFrontLeftWindow
        case "4289": return .invalidIgnitionStateFrontRightWindow
        case "4290": return .invalidIgnitionStateRearLeftWindow
        case "4291": return .invalidIgnitionStateRearRightWindow
        case "4292": return .invalidIgnitionStateRearLeftRollerBlind
        case "4293": return .invalidIgnitionStateRearRightRollerBlind
        case "4297": return .thermalProtectionActiveRearRollerBlind
        case "4298": return .vehicleInMotion
        case "4302": return .openLoadRearRollerBlind
        case "4303": return .systemCouldNotBeNormed
        case "4304": return .systemCouldNotBeNormedFrontLeftWindow
        case "4305": return .systemCouldNotBeNormedFrontRightWindow
        case "4306": return .systemCouldNotBeNormedRearLeftWindow
        case "4307": return .systemCouldNotBeNormedRearRightWindow
        case "4308": return .systemCouldNotBeNormedRearLeftRollerBlind
        case "4309": return .systemCouldNotBeNormedRearRightRollerBlind
        case "4313": return .temperatureTooLowRearRollerBlind
        case "4314": return .systemMalfunction
        case "4315": return .systemMalfunctionFrontLeftWindow
        case "4316": return .systemMalfunctionFrontRightWindow
        case "4317": return .systemMalfunctionRearLeftWindow
        case "4318": return .systemMalfunctionRearRightWindow
        case "4319": return .systemMalfunctionRearLeftRollerBlind
        case "4320": return .systemMalfunctionRearRightRollerBlind
        case "4324": return .systemMalfunctionRearRollerBlind
        case "4325": return .internalSystemError
        case "4326": return .invalidNumberFrontLeftWindow
        case "4327": return .featureNotAvailableFrontLeftWindow
        case "4328": return .invalidNumberFrontRightWindow
        case "4329": return .featureNotAvailableFrontRightWindow
        case "4330": return .invalidNumberRearLeftWindow
        case "4331": return .featureNotAvailableRearLeftWindow
        case "4332": return .invalidNumberRearRightWindow
        case "4333": return .featureNotAvailableRearRightWindow
        case "4336": return .invalidNumberRearLeftRollerBlind
        case "4337": return .featureNotAvailableRearLeftRollerBlind
        case "4338": return .invalidNumberRearRightRollerBlind
        case "4339": return .featureNotAvailableRearRightRollerBlind
        case "4344": return .unknownErrorRearRollerBlind
        case "4346": return .invalidPositionFrontLeftWindow
        case "4347": return .unavailableUiHandlerFrontLeftWindow
        case "4348": return .invalidPositionFrontRightWindow
        case "4349": return .unavailableUiHandlerFrontRightWindow
        case "4350": return .invalidPositionRearLeftWindow
        case "4351": return .unavailableUiHandlerRearLeftWindow
        case "4352": return .invalidPositionRearRightWindow
        case "4353": return .unavailableUiHandlerRearRightWindow
        case "4354": return .invalidPositionRearLeftRollerBlind
        case "4355": return .unavailableUiHandlerRearLeftRollerBlind
        case "4356": return .invalidPositionRearRightRollerBlind
        case "4357": return .unavailableUiHandlerRearRightRollerBlind
        case "4364": return .invalidPositionRearRollerBlind
        case "4365": return .unavailableUiHandlerRearRollerBlind
        case "6901": return .windowRoofCommandFailed
        case "6902": return .windowRoofCommandFailedIgnState
        case "6903": return .windowRoofCommandWindowNotNormed
        case "6904": return .windowRoofCommandServiceNotActive
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .afterRunActive: return "afterRunActive"
        case .afterRunActiveFrontLeftWindow: return "afterRunActiveFrontLeftWindow"
        case .afterRunActiveFrontRightWindow: return "afterRunActiveFrontRightWindow"
        case .afterRunActiveRearLeftRollerBlind: return "afterRunActiveRearLeftRollerBlind"
        case .afterRunActiveRearLeftWindow: return "afterRunActiveRearLeftWindow"
        case .afterRunActiveRearRightRollerBlind: return "afterRunActiveRearRightRollerBlind"
        case .afterRunActiveRearRightWindow: return "afterRunActiveRearRightWindow"
        case .antiTrapProtectionActive: return "antiTrapProtectionActive"
        case .antiTrapProtectionActiveFrontLeftWindow: return "antiTrapProtectionActiveFrontLeftWindow"
        case .antiTrapProtectionActiveFrontRightWindow: return "antiTrapProtectionActiveFrontRightWindow"
        case .antiTrapProtectionActiveRearLeftRollerBlind: return "antiTrapProtectionActiveRearLeftRollerBlind"
        case .antiTrapProtectionActiveRearLeftWindow: return "antiTrapProtectionActiveRearLeftWindow"
        case .antiTrapProtectionActiveRearRightRollerBlind: return "antiTrapProtectionActiveRearRightRollerBlind"
        case .antiTrapProtectionActiveRearRightWindow: return "antiTrapProtectionActiveRearRightWindow"
        case .cancelledManuallyInVehicle: return "cancelledManuallyInVehicle"
        case .cancelledManuallyInVehicleFrontLeftWindow: return "cancelledManuallyInVehicleFrontLeftWindow"
        case .cancelledManuallyInVehicleFrontRightWindow: return "cancelledManuallyInVehicleFrontRightWindow"
        case .cancelledManuallyInVehicleRearLeftRollerBlind: return "cancelledManuallyInVehicleRearLeftRollerBlind"
        case .cancelledManuallyInVehicleRearLeftWindow: return "cancelledManuallyInVehicleRearLeftWindow"
        case .cancelledManuallyInVehicleRearRightRollerBlind: return "cancelledManuallyInVehicleRearRightRollerBlind"
        case .cancelledManuallyInVehicleRearRightWindow: return "cancelledManuallyInVehicleRearRightWindow"
        case .cancelledManuallyInVehicleSunroof: return "cancelledManuallyInVehicleSunroof"
        case .driveMotorOverheated: return "driveMotorOverheated"
        case .driveMotorOverheatedFrontLeftWindow: return "driveMotorOverheatedFrontLeftWindow"
        case .driveMotorOverheatedFrontRightWindow: return "driveMotorOverheatedFrontRightWindow"
        case .driveMotorOverheatedRearLeftRollerBlind: return "driveMotorOverheatedRearLeftRollerBlind"
        case .driveMotorOverheatedRearLeftWindow: return "driveMotorOverheatedRearLeftWindow"
        case .driveMotorOverheatedRearRightRollerBlind: return "driveMotorOverheatedRearRightRollerBlind"
        case .driveMotorOverheatedRearRightWindow: return "driveMotorOverheatedRearRightWindow"
        case .fastpathTimeout: return "fastpathTimeout"
        case .featureNotAvailableFrontLeftWindow: return "featureNotAvailableFrontLeftWindow"
        case .featureNotAvailableFrontRightWindow: return "featureNotAvailableFrontRightWindow"
        case .featureNotAvailableRearLeftRollerBlind: return "featureNotAvailableRearLeftRollerBlind"
        case .featureNotAvailableRearLeftWindow: return "featureNotAvailableRearLeftWindow"
        case .featureNotAvailableRearRightRollerBlind: return "featureNotAvailableRearRightRollerBlind"
        case .featureNotAvailableRearRightWindow: return "featureNotAvailableRearRightWindow"
        case .featureNotAvailableRearRollerBlind: return "featureNotAvailableRearRollerBlind"
        case .ignitionOn: return "ignitionOn"
        case .internalSystemError: return "internalSystemError"
        case .invalidIgnitionState: return "invalidIgnitionState"
        case .invalidIgnitionStateFrontLeftWindow: return "invalidIgnitionStateFrontLeftWindow"
        case .invalidIgnitionStateFrontRightWindow: return "invalidIgnitionStateFrontRightWindow"
        case .invalidIgnitionStateRearLeftRollerBlind: return "invalidIgnitionStateRearLeftRollerBlind"
        case .invalidIgnitionStateRearLeftWindow: return "invalidIgnitionStateRearLeftWindow"
        case .invalidIgnitionStateRearRightRollerBlind: return "invalidIgnitionStateRearRightRollerBlind"
        case .invalidIgnitionStateRearRightWindow: return "invalidIgnitionStateRearRightWindow"
        case .invalidNumberFrontLeftWindow: return "invalidNumberFrontLeftWindow"
        case .invalidNumberFrontRightWindow: return "invalidNumberFrontRightWindow"
        case .invalidNumberRearLeftRollerBlind: return "invalidNumberRearLeftRollerBlind"
        case .invalidNumberRearLeftWindow: return "invalidNumberRearLeftWindow"
        case .invalidNumberRearRightRollerBlind: return "invalidNumberRearRightRollerBlind"
        case .invalidNumberRearRightWindow: return "invalidNumberRearRightWindow"
        case .invalidPositionFrontLeftWindow: return "invalidPositionFrontLeftWindow"
        case .invalidPositionFrontRightWindow: return "invalidPositionFrontRightWindow"
        case .invalidPositionRearLeftRollerBlind: return "invalidPositionRearLeftRollerBlind"
        case .invalidPositionRearLeftWindow: return "invalidPositionRearLeftWindow"
        case .invalidPositionRearRightRollerBlind: return "invalidPositionRearRightRollerBlind"
        case .invalidPositionRearRightWindow: return "invalidPositionRearRightWindow"
        case .invalidPositionRearRollerBlind: return "invalidPositionRearRollerBlind"
        case .invalidPowerStatus: return "invalidPowerStatus"
        case .invalidPowerStatusFrontLeftWindow: return "invalidPowerStatusFrontLeftWindow"
        case .invalidPowerStatusFrontRightWindow: return "invalidPowerStatusFrontRightWindow"
        case .invalidPowerStatusRearLeftRollerBlind: return "invalidPowerStatusRearLeftRollerBlind"
        case .invalidPowerStatusRearLeftWindow: return "invalidPowerStatusRearLeftWindow"
        case .invalidPowerStatusRearRightRollerBlind: return "invalidPowerStatusRearRightRollerBlind"
        case .invalidPowerStatusRearRightWindow: return "invalidPowerStatusRearRightWindow"
        case .invalidPowerStatusRearRollerBlind: return "invalidPowerStatusRearRollerBlind"
        case .lowBatteryLevel: return "lowBatteryLevel"
        case .lowBatteryLevel1: return "lowBatteryLevel1"
        case .lowBatteryLevel2: return "lowBatteryLevel2"
        case .mechanicalProblemRearRollerBlind: return "mechanicalProblemRearRollerBlind"
        case .multiAntiTrapProtections: return "multiAntiTrapProtections"
        case .multiAntiTrapProtectionsFrontLeftWindow: return "multiAntiTrapProtectionsFrontLeftWindow"
        case .multiAntiTrapProtectionsFrontRightWindow: return "multiAntiTrapProtectionsFrontRightWindow"
        case .multiAntiTrapProtectionsRearLeftRollerBlind: return "multiAntiTrapProtectionsRearLeftRollerBlind"
        case .multiAntiTrapProtectionsRearLeftWindow: return "multiAntiTrapProtectionsRearLeftWindow"
        case .multiAntiTrapProtectionsRearRightRollerBlind: return "multiAntiTrapProtectionsRearRightRollerBlind"
        case .multiAntiTrapProtectionsRearRightWindow: return "multiAntiTrapProtectionsRearRightWindow"
        case .openLoadRearRollerBlind: return "openLoadRearRollerBlind"
        case .remoteEngineStartIsActive: return "remoteEngineStartIsActive"
        case .sensorProblemRearRollerBlind: return "sensorProblemRearRollerBlind"
        case .serviceNotAuthorized: return "serviceNotAuthorized"
        case .systemBlockedRearRollerBlind: return "systemBlockedRearRollerBlind"
        case .systemCouldNotBeNormed: return "systemCouldNotBeNormed"
        case .systemCouldNotBeNormedFrontLeftWindow: return "systemCouldNotBeNormedFrontLeftWindow"
        case .systemCouldNotBeNormedFrontRightWindow: return "systemCouldNotBeNormedFrontRightWindow"
        case .systemCouldNotBeNormedRearLeftRollerBlind: return "systemCouldNotBeNormedRearLeftRollerBlind"
        case .systemCouldNotBeNormedRearLeftWindow: return "systemCouldNotBeNormedRearLeftWindow"
        case .systemCouldNotBeNormedRearRightRollerBlind: return "systemCouldNotBeNormedRearRightRollerBlind"
        case .systemCouldNotBeNormedRearRightWindow: return "systemCouldNotBeNormedRearRightWindow"
        case .systemMalfunction: return "systemMalfunction"
        case .systemMalfunctionFrontLeftWindow: return "systemMalfunctionFrontLeftWindow"
        case .systemMalfunctionFrontRightWindow: return "systemMalfunctionFrontRightWindow"
        case .systemMalfunctionRearLeftRollerBlind: return "systemMalfunctionRearLeftRollerBlind"
        case .systemMalfunctionRearLeftWindow: return "systemMalfunctionRearLeftWindow"
        case .systemMalfunctionRearRightRollerBlind: return "systemMalfunctionRearRightRollerBlind"
        case .systemMalfunctionRearRightWindow: return "systemMalfunctionRearRightWindow"
        case .systemMalfunctionRearRollerBlind: return "systemMalfunctionRearRollerBlind"
        case .systemNotNormed: return "systemNotNormed"
        case .systemNotNormedFrontLeftWindow: return "systemNotNormedFrontLeftWindow"
        case .systemNotNormedFrontRightWindow: return "systemNotNormedFrontRightWindow"
        case .systemNotNormedRearLeftRollerBlind: return "systemNotNormedRearLeftRollerBlind"
        case .systemNotNormedRearLeftWindow: return "systemNotNormedRearLeftWindow"
        case .systemNotNormedRearRightRollerBlind: return "systemNotNormedRearRightRollerBlind"
        case .systemNotNormedRearRightWindow: return "systemNotNormedRearRightWindow"
        case .temperatureTooLowRearRollerBlind: return "temperatureTooLowRearRollerBlind"
        case .thermalProtectionActiveRearRollerBlind: return "thermalProtectionActiveRearRollerBlind"
        case .unavailableUiHandlerFrontLeftWindow: return "unavailableUiHandlerFrontLeftWindow"
        case .unavailableUiHandlerFrontRightWindow: return "unavailableUiHandlerFrontRightWindow"
        case .unavailableUiHandlerRearLeftRollerBlind: return "unavailableUiHandlerRearLeftRollerBlind"
        case .unavailableUiHandlerRearLeftWindow: return "unavailableUiHandlerRearLeftWindow"
        case .unavailableUiHandlerRearRightRollerBlind: return "unavailableUiHandlerRearRightRollerBlind"
        case .unavailableUiHandlerRearRightWindow: return "unavailableUiHandlerRearRightWindow"
        case .unavailableUiHandlerRearRollerBlind: return "unavailableUiHandlerRearRollerBlind"
        case .unknownErrorRearRollerBlind: return "unknownErrorRearRollerBlind"
        case .vehicleInMotion: return "vehicleInMotion"
        case .windowRoofCommandFailed: return "windowRoofCommandFailed"
        case .windowRoofCommandFailedIgnState: return "windowRoofCommandFailedIgnState"
        case .windowRoofCommandServiceNotActive: return "windowRoofCommandServiceNotActive"
        case .windowRoofCommandWindowNotNormed: return "windowRoofCommandWindowNotNormed"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.WindowsClose: BaseCommandProtocol {

	public typealias Error = WindowsCloseError

	public func createGenericError(error: GenericCommandError) -> WindowsCloseError {
		return WindowsCloseError.genericError(error: error)
	}
}

extension Command.WindowsClose: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the WindowsMove command version v1
public enum WindowsMoveError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Failed due to afterrun active
    case afterRunActive

    /// Failed due to afterrun active on front left window
    case afterRunActiveFrontLeftWindow

    /// Failed due to afterrun active on front right window
    case afterRunActiveFrontRightWindow

    /// Failed due to afterrun active on rear left roller blind
    case afterRunActiveRearLeftRollerBlind

    /// Failed due to afterrun active on rear left window
    case afterRunActiveRearLeftWindow

    /// Failed due to afterrun active on rear right roller blind
    case afterRunActiveRearRightRollerBlind

    /// Failed due to afterrun active on rear right window
    case afterRunActiveRearRightWindow

    /// Failed due to anti-trap protection active
    case antiTrapProtectionActive

    /// Failed due to anti-trap protection active on front left window
    case antiTrapProtectionActiveFrontLeftWindow

    /// Failed due to anti-trap protection active on front right window
    case antiTrapProtectionActiveFrontRightWindow

    /// Failed due to anti-trap protection active on rear left roller blind
    case antiTrapProtectionActiveRearLeftRollerBlind

    /// Failed due to anti-trap protection active on rear left window
    case antiTrapProtectionActiveRearLeftWindow

    /// Failed due to anti-trap protection active on rear right roller blind
    case antiTrapProtectionActiveRearRightRollerBlind

    /// Failed due to anti-trap protection active on rear right window
    case antiTrapProtectionActiveRearRightWindow

    /// Failed due to manual cancellation inside vehicle
    case cancelledManuallyInVehicle

    /// Failed due to manual cancellation inside vehicle on front left window
    case cancelledManuallyInVehicleFrontLeftWindow

    /// Failed due to manual cancellation inside vehicle on front right window
    case cancelledManuallyInVehicleFrontRightWindow

    /// Failed due to manual cancellation inside vehicle on rear left roller blind
    case cancelledManuallyInVehicleRearLeftRollerBlind

    /// Failed due to manual cancellation inside vehicle on rear left window
    case cancelledManuallyInVehicleRearLeftWindow

    /// Failed due to manual cancellation inside vehicle on rear right roller blind
    case cancelledManuallyInVehicleRearRightRollerBlind

    /// Failed due to manual cancellation inside vehicle on rear right window
    case cancelledManuallyInVehicleRearRightWindow

    /// Failed due to manual cancellation inside vehicle on sunroof
    case cancelledManuallyInVehicleSunroof

    /// Failed due to drive motor overheated
    case driveMotorOverheated

    /// Failed due to drive motor overheated on front left window
    case driveMotorOverheatedFrontLeftWindow

    /// Failed due to drive motor overheated on front right window
    case driveMotorOverheatedFrontRightWindow

    /// Failed due to drive motor overheated on rear left roller blind
    case driveMotorOverheatedRearLeftRollerBlind

    /// Failed due to drive motor overheated on rear left window
    case driveMotorOverheatedRearLeftWindow

    /// Failed due to drive motor overheated on rear right roller blind
    case driveMotorOverheatedRearRightRollerBlind

    /// Failed due to drive motor overheated on rear right window
    case driveMotorOverheatedRearRightWindow

    /// Failed due to feature not available on front left window
    case featureNotAvailableFrontLeftWindow

    /// Failed due to feature not available on front right window
    case featureNotAvailableFrontRightWindow

    /// Failed due to feature not available on rear left roller blind
    case featureNotAvailableRearLeftRollerBlind

    /// Failed due to feature not available on rear left window
    case featureNotAvailableRearLeftWindow

    /// Failed due to feature not available on rear right roller blind
    case featureNotAvailableRearRightRollerBlind

    /// Failed due to feature not available on rear right window
    case featureNotAvailableRearRightWindow

    /// Failed due to feature not available on rear roller blind
    case featureNotAvailableRearRollerBlind

    /// Failed due to ignition is on
    case ignitionOn

    /// Failed due to internal system error
    case internalSystemError

    /// Failed due to invalid ignition state
    case invalidIgnitionState

    /// Failed due to invalid ignition state on front left window
    case invalidIgnitionStateFrontLeftWindow

    /// Failed due to invalid ignition state on front right window
    case invalidIgnitionStateFrontRightWindow

    /// Failed due to invalid ignition state on rear left roller blind
    case invalidIgnitionStateRearLeftRollerBlind

    /// Failed due to invalid ignition state on rear left window
    case invalidIgnitionStateRearLeftWindow

    /// Failed due to invalid ignition state on rear right roller blind
    case invalidIgnitionStateRearRightRollerBlind

    /// Failed due to invalid ignition state on rear right window
    case invalidIgnitionStateRearRightWindow

    /// Failed due to invalid number on front left window
    case invalidNumberFrontLeftWindow

    /// Failed due to invalid number on front right window
    case invalidNumberFrontRightWindow

    /// Failed due to invalid number on rear left roller blind
    case invalidNumberRearLeftRollerBlind

    /// Failed due to invalid number on rear left window
    case invalidNumberRearLeftWindow

    /// Failed due to invalid number on rear right roller blind
    case invalidNumberRearRightRollerBlind

    /// Failed due to invalid number on rear right window
    case invalidNumberRearRightWindow

    /// Failed due to invalid position on front left window
    case invalidPositionFrontLeftWindow

    /// Failed due to invalid position on front right window
    case invalidPositionFrontRightWindow

    /// Failed due to invalid position on rear left roller blind
    case invalidPositionRearLeftRollerBlind

    /// Failed due to invalid position on rear left window
    case invalidPositionRearLeftWindow

    /// Failed due to invalid position on rear right roller blind
    case invalidPositionRearRightRollerBlind

    /// Failed due to invalid position on rear right window
    case invalidPositionRearRightWindow

    /// Failed due to invalid position on rear roller blind
    case invalidPositionRearRollerBlind

    /// Failed due to invalid power status
    case invalidPowerStatus

    /// Failed due to invalid power status on front left window
    case invalidPowerStatusFrontLeftWindow

    /// Failed due to invalid power status on front right window
    case invalidPowerStatusFrontRightWindow

    /// Failed due to invalid power status on rear left roller blind
    case invalidPowerStatusRearLeftRollerBlind

    /// Failed due to invalid power status on rear left window
    case invalidPowerStatusRearLeftWindow

    /// Failed due to invalid power status on rear right roller blind
    case invalidPowerStatusRearRightRollerBlind

    /// Failed due to invalid power status on rear right window
    case invalidPowerStatusRearRightWindow

    /// Failed due to low or high voltage on rear roller blind
    case invalidPowerStatusRearRollerBlind

    /// Failed due to low battery level 1
    case lowBatteryLevel1

    /// Failed due to low battery level 2
    case lowBatteryLevel2

    /// Failed due to mechanical problem on rear roller blind
    case mechanicalProblemRearRollerBlind

    /// Failed due to multiple anti-trap protection activations
    case multiAntiTrapProtections

    /// Failed due to multiple anti-trap protection activations on front left window
    case multiAntiTrapProtectionsFrontLeftWindow

    /// Failed due to multiple anti-trap protection activations on front right window
    case multiAntiTrapProtectionsFrontRightWindow

    /// Failed due to multiple anti-trap protection activations on rear left roller blind
    case multiAntiTrapProtectionsRearLeftRollerBlind

    /// Failed due to multiple anti-trap protection activations on rear left window
    case multiAntiTrapProtectionsRearLeftWindow

    /// Failed due to multiple anti-trap protection activations on rear right roller blind
    case multiAntiTrapProtectionsRearRightRollerBlind

    /// Failed due to multiple anti-trap protection activations on rear right window
    case multiAntiTrapProtectionsRearRightWindow

    /// Failed due to open load on rear roller blind
    case openLoadRearRollerBlind

    /// Failed due to remote engine start is active
    case remoteEngineStartIsActive

    /// Failed due to hall sensor signal problem on rear roller blind
    case sensorProblemRearRollerBlind

    /// Service not authorized
    case serviceNotAuthorized

    /// Failed due to system is blocked on rear roller blind
    case systemBlockedRearRollerBlind

    /// Failed due to system could not be normed
    case systemCouldNotBeNormed

    /// Failed due to system could not be normed on front left window
    case systemCouldNotBeNormedFrontLeftWindow

    /// Failed due to system could not be normed on front right window
    case systemCouldNotBeNormedFrontRightWindow

    /// Failed due to system could not be normed on rear left roller blind
    case systemCouldNotBeNormedRearLeftRollerBlind

    /// Failed due to system could not be normed on rear left window
    case systemCouldNotBeNormedRearLeftWindow

    /// Failed due to system could not be normed on rear right roller blind
    case systemCouldNotBeNormedRearRightRollerBlind

    /// Failed due to system could not be normed on rear right window
    case systemCouldNotBeNormedRearRightWindow

    /// Failed due to system malfunction
    case systemMalfunction

    /// Failed due to system malfunction on front left window
    case systemMalfunctionFrontLeftWindow

    /// Failed due to system malfunction on front right window
    case systemMalfunctionFrontRightWindow

    /// Failed due to system malfunction on rear left roller blind
    case systemMalfunctionRearLeftRollerBlind

    /// Failed due to system malfunction on rear left window
    case systemMalfunctionRearLeftWindow

    /// Failed due to system malfunction on rear right roller blind
    case systemMalfunctionRearRightRollerBlind

    /// Failed due to system malfunction on rear right window
    case systemMalfunctionRearRightWindow

    /// Failed due to system malfunction on rear roller blind
    case systemMalfunctionRearRollerBlind

    /// Failed due to system not normed
    case systemNotNormed

    /// Failed due to system not normed  on front left window
    case systemNotNormedFrontLeftWindow

    /// Failed due to system not normed  on front right window
    case systemNotNormedFrontRightWindow

    /// Failed due to system not normed on rear left roller blind
    case systemNotNormedRearLeftRollerBlind

    /// Failed due to system not normed  on rear left window
    case systemNotNormedRearLeftWindow

    /// Failed due to system not normed on rear right roller blind
    case systemNotNormedRearRightRollerBlind

    /// Failed due to system not normed  on rear right window
    case systemNotNormedRearRightWindow

    /// Failed due to temperature too low on rear roller blind
    case temperatureTooLowRearRollerBlind

    /// Failed due to thermal protection active on rear roller blind
    case thermalProtectionActiveRearRollerBlind

    /// Failed due to UI handler not available on front left window
    case unavailableUiHandlerFrontLeftWindow

    /// Failed due to UI handler not available on front right window
    case unavailableUiHandlerFrontRightWindow

    /// Failed due to UI handler not available on rear left roller blind
    case unavailableUiHandlerRearLeftRollerBlind

    /// Failed due to UI handler not available on rear left window
    case unavailableUiHandlerRearLeftWindow

    /// Failed due to UI handler not available on rear right roller blind
    case unavailableUiHandlerRearRightRollerBlind

    /// Failed due to UI handler not available on rear right window
    case unavailableUiHandlerRearRightWindow

    /// Failed due to UI handler not available on rear roller blind
    case unavailableUiHandlerRearRollerBlind

    /// Failed due to unknown error on rear roller blind
    case unknownErrorRearRollerBlind

    /// Failed because vehicle is in motion
    case vehicleInMotion

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> WindowsMoveError {
	    switch code { 
        case "4200": return .serviceNotAuthorized
        case "4201": return .remoteEngineStartIsActive
        case "4202": return .ignitionOn
        case "4203": return .lowBatteryLevel2
        case "4204": return .lowBatteryLevel1
        case "4205": return .antiTrapProtectionActive
        case "4206": return .antiTrapProtectionActiveFrontLeftWindow
        case "4207": return .antiTrapProtectionActiveFrontRightWindow
        case "4208": return .antiTrapProtectionActiveRearLeftWindow
        case "4209": return .antiTrapProtectionActiveRearRightWindow
        case "4210": return .antiTrapProtectionActiveRearLeftRollerBlind
        case "4211": return .antiTrapProtectionActiveRearRightRollerBlind
        case "4215": return .systemBlockedRearRollerBlind
        case "4216": return .multiAntiTrapProtections
        case "4217": return .multiAntiTrapProtectionsFrontLeftWindow
        case "4218": return .multiAntiTrapProtectionsFrontRightWindow
        case "4219": return .multiAntiTrapProtectionsRearLeftWindow
        case "4220": return .multiAntiTrapProtectionsRearRightWindow
        case "4221": return .multiAntiTrapProtectionsRearLeftRollerBlind
        case "4222": return .multiAntiTrapProtectionsRearRightRollerBlind
        case "4226": return .sensorProblemRearRollerBlind
        case "4227": return .cancelledManuallyInVehicle
        case "4228": return .cancelledManuallyInVehicleFrontLeftWindow
        case "4229": return .cancelledManuallyInVehicleFrontRightWindow
        case "4230": return .cancelledManuallyInVehicleRearLeftWindow
        case "4231": return .cancelledManuallyInVehicleRearRightWindow
        case "4232": return .cancelledManuallyInVehicleRearLeftRollerBlind
        case "4233": return .cancelledManuallyInVehicleRearRightRollerBlind
        case "4234": return .cancelledManuallyInVehicleSunroof
        case "4242": return .driveMotorOverheated
        case "4243": return .driveMotorOverheatedFrontLeftWindow
        case "4244": return .driveMotorOverheatedFrontRightWindow
        case "4245": return .driveMotorOverheatedRearLeftWindow
        case "4246": return .driveMotorOverheatedRearRightWindow
        case "4247": return .driveMotorOverheatedRearLeftRollerBlind
        case "4248": return .driveMotorOverheatedRearRightRollerBlind
        case "4253": return .systemNotNormed
        case "4254": return .systemNotNormedFrontLeftWindow
        case "4255": return .systemNotNormedFrontRightWindow
        case "4256": return .systemNotNormedRearLeftWindow
        case "4257": return .systemNotNormedRearRightWindow
        case "4258": return .systemNotNormedRearLeftRollerBlind
        case "4259": return .systemNotNormedRearRightRollerBlind
        case "4263": return .featureNotAvailableRearRollerBlind
        case "4265": return .invalidPowerStatus
        case "4266": return .invalidPowerStatusFrontLeftWindow
        case "4267": return .invalidPowerStatusFrontRightWindow
        case "4268": return .invalidPowerStatusRearLeftWindow
        case "4269": return .invalidPowerStatusRearRightWindow
        case "4270": return .invalidPowerStatusRearLeftRollerBlind
        case "4271": return .invalidPowerStatusRearRightRollerBlind
        case "4275": return .invalidPowerStatusRearRollerBlind
        case "4276": return .afterRunActive
        case "4277": return .afterRunActiveFrontLeftWindow
        case "4278": return .afterRunActiveFrontRightWindow
        case "4279": return .afterRunActiveRearLeftWindow
        case "4280": return .afterRunActiveRearRightWindow
        case "4281": return .afterRunActiveRearLeftRollerBlind
        case "4282": return .afterRunActiveRearRightRollerBlind
        case "4286": return .mechanicalProblemRearRollerBlind
        case "4287": return .invalidIgnitionState
        case "4288": return .invalidIgnitionStateFrontLeftWindow
        case "4289": return .invalidIgnitionStateFrontRightWindow
        case "4290": return .invalidIgnitionStateRearLeftWindow
        case "4291": return .invalidIgnitionStateRearRightWindow
        case "4292": return .invalidIgnitionStateRearLeftRollerBlind
        case "4293": return .invalidIgnitionStateRearRightRollerBlind
        case "4297": return .thermalProtectionActiveRearRollerBlind
        case "4298": return .vehicleInMotion
        case "4302": return .openLoadRearRollerBlind
        case "4303": return .systemCouldNotBeNormed
        case "4304": return .systemCouldNotBeNormedFrontLeftWindow
        case "4305": return .systemCouldNotBeNormedFrontRightWindow
        case "4306": return .systemCouldNotBeNormedRearLeftWindow
        case "4307": return .systemCouldNotBeNormedRearRightWindow
        case "4308": return .systemCouldNotBeNormedRearLeftRollerBlind
        case "4309": return .systemCouldNotBeNormedRearRightRollerBlind
        case "4313": return .temperatureTooLowRearRollerBlind
        case "4314": return .systemMalfunction
        case "4315": return .systemMalfunctionFrontLeftWindow
        case "4316": return .systemMalfunctionFrontRightWindow
        case "4317": return .systemMalfunctionRearLeftWindow
        case "4318": return .systemMalfunctionRearRightWindow
        case "4319": return .systemMalfunctionRearLeftRollerBlind
        case "4320": return .systemMalfunctionRearRightRollerBlind
        case "4324": return .systemMalfunctionRearRollerBlind
        case "4325": return .internalSystemError
        case "4326": return .invalidNumberFrontLeftWindow
        case "4327": return .featureNotAvailableFrontLeftWindow
        case "4328": return .invalidNumberFrontRightWindow
        case "4329": return .featureNotAvailableFrontRightWindow
        case "4330": return .invalidNumberRearLeftWindow
        case "4331": return .featureNotAvailableRearLeftWindow
        case "4332": return .invalidNumberRearRightWindow
        case "4333": return .featureNotAvailableRearRightWindow
        case "4336": return .invalidNumberRearLeftRollerBlind
        case "4337": return .featureNotAvailableRearLeftRollerBlind
        case "4338": return .invalidNumberRearRightRollerBlind
        case "4339": return .featureNotAvailableRearRightRollerBlind
        case "4344": return .unknownErrorRearRollerBlind
        case "4346": return .invalidPositionFrontLeftWindow
        case "4347": return .unavailableUiHandlerFrontLeftWindow
        case "4348": return .invalidPositionFrontRightWindow
        case "4349": return .unavailableUiHandlerFrontRightWindow
        case "4350": return .invalidPositionRearLeftWindow
        case "4351": return .unavailableUiHandlerRearLeftWindow
        case "4352": return .invalidPositionRearRightWindow
        case "4353": return .unavailableUiHandlerRearRightWindow
        case "4354": return .invalidPositionRearLeftRollerBlind
        case "4355": return .unavailableUiHandlerRearLeftRollerBlind
        case "4356": return .invalidPositionRearRightRollerBlind
        case "4357": return .unavailableUiHandlerRearRightRollerBlind
        case "4364": return .invalidPositionRearRollerBlind
        case "4365": return .unavailableUiHandlerRearRollerBlind
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .afterRunActive: return "afterRunActive"
        case .afterRunActiveFrontLeftWindow: return "afterRunActiveFrontLeftWindow"
        case .afterRunActiveFrontRightWindow: return "afterRunActiveFrontRightWindow"
        case .afterRunActiveRearLeftRollerBlind: return "afterRunActiveRearLeftRollerBlind"
        case .afterRunActiveRearLeftWindow: return "afterRunActiveRearLeftWindow"
        case .afterRunActiveRearRightRollerBlind: return "afterRunActiveRearRightRollerBlind"
        case .afterRunActiveRearRightWindow: return "afterRunActiveRearRightWindow"
        case .antiTrapProtectionActive: return "antiTrapProtectionActive"
        case .antiTrapProtectionActiveFrontLeftWindow: return "antiTrapProtectionActiveFrontLeftWindow"
        case .antiTrapProtectionActiveFrontRightWindow: return "antiTrapProtectionActiveFrontRightWindow"
        case .antiTrapProtectionActiveRearLeftRollerBlind: return "antiTrapProtectionActiveRearLeftRollerBlind"
        case .antiTrapProtectionActiveRearLeftWindow: return "antiTrapProtectionActiveRearLeftWindow"
        case .antiTrapProtectionActiveRearRightRollerBlind: return "antiTrapProtectionActiveRearRightRollerBlind"
        case .antiTrapProtectionActiveRearRightWindow: return "antiTrapProtectionActiveRearRightWindow"
        case .cancelledManuallyInVehicle: return "cancelledManuallyInVehicle"
        case .cancelledManuallyInVehicleFrontLeftWindow: return "cancelledManuallyInVehicleFrontLeftWindow"
        case .cancelledManuallyInVehicleFrontRightWindow: return "cancelledManuallyInVehicleFrontRightWindow"
        case .cancelledManuallyInVehicleRearLeftRollerBlind: return "cancelledManuallyInVehicleRearLeftRollerBlind"
        case .cancelledManuallyInVehicleRearLeftWindow: return "cancelledManuallyInVehicleRearLeftWindow"
        case .cancelledManuallyInVehicleRearRightRollerBlind: return "cancelledManuallyInVehicleRearRightRollerBlind"
        case .cancelledManuallyInVehicleRearRightWindow: return "cancelledManuallyInVehicleRearRightWindow"
        case .cancelledManuallyInVehicleSunroof: return "cancelledManuallyInVehicleSunroof"
        case .driveMotorOverheated: return "driveMotorOverheated"
        case .driveMotorOverheatedFrontLeftWindow: return "driveMotorOverheatedFrontLeftWindow"
        case .driveMotorOverheatedFrontRightWindow: return "driveMotorOverheatedFrontRightWindow"
        case .driveMotorOverheatedRearLeftRollerBlind: return "driveMotorOverheatedRearLeftRollerBlind"
        case .driveMotorOverheatedRearLeftWindow: return "driveMotorOverheatedRearLeftWindow"
        case .driveMotorOverheatedRearRightRollerBlind: return "driveMotorOverheatedRearRightRollerBlind"
        case .driveMotorOverheatedRearRightWindow: return "driveMotorOverheatedRearRightWindow"
        case .featureNotAvailableFrontLeftWindow: return "featureNotAvailableFrontLeftWindow"
        case .featureNotAvailableFrontRightWindow: return "featureNotAvailableFrontRightWindow"
        case .featureNotAvailableRearLeftRollerBlind: return "featureNotAvailableRearLeftRollerBlind"
        case .featureNotAvailableRearLeftWindow: return "featureNotAvailableRearLeftWindow"
        case .featureNotAvailableRearRightRollerBlind: return "featureNotAvailableRearRightRollerBlind"
        case .featureNotAvailableRearRightWindow: return "featureNotAvailableRearRightWindow"
        case .featureNotAvailableRearRollerBlind: return "featureNotAvailableRearRollerBlind"
        case .ignitionOn: return "ignitionOn"
        case .internalSystemError: return "internalSystemError"
        case .invalidIgnitionState: return "invalidIgnitionState"
        case .invalidIgnitionStateFrontLeftWindow: return "invalidIgnitionStateFrontLeftWindow"
        case .invalidIgnitionStateFrontRightWindow: return "invalidIgnitionStateFrontRightWindow"
        case .invalidIgnitionStateRearLeftRollerBlind: return "invalidIgnitionStateRearLeftRollerBlind"
        case .invalidIgnitionStateRearLeftWindow: return "invalidIgnitionStateRearLeftWindow"
        case .invalidIgnitionStateRearRightRollerBlind: return "invalidIgnitionStateRearRightRollerBlind"
        case .invalidIgnitionStateRearRightWindow: return "invalidIgnitionStateRearRightWindow"
        case .invalidNumberFrontLeftWindow: return "invalidNumberFrontLeftWindow"
        case .invalidNumberFrontRightWindow: return "invalidNumberFrontRightWindow"
        case .invalidNumberRearLeftRollerBlind: return "invalidNumberRearLeftRollerBlind"
        case .invalidNumberRearLeftWindow: return "invalidNumberRearLeftWindow"
        case .invalidNumberRearRightRollerBlind: return "invalidNumberRearRightRollerBlind"
        case .invalidNumberRearRightWindow: return "invalidNumberRearRightWindow"
        case .invalidPositionFrontLeftWindow: return "invalidPositionFrontLeftWindow"
        case .invalidPositionFrontRightWindow: return "invalidPositionFrontRightWindow"
        case .invalidPositionRearLeftRollerBlind: return "invalidPositionRearLeftRollerBlind"
        case .invalidPositionRearLeftWindow: return "invalidPositionRearLeftWindow"
        case .invalidPositionRearRightRollerBlind: return "invalidPositionRearRightRollerBlind"
        case .invalidPositionRearRightWindow: return "invalidPositionRearRightWindow"
        case .invalidPositionRearRollerBlind: return "invalidPositionRearRollerBlind"
        case .invalidPowerStatus: return "invalidPowerStatus"
        case .invalidPowerStatusFrontLeftWindow: return "invalidPowerStatusFrontLeftWindow"
        case .invalidPowerStatusFrontRightWindow: return "invalidPowerStatusFrontRightWindow"
        case .invalidPowerStatusRearLeftRollerBlind: return "invalidPowerStatusRearLeftRollerBlind"
        case .invalidPowerStatusRearLeftWindow: return "invalidPowerStatusRearLeftWindow"
        case .invalidPowerStatusRearRightRollerBlind: return "invalidPowerStatusRearRightRollerBlind"
        case .invalidPowerStatusRearRightWindow: return "invalidPowerStatusRearRightWindow"
        case .invalidPowerStatusRearRollerBlind: return "invalidPowerStatusRearRollerBlind"
        case .lowBatteryLevel1: return "lowBatteryLevel1"
        case .lowBatteryLevel2: return "lowBatteryLevel2"
        case .mechanicalProblemRearRollerBlind: return "mechanicalProblemRearRollerBlind"
        case .multiAntiTrapProtections: return "multiAntiTrapProtections"
        case .multiAntiTrapProtectionsFrontLeftWindow: return "multiAntiTrapProtectionsFrontLeftWindow"
        case .multiAntiTrapProtectionsFrontRightWindow: return "multiAntiTrapProtectionsFrontRightWindow"
        case .multiAntiTrapProtectionsRearLeftRollerBlind: return "multiAntiTrapProtectionsRearLeftRollerBlind"
        case .multiAntiTrapProtectionsRearLeftWindow: return "multiAntiTrapProtectionsRearLeftWindow"
        case .multiAntiTrapProtectionsRearRightRollerBlind: return "multiAntiTrapProtectionsRearRightRollerBlind"
        case .multiAntiTrapProtectionsRearRightWindow: return "multiAntiTrapProtectionsRearRightWindow"
        case .openLoadRearRollerBlind: return "openLoadRearRollerBlind"
        case .remoteEngineStartIsActive: return "remoteEngineStartIsActive"
        case .sensorProblemRearRollerBlind: return "sensorProblemRearRollerBlind"
        case .serviceNotAuthorized: return "serviceNotAuthorized"
        case .systemBlockedRearRollerBlind: return "systemBlockedRearRollerBlind"
        case .systemCouldNotBeNormed: return "systemCouldNotBeNormed"
        case .systemCouldNotBeNormedFrontLeftWindow: return "systemCouldNotBeNormedFrontLeftWindow"
        case .systemCouldNotBeNormedFrontRightWindow: return "systemCouldNotBeNormedFrontRightWindow"
        case .systemCouldNotBeNormedRearLeftRollerBlind: return "systemCouldNotBeNormedRearLeftRollerBlind"
        case .systemCouldNotBeNormedRearLeftWindow: return "systemCouldNotBeNormedRearLeftWindow"
        case .systemCouldNotBeNormedRearRightRollerBlind: return "systemCouldNotBeNormedRearRightRollerBlind"
        case .systemCouldNotBeNormedRearRightWindow: return "systemCouldNotBeNormedRearRightWindow"
        case .systemMalfunction: return "systemMalfunction"
        case .systemMalfunctionFrontLeftWindow: return "systemMalfunctionFrontLeftWindow"
        case .systemMalfunctionFrontRightWindow: return "systemMalfunctionFrontRightWindow"
        case .systemMalfunctionRearLeftRollerBlind: return "systemMalfunctionRearLeftRollerBlind"
        case .systemMalfunctionRearLeftWindow: return "systemMalfunctionRearLeftWindow"
        case .systemMalfunctionRearRightRollerBlind: return "systemMalfunctionRearRightRollerBlind"
        case .systemMalfunctionRearRightWindow: return "systemMalfunctionRearRightWindow"
        case .systemMalfunctionRearRollerBlind: return "systemMalfunctionRearRollerBlind"
        case .systemNotNormed: return "systemNotNormed"
        case .systemNotNormedFrontLeftWindow: return "systemNotNormedFrontLeftWindow"
        case .systemNotNormedFrontRightWindow: return "systemNotNormedFrontRightWindow"
        case .systemNotNormedRearLeftRollerBlind: return "systemNotNormedRearLeftRollerBlind"
        case .systemNotNormedRearLeftWindow: return "systemNotNormedRearLeftWindow"
        case .systemNotNormedRearRightRollerBlind: return "systemNotNormedRearRightRollerBlind"
        case .systemNotNormedRearRightWindow: return "systemNotNormedRearRightWindow"
        case .temperatureTooLowRearRollerBlind: return "temperatureTooLowRearRollerBlind"
        case .thermalProtectionActiveRearRollerBlind: return "thermalProtectionActiveRearRollerBlind"
        case .unavailableUiHandlerFrontLeftWindow: return "unavailableUiHandlerFrontLeftWindow"
        case .unavailableUiHandlerFrontRightWindow: return "unavailableUiHandlerFrontRightWindow"
        case .unavailableUiHandlerRearLeftRollerBlind: return "unavailableUiHandlerRearLeftRollerBlind"
        case .unavailableUiHandlerRearLeftWindow: return "unavailableUiHandlerRearLeftWindow"
        case .unavailableUiHandlerRearRightRollerBlind: return "unavailableUiHandlerRearRightRollerBlind"
        case .unavailableUiHandlerRearRightWindow: return "unavailableUiHandlerRearRightWindow"
        case .unavailableUiHandlerRearRollerBlind: return "unavailableUiHandlerRearRollerBlind"
        case .unknownErrorRearRollerBlind: return "unknownErrorRearRollerBlind"
        case .vehicleInMotion: return "vehicleInMotion"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.WindowsMove: BaseCommandProtocol {

	public typealias Error = WindowsMoveError

	public func createGenericError(error: GenericCommandError) -> WindowsMoveError {
		return WindowsMoveError.genericError(error: error)
	}
}

extension Command.WindowsMove: CommandPinProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String, pin: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self, pin: pin)
	}
}


/// All possible error codes for the WindowsOpen command version v1
public enum WindowsOpenError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Failed due to afterrun active
    case afterRunActive

    /// Failed due to afterrun active on front left window
    case afterRunActiveFrontLeftWindow

    /// Failed due to afterrun active on front right window
    case afterRunActiveFrontRightWindow

    /// Failed due to afterrun active on rear left roller blind
    case afterRunActiveRearLeftRollerBlind

    /// Failed due to afterrun active on rear left window
    case afterRunActiveRearLeftWindow

    /// Failed due to afterrun active on rear right roller blind
    case afterRunActiveRearRightRollerBlind

    /// Failed due to afterrun active on rear right window
    case afterRunActiveRearRightWindow

    /// Failed due to anti-trap protection active
    case antiTrapProtectionActive

    /// Failed due to anti-trap protection active on front left window
    case antiTrapProtectionActiveFrontLeftWindow

    /// Failed due to anti-trap protection active on front right window
    case antiTrapProtectionActiveFrontRightWindow

    /// Failed due to anti-trap protection active on rear left roller blind
    case antiTrapProtectionActiveRearLeftRollerBlind

    /// Failed due to anti-trap protection active on rear left window
    case antiTrapProtectionActiveRearLeftWindow

    /// Failed due to anti-trap protection active on rear right roller blind
    case antiTrapProtectionActiveRearRightRollerBlind

    /// Failed due to anti-trap protection active on rear right window
    case antiTrapProtectionActiveRearRightWindow

    /// Failed due to manual cancellation inside vehicle
    case cancelledManuallyInVehicle

    /// Failed due to manual cancellation inside vehicle on front left window
    case cancelledManuallyInVehicleFrontLeftWindow

    /// Failed due to manual cancellation inside vehicle on front right window
    case cancelledManuallyInVehicleFrontRightWindow

    /// Failed due to manual cancellation inside vehicle on rear left roller blind
    case cancelledManuallyInVehicleRearLeftRollerBlind

    /// Failed due to manual cancellation inside vehicle on rear left window
    case cancelledManuallyInVehicleRearLeftWindow

    /// Failed due to manual cancellation inside vehicle on rear right roller blind
    case cancelledManuallyInVehicleRearRightRollerBlind

    /// Failed due to manual cancellation inside vehicle on rear right window
    case cancelledManuallyInVehicleRearRightWindow

    /// Failed due to manual cancellation inside vehicle on sunroof
    case cancelledManuallyInVehicleSunroof

    /// Failed due to drive motor overheated
    case driveMotorOverheated

    /// Failed due to drive motor overheated on front left window
    case driveMotorOverheatedFrontLeftWindow

    /// Failed due to drive motor overheated on front right window
    case driveMotorOverheatedFrontRightWindow

    /// Failed due to drive motor overheated on rear left roller blind
    case driveMotorOverheatedRearLeftRollerBlind

    /// Failed due to drive motor overheated on rear left window
    case driveMotorOverheatedRearLeftWindow

    /// Failed due to drive motor overheated on rear right roller blind
    case driveMotorOverheatedRearRightRollerBlind

    /// Failed due to drive motor overheated on rear right window
    case driveMotorOverheatedRearRightWindow

    /// Fastpath timeout
    case fastpathTimeout

    /// Failed due to feature not available on front left window
    case featureNotAvailableFrontLeftWindow

    /// Failed due to feature not available on front right window
    case featureNotAvailableFrontRightWindow

    /// Failed due to feature not available on rear left roller blind
    case featureNotAvailableRearLeftRollerBlind

    /// Failed due to feature not available on rear left window
    case featureNotAvailableRearLeftWindow

    /// Failed due to feature not available on rear right roller blind
    case featureNotAvailableRearRightRollerBlind

    /// Failed due to feature not available on rear right window
    case featureNotAvailableRearRightWindow

    /// Failed due to feature not available on rear roller blind
    case featureNotAvailableRearRollerBlind

    /// Failed due to ignition is on
    case ignitionOn

    /// Failed due to internal system error
    case internalSystemError

    /// Failed due to invalid ignition state
    case invalidIgnitionState

    /// Failed due to invalid ignition state on front left window
    case invalidIgnitionStateFrontLeftWindow

    /// Failed due to invalid ignition state on front right window
    case invalidIgnitionStateFrontRightWindow

    /// Failed due to invalid ignition state on rear left roller blind
    case invalidIgnitionStateRearLeftRollerBlind

    /// Failed due to invalid ignition state on rear left window
    case invalidIgnitionStateRearLeftWindow

    /// Failed due to invalid ignition state on rear right roller blind
    case invalidIgnitionStateRearRightRollerBlind

    /// Failed due to invalid ignition state on rear right window
    case invalidIgnitionStateRearRightWindow

    /// Failed due to invalid number on front left window
    case invalidNumberFrontLeftWindow

    /// Failed due to invalid number on front right window
    case invalidNumberFrontRightWindow

    /// Failed due to invalid number on rear left roller blind
    case invalidNumberRearLeftRollerBlind

    /// Failed due to invalid number on rear left window
    case invalidNumberRearLeftWindow

    /// Failed due to invalid number on rear right roller blind
    case invalidNumberRearRightRollerBlind

    /// Failed due to invalid number on rear right window
    case invalidNumberRearRightWindow

    /// Failed due to invalid position on front left window
    case invalidPositionFrontLeftWindow

    /// Failed due to invalid position on front right window
    case invalidPositionFrontRightWindow

    /// Failed due to invalid position on rear left roller blind
    case invalidPositionRearLeftRollerBlind

    /// Failed due to invalid position on rear left window
    case invalidPositionRearLeftWindow

    /// Failed due to invalid position on rear right roller blind
    case invalidPositionRearRightRollerBlind

    /// Failed due to invalid position on rear right window
    case invalidPositionRearRightWindow

    /// Failed due to invalid position on rear roller blind
    case invalidPositionRearRollerBlind

    /// Failed due to invalid power status
    case invalidPowerStatus

    /// Failed due to invalid power status on front left window
    case invalidPowerStatusFrontLeftWindow

    /// Failed due to invalid power status on front right window
    case invalidPowerStatusFrontRightWindow

    /// Failed due to invalid power status on rear left roller blind
    case invalidPowerStatusRearLeftRollerBlind

    /// Failed due to invalid power status on rear left window
    case invalidPowerStatusRearLeftWindow

    /// Failed due to invalid power status on rear right roller blind
    case invalidPowerStatusRearRightRollerBlind

    /// Failed due to invalid power status on rear right window
    case invalidPowerStatusRearRightWindow

    /// Failed due to low or high voltage on rear roller blind
    case invalidPowerStatusRearRollerBlind

    /// Energy level in Battery is too low
    case lowBatteryLevel

    /// Failed due to low battery level 1
    case lowBatteryLevel1

    /// Failed due to low battery level 2
    case lowBatteryLevel2

    /// Failed due to mechanical problem on rear roller blind
    case mechanicalProblemRearRollerBlind

    /// Failed due to multiple anti-trap protection activations
    case multiAntiTrapProtections

    /// Failed due to multiple anti-trap protection activations on front left window
    case multiAntiTrapProtectionsFrontLeftWindow

    /// Failed due to multiple anti-trap protection activations on front right window
    case multiAntiTrapProtectionsFrontRightWindow

    /// Failed due to multiple anti-trap protection activations on rear left roller blind
    case multiAntiTrapProtectionsRearLeftRollerBlind

    /// Failed due to multiple anti-trap protection activations on rear left window
    case multiAntiTrapProtectionsRearLeftWindow

    /// Failed due to multiple anti-trap protection activations on rear right roller blind
    case multiAntiTrapProtectionsRearRightRollerBlind

    /// Failed due to multiple anti-trap protection activations on rear right window
    case multiAntiTrapProtectionsRearRightWindow

    /// Failed due to open load on rear roller blind
    case openLoadRearRollerBlind

    /// Failed due to remote engine start is active
    case remoteEngineStartIsActive

    /// Failed due to hall sensor signal problem on rear roller blind
    case sensorProblemRearRollerBlind

    /// Service not authorized
    case serviceNotAuthorized

    /// Failed due to system is blocked on rear roller blind
    case systemBlockedRearRollerBlind

    /// Failed due to system could not be normed
    case systemCouldNotBeNormed

    /// Failed due to system could not be normed on front left window
    case systemCouldNotBeNormedFrontLeftWindow

    /// Failed due to system could not be normed on front right window
    case systemCouldNotBeNormedFrontRightWindow

    /// Failed due to system could not be normed on rear left roller blind
    case systemCouldNotBeNormedRearLeftRollerBlind

    /// Failed due to system could not be normed on rear left window
    case systemCouldNotBeNormedRearLeftWindow

    /// Failed due to system could not be normed on rear right roller blind
    case systemCouldNotBeNormedRearRightRollerBlind

    /// Failed due to system could not be normed on rear right window
    case systemCouldNotBeNormedRearRightWindow

    /// Failed due to system malfunction
    case systemMalfunction

    /// Failed due to system malfunction on front left window
    case systemMalfunctionFrontLeftWindow

    /// Failed due to system malfunction on front right window
    case systemMalfunctionFrontRightWindow

    /// Failed due to system malfunction on rear left roller blind
    case systemMalfunctionRearLeftRollerBlind

    /// Failed due to system malfunction on rear left window
    case systemMalfunctionRearLeftWindow

    /// Failed due to system malfunction on rear right roller blind
    case systemMalfunctionRearRightRollerBlind

    /// Failed due to system malfunction on rear right window
    case systemMalfunctionRearRightWindow

    /// Failed due to system malfunction on rear roller blind
    case systemMalfunctionRearRollerBlind

    /// Failed due to system not normed
    case systemNotNormed

    /// Failed due to system not normed  on front left window
    case systemNotNormedFrontLeftWindow

    /// Failed due to system not normed  on front right window
    case systemNotNormedFrontRightWindow

    /// Failed due to system not normed on rear left roller blind
    case systemNotNormedRearLeftRollerBlind

    /// Failed due to system not normed  on rear left window
    case systemNotNormedRearLeftWindow

    /// Failed due to system not normed on rear right roller blind
    case systemNotNormedRearRightRollerBlind

    /// Failed due to system not normed  on rear right window
    case systemNotNormedRearRightWindow

    /// Failed due to temperature too low on rear roller blind
    case temperatureTooLowRearRollerBlind

    /// Failed due to thermal protection active on rear roller blind
    case thermalProtectionActiveRearRollerBlind

    /// Failed due to UI handler not available on front left window
    case unavailableUiHandlerFrontLeftWindow

    /// Failed due to UI handler not available on front right window
    case unavailableUiHandlerFrontRightWindow

    /// Failed due to UI handler not available on rear left roller blind
    case unavailableUiHandlerRearLeftRollerBlind

    /// Failed due to UI handler not available on rear left window
    case unavailableUiHandlerRearLeftWindow

    /// Failed due to UI handler not available on rear right roller blind
    case unavailableUiHandlerRearRightRollerBlind

    /// Failed due to UI handler not available on rear right window
    case unavailableUiHandlerRearRightWindow

    /// Failed due to UI handler not available on rear roller blind
    case unavailableUiHandlerRearRollerBlind

    /// Failed due to unknown error on rear roller blind
    case unknownErrorRearRollerBlind

    /// Failed because vehicle is in motion
    case vehicleInMotion

    /// Remote window/roof command failed
    case windowRoofCommandFailed

    /// Remote window/roof command failed (vehicle state in IGN)
    case windowRoofCommandFailedIgnState

    /// Remote window/roof command failed (service not activated in HERMES)
    case windowRoofCommandServiceNotActive

    /// Remote window/roof command failed (window not normed)
    case windowRoofCommandWindowNotNormed

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> WindowsOpenError {
	    switch code { 
        case "21": return .lowBatteryLevel
        case "42": return .fastpathTimeout
        case "4200": return .serviceNotAuthorized
        case "4201": return .remoteEngineStartIsActive
        case "4202": return .ignitionOn
        case "4203": return .lowBatteryLevel2
        case "4204": return .lowBatteryLevel1
        case "4205": return .antiTrapProtectionActive
        case "4206": return .antiTrapProtectionActiveFrontLeftWindow
        case "4207": return .antiTrapProtectionActiveFrontRightWindow
        case "4208": return .antiTrapProtectionActiveRearLeftWindow
        case "4209": return .antiTrapProtectionActiveRearRightWindow
        case "4210": return .antiTrapProtectionActiveRearLeftRollerBlind
        case "4211": return .antiTrapProtectionActiveRearRightRollerBlind
        case "4215": return .systemBlockedRearRollerBlind
        case "4216": return .multiAntiTrapProtections
        case "4217": return .multiAntiTrapProtectionsFrontLeftWindow
        case "4218": return .multiAntiTrapProtectionsFrontRightWindow
        case "4219": return .multiAntiTrapProtectionsRearLeftWindow
        case "4220": return .multiAntiTrapProtectionsRearRightWindow
        case "4221": return .multiAntiTrapProtectionsRearLeftRollerBlind
        case "4222": return .multiAntiTrapProtectionsRearRightRollerBlind
        case "4226": return .sensorProblemRearRollerBlind
        case "4227": return .cancelledManuallyInVehicle
        case "4228": return .cancelledManuallyInVehicleFrontLeftWindow
        case "4229": return .cancelledManuallyInVehicleFrontRightWindow
        case "4230": return .cancelledManuallyInVehicleRearLeftWindow
        case "4231": return .cancelledManuallyInVehicleRearRightWindow
        case "4232": return .cancelledManuallyInVehicleRearLeftRollerBlind
        case "4233": return .cancelledManuallyInVehicleRearRightRollerBlind
        case "4234": return .cancelledManuallyInVehicleSunroof
        case "4242": return .driveMotorOverheated
        case "4243": return .driveMotorOverheatedFrontLeftWindow
        case "4244": return .driveMotorOverheatedFrontRightWindow
        case "4245": return .driveMotorOverheatedRearLeftWindow
        case "4246": return .driveMotorOverheatedRearRightWindow
        case "4247": return .driveMotorOverheatedRearLeftRollerBlind
        case "4248": return .driveMotorOverheatedRearRightRollerBlind
        case "4253": return .systemNotNormed
        case "4254": return .systemNotNormedFrontLeftWindow
        case "4255": return .systemNotNormedFrontRightWindow
        case "4256": return .systemNotNormedRearLeftWindow
        case "4257": return .systemNotNormedRearRightWindow
        case "4258": return .systemNotNormedRearLeftRollerBlind
        case "4259": return .systemNotNormedRearRightRollerBlind
        case "4263": return .featureNotAvailableRearRollerBlind
        case "4265": return .invalidPowerStatus
        case "4266": return .invalidPowerStatusFrontLeftWindow
        case "4267": return .invalidPowerStatusFrontRightWindow
        case "4268": return .invalidPowerStatusRearLeftWindow
        case "4269": return .invalidPowerStatusRearRightWindow
        case "4270": return .invalidPowerStatusRearLeftRollerBlind
        case "4271": return .invalidPowerStatusRearRightRollerBlind
        case "4275": return .invalidPowerStatusRearRollerBlind
        case "4276": return .afterRunActive
        case "4277": return .afterRunActiveFrontLeftWindow
        case "4278": return .afterRunActiveFrontRightWindow
        case "4279": return .afterRunActiveRearLeftWindow
        case "4280": return .afterRunActiveRearRightWindow
        case "4281": return .afterRunActiveRearLeftRollerBlind
        case "4282": return .afterRunActiveRearRightRollerBlind
        case "4286": return .mechanicalProblemRearRollerBlind
        case "4287": return .invalidIgnitionState
        case "4288": return .invalidIgnitionStateFrontLeftWindow
        case "4289": return .invalidIgnitionStateFrontRightWindow
        case "4290": return .invalidIgnitionStateRearLeftWindow
        case "4291": return .invalidIgnitionStateRearRightWindow
        case "4292": return .invalidIgnitionStateRearLeftRollerBlind
        case "4293": return .invalidIgnitionStateRearRightRollerBlind
        case "4297": return .thermalProtectionActiveRearRollerBlind
        case "4298": return .vehicleInMotion
        case "4302": return .openLoadRearRollerBlind
        case "4303": return .systemCouldNotBeNormed
        case "4304": return .systemCouldNotBeNormedFrontLeftWindow
        case "4305": return .systemCouldNotBeNormedFrontRightWindow
        case "4306": return .systemCouldNotBeNormedRearLeftWindow
        case "4307": return .systemCouldNotBeNormedRearRightWindow
        case "4308": return .systemCouldNotBeNormedRearLeftRollerBlind
        case "4309": return .systemCouldNotBeNormedRearRightRollerBlind
        case "4313": return .temperatureTooLowRearRollerBlind
        case "4314": return .systemMalfunction
        case "4315": return .systemMalfunctionFrontLeftWindow
        case "4316": return .systemMalfunctionFrontRightWindow
        case "4317": return .systemMalfunctionRearLeftWindow
        case "4318": return .systemMalfunctionRearRightWindow
        case "4319": return .systemMalfunctionRearLeftRollerBlind
        case "4320": return .systemMalfunctionRearRightRollerBlind
        case "4324": return .systemMalfunctionRearRollerBlind
        case "4325": return .internalSystemError
        case "4326": return .invalidNumberFrontLeftWindow
        case "4327": return .featureNotAvailableFrontLeftWindow
        case "4328": return .invalidNumberFrontRightWindow
        case "4329": return .featureNotAvailableFrontRightWindow
        case "4330": return .invalidNumberRearLeftWindow
        case "4331": return .featureNotAvailableRearLeftWindow
        case "4332": return .invalidNumberRearRightWindow
        case "4333": return .featureNotAvailableRearRightWindow
        case "4336": return .invalidNumberRearLeftRollerBlind
        case "4337": return .featureNotAvailableRearLeftRollerBlind
        case "4338": return .invalidNumberRearRightRollerBlind
        case "4339": return .featureNotAvailableRearRightRollerBlind
        case "4344": return .unknownErrorRearRollerBlind
        case "4346": return .invalidPositionFrontLeftWindow
        case "4347": return .unavailableUiHandlerFrontLeftWindow
        case "4348": return .invalidPositionFrontRightWindow
        case "4349": return .unavailableUiHandlerFrontRightWindow
        case "4350": return .invalidPositionRearLeftWindow
        case "4351": return .unavailableUiHandlerRearLeftWindow
        case "4352": return .invalidPositionRearRightWindow
        case "4353": return .unavailableUiHandlerRearRightWindow
        case "4354": return .invalidPositionRearLeftRollerBlind
        case "4355": return .unavailableUiHandlerRearLeftRollerBlind
        case "4356": return .invalidPositionRearRightRollerBlind
        case "4357": return .unavailableUiHandlerRearRightRollerBlind
        case "4364": return .invalidPositionRearRollerBlind
        case "4365": return .unavailableUiHandlerRearRollerBlind
        case "6901": return .windowRoofCommandFailed
        case "6902": return .windowRoofCommandFailedIgnState
        case "6903": return .windowRoofCommandWindowNotNormed
        case "6904": return .windowRoofCommandServiceNotActive
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .afterRunActive: return "afterRunActive"
        case .afterRunActiveFrontLeftWindow: return "afterRunActiveFrontLeftWindow"
        case .afterRunActiveFrontRightWindow: return "afterRunActiveFrontRightWindow"
        case .afterRunActiveRearLeftRollerBlind: return "afterRunActiveRearLeftRollerBlind"
        case .afterRunActiveRearLeftWindow: return "afterRunActiveRearLeftWindow"
        case .afterRunActiveRearRightRollerBlind: return "afterRunActiveRearRightRollerBlind"
        case .afterRunActiveRearRightWindow: return "afterRunActiveRearRightWindow"
        case .antiTrapProtectionActive: return "antiTrapProtectionActive"
        case .antiTrapProtectionActiveFrontLeftWindow: return "antiTrapProtectionActiveFrontLeftWindow"
        case .antiTrapProtectionActiveFrontRightWindow: return "antiTrapProtectionActiveFrontRightWindow"
        case .antiTrapProtectionActiveRearLeftRollerBlind: return "antiTrapProtectionActiveRearLeftRollerBlind"
        case .antiTrapProtectionActiveRearLeftWindow: return "antiTrapProtectionActiveRearLeftWindow"
        case .antiTrapProtectionActiveRearRightRollerBlind: return "antiTrapProtectionActiveRearRightRollerBlind"
        case .antiTrapProtectionActiveRearRightWindow: return "antiTrapProtectionActiveRearRightWindow"
        case .cancelledManuallyInVehicle: return "cancelledManuallyInVehicle"
        case .cancelledManuallyInVehicleFrontLeftWindow: return "cancelledManuallyInVehicleFrontLeftWindow"
        case .cancelledManuallyInVehicleFrontRightWindow: return "cancelledManuallyInVehicleFrontRightWindow"
        case .cancelledManuallyInVehicleRearLeftRollerBlind: return "cancelledManuallyInVehicleRearLeftRollerBlind"
        case .cancelledManuallyInVehicleRearLeftWindow: return "cancelledManuallyInVehicleRearLeftWindow"
        case .cancelledManuallyInVehicleRearRightRollerBlind: return "cancelledManuallyInVehicleRearRightRollerBlind"
        case .cancelledManuallyInVehicleRearRightWindow: return "cancelledManuallyInVehicleRearRightWindow"
        case .cancelledManuallyInVehicleSunroof: return "cancelledManuallyInVehicleSunroof"
        case .driveMotorOverheated: return "driveMotorOverheated"
        case .driveMotorOverheatedFrontLeftWindow: return "driveMotorOverheatedFrontLeftWindow"
        case .driveMotorOverheatedFrontRightWindow: return "driveMotorOverheatedFrontRightWindow"
        case .driveMotorOverheatedRearLeftRollerBlind: return "driveMotorOverheatedRearLeftRollerBlind"
        case .driveMotorOverheatedRearLeftWindow: return "driveMotorOverheatedRearLeftWindow"
        case .driveMotorOverheatedRearRightRollerBlind: return "driveMotorOverheatedRearRightRollerBlind"
        case .driveMotorOverheatedRearRightWindow: return "driveMotorOverheatedRearRightWindow"
        case .fastpathTimeout: return "fastpathTimeout"
        case .featureNotAvailableFrontLeftWindow: return "featureNotAvailableFrontLeftWindow"
        case .featureNotAvailableFrontRightWindow: return "featureNotAvailableFrontRightWindow"
        case .featureNotAvailableRearLeftRollerBlind: return "featureNotAvailableRearLeftRollerBlind"
        case .featureNotAvailableRearLeftWindow: return "featureNotAvailableRearLeftWindow"
        case .featureNotAvailableRearRightRollerBlind: return "featureNotAvailableRearRightRollerBlind"
        case .featureNotAvailableRearRightWindow: return "featureNotAvailableRearRightWindow"
        case .featureNotAvailableRearRollerBlind: return "featureNotAvailableRearRollerBlind"
        case .ignitionOn: return "ignitionOn"
        case .internalSystemError: return "internalSystemError"
        case .invalidIgnitionState: return "invalidIgnitionState"
        case .invalidIgnitionStateFrontLeftWindow: return "invalidIgnitionStateFrontLeftWindow"
        case .invalidIgnitionStateFrontRightWindow: return "invalidIgnitionStateFrontRightWindow"
        case .invalidIgnitionStateRearLeftRollerBlind: return "invalidIgnitionStateRearLeftRollerBlind"
        case .invalidIgnitionStateRearLeftWindow: return "invalidIgnitionStateRearLeftWindow"
        case .invalidIgnitionStateRearRightRollerBlind: return "invalidIgnitionStateRearRightRollerBlind"
        case .invalidIgnitionStateRearRightWindow: return "invalidIgnitionStateRearRightWindow"
        case .invalidNumberFrontLeftWindow: return "invalidNumberFrontLeftWindow"
        case .invalidNumberFrontRightWindow: return "invalidNumberFrontRightWindow"
        case .invalidNumberRearLeftRollerBlind: return "invalidNumberRearLeftRollerBlind"
        case .invalidNumberRearLeftWindow: return "invalidNumberRearLeftWindow"
        case .invalidNumberRearRightRollerBlind: return "invalidNumberRearRightRollerBlind"
        case .invalidNumberRearRightWindow: return "invalidNumberRearRightWindow"
        case .invalidPositionFrontLeftWindow: return "invalidPositionFrontLeftWindow"
        case .invalidPositionFrontRightWindow: return "invalidPositionFrontRightWindow"
        case .invalidPositionRearLeftRollerBlind: return "invalidPositionRearLeftRollerBlind"
        case .invalidPositionRearLeftWindow: return "invalidPositionRearLeftWindow"
        case .invalidPositionRearRightRollerBlind: return "invalidPositionRearRightRollerBlind"
        case .invalidPositionRearRightWindow: return "invalidPositionRearRightWindow"
        case .invalidPositionRearRollerBlind: return "invalidPositionRearRollerBlind"
        case .invalidPowerStatus: return "invalidPowerStatus"
        case .invalidPowerStatusFrontLeftWindow: return "invalidPowerStatusFrontLeftWindow"
        case .invalidPowerStatusFrontRightWindow: return "invalidPowerStatusFrontRightWindow"
        case .invalidPowerStatusRearLeftRollerBlind: return "invalidPowerStatusRearLeftRollerBlind"
        case .invalidPowerStatusRearLeftWindow: return "invalidPowerStatusRearLeftWindow"
        case .invalidPowerStatusRearRightRollerBlind: return "invalidPowerStatusRearRightRollerBlind"
        case .invalidPowerStatusRearRightWindow: return "invalidPowerStatusRearRightWindow"
        case .invalidPowerStatusRearRollerBlind: return "invalidPowerStatusRearRollerBlind"
        case .lowBatteryLevel: return "lowBatteryLevel"
        case .lowBatteryLevel1: return "lowBatteryLevel1"
        case .lowBatteryLevel2: return "lowBatteryLevel2"
        case .mechanicalProblemRearRollerBlind: return "mechanicalProblemRearRollerBlind"
        case .multiAntiTrapProtections: return "multiAntiTrapProtections"
        case .multiAntiTrapProtectionsFrontLeftWindow: return "multiAntiTrapProtectionsFrontLeftWindow"
        case .multiAntiTrapProtectionsFrontRightWindow: return "multiAntiTrapProtectionsFrontRightWindow"
        case .multiAntiTrapProtectionsRearLeftRollerBlind: return "multiAntiTrapProtectionsRearLeftRollerBlind"
        case .multiAntiTrapProtectionsRearLeftWindow: return "multiAntiTrapProtectionsRearLeftWindow"
        case .multiAntiTrapProtectionsRearRightRollerBlind: return "multiAntiTrapProtectionsRearRightRollerBlind"
        case .multiAntiTrapProtectionsRearRightWindow: return "multiAntiTrapProtectionsRearRightWindow"
        case .openLoadRearRollerBlind: return "openLoadRearRollerBlind"
        case .remoteEngineStartIsActive: return "remoteEngineStartIsActive"
        case .sensorProblemRearRollerBlind: return "sensorProblemRearRollerBlind"
        case .serviceNotAuthorized: return "serviceNotAuthorized"
        case .systemBlockedRearRollerBlind: return "systemBlockedRearRollerBlind"
        case .systemCouldNotBeNormed: return "systemCouldNotBeNormed"
        case .systemCouldNotBeNormedFrontLeftWindow: return "systemCouldNotBeNormedFrontLeftWindow"
        case .systemCouldNotBeNormedFrontRightWindow: return "systemCouldNotBeNormedFrontRightWindow"
        case .systemCouldNotBeNormedRearLeftRollerBlind: return "systemCouldNotBeNormedRearLeftRollerBlind"
        case .systemCouldNotBeNormedRearLeftWindow: return "systemCouldNotBeNormedRearLeftWindow"
        case .systemCouldNotBeNormedRearRightRollerBlind: return "systemCouldNotBeNormedRearRightRollerBlind"
        case .systemCouldNotBeNormedRearRightWindow: return "systemCouldNotBeNormedRearRightWindow"
        case .systemMalfunction: return "systemMalfunction"
        case .systemMalfunctionFrontLeftWindow: return "systemMalfunctionFrontLeftWindow"
        case .systemMalfunctionFrontRightWindow: return "systemMalfunctionFrontRightWindow"
        case .systemMalfunctionRearLeftRollerBlind: return "systemMalfunctionRearLeftRollerBlind"
        case .systemMalfunctionRearLeftWindow: return "systemMalfunctionRearLeftWindow"
        case .systemMalfunctionRearRightRollerBlind: return "systemMalfunctionRearRightRollerBlind"
        case .systemMalfunctionRearRightWindow: return "systemMalfunctionRearRightWindow"
        case .systemMalfunctionRearRollerBlind: return "systemMalfunctionRearRollerBlind"
        case .systemNotNormed: return "systemNotNormed"
        case .systemNotNormedFrontLeftWindow: return "systemNotNormedFrontLeftWindow"
        case .systemNotNormedFrontRightWindow: return "systemNotNormedFrontRightWindow"
        case .systemNotNormedRearLeftRollerBlind: return "systemNotNormedRearLeftRollerBlind"
        case .systemNotNormedRearLeftWindow: return "systemNotNormedRearLeftWindow"
        case .systemNotNormedRearRightRollerBlind: return "systemNotNormedRearRightRollerBlind"
        case .systemNotNormedRearRightWindow: return "systemNotNormedRearRightWindow"
        case .temperatureTooLowRearRollerBlind: return "temperatureTooLowRearRollerBlind"
        case .thermalProtectionActiveRearRollerBlind: return "thermalProtectionActiveRearRollerBlind"
        case .unavailableUiHandlerFrontLeftWindow: return "unavailableUiHandlerFrontLeftWindow"
        case .unavailableUiHandlerFrontRightWindow: return "unavailableUiHandlerFrontRightWindow"
        case .unavailableUiHandlerRearLeftRollerBlind: return "unavailableUiHandlerRearLeftRollerBlind"
        case .unavailableUiHandlerRearLeftWindow: return "unavailableUiHandlerRearLeftWindow"
        case .unavailableUiHandlerRearRightRollerBlind: return "unavailableUiHandlerRearRightRollerBlind"
        case .unavailableUiHandlerRearRightWindow: return "unavailableUiHandlerRearRightWindow"
        case .unavailableUiHandlerRearRollerBlind: return "unavailableUiHandlerRearRollerBlind"
        case .unknownErrorRearRollerBlind: return "unknownErrorRearRollerBlind"
        case .vehicleInMotion: return "vehicleInMotion"
        case .windowRoofCommandFailed: return "windowRoofCommandFailed"
        case .windowRoofCommandFailedIgnState: return "windowRoofCommandFailedIgnState"
        case .windowRoofCommandServiceNotActive: return "windowRoofCommandServiceNotActive"
        case .windowRoofCommandWindowNotNormed: return "windowRoofCommandWindowNotNormed"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.WindowsOpen: BaseCommandProtocol {

	public typealias Error = WindowsOpenError

	public func createGenericError(error: GenericCommandError) -> WindowsOpenError {
		return WindowsOpenError.genericError(error: error)
	}
}

extension Command.WindowsOpen: CommandPinProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String, pin: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self, pin: pin)
	}
}


/// All possible error codes for the WindowsVentilate command version v1
public enum WindowsVentilateError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Failed due to afterrun active
    case afterRunActive

    /// Failed due to afterrun active on front left window
    case afterRunActiveFrontLeftWindow

    /// Failed due to afterrun active on front right window
    case afterRunActiveFrontRightWindow

    /// Failed due to afterrun active on rear left roller blind
    case afterRunActiveRearLeftRollerBlind

    /// Failed due to afterrun active on rear left window
    case afterRunActiveRearLeftWindow

    /// Failed due to afterrun active on rear right roller blind
    case afterRunActiveRearRightRollerBlind

    /// Failed due to afterrun active on rear right window
    case afterRunActiveRearRightWindow

    /// Failed due to anti-trap protection active
    case antiTrapProtectionActive

    /// Failed due to anti-trap protection active on front left window
    case antiTrapProtectionActiveFrontLeftWindow

    /// Failed due to anti-trap protection active on front right window
    case antiTrapProtectionActiveFrontRightWindow

    /// Failed due to anti-trap protection active on rear left roller blind
    case antiTrapProtectionActiveRearLeftRollerBlind

    /// Failed due to anti-trap protection active on rear left window
    case antiTrapProtectionActiveRearLeftWindow

    /// Failed due to anti-trap protection active on rear right roller blind
    case antiTrapProtectionActiveRearRightRollerBlind

    /// Failed due to anti-trap protection active on rear right window
    case antiTrapProtectionActiveRearRightWindow

    /// Failed due to manual cancellation inside vehicle
    case cancelledManuallyInVehicle

    /// Failed due to manual cancellation inside vehicle on front left window
    case cancelledManuallyInVehicleFrontLeftWindow

    /// Failed due to manual cancellation inside vehicle on front right window
    case cancelledManuallyInVehicleFrontRightWindow

    /// Failed due to manual cancellation inside vehicle on rear left roller blind
    case cancelledManuallyInVehicleRearLeftRollerBlind

    /// Failed due to manual cancellation inside vehicle on rear left window
    case cancelledManuallyInVehicleRearLeftWindow

    /// Failed due to manual cancellation inside vehicle on rear right roller blind
    case cancelledManuallyInVehicleRearRightRollerBlind

    /// Failed due to manual cancellation inside vehicle on rear right window
    case cancelledManuallyInVehicleRearRightWindow

    /// Failed due to manual cancellation inside vehicle on sunroof
    case cancelledManuallyInVehicleSunroof

    /// Failed due to drive motor overheated
    case driveMotorOverheated

    /// Failed due to drive motor overheated on front left window
    case driveMotorOverheatedFrontLeftWindow

    /// Failed due to drive motor overheated on front right window
    case driveMotorOverheatedFrontRightWindow

    /// Failed due to drive motor overheated on rear left roller blind
    case driveMotorOverheatedRearLeftRollerBlind

    /// Failed due to drive motor overheated on rear left window
    case driveMotorOverheatedRearLeftWindow

    /// Failed due to drive motor overheated on rear right roller blind
    case driveMotorOverheatedRearRightRollerBlind

    /// Failed due to drive motor overheated on rear right window
    case driveMotorOverheatedRearRightWindow

    /// Fastpath timeout
    case fastpathTimeout

    /// Failed due to feature not available on front left window
    case featureNotAvailableFrontLeftWindow

    /// Failed due to feature not available on front right window
    case featureNotAvailableFrontRightWindow

    /// Failed due to feature not available on rear left roller blind
    case featureNotAvailableRearLeftRollerBlind

    /// Failed due to feature not available on rear left window
    case featureNotAvailableRearLeftWindow

    /// Failed due to feature not available on rear right roller blind
    case featureNotAvailableRearRightRollerBlind

    /// Failed due to feature not available on rear right window
    case featureNotAvailableRearRightWindow

    /// Failed due to feature not available on rear roller blind
    case featureNotAvailableRearRollerBlind

    /// Failed due to ignition is on
    case ignitionOn

    /// Failed due to internal system error
    case internalSystemError

    /// Failed due to invalid ignition state
    case invalidIgnitionState

    /// Failed due to invalid ignition state on front left window
    case invalidIgnitionStateFrontLeftWindow

    /// Failed due to invalid ignition state on front right window
    case invalidIgnitionStateFrontRightWindow

    /// Failed due to invalid ignition state on rear left roller blind
    case invalidIgnitionStateRearLeftRollerBlind

    /// Failed due to invalid ignition state on rear left window
    case invalidIgnitionStateRearLeftWindow

    /// Failed due to invalid ignition state on rear right roller blind
    case invalidIgnitionStateRearRightRollerBlind

    /// Failed due to invalid ignition state on rear right window
    case invalidIgnitionStateRearRightWindow

    /// Failed due to invalid number on front left window
    case invalidNumberFrontLeftWindow

    /// Failed due to invalid number on front right window
    case invalidNumberFrontRightWindow

    /// Failed due to invalid number on rear left roller blind
    case invalidNumberRearLeftRollerBlind

    /// Failed due to invalid number on rear left window
    case invalidNumberRearLeftWindow

    /// Failed due to invalid number on rear right roller blind
    case invalidNumberRearRightRollerBlind

    /// Failed due to invalid number on rear right window
    case invalidNumberRearRightWindow

    /// Failed due to invalid position on front left window
    case invalidPositionFrontLeftWindow

    /// Failed due to invalid position on front right window
    case invalidPositionFrontRightWindow

    /// Failed due to invalid position on rear left roller blind
    case invalidPositionRearLeftRollerBlind

    /// Failed due to invalid position on rear left window
    case invalidPositionRearLeftWindow

    /// Failed due to invalid position on rear right roller blind
    case invalidPositionRearRightRollerBlind

    /// Failed due to invalid position on rear right window
    case invalidPositionRearRightWindow

    /// Failed due to invalid position on rear roller blind
    case invalidPositionRearRollerBlind

    /// Failed due to invalid power status
    case invalidPowerStatus

    /// Failed due to invalid power status on front left window
    case invalidPowerStatusFrontLeftWindow

    /// Failed due to invalid power status on front right window
    case invalidPowerStatusFrontRightWindow

    /// Failed due to invalid power status on rear left roller blind
    case invalidPowerStatusRearLeftRollerBlind

    /// Failed due to invalid power status on rear left window
    case invalidPowerStatusRearLeftWindow

    /// Failed due to invalid power status on rear right roller blind
    case invalidPowerStatusRearRightRollerBlind

    /// Failed due to invalid power status on rear right window
    case invalidPowerStatusRearRightWindow

    /// Failed due to low or high voltage on rear roller blind
    case invalidPowerStatusRearRollerBlind

    /// Energy level in Battery is too low
    case lowBatteryLevel

    /// Failed due to low battery level 1
    case lowBatteryLevel1

    /// Failed due to low battery level 2
    case lowBatteryLevel2

    /// Failed due to mechanical problem on rear roller blind
    case mechanicalProblemRearRollerBlind

    /// Failed due to multiple anti-trap protection activations
    case multiAntiTrapProtections

    /// Failed due to multiple anti-trap protection activations on front left window
    case multiAntiTrapProtectionsFrontLeftWindow

    /// Failed due to multiple anti-trap protection activations on front right window
    case multiAntiTrapProtectionsFrontRightWindow

    /// Failed due to multiple anti-trap protection activations on rear left roller blind
    case multiAntiTrapProtectionsRearLeftRollerBlind

    /// Failed due to multiple anti-trap protection activations on rear left window
    case multiAntiTrapProtectionsRearLeftWindow

    /// Failed due to multiple anti-trap protection activations on rear right roller blind
    case multiAntiTrapProtectionsRearRightRollerBlind

    /// Failed due to multiple anti-trap protection activations on rear right window
    case multiAntiTrapProtectionsRearRightWindow

    /// Failed due to open load on rear roller blind
    case openLoadRearRollerBlind

    /// Failed due to remote engine start is active
    case remoteEngineStartIsActive

    /// Failed due to hall sensor signal problem on rear roller blind
    case sensorProblemRearRollerBlind

    /// Service not authorized
    case serviceNotAuthorized

    /// Failed due to system is blocked on rear roller blind
    case systemBlockedRearRollerBlind

    /// Failed due to system could not be normed
    case systemCouldNotBeNormed

    /// Failed due to system could not be normed on front left window
    case systemCouldNotBeNormedFrontLeftWindow

    /// Failed due to system could not be normed on front right window
    case systemCouldNotBeNormedFrontRightWindow

    /// Failed due to system could not be normed on rear left roller blind
    case systemCouldNotBeNormedRearLeftRollerBlind

    /// Failed due to system could not be normed on rear left window
    case systemCouldNotBeNormedRearLeftWindow

    /// Failed due to system could not be normed on rear right roller blind
    case systemCouldNotBeNormedRearRightRollerBlind

    /// Failed due to system could not be normed on rear right window
    case systemCouldNotBeNormedRearRightWindow

    /// Failed due to system malfunction
    case systemMalfunction

    /// Failed due to system malfunction on front left window
    case systemMalfunctionFrontLeftWindow

    /// Failed due to system malfunction on front right window
    case systemMalfunctionFrontRightWindow

    /// Failed due to system malfunction on rear left roller blind
    case systemMalfunctionRearLeftRollerBlind

    /// Failed due to system malfunction on rear left window
    case systemMalfunctionRearLeftWindow

    /// Failed due to system malfunction on rear right roller blind
    case systemMalfunctionRearRightRollerBlind

    /// Failed due to system malfunction on rear right window
    case systemMalfunctionRearRightWindow

    /// Failed due to system malfunction on rear roller blind
    case systemMalfunctionRearRollerBlind

    /// Failed due to system not normed
    case systemNotNormed

    /// Failed due to system not normed  on front left window
    case systemNotNormedFrontLeftWindow

    /// Failed due to system not normed  on front right window
    case systemNotNormedFrontRightWindow

    /// Failed due to system not normed on rear left roller blind
    case systemNotNormedRearLeftRollerBlind

    /// Failed due to system not normed  on rear left window
    case systemNotNormedRearLeftWindow

    /// Failed due to system not normed on rear right roller blind
    case systemNotNormedRearRightRollerBlind

    /// Failed due to system not normed  on rear right window
    case systemNotNormedRearRightWindow

    /// Failed due to temperature too low on rear roller blind
    case temperatureTooLowRearRollerBlind

    /// Failed due to thermal protection active on rear roller blind
    case thermalProtectionActiveRearRollerBlind

    /// Failed due to UI handler not available on front left window
    case unavailableUiHandlerFrontLeftWindow

    /// Failed due to UI handler not available on front right window
    case unavailableUiHandlerFrontRightWindow

    /// Failed due to UI handler not available on rear left roller blind
    case unavailableUiHandlerRearLeftRollerBlind

    /// Failed due to UI handler not available on rear left window
    case unavailableUiHandlerRearLeftWindow

    /// Failed due to UI handler not available on rear right roller blind
    case unavailableUiHandlerRearRightRollerBlind

    /// Failed due to UI handler not available on rear right window
    case unavailableUiHandlerRearRightWindow

    /// Failed due to UI handler not available on rear roller blind
    case unavailableUiHandlerRearRollerBlind

    /// Failed due to unknown error on rear roller blind
    case unknownErrorRearRollerBlind

    /// Failed because vehicle is in motion
    case vehicleInMotion

    /// Remote window/roof command failed
    case windowRoofCommandFailed

    /// Remote window/roof command failed (vehicle state in IGN)
    case windowRoofCommandFailedIgnState

    /// Remote window/roof command failed (service not activated in HERMES)
    case windowRoofCommandServiceNotActive

    /// Remote window/roof command failed (window not normed)
    case windowRoofCommandWindowNotNormed

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> WindowsVentilateError {
	    switch code { 
        case "21": return .lowBatteryLevel
        case "42": return .fastpathTimeout
        case "4200": return .serviceNotAuthorized
        case "4201": return .remoteEngineStartIsActive
        case "4202": return .ignitionOn
        case "4203": return .lowBatteryLevel2
        case "4204": return .lowBatteryLevel1
        case "4205": return .antiTrapProtectionActive
        case "4206": return .antiTrapProtectionActiveFrontLeftWindow
        case "4207": return .antiTrapProtectionActiveFrontRightWindow
        case "4208": return .antiTrapProtectionActiveRearLeftWindow
        case "4209": return .antiTrapProtectionActiveRearRightWindow
        case "4210": return .antiTrapProtectionActiveRearLeftRollerBlind
        case "4211": return .antiTrapProtectionActiveRearRightRollerBlind
        case "4215": return .systemBlockedRearRollerBlind
        case "4216": return .multiAntiTrapProtections
        case "4217": return .multiAntiTrapProtectionsFrontLeftWindow
        case "4218": return .multiAntiTrapProtectionsFrontRightWindow
        case "4219": return .multiAntiTrapProtectionsRearLeftWindow
        case "4220": return .multiAntiTrapProtectionsRearRightWindow
        case "4221": return .multiAntiTrapProtectionsRearLeftRollerBlind
        case "4222": return .multiAntiTrapProtectionsRearRightRollerBlind
        case "4226": return .sensorProblemRearRollerBlind
        case "4227": return .cancelledManuallyInVehicle
        case "4228": return .cancelledManuallyInVehicleFrontLeftWindow
        case "4229": return .cancelledManuallyInVehicleFrontRightWindow
        case "4230": return .cancelledManuallyInVehicleRearLeftWindow
        case "4231": return .cancelledManuallyInVehicleRearRightWindow
        case "4232": return .cancelledManuallyInVehicleRearLeftRollerBlind
        case "4233": return .cancelledManuallyInVehicleRearRightRollerBlind
        case "4234": return .cancelledManuallyInVehicleSunroof
        case "4242": return .driveMotorOverheated
        case "4243": return .driveMotorOverheatedFrontLeftWindow
        case "4244": return .driveMotorOverheatedFrontRightWindow
        case "4245": return .driveMotorOverheatedRearLeftWindow
        case "4246": return .driveMotorOverheatedRearRightWindow
        case "4247": return .driveMotorOverheatedRearLeftRollerBlind
        case "4248": return .driveMotorOverheatedRearRightRollerBlind
        case "4253": return .systemNotNormed
        case "4254": return .systemNotNormedFrontLeftWindow
        case "4255": return .systemNotNormedFrontRightWindow
        case "4256": return .systemNotNormedRearLeftWindow
        case "4257": return .systemNotNormedRearRightWindow
        case "4258": return .systemNotNormedRearLeftRollerBlind
        case "4259": return .systemNotNormedRearRightRollerBlind
        case "4263": return .featureNotAvailableRearRollerBlind
        case "4265": return .invalidPowerStatus
        case "4266": return .invalidPowerStatusFrontLeftWindow
        case "4267": return .invalidPowerStatusFrontRightWindow
        case "4268": return .invalidPowerStatusRearLeftWindow
        case "4269": return .invalidPowerStatusRearRightWindow
        case "4270": return .invalidPowerStatusRearLeftRollerBlind
        case "4271": return .invalidPowerStatusRearRightRollerBlind
        case "4275": return .invalidPowerStatusRearRollerBlind
        case "4276": return .afterRunActive
        case "4277": return .afterRunActiveFrontLeftWindow
        case "4278": return .afterRunActiveFrontRightWindow
        case "4279": return .afterRunActiveRearLeftWindow
        case "4280": return .afterRunActiveRearRightWindow
        case "4281": return .afterRunActiveRearLeftRollerBlind
        case "4282": return .afterRunActiveRearRightRollerBlind
        case "4286": return .mechanicalProblemRearRollerBlind
        case "4287": return .invalidIgnitionState
        case "4288": return .invalidIgnitionStateFrontLeftWindow
        case "4289": return .invalidIgnitionStateFrontRightWindow
        case "4290": return .invalidIgnitionStateRearLeftWindow
        case "4291": return .invalidIgnitionStateRearRightWindow
        case "4292": return .invalidIgnitionStateRearLeftRollerBlind
        case "4293": return .invalidIgnitionStateRearRightRollerBlind
        case "4297": return .thermalProtectionActiveRearRollerBlind
        case "4298": return .vehicleInMotion
        case "4302": return .openLoadRearRollerBlind
        case "4303": return .systemCouldNotBeNormed
        case "4304": return .systemCouldNotBeNormedFrontLeftWindow
        case "4305": return .systemCouldNotBeNormedFrontRightWindow
        case "4306": return .systemCouldNotBeNormedRearLeftWindow
        case "4307": return .systemCouldNotBeNormedRearRightWindow
        case "4308": return .systemCouldNotBeNormedRearLeftRollerBlind
        case "4309": return .systemCouldNotBeNormedRearRightRollerBlind
        case "4313": return .temperatureTooLowRearRollerBlind
        case "4314": return .systemMalfunction
        case "4315": return .systemMalfunctionFrontLeftWindow
        case "4316": return .systemMalfunctionFrontRightWindow
        case "4317": return .systemMalfunctionRearLeftWindow
        case "4318": return .systemMalfunctionRearRightWindow
        case "4319": return .systemMalfunctionRearLeftRollerBlind
        case "4320": return .systemMalfunctionRearRightRollerBlind
        case "4324": return .systemMalfunctionRearRollerBlind
        case "4325": return .internalSystemError
        case "4326": return .invalidNumberFrontLeftWindow
        case "4327": return .featureNotAvailableFrontLeftWindow
        case "4328": return .invalidNumberFrontRightWindow
        case "4329": return .featureNotAvailableFrontRightWindow
        case "4330": return .invalidNumberRearLeftWindow
        case "4331": return .featureNotAvailableRearLeftWindow
        case "4332": return .invalidNumberRearRightWindow
        case "4333": return .featureNotAvailableRearRightWindow
        case "4336": return .invalidNumberRearLeftRollerBlind
        case "4337": return .featureNotAvailableRearLeftRollerBlind
        case "4338": return .invalidNumberRearRightRollerBlind
        case "4339": return .featureNotAvailableRearRightRollerBlind
        case "4344": return .unknownErrorRearRollerBlind
        case "4346": return .invalidPositionFrontLeftWindow
        case "4347": return .unavailableUiHandlerFrontLeftWindow
        case "4348": return .invalidPositionFrontRightWindow
        case "4349": return .unavailableUiHandlerFrontRightWindow
        case "4350": return .invalidPositionRearLeftWindow
        case "4351": return .unavailableUiHandlerRearLeftWindow
        case "4352": return .invalidPositionRearRightWindow
        case "4353": return .unavailableUiHandlerRearRightWindow
        case "4354": return .invalidPositionRearLeftRollerBlind
        case "4355": return .unavailableUiHandlerRearLeftRollerBlind
        case "4356": return .invalidPositionRearRightRollerBlind
        case "4357": return .unavailableUiHandlerRearRightRollerBlind
        case "4364": return .invalidPositionRearRollerBlind
        case "4365": return .unavailableUiHandlerRearRollerBlind
        case "6901": return .windowRoofCommandFailed
        case "6902": return .windowRoofCommandFailedIgnState
        case "6903": return .windowRoofCommandWindowNotNormed
        case "6904": return .windowRoofCommandServiceNotActive
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .afterRunActive: return "afterRunActive"
        case .afterRunActiveFrontLeftWindow: return "afterRunActiveFrontLeftWindow"
        case .afterRunActiveFrontRightWindow: return "afterRunActiveFrontRightWindow"
        case .afterRunActiveRearLeftRollerBlind: return "afterRunActiveRearLeftRollerBlind"
        case .afterRunActiveRearLeftWindow: return "afterRunActiveRearLeftWindow"
        case .afterRunActiveRearRightRollerBlind: return "afterRunActiveRearRightRollerBlind"
        case .afterRunActiveRearRightWindow: return "afterRunActiveRearRightWindow"
        case .antiTrapProtectionActive: return "antiTrapProtectionActive"
        case .antiTrapProtectionActiveFrontLeftWindow: return "antiTrapProtectionActiveFrontLeftWindow"
        case .antiTrapProtectionActiveFrontRightWindow: return "antiTrapProtectionActiveFrontRightWindow"
        case .antiTrapProtectionActiveRearLeftRollerBlind: return "antiTrapProtectionActiveRearLeftRollerBlind"
        case .antiTrapProtectionActiveRearLeftWindow: return "antiTrapProtectionActiveRearLeftWindow"
        case .antiTrapProtectionActiveRearRightRollerBlind: return "antiTrapProtectionActiveRearRightRollerBlind"
        case .antiTrapProtectionActiveRearRightWindow: return "antiTrapProtectionActiveRearRightWindow"
        case .cancelledManuallyInVehicle: return "cancelledManuallyInVehicle"
        case .cancelledManuallyInVehicleFrontLeftWindow: return "cancelledManuallyInVehicleFrontLeftWindow"
        case .cancelledManuallyInVehicleFrontRightWindow: return "cancelledManuallyInVehicleFrontRightWindow"
        case .cancelledManuallyInVehicleRearLeftRollerBlind: return "cancelledManuallyInVehicleRearLeftRollerBlind"
        case .cancelledManuallyInVehicleRearLeftWindow: return "cancelledManuallyInVehicleRearLeftWindow"
        case .cancelledManuallyInVehicleRearRightRollerBlind: return "cancelledManuallyInVehicleRearRightRollerBlind"
        case .cancelledManuallyInVehicleRearRightWindow: return "cancelledManuallyInVehicleRearRightWindow"
        case .cancelledManuallyInVehicleSunroof: return "cancelledManuallyInVehicleSunroof"
        case .driveMotorOverheated: return "driveMotorOverheated"
        case .driveMotorOverheatedFrontLeftWindow: return "driveMotorOverheatedFrontLeftWindow"
        case .driveMotorOverheatedFrontRightWindow: return "driveMotorOverheatedFrontRightWindow"
        case .driveMotorOverheatedRearLeftRollerBlind: return "driveMotorOverheatedRearLeftRollerBlind"
        case .driveMotorOverheatedRearLeftWindow: return "driveMotorOverheatedRearLeftWindow"
        case .driveMotorOverheatedRearRightRollerBlind: return "driveMotorOverheatedRearRightRollerBlind"
        case .driveMotorOverheatedRearRightWindow: return "driveMotorOverheatedRearRightWindow"
        case .fastpathTimeout: return "fastpathTimeout"
        case .featureNotAvailableFrontLeftWindow: return "featureNotAvailableFrontLeftWindow"
        case .featureNotAvailableFrontRightWindow: return "featureNotAvailableFrontRightWindow"
        case .featureNotAvailableRearLeftRollerBlind: return "featureNotAvailableRearLeftRollerBlind"
        case .featureNotAvailableRearLeftWindow: return "featureNotAvailableRearLeftWindow"
        case .featureNotAvailableRearRightRollerBlind: return "featureNotAvailableRearRightRollerBlind"
        case .featureNotAvailableRearRightWindow: return "featureNotAvailableRearRightWindow"
        case .featureNotAvailableRearRollerBlind: return "featureNotAvailableRearRollerBlind"
        case .ignitionOn: return "ignitionOn"
        case .internalSystemError: return "internalSystemError"
        case .invalidIgnitionState: return "invalidIgnitionState"
        case .invalidIgnitionStateFrontLeftWindow: return "invalidIgnitionStateFrontLeftWindow"
        case .invalidIgnitionStateFrontRightWindow: return "invalidIgnitionStateFrontRightWindow"
        case .invalidIgnitionStateRearLeftRollerBlind: return "invalidIgnitionStateRearLeftRollerBlind"
        case .invalidIgnitionStateRearLeftWindow: return "invalidIgnitionStateRearLeftWindow"
        case .invalidIgnitionStateRearRightRollerBlind: return "invalidIgnitionStateRearRightRollerBlind"
        case .invalidIgnitionStateRearRightWindow: return "invalidIgnitionStateRearRightWindow"
        case .invalidNumberFrontLeftWindow: return "invalidNumberFrontLeftWindow"
        case .invalidNumberFrontRightWindow: return "invalidNumberFrontRightWindow"
        case .invalidNumberRearLeftRollerBlind: return "invalidNumberRearLeftRollerBlind"
        case .invalidNumberRearLeftWindow: return "invalidNumberRearLeftWindow"
        case .invalidNumberRearRightRollerBlind: return "invalidNumberRearRightRollerBlind"
        case .invalidNumberRearRightWindow: return "invalidNumberRearRightWindow"
        case .invalidPositionFrontLeftWindow: return "invalidPositionFrontLeftWindow"
        case .invalidPositionFrontRightWindow: return "invalidPositionFrontRightWindow"
        case .invalidPositionRearLeftRollerBlind: return "invalidPositionRearLeftRollerBlind"
        case .invalidPositionRearLeftWindow: return "invalidPositionRearLeftWindow"
        case .invalidPositionRearRightRollerBlind: return "invalidPositionRearRightRollerBlind"
        case .invalidPositionRearRightWindow: return "invalidPositionRearRightWindow"
        case .invalidPositionRearRollerBlind: return "invalidPositionRearRollerBlind"
        case .invalidPowerStatus: return "invalidPowerStatus"
        case .invalidPowerStatusFrontLeftWindow: return "invalidPowerStatusFrontLeftWindow"
        case .invalidPowerStatusFrontRightWindow: return "invalidPowerStatusFrontRightWindow"
        case .invalidPowerStatusRearLeftRollerBlind: return "invalidPowerStatusRearLeftRollerBlind"
        case .invalidPowerStatusRearLeftWindow: return "invalidPowerStatusRearLeftWindow"
        case .invalidPowerStatusRearRightRollerBlind: return "invalidPowerStatusRearRightRollerBlind"
        case .invalidPowerStatusRearRightWindow: return "invalidPowerStatusRearRightWindow"
        case .invalidPowerStatusRearRollerBlind: return "invalidPowerStatusRearRollerBlind"
        case .lowBatteryLevel: return "lowBatteryLevel"
        case .lowBatteryLevel1: return "lowBatteryLevel1"
        case .lowBatteryLevel2: return "lowBatteryLevel2"
        case .mechanicalProblemRearRollerBlind: return "mechanicalProblemRearRollerBlind"
        case .multiAntiTrapProtections: return "multiAntiTrapProtections"
        case .multiAntiTrapProtectionsFrontLeftWindow: return "multiAntiTrapProtectionsFrontLeftWindow"
        case .multiAntiTrapProtectionsFrontRightWindow: return "multiAntiTrapProtectionsFrontRightWindow"
        case .multiAntiTrapProtectionsRearLeftRollerBlind: return "multiAntiTrapProtectionsRearLeftRollerBlind"
        case .multiAntiTrapProtectionsRearLeftWindow: return "multiAntiTrapProtectionsRearLeftWindow"
        case .multiAntiTrapProtectionsRearRightRollerBlind: return "multiAntiTrapProtectionsRearRightRollerBlind"
        case .multiAntiTrapProtectionsRearRightWindow: return "multiAntiTrapProtectionsRearRightWindow"
        case .openLoadRearRollerBlind: return "openLoadRearRollerBlind"
        case .remoteEngineStartIsActive: return "remoteEngineStartIsActive"
        case .sensorProblemRearRollerBlind: return "sensorProblemRearRollerBlind"
        case .serviceNotAuthorized: return "serviceNotAuthorized"
        case .systemBlockedRearRollerBlind: return "systemBlockedRearRollerBlind"
        case .systemCouldNotBeNormed: return "systemCouldNotBeNormed"
        case .systemCouldNotBeNormedFrontLeftWindow: return "systemCouldNotBeNormedFrontLeftWindow"
        case .systemCouldNotBeNormedFrontRightWindow: return "systemCouldNotBeNormedFrontRightWindow"
        case .systemCouldNotBeNormedRearLeftRollerBlind: return "systemCouldNotBeNormedRearLeftRollerBlind"
        case .systemCouldNotBeNormedRearLeftWindow: return "systemCouldNotBeNormedRearLeftWindow"
        case .systemCouldNotBeNormedRearRightRollerBlind: return "systemCouldNotBeNormedRearRightRollerBlind"
        case .systemCouldNotBeNormedRearRightWindow: return "systemCouldNotBeNormedRearRightWindow"
        case .systemMalfunction: return "systemMalfunction"
        case .systemMalfunctionFrontLeftWindow: return "systemMalfunctionFrontLeftWindow"
        case .systemMalfunctionFrontRightWindow: return "systemMalfunctionFrontRightWindow"
        case .systemMalfunctionRearLeftRollerBlind: return "systemMalfunctionRearLeftRollerBlind"
        case .systemMalfunctionRearLeftWindow: return "systemMalfunctionRearLeftWindow"
        case .systemMalfunctionRearRightRollerBlind: return "systemMalfunctionRearRightRollerBlind"
        case .systemMalfunctionRearRightWindow: return "systemMalfunctionRearRightWindow"
        case .systemMalfunctionRearRollerBlind: return "systemMalfunctionRearRollerBlind"
        case .systemNotNormed: return "systemNotNormed"
        case .systemNotNormedFrontLeftWindow: return "systemNotNormedFrontLeftWindow"
        case .systemNotNormedFrontRightWindow: return "systemNotNormedFrontRightWindow"
        case .systemNotNormedRearLeftRollerBlind: return "systemNotNormedRearLeftRollerBlind"
        case .systemNotNormedRearLeftWindow: return "systemNotNormedRearLeftWindow"
        case .systemNotNormedRearRightRollerBlind: return "systemNotNormedRearRightRollerBlind"
        case .systemNotNormedRearRightWindow: return "systemNotNormedRearRightWindow"
        case .temperatureTooLowRearRollerBlind: return "temperatureTooLowRearRollerBlind"
        case .thermalProtectionActiveRearRollerBlind: return "thermalProtectionActiveRearRollerBlind"
        case .unavailableUiHandlerFrontLeftWindow: return "unavailableUiHandlerFrontLeftWindow"
        case .unavailableUiHandlerFrontRightWindow: return "unavailableUiHandlerFrontRightWindow"
        case .unavailableUiHandlerRearLeftRollerBlind: return "unavailableUiHandlerRearLeftRollerBlind"
        case .unavailableUiHandlerRearLeftWindow: return "unavailableUiHandlerRearLeftWindow"
        case .unavailableUiHandlerRearRightRollerBlind: return "unavailableUiHandlerRearRightRollerBlind"
        case .unavailableUiHandlerRearRightWindow: return "unavailableUiHandlerRearRightWindow"
        case .unavailableUiHandlerRearRollerBlind: return "unavailableUiHandlerRearRollerBlind"
        case .unknownErrorRearRollerBlind: return "unknownErrorRearRollerBlind"
        case .vehicleInMotion: return "vehicleInMotion"
        case .windowRoofCommandFailed: return "windowRoofCommandFailed"
        case .windowRoofCommandFailedIgnState: return "windowRoofCommandFailedIgnState"
        case .windowRoofCommandServiceNotActive: return "windowRoofCommandServiceNotActive"
        case .windowRoofCommandWindowNotNormed: return "windowRoofCommandWindowNotNormed"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.WindowsVentilate: BaseCommandProtocol {

	public typealias Error = WindowsVentilateError

	public func createGenericError(error: GenericCommandError) -> WindowsVentilateError {
		return WindowsVentilateError.genericError(error: error)
	}
}

extension Command.WindowsVentilate: CommandPinProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String, pin: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self, pin: pin)
	}
}


/// All possible error codes for the ZevPreconditioningConfigure command version v1
public enum ZevPreconditioningConfigureError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> ZevPreconditioningConfigureError {
	    switch code { 
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.ZevPreconditioningConfigure: BaseCommandProtocol {

	public typealias Error = ZevPreconditioningConfigureError

	public func createGenericError(error: GenericCommandError) -> ZevPreconditioningConfigureError {
		return ZevPreconditioningConfigureError.genericError(error: error)
	}
}

extension Command.ZevPreconditioningConfigure: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the ZevPreconditioningConfigureSeats command version v1
public enum ZevPreconditioningConfigureSeatsError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> ZevPreconditioningConfigureSeatsError {
	    switch code { 
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.ZevPreconditioningConfigureSeats: BaseCommandProtocol {

	public typealias Error = ZevPreconditioningConfigureSeatsError

	public func createGenericError(error: GenericCommandError) -> ZevPreconditioningConfigureSeatsError {
		return ZevPreconditioningConfigureSeatsError.genericError(error: error)
	}
}

extension Command.ZevPreconditioningConfigureSeats: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the ZevPreconditioningStop command version v1
public enum ZevPreconditioningStopError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> ZevPreconditioningStopError {
	    switch code { 
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.ZevPreconditioningStop: BaseCommandProtocol {

	public typealias Error = ZevPreconditioningStopError

	public func createGenericError(error: GenericCommandError) -> ZevPreconditioningStopError {
		return ZevPreconditioningStopError.genericError(error: error)
	}
}

extension Command.ZevPreconditioningStop: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


// swiftlint:enable all
