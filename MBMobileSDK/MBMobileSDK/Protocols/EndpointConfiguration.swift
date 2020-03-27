//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

protocol EndpointConfiguration {
    
    associatedtype Region: RawRepresentable where Region.RawValue == String
    associatedtype Stage: RawRepresentable where Stage.RawValue == String

    init(region: Region, stage: Stage)
}

extension EndpointConfiguration where Region.RawValue == String, Stage.RawValue == String {
    
    static var modifiedStage: Stage? {
        get {
            guard let value = UserDefaultsHelper.modifiedStage,
                let endpoint = Stage(rawValue: value) else {
                    return nil
            }
            return endpoint
        }
        set {
            UserDefaultsHelper.modifiedStage = newValue?.rawValue
        }
    }
    
    static var modifiedRegion: Region? {
        get {
            guard let value = UserDefaultsHelper.modifiedRegion,
                let region = Region(rawValue: value) else {
                    return nil
            }
            return region
        }
        set {
            UserDefaultsHelper.modifiedRegion = newValue?.rawValue
        }
    }
}
