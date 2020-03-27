//
// Copyright (c) 2019 MBition GmbH. All rights reserved.
//

import Foundation

extension Bundle {

    var buildVersion: String {
        return self.string(for: String(kCFBundleVersionKey)) ?? ""
    }

    var shortVersion: String {
        return self.string(for: "CFBundleShortVersionString") ?? ""
    }

    var displayName: String {
        return self.string(for: "CFBundleDisplayName") ?? self.string(for: String(kCFBundleNameKey)) ?? ""
    }


    // MARK: - Helper
	
    private func string(for key: String) -> String? {
        return self.object(forInfoDictionaryKey: key) as? String
    }
}
