//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - VehicleCommandRequestService

class VehicleCommandRequestService {
	
	private static let shared = VehicleCommandRequestService()
	
	
	// MARK: Properties
	
	private var commands: [String: CommandRequestModelProtocol] = [:]
	
	
	// MARK: - Public
	
	static func all() -> [CommandRequestModelProtocol] {
		return self.shared.commands.map { $0.value }
	}
	
	static func commandRequestModelFor(uuid: String) -> CommandRequestModelProtocol? {
		return self.shared.commands[uuid]
	}
	
	static func remove(for uuid: String?) {
		
		guard let uuid = uuid else {
			return
		}
		
		self.shared.commands.removeValue(forKey: uuid)
	}
	
	static func set(commandRequestModel: CommandRequestModelProtocol) {
		
		self.remove(for: commandRequestModel.requestId)
		self.shared.commands[commandRequestModel.requestId] = commandRequestModel
	}
}
