//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import SwiftProtobuf

struct CommandSerializer {
	
	let vin: String
	let requestId: String
	
	func serialize(command: CommandSerializable) -> Data? {
		
		var commandRequest = self.commandRequest()
		
		command.populate(commandRequest: &commandRequest)
		
		return self.clientMessageSerialized(commandRequest: commandRequest)
	}
	
	func serialize(command: CommandPinSerializable, pin: String) -> Data? {
		
		var commandRequest = self.commandRequest()
		
		command.populate(commandRequest: &commandRequest, pin: pin)
		
		return self.clientMessageSerialized(commandRequest: commandRequest)
	}
	
	private func commandRequest() -> Proto_CommandRequest {
		return Proto_CommandRequest.with {
			$0.backend   = .vehicleApi
			$0.requestID = self.requestId
			$0.vin       = self.vin
		}
	}
	
	private func clientMessageSerialized(commandRequest: Proto_CommandRequest) -> Data? {
		
		let clientMessage = Proto_ClientMessage.with {
			$0.commandRequest = commandRequest
		}
		
		do {
			return try clientMessage.serializedData()
		} catch {
			LOG.E("error: serialized client message")
			return nil
		}
	}
}
