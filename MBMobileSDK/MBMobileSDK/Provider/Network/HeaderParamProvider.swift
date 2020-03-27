//
// Copyright (c) 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit
import MBIngressKit

final public class HeaderParamProvider {
    public static var applicationIdentifier: String?
    public static var ldssoAppId: String?
    public static var ldssoAppVersion: String?

    private var sdkVersion: String

    private var deviceLocale: String {
          
        guard let languageCode = Locale.current.languageCode,
            let regionCode = Locale.current.regionCode else {
                return ""
        }
        return languageCode + "-" + regionCode
    }

    // MARK: - Init
    public init(sdkVersion: String) {
        self.sdkVersion = sdkVersion
    }
}

extension HeaderParamProvider: HeaderParamProviding {
    public var authorizationHeaderParamKey: String {
        return HeaderParamKey.authorization
    }

    public var countryCodeHeaderParamKey: String {
        return HeaderParamKey.countryCode
    }

    public var defaultHeaderParams: [String: String] {

        let applicationIdentifier = HeaderParamProvider.applicationIdentifier ?? ""

        if applicationIdentifier == "" {
            LOG.E("ApplicationIdentifier is missing")
        }

        return [
            HeaderParamKey.sessionId: BffProvider.providerSessionId,
            HeaderParamKey.trackingId: UUID().uuidString,
            HeaderParamKey.applicationName: applicationIdentifier,
            HeaderParamKey.sdkVersion: self.sdkVersion,
            HeaderParamKey.locale: self.deviceLocale,
            HeaderParamKey.operatingName: "ios",
            HeaderParamKey.applicationVersion: "\(Bundle.main.shortVersion) (\(Bundle.main.buildVersion))",
            HeaderParamKey.operatingVersion: UIDevice.current.systemVersion
        ]
    }

    public var localeHeaderParamKey: String {
        return HeaderParamKey.locale
    }

    public var ldssoAppHeaderParams: [String: String] {

        let ldssoAppId = HeaderParamProvider.ldssoAppId ?? ""
        let ldssoAppVersion = HeaderParamProvider.ldssoAppVersion ?? ""

        if ldssoAppId == "" {
            LOG.E("Ldsso App Id is missing")
        }

        if ldssoAppVersion == "" {
            LOG.E("Ldsso App Version is missing")
        }

        return [
            HeaderParamKey.ldssoAppId: ldssoAppId,
            HeaderParamKey.ldssoAppVersion: ldssoAppVersion
        ]
    }
}
