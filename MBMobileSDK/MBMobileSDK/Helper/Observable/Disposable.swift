//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public typealias Disposal = [Disposable]

/// Disposal class for the Observable<T> class
public final class Disposable {
	
	private let dispose: () -> Void
	
	
	// MARK: - Init
	
	init(_ dispose: @escaping () -> Void) {
		self.dispose = dispose
	}
	
	
	// MARK: - Public
	
	/// Add a disposal of an observable object
	///
	/// - Parameters:
	///   - disposal: Disposal
	public func add(to disposal: inout Disposal) {
		disposal.append(self)
	}
	
	
	// MARK: - Life cycle
	
	deinit {
		self.dispose()
	}
}
