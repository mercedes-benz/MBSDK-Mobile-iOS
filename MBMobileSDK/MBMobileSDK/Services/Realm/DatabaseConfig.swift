//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit
import MBRealmKit
import RealmSwift

struct DatabaseConfig: RealmConfigProtocol {
	
	var deleteRealmIfMigrationNeeded: Bool {
		return true
	}
	var encryptionKey: Data? {
		return KeychainProviderArchetype.realmEncryptionKey
	}
	var filename: String {
		return "MyCar"
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
			DBDealerAddressModel.self,
			DBDealerDayPeriodModel.self,
			DBDealerMerchantModel.self,
			DBDealerOpeningDayModel.self,
			DBDealerOpeningHoursModel.self,
            DBSendToCarCapabilitiesModel.self,
            DBVehicleChargeProgramModel.self,
			DBVehicleChargingBreakClockTimerModel.self,
			DBVehicleCommandCapabilitiesModel.self,
			DBVehicleCommandCapabilityModel.self,
			DBVehicleCommandParameterModel.self,
			DBVehicleModel.self,
			DBVehicleDealerItemModel.self,
			DBVehicleSelectionModel.self,
			DBVehicleServiceMissingDataModel.self,
			DBVehicleServiceModel.self,
			DBVehicleServicePrerequisiteModel.self,
            DBVehicleStatusChargeProgramModel.self,
			DBVehicleStatusChargingBreakClockTimerModel.self,
			DBVehicleStatusChargingPowerControlModel.self,
			DBVehicleStatusModel.self,
			DBVehicleStatusBoolModel.self,
			DBVehicleStatusDayTimeModel.self,
			DBVehicleStatusDoubleModel.self,
			DBVehicleStatusIntModel.self,
			DBVehicleStatusSocProfileModel.self,
            DBVehicleStatusSpeedAlertModel.self,
			DBVehicleStatusTariffModel.self,
			DBVehicleStatusTimeProfileModel.self,
			DBVehicleStatusWeeklyProfileModel.self,
            DBVehicleSupportableModel.self,
            DBVehicleSpeedAlertModel.self,
			DBVehicleUserManagementModel.self,
			DBVehicleAssignedUserModel.self,
			DBUserManagementMetaDataModel.self
		]
	}
	var readOnly: Bool {
		return false
	}
	var schemaVersion: UInt64 {
		return 60
	}
}
