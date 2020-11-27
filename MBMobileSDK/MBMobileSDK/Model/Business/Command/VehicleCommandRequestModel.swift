//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - VehicleCommandRequestModel

class VehicleCommandRequestModel<T>: NSObject where T: BaseCommandProtocol, T: CommandTypeProtocol {
	
	let completion: CarKit.CommandUpdateCallback<T.Error>?
	let requestId: String
	let command: T
	let vin: String
	let fullStatus: Proto_AppTwinCommandStatus?
	
	
	// MARK: - Init
	
	init(completion: CarKit.CommandUpdateCallback<T.Error>?, requestId: String, command: T, vin: String, fullStatus: Proto_AppTwinCommandStatus?) {
		
		self.completion   = completion
		self.requestId    = requestId
		self.command      = command
		self.vin          = vin
		self.fullStatus   = fullStatus
	}
}


// MARK: - CommandRequestModelProtocol

extension VehicleCommandRequestModel: CommandRequestModelProtocol {
	
	// MARK: - Properties
	
	var commandState: Proto_VehicleAPI.CommandState? {
		return self.fullStatus?.state
	}
	
	var commandType: Proto_ACP.CommandType {
		return self.fullStatus?.type ?? .unknowncommandtype
	}
	
	var processId: Int64 {
		return self.fullStatus?.processID ?? 0
	}
	
	
	// MARK: - Methods
	
	func callCompletion() {
		
		guard let fullStatus = self.fullStatus else {
			return
		}
		
		let timestamp = Date(timeIntervalSince1970: TimeInterval(fullStatus.timestampInMs) / 1000)
		let metaData = CommandProcessingMetaData(timestamp: timestamp)
		
		switch fullStatus.state {
		case .initiation:
			self.completion?(.updated(state: .accepted), metaData)
			
		case .enqueued:
			self.completion?(.updated(state: .enqueued), metaData)
			
		case .processing:
			self.completion?(.updated(state: .processing), metaData)
			
		case .waiting:
			self.completion?(.updated(state: .waiting), metaData)
			
		case .finished:
			self.completion?(.finished, metaData)
			
		case .failed, .unknownCommandState, .UNRECOGNIZED:
			
            let errors = fullStatus.errors.map { (error) -> T.Error in
				LOG.D("vehicle command failed with error (code \(error.code)) and message  \"\(error.message)\"")
				return T.Error.fromErrorCode(code: error.code, message: error.message, attributes: error.attributes)
			}
            
            if self.command is CommandPinProtocol {
                
                CarKit.pinProvider?.handlePinFailure(with: errors,
                                                     command: self.command,
                                                     provider: nil,
                                                     completion: self.completion)
            }
            
            self.completion?(.failed(errors: errors), metaData)
		}
	}
	
	func handleTimeout() {
		
		let metaData = CommandProcessingMetaData(timestamp: Date())
		self.completion?(.failed(errors: [self.command.createGenericError(error: .noInternetConnection)]), metaData) // timeout error
	}
	
	func updateFullStatus(with fullStatus: Proto_AppTwinCommandStatus) -> CommandRequestModelProtocol {
        return VehicleCommandRequestModel(completion: self.completion,
                                          requestId: self.requestId,
                                          command: self.command,
                                          vin: self.vin,
                                          fullStatus: fullStatus)
	}
}
