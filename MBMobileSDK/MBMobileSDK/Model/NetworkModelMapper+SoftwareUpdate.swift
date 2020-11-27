//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

extension NetworkModelMapper {
     
    static func map(apiSoftwareUpdateModel: APISoftwareUpdateModel) -> SoftwareUpdateModel {
        
        let lastSynchronization: Date? = {
            guard let lastSync = apiSoftwareUpdateModel.lastSynchronization else {
                return nil
            }
            
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            return formatter.date(from: lastSync)
        }()
        
        return SoftwareUpdateModel(totalUpdates: apiSoftwareUpdateModel.totalUpdates,
                                   availableUpdates: apiSoftwareUpdateModel.availableUpdates,
                                   lastSynchronization: lastSynchronization,
                                   updates: self.map(apiSoftwareUpdateItemModels: apiSoftwareUpdateModel.updates))
    }
    
    static func map(apiSoftwareUpdateItemModels: [APISoftwareUpdateItemModel]) -> [SoftwareUpdateItemModel] {
        return apiSoftwareUpdateItemModels.map { self.map(apiSoftwareUpdateItemModel: $0) }
    }
    
    static func map(apiSoftwareUpdateItemModel: APISoftwareUpdateItemModel) -> SoftwareUpdateItemModel {
        let timestamp: Date? = {
            guard let ts = apiSoftwareUpdateItemModel.timestamp else {
                return nil
            }
            
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            return formatter.date(from: ts)
        }()
        
        return SoftwareUpdateItemModel(title: apiSoftwareUpdateItemModel.title,
                                       description: apiSoftwareUpdateItemModel.description,
                                       timestamp: timestamp,
                                       status: apiSoftwareUpdateItemModel.status)
    }
    
}
