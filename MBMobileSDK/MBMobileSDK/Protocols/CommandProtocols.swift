//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import SwiftProtobuf

// MARK: - CommandProtocol

public protocol CommandErrorProtocol {
	static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> Self
	func unwrapGenericError() -> GenericCommandError?
}


// MARK: - BaseCommandProtocol

public protocol BaseCommandProtocol {

	associatedtype Error: CommandErrorProtocol
	
	func createGenericError(error: GenericCommandError) -> Error
}


// MARK: - BaseCommandProtocol

public protocol CommandTypeProtocol {

}


// MARK: - CommandProtocol

public protocol CommandProtocol: CommandTypeProtocol {
	func serialize(with selectedFinOrVin: String, requestId: String) -> Data?
}


// MARK: - CommandPinProtocol

public protocol CommandPinProtocol: CommandTypeProtocol {
	func serialize(with selectedFinOrVin: String, requestId: String, pin: String) -> Data?
}


// MARK: - CommandSerializable

protocol CommandSerializable {
	func populate(commandRequest: inout Proto_CommandRequest)
}


// MARK: - CommandPinSerializable

protocol CommandPinSerializable {
	func populate(commandRequest: inout Proto_CommandRequest, pin: String)
}


// MARK: - CommandRequestModelProtocol

protocol CommandRequestModelProtocol {
	
	var commandState: Proto_VehicleAPI.CommandState? { get }
	var commandType: Proto_ACP.CommandType { get }
	var processId: Int64 { get }
	var requestId: String { get }
	var vin: String { get }
	
	func callCompletion()
	func handleTimeout()
	func updateFullStatus(with fullStatus: Proto_AppTwinCommandStatus) -> CommandRequestModelProtocol
}
