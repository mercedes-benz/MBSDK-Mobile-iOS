//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit
import MBRealmKit
import RealmSwift

struct DatabaseUserConfig: RealmConfigProtocol {
	
	var deleteRealmIfMigrationNeeded: Bool {
		return true
	}
	var encryptionKey: Data? {
		return KeychainProviderArchetype.realmEncryptionKey
	}
	var filename: String {
		return "User"
	}
	var filesizeToCompact: Int? {
		return 150
	}
	var inMemoryIdentifier: String? {
		return nil
	}
	var migrationBlock: MigrationBlock? {
		return nil
	}
	var objects: [ObjectBase.Type]? {
		return [
			DBUserAdaptionValuesModel.self,
			DBUserAddressModel.self,
			DBUserCommunicationPreferenceModel.self,
			DBUserModel.self,
			DBUserUnitPreferenceModel.self
		]
	}
	var readOnly: Bool {
		return false
	}
	var schemaVersion: UInt64 {
		return 8
	}
}
