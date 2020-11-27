//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit

/// Main part of the MBIngressKit-module
///
/// Fascade to communicate with all provided services
public class IngressKit {

	// MARK: Properties
	private static let shared = IngressKit()
    
	private let serviceLogin: LoginService
    

	static var defaultRequestTimeout: TimeInterval = 60

	// MARK: - Public

	/// Access to login services
	public static var loginService: LoginServiceRepresentable {
		return self.shared.serviceLogin
	}
    
	/// CountryCode
    public static var countryCode: String {
        return IngressKit.regionHelper.countryCode(for: IngressKit.shared.userService.currentUser)
    }

	/// Locale identifier
    public static var localeIdentifier: String {
        return IngressKit.regionHelper.locale(for: IngressKit.shared.userService.currentUser)
    }

    /// Returns the bff provider
    public static var bffProvider: BffProviding?

	/// Returns the filtered authentication providers according to selected region and stage. You can find all possible authentication providers in MobileSDKContext
    public static var filteredAuthenticationProviders: [AuthenticationProviding] = []
	
    ///
    public static var preferredAuthenticationType: AuthenticationType = .keycloak
    
	// MARK: - Private
    private static let regionHelper = UserRegionHelper()
    private let databaseNotificationService: UsersDatabaseNotificationService
    private let userService: UserServiceRepresentable


	// MARK: - Initializer

	private init() {

		self.databaseNotificationService = UsersDatabaseNotificationService()

        guard IngressKit.filteredAuthenticationProviders.isEmpty == false else {
            fatalError("init IngressKit without AuthenticationProvider is not valid.")
        }
        
        self.userService = UserService()
        self.serviceLogin = LoginService(userFunctions: userService)
        (self.userService as? UserService)?.loginService = self.serviceLogin
	}
}
