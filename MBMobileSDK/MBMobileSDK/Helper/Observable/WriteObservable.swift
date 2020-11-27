//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Generic class for an writable observable object
public class WriteObservable<T>: Observable<T> {

	// MARK: Properties
	public var value: T {
		didSet {
			
			self.observableValue = self.value
			
			let state: Observable<T>.State = .updated(self.value)
            self.observers.values.forEach { $0(state) }
		}
	}
	

	// MARK: - Init

	public override init(_ value: T) {
		self.value = value

		super.init(value)
	}
	
	
	// MARK: - Helper
	
	func updateWithoutNotifyObserver(value: T) {
		
		let observers  = self.observers
		self.observers = [:]
		self.value     = value
		self.observers = observers
	}
}
