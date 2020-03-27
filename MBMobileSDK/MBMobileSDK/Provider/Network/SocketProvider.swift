//
// Copyright (c) 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit

final class SocketProvider {

    private var sdkVersion: String


    // MARK: - Init
    public init(sdkVersion: String) {

        guard sdkVersion.isEmpty == false else {
            fatalError("no sdk version available")
        }

        self.sdkVersion = sdkVersion
    }
}

extension SocketProvider: SocketProviding {

    public var headerParamProvider: HeaderParamProviding {
        return HeaderParamProvider(sdkVersion: self.sdkVersion)
    }

    public var urlProvider: UrlProviding {
        return SocketUrlProvider()
    }
}


// MARK: - SocketUrlProvider
final class SocketUrlProvider {

    init() {
    }
}

extension SocketUrlProvider: UrlProviding {

    var baseUrl: String {
        return "wss://websocket-\(EndpointHelper.urlStageString).risingstars\(EndpointHelper.urlRegionString).daimler.com/ws"
    }
}
