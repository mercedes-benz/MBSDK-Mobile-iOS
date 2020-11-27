//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit
#if canImport(MBCommonKitLogger)
import MBCommonKitLogger
#endif
#if canImport(MBCommonKitTracking)
import MBCommonKitTracking
#endif
import MBNetworkKit
import MBRealmKit

let LOG = MBLogger.shared

/// Global class to interact with and initialize MobileSDK.
public class MobileSDK {
    
    static let shared = MobileSDK()
    
    private (set) var context: MBMobileSDKContextConformable!
    
    private var trackingManager: TrackingManager
    
    /// A error handler which can be used to propagate errors to the ui.
    public static var sessionErrorHandler: SessionErrorHandling = DefaultSessionErrorHandler()
	
	
	// MARK: - Init
    
    public convenience init() {
        self.init(trackingManager: MBTrackingManager.shared)
    }

    public init(trackingManager: TrackingManager) {
        self.trackingManager = trackingManager
    }
	
	
	// MARK: - Life cycle
	
	deinit {
        LOG.V()
		
		self.removeObserver()
    }
}


extension MobileSDK {
	
	// MARK: - Public
    
	/// Initializes MobileSDK.
	/// - Parameters:
	///   - configuration: A configuration object. Either created manually or using the provided Confioguration builder.
	///   - context: A optional context object.
	public class func setup(configuration: MBMobileSDKConfiguration, context: MBMobileSDKContextConformable? = nil) {
	
		self.shared.context = context ?? MobileSDKContext(configuration: configuration)
		
		self.shared.renewSessionId()
	
		MobileSDK.shared.addObserver()
		
        self.shared.setupUserDefaultsHelper(
            endpointRegion: configuration.endpointRegion,
            endpointStage: configuration.endpointStage)
		self.shared.setupCarKit()
		self.shared.setupIngressKit()
		self.shared.setupNetworkKit()
        
        LOG.D("Setup successfull: MBMobileSDK")
	}

	/// Performs a logout of the current user
    public class func doLogout() {
		
        IngressKit.loginService.logout { (_) in
            Notification.Name.didLogout.post()
        }
    }

    /// Resets the NetworkKit. Call this after chaing of region or endpoint.
    public class func endpointOrRegionChanged() {
        // updates the base url which is set
        self.shared.setupNetworkKit()
    }
        
    /// Sets a pin provider which is asked for the security pin of the currently logged in user. The pin is required for e.g.
    /// critical car commands
    /// - Parameter pinProvider: The pin provider used for critical commands
    public class func usePinProvider(pinProvider: PinProviding) {
        CarKit.pinProvider = pinProvider
    }
	
	
	// MARK: - Setup
	
    private func setupCarKit() {
		
        CarKit.bffProvider = self.context.bffProvider
        CarKit.cdnProvider = self.context.cdnUrlProvider
		CarKit.pinProvider = self.context.pinProvider
        CarKit.tokenProvider = self.context.tokenProvider
    }

	private func setupIngressKit() {
		
		IngressKit.bffProvider = self.context.bffProvider
		IngressKit.filteredAuthenticationProviders = self.context.authenticationProviders
    }
	
    private func setupNetworkKit() {
		
        let baseUrl = self.context.socketProvider.urlProvider.baseUrl
        LOG.D("Used base URL: \(baseUrl)")
        Socket.socketBaseUrl = baseUrl
		Socket.headerParamProvider = self.context.socketProvider.headerParamProvider
    }
    
    private func setupUserDefaultsHelper(endpointRegion: String, endpointStage: String) {
		
		// stage setup
        if UserDefaultsHelper.modifiedRegion == nil {
            UserDefaultsHelper.modifiedRegion = endpointRegion
        }
        
		if UserDefaultsHelper.modifiedStage == nil {
            UserDefaultsHelper.modifiedStage = endpointStage
		}
	}
	
	
    // MARK: - Observer
    
    private func addObserver() {
        
        Notification.Name.didLogout.add(self, selector: #selector(self.didLogout))
    }
    
    private func removeObserver() {
        
        Notification.Name.didLogout.remove(self)
    }
    
    @objc private func didLogout() {
		
		self.renewSessionId()
        
        CarKit.socketService.sendLogoutMessage()
        CarKit.logout()
        CarKit.sharedVehicleSelection = nil
        CarKit.socketService.closeConnection()
        Socket.service.disconnect(forced: true)
        
        self.deleteDatabases()
        
        self.trackingManager.isTrackingEnabled = true
    }
    
    
    // MARK: - Helper
    
    private func renewSessionId() {
		
        let sessionId = UUID().uuidString
        self.context.bffProvider.sessionId = sessionId
    }
    
    private func deleteDatabases() {
		
        CarKit.vehicleImageService.deleteAllImages()
        DatabaseService.deleteAll(method: .sync)
        DatabaseUserService.delete(method: .sync)
    }
}
