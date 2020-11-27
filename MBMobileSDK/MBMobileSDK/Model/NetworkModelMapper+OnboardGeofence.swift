//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - Onboard Geofence

extension NetworkModelMapper {
    
    static func map(apiCustomerFenceModel: [APICustomerFenceModel]) -> [CustomerFenceModel] {
        return apiCustomerFenceModel.map { self.map(apiCustomerFenceModel: $0) }
    }
    
    static func map(apiCustomerFenceModel: APICustomerFenceModel) -> CustomerFenceModel {
        return CustomerFenceModel(customerfenceid: apiCustomerFenceModel.customerfenceid,
                                  geofenceid: apiCustomerFenceModel.geofenceid,
                                  name: apiCustomerFenceModel.name,
                                  days: apiCustomerFenceModel.days,
                                  beginMinutes: apiCustomerFenceModel.beginMinutes,
                                  endMinutes: apiCustomerFenceModel.endMinutes,
                                  timestamp: apiCustomerFenceModel.ts,
                                  violationtype: apiCustomerFenceModel.violationtype)
    }
    
    static func map(customerFenceModel: [CustomerFenceModel]) -> [APICustomerFenceModel] {
        return customerFenceModel.map { self.map(customerFenceModel: $0) }
    }
    
    static func map(customerFenceModel: CustomerFenceModel) -> APICustomerFenceModel {
        return APICustomerFenceModel(customerfenceid: customerFenceModel.customerfenceid,
                                  geofenceid: customerFenceModel.geofenceid,
                                  name: customerFenceModel.name,
                                  days: customerFenceModel.days,
                                  beginMinutes: customerFenceModel.beginMinutes,
                                  endMinutes: customerFenceModel.endMinutes,
                                  ts: customerFenceModel.timestamp,
                                  violationtype: customerFenceModel.violationtype)
    }
    
    static func map(apiOnboardFenceModel: [APIOnboardFenceModel]) -> [OnboardFenceModel] {
        return apiOnboardFenceModel.map { self.map(apiOnboardFenceModel: $0) }
    }
    
    static func map(apiOnboardFenceModel: APIOnboardFenceModel) -> OnboardFenceModel {
        return OnboardFenceModel(geofenceid: apiOnboardFenceModel.geofenceid,
                                 name: apiOnboardFenceModel.name,
                                 isActive: apiOnboardFenceModel.isActive,
                                 center: apiOnboardFenceModel.center,
                                 fencetype: apiOnboardFenceModel.fencetype,
                                 radiusInMeter: apiOnboardFenceModel.radiusInMeter,
                                 verticescount: apiOnboardFenceModel.verticescount,
                                 verticespositions: apiOnboardFenceModel.verticespositions,
                                 syncstatus: apiOnboardFenceModel.syncstatus)
    }
    
    static func map(onboardFenceModel: [OnboardFenceModel]) -> [APIOnboardFenceModel] {
        return onboardFenceModel.map { self.map(onboardFenceModel: $0) }
    }
    static func map(onboardFenceModel: OnboardFenceModel) -> APIOnboardFenceModel {
        return APIOnboardFenceModel(geofenceid: onboardFenceModel.geofenceid,
                                    name: onboardFenceModel.name,
                                    isActive: onboardFenceModel.isActive,
                                    center: onboardFenceModel.center,
                                    fencetype: onboardFenceModel.fencetype,
                                    radiusInMeter: onboardFenceModel.radiusInMeter,
                                    verticescount: onboardFenceModel.verticescount,
                                    verticespositions: onboardFenceModel.verticespositions,
                                    syncstatus: onboardFenceModel.syncstatus)
    }
    
    static func map(apiCustomerFenceViolationModel: [APICustomerFenceViolationModel]) -> [CustomerFenceViolationModel] {
        return apiCustomerFenceViolationModel.map { self.map(apiCustomerFenceViolationModel: $0) }
    }
    
    static func map(apiCustomerFenceViolationModel: APICustomerFenceViolationModel) -> CustomerFenceViolationModel {
        
        let customerfence: CustomerFenceModel? = {
            guard let fence = apiCustomerFenceViolationModel.customerfence else {
                return nil
            }
            return self.map(apiCustomerFenceModel: fence)
        }()
        
        let onboardfence: OnboardFenceModel? = {
            guard let fence = apiCustomerFenceViolationModel.onboardfence else {
                return nil
            }
            return self.map(apiOnboardFenceModel: fence)
        }()
        
        return CustomerFenceViolationModel(violationid: apiCustomerFenceViolationModel.violationid,
                                           time: apiCustomerFenceViolationModel.time,
                                           coordinates: apiCustomerFenceViolationModel.coordinates,
                                           customerfence: customerfence,
                                           onboardfence: onboardfence)
    }
}
