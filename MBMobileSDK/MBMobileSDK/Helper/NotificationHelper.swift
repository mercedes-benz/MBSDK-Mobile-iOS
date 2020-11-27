//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

protocol NotificationSending {
    
    func sendDidUpdateUserNotification(_ user: UserModel?, isNewUser: Bool)
    func sendDidUpdateUserRegionLanguage(_ user: UserModel?)
}

class NotificationHelper: NotificationSending {
    
    func sendDidUpdateUserNotification(_ user: UserModel?, isNewUser: Bool) {

        let userInfo: [String: Bool] = [
            "isNewUser": isNewUser
        ]
        
        NotificationCenter.default.post(name: NSNotification.Name.didUpdateUser,
                                        object: user,
                                        userInfo: userInfo)
    }
    
    func sendDidUpdateUserRegionLanguage(_ user: UserModel?) {
        
        NotificationCenter.default.post(name: NSNotification.Name.didUpdateUserRegionLanguage,
                                        object: user,
                                        userInfo: nil)
    }
}
