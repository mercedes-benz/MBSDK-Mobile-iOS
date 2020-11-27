//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - AttributedOperation

class AttributedOperation: Operation {
	
	// MARK: - Keys
	
	private struct Keys {
		static let executing = "isExecuting"
		static let finished = "isFinished"
	}
	
	// MARK: - Properties
	
	private var _executing = false {
		willSet {
			self.willChangeValue(forKey: Keys.executing)
		}
		didSet {
			self.didChangeValue(forKey: Keys.executing)
		}
	}
	
	override var isExecuting: Bool {
		return self._executing
	}
	
	private var _finished = false {
		willSet {
			self.willChangeValue(forKey: Keys.finished)
		}
		didSet {
			self.didChangeValue(forKey: Keys.finished)
		}
	}
	
	
	// MARK: - Public
	
	override var isFinished: Bool {
		return self._finished
	}
	
	func execute() {
		self._executing = true
	}
	
	func finished() {
		self._finished = true
	}
}


// MARK: - VepRealmOperation

class VepCacheOperation: AttributedOperation {
	
	typealias NotifySocketHandler = (Data?, Int32?) -> Void
	typealias WriteCompleted = (DTOModelMapper.VehicleStatusTupel, String) -> Void

	// MARK: - Properties
	
	private var cacheService: CacheServiceRepresentable
	private var notifySocketHandler: NotifySocketHandler?
	private var vehicleStatusDTO: VehicleStatusDTO
	private var writeCompleted: WriteCompleted

	
	// MARK: - Public
	
	func set(notifySocketHandler: @escaping NotifySocketHandler) {
		self.notifySocketHandler = notifySocketHandler
	}
	
	
	// MARK: - Init
	
	convenience init(vehicleStatusDTO: VehicleStatusDTO, writeCompleted: @escaping WriteCompleted, notifySocketHandler: NotifySocketHandler?) {
		self.init(cacheService: CacheService(),
				  vehicleStatusDTO: vehicleStatusDTO,
				  writeCompleted: writeCompleted,
				  notifySocketHandler: notifySocketHandler)
	}
	
	init(cacheService: CacheServiceRepresentable, vehicleStatusDTO: VehicleStatusDTO, writeCompleted: @escaping WriteCompleted, notifySocketHandler: NotifySocketHandler?) {
		
		self.cacheService        = cacheService
		self.notifySocketHandler = notifySocketHandler
		self.vehicleStatusDTO    = vehicleStatusDTO
		self.writeCompleted      = writeCompleted
	}
	
	
	// MARK: - Overriden
	
	override func main() {
		
		guard self.isCancelled == false else {
			self.finished()
			return
		}
		
		self.execute()
		
		self.cacheService.update(statusUpdateModel: self.vehicleStatusDTO) { [weak self] (vehicleStatusTupel, updatedVin) in
			
			self?.writeCompleted(vehicleStatusTupel, updatedVin)
			self?.notifySocketHandler?(self?.vehicleStatusDTO.clientMessageData, self?.vehicleStatusDTO.sequenceNumber)
			self?.finished()
		}
	}
}
