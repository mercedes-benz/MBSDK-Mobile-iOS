//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

extension Notification.Name {
	
	func add(_ observer: Any, selector: Selector, object: Any? = nil) {
		NotificationCenter.default.addObserver(observer, selector: selector, name: self, object: object)
	}
	
	func post(object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
		NotificationCenter.default.post(name: self, object: object, userInfo: userInfo)
	}
	
	func remove(_ observer: Any, object: Any? = nil) {
		NotificationCenter.default.removeObserver(observer, name: self, object: object)
	}
}


// MARK: - IngressNotificationNames

public extension Notification.Name {
	
	///
	static let willLogin = Notification.Name("IngressWillLogin")
	
	///
	static let didLogin = Notification.Name("IngressDidCompleteLogin")
	
	///
	static let willLogout = Notification.Name("IngressWillLogout")
	
	///
	static let didLogout = Notification.Name("IngressDidLogout")
}
