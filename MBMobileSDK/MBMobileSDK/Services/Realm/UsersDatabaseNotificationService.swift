//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit
import MBRealmKit
import RealmSwift

class UsersDatabaseNotificationService {
    
    // MARK: Struct
    private struct Token {
        static let users = "users"
    }
    
    // MARK: Lazy
    private lazy var tokenName: String = {
        return String(describing: self)
    }()
    
    private let notificationSending: NotificationSending
    
    // MARK: - Init
    
    init(notificationSending: NotificationSending = NotificationHelper()) {
        
        self.notificationSending = notificationSending
        
		let isTargetExtension = Bundle.main.bundleURL.pathExtension == "appex"
		if isTargetExtension == false {
			self.observeUsers()
		}
    }
    
    
    // MARK: - Object life cycle
    
    deinit {
        LOG.V()
        
        RealmToken.invalide(for: self.tokenName + Token.users)
    }
    
    
    // MARK: - Helper
    
    private func observeUsers() {
        
        let token = DatabaseUserService.fetch(initial: { [weak self] (provider) in
            self?.didChangeUsers(with: provider, isNewUser: true)
        }, update: { [weak self] (provider, _, insertions, _) in
            self?.didChangeUsers(with: provider, isNewUser: insertions.isEmpty == false)
        }, error: nil)
        
        RealmToken.set(token: token, for: self.tokenName + Token.users)
    }
    
    private func didChangeUsers(with provider: ResultsUserProvider, isNewUser: Bool) {
        self.notificationSending.sendDidUpdateUserNotification(provider.map(), isNewUser: isNewUser)
    }
}
