//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import RealmSwift
import MBRealmKit

struct MockDatabaseConfig: RealmConfigProtocol {
	
	// MARK: - Init
	
	init(encryptionKey: Data?) {
		self.encryptionKey = encryptionKey
	}
	
	
	// MARK: - RealmConfigProtocol
	
	var deleteRealmIfMigrationNeeded: Bool {
		return false
	}
	
	var encryptionKey: Data?
	
	var filename: String {
		return "Mock_CarKit"
	}
	
	var filesizeToCompact: Int? {
		return nil
	}
	
	var inMemoryIdentifier: String? {
		return "Mock_CarKit"
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
		return 0
	}
}
