//
// Copyright (c) 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct EndpointHelper {

    private static var lineChar: String = "-"

    static var urlRegionString: String {

        let prefix: String = {
            guard let stage = MBMobileSDKEndpoint.modifiedStage,
                  stage != .prod else {
                return ""
            }

            return lineChar
        }()

        guard let region = MBMobileSDKEndpoint.modifiedRegion,
              region != .ece else {

            guard let stage = MBMobileSDKEndpoint.modifiedStage,
                  stage != .mock else {
                return lineChar + "mock"
            }
            return prefix
        }

        return prefix + lineChar + region.rawValue
    }

    static var urlStageString: String {
        return UserDefaultsHelper.modifiedStage ?? ""
    }
}
