//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

protocol Send2CarNotificationSending {
    func sendDidChangeSendToCarCapabilities(capabilities: SendToCarCapabilitiesModel)
}

class Send2CarNotificationSender: Send2CarNotificationSending {
    
    private let notificationCenter: NotificationCenter
    
    convenience init() {
        self.init(notificationCenter: .default)
    }
    
    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }
    
    func sendDidChangeSendToCarCapabilities(capabilities: SendToCarCapabilitiesModel) {
        
        LOG.D("Sending didChangeSendToCarCapabilities Notification")
        self.notificationCenter.post(name: NSNotification.Name.didChangeSendToCarCapabilities,
                                     object: capabilities)
    }
}
