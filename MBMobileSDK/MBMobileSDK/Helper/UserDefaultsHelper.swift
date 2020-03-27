//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBIngressKit

open class UserDefaultsHelper {

    // MARK: - Keys

    public struct Keys {

        public static let stageEndpoint = "stageItemKey"
        public static let stageRegion = "stageRegionKey"
    }

    // MARK: - Properties

    public static var appGroupIdentifier: String?


    // MARK: - Region & Stage
    
    public class var modifiedRegion: String? {
        get {
            guard let value = self.appGroupUserDefaults.string(forKey: Keys.stageRegion),
                    value.isEmpty == false else {
                return nil
            }
            return value
        }
        set {
            guard let rawValue = newValue else {
                self.appGroupUserDefaults.removeObject(forKey: Keys.stageRegion)
                return
            }

            self.saveToAppGroupDefaults(value: rawValue, key: Keys.stageRegion)
        }
    }
    
    public class var modifiedStage: String? {
        get {
            guard let value = self.appGroupUserDefaults.string(forKey: Keys.stageEndpoint),
                value.isEmpty == false else {
                    return nil
            }
            return value
        }
        set {
            guard let rawValue = newValue else {
                self.appGroupUserDefaults.removeObject(forKey: Keys.stageEndpoint)
                return
            }

            self.saveToAppGroupDefaults(value: rawValue, key: Keys.stageEndpoint)
        }
    }
    
    
    // MARK: - Helper

    public class var appGroupUserDefaults: UserDefaults {

        guard let appGroupSuiteName = self.appGroupIdentifier,
              let appGroupDefaults = UserDefaults(suiteName: appGroupSuiteName),
              appGroupSuiteName.isEmpty == false else {
            return UserDefaults.standard
        }

        return appGroupDefaults
    }


    private class func saveToAppGroupDefaults(value: Any?, key: String) {

        self.appGroupUserDefaults.set(value, forKey: key)
        self.appGroupUserDefaults.synchronize()
    }


    private class func saveToLocalDefaults(value: Any?, key: String) {

        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
}
