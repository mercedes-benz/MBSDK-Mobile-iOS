//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit
import MBRealmKit
import RealmSwift

struct MockRealmConfiguration: RealmConfigProtocol {
	
	var deleteRealmIfMigrationNeeded: Bool {
		return true
	}
	var encryptionKey: Data? {
		return nil
	}
	var filename: String {
		return "MyCar"
	}
	var filesizeToCompact: Int? {
		return 150
	}
	var inMemoryIdentifier: String? {
		return "MyCar"
	}
	var migrationBlock: MigrationBlock? {
		return nil
	}
	var objects: [ObjectBase.Type]? {
		return nil
	}
	var readOnly: Bool {
		return false
	}
	var schemaVersion: UInt64 {
		return 1
	}
}
