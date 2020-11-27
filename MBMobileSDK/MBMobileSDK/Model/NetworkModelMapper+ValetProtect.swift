//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

extension NetworkModelMapper {

    static func map(apiValetProtectModel apiModel: APIValetProtect) -> ValetProtectModel {
        return ValetProtectModel(name: apiModel.name,
								 violationtypes: self.map(apiViolationType: apiModel.violationtypes),
                                 center: self.map(apiCenterModel: apiModel.center),
                                 radius: self.map(apiRadiusModel: apiModel.radius))
    }

    static func map(apiValetProtectViolationModels apiModels: [APIValetProtectViolation]) -> [ValetProtectViolationModel] {
        return apiModels.map { self.map(apiValetProtectViolationModel: $0) }
    }

    static func map(apiValetProtectViolationModel apiModel: APIValetProtectViolation) -> ValetProtectViolationModel {
        return ValetProtectViolationModel(id: apiModel.id,
                                          violationtype: self.map(apiViolationtype: apiModel.violationtype),
                                          time: apiModel.time,
                                          coordinate: self.map(apiCenterModel: apiModel.coordinate),
                                          valetProtect: self.map(apiValetProtectModel: apiModel.valetProtect))
    }

    static func map(apiViolationType types: [String]) -> [ValetProtectViolationType] {
        return types.compactMap { ValetProtectViolationType(rawValue: $0) }
    }

    static func map(apiDistanceUnitType unitType: String) -> DistanceUnit {
        return DistanceUnit.map(unit: unitType) ?? .kilometers
    }

    static func map(apiViolationtype violationType: String) -> ValetProtectViolationType {
        return ValetProtectViolationType(rawValue: violationType) ?? .ignitionOn
    }

    static func map(apiCenterModel apiModel: APIValetProtectCenter?) -> ValetProtectCenterModel? {
        
        guard let apiModel = apiModel else {
            return nil
        }
		
        return ValetProtectCenterModel(latitude: apiModel.latitude,
									   longitude: apiModel.longitude)
    }

    static func map(apiRadiusModel apiModel: APIValetProtectRadius?) -> ValetProtectRadiusModel? {
        
        guard let apiModel = apiModel else {
            return nil
        }
		
        return ValetProtectRadiusModel(value: apiModel.value,
									   unit: self.map(apiDistanceUnitType: apiModel.unit))
    }
}
