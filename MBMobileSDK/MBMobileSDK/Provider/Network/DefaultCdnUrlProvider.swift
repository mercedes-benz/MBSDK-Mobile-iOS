//
// Copyright (c) 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit

final class DefaultCdnUrlProvider {

    init() {}
}

extension DefaultCdnUrlProvider: UrlProviding {

    var baseUrl: String {

        let stage: String = {
            guard let stage = MBMobileSDKEndpoint.modifiedStage else {
                return ""
            }

            switch stage {
            case .mock:	return "-int"
            case .prod:	return ""
            }
        }()
        return "https://vehicle-topview\(stage).azureedge.net"
    }
}
