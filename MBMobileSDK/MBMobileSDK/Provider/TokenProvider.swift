//
// Copyright (c) 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit
import MBIngressKit

final public class TokenProvider {

    public init() {}
}

extension TokenProvider: TokenProviding {

    public func requestToken(onComplete: @escaping TokenProvidingCompletion) {
        IngressKit.loginService.refreshTokenIfNeeded(onComplete: { (token) in
            onComplete(token)
        }, onError: { (error) in
            guard error.type != .unknown else {
                LOG.E("refreshTokenIfNeeded resulted in an unknown error: \(error). Not showing a error dialog to the user.")
                return
            }
            
            MobileSDK.shared.sessionErrorHandler.handleRefreshError(error)
        })
    }
}
