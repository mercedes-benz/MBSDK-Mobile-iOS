//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public extension Notification.Name {
    
    /// Will be sent when the services of the selected vehicle was changed in cache
    ///
    /// Returns the vehicle service status as object of the notification grouped by category name
    static let didChangeServiceGroups = Notification.Name("CarKit.DidChangeServiceGroups")
    
    /// Will be sent when the services of the selected vehicle was changed in cache
    ///
    /// Returns the vehicle service status as object of the notification
    static let didChangeServices = Notification.Name("CarKit.DidChangeServices")
    
    /// Will be sent when the vehicle masterdata was changed in cache
    ///
    /// - Returns:
    ///   - object: ResultsVehicleProvider as object of the notification
    ///   - userInfo: A dictionary consists of the keys \"deletions\", \"insertions\” and \”modifications\”. Each key contains an array of Int that represents the changed indexes in the cache.
    static let didChangeVehicles = Notification.Name("CarKit.DidChangeVehicles")
    
    /// Will be sent when the selected vehicle was changed in cache
    ///
    /// Returns the current vehicle status as object of the notification
    static let didChangeVehicleSelection = Notification.Name("CarKit.DidChangeVehicleSelection")
    
    /// Will be sent when capabilites of vehicles was changed in cache
    ///
    /// Returns the vehicle service capabilities as object of the notification grouped by category name
    static let didChangeSendToCarCapabilities = Notification.Name("CarKit.DidChangeSendToCarCapabilities")
    
    /// Will be sent when the vehicle status of a user has changed, f.e. for service activations
    static let didUserVehicleAuthChangedUpdate = Notification.Name("CarKit.DidUserVehicleAuthChangedUpdate")
}


public extension Notification.Name {
    
    /// Will be sent when the user data was changed in cache
    ///
    /// Returns the user as object of the notification
    /// - Returns:
    ///   - object: the user as object of the notification
    ///   - userInfo: A dictionary consists of the keys \"isNewUser\"
    static let didUpdateUser = Notification.Name("IngressKit.DidUpdateUser")
    
    /// Will be sent when the user region and/or language did change
    ///
    /// Returns the user as object of the notification
    /// - Returns:
    ///   - object: the user as object of the notification
    static let didUpdateUserRegionLanguage = Notification.Name("IngressKit.didUpdateUserRegionLanguage")
}


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
