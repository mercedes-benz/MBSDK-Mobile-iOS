//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Generic class for an read-only observable object
public class Observable<T> {
	
	// MARK: Enum
	
	/// State of the observable
	public enum State<T> {
		/// initial observable
		case initial(T)
		/// updated observable
		case updated(T)
		
		public var value: T {
			switch self {
			case .initial(let value):	return value
			case .updated(let value):	return value
			}
		}
	}
	
	// MARK: Typealias
	
	/// Completion for an observer
	///
	/// Returns a generic object
	public typealias Observer = (State<T>) -> Void
	
	// MARK: Properties
	var observers: [Int: Observer] = [:]
	var uniqueID = (0...).makeIterator()
	internal var observableValue: T
	
	
	// MARK: - Init
	
	public init(_ value: T) {
		self.observableValue = value
	}
	
	
	// MARK: - Public
	
	/// Returns the current generic object
	public var current: T {
		return self.observableValue
	}
	
	/// Start to observe an object
	///
	/// - Parameters:
	///   - observer: Closure with Observer
	/// - Returns: Disposable
	public func observe(_ observer: @escaping Observer) -> Disposable {
		
		guard let id = self.uniqueID.next() else {
			fatalError("There should always be a next unique id")
		}
		
		self.observers[id] = observer
		
		let state: Observable<T>.State = .initial(self.observableValue)
		observer(state)
		
		let disposable = Disposable { [weak self] in
			self?.observers[id] = nil
		}
		
		return disposable
	}
	
	/// Remove all observables
	public func removeAllObservers() {
		self.observers.removeAll()
	}
}
