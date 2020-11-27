//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class DBImageModel: Object {
	
	// MARK: Properties
	dynamic var background: Int = 0
	dynamic var centered: Bool = false
	dynamic var degrees: Int = 0
	dynamic var imageData: Data?
	dynamic var isPng: Bool = false
	dynamic var night: Bool = false
	dynamic var primaryKey: String = ""
	dynamic var roofOpen: Bool = false
	dynamic var size: Int = 0
	dynamic var vin: String = ""
	
	
	// MARK: - Realm
	
	override public static func primaryKey() -> String? {
		return "primaryKey"
	}
}
