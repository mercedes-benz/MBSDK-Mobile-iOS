//
// Copyright (c) 2019 MBition GmbH. All rights reserved.
//

import Foundation
import UIKit
import MBCommonKit

final public class DefaultHeaderParamProvider {
    public static var applicationIdentifier: String?
    public static var ldssoAppId: String?
    public static var ldssoAppVersion: String?

    private var sdkVersion: String
    
    // dependencies
    private let localeProvider: LocaleProviding

    private var deviceLocale: String {
        return self.localeProvider.locale
    }

    // MARK: - Init
    public init(sdkVersion: String, localeProvider: LocaleProviding = MBLocaleProvider()) {
        self.sdkVersion = sdkVersion
        self.localeProvider = localeProvider
    }
}

extension DefaultHeaderParamProvider: HeaderParamProviding {
    public var authorizationHeaderParamKey: String {
        return HeaderParamKey.authorization
    }

    public var authorizationModeParamKey: String {
        return HeaderParamKey.authorizationMode
    }
    
    public var countryCodeHeaderParamKey: String {
        return HeaderParamKey.countryCode
    }

    public var defaultHeaderParams: [String: String] {

        let applicationIdentifier = DefaultHeaderParamProvider.applicationIdentifier ?? ""

        if applicationIdentifier == "" {
            LOG.E("ApplicationIdentifier is missing")
        }

        return [
            HeaderParamKey.sessionId: DefaultBffProvider.providerSessionId,
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

        let ldssoAppId = DefaultHeaderParamProvider.ldssoAppId ?? ""
        let ldssoAppVersion = DefaultHeaderParamProvider.ldssoAppVersion ?? ""

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
