//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit
import MBNetworkKit

/// Main part of the MBCarKir-module
///
/// Fascade to communicate with all provided services
public class CarKit {
	
	// MARK: Typealias
	
	/// Completion for vehicle api based commands
	public typealias CommandUpdateCallback<T: CommandErrorProtocol> = (CommandProcessingState<T>, CommandProcessingMetaData) -> Void

	/// Completion for error message
	///
	/// Returns a string
	public typealias ErrorDescription = (String) -> Void

    /// Completion for vehicle selection
    public typealias VehicleSelectionResult = (Result<Void, VehicleServiceError>) -> Void
    
	// MARK: Properties
	private static let shared = CarKit()
	private let accountLinkageService: AccountLinkageServiceRepresentable
	private let assignmentService: AssignmentServiceRepresentable
	private let dealerService: DealerServiceRepresentable
    private let geofencingService: GeofencingServiceRepresentable
    private let geofencingViolationsService: GeofencingViolationServiceRepresentable
	private let sendToCarService: SendToCarServiceRepresentable
	private let servicesService: ServicesServiceRepresentable
	private let socketService: SocketServiceRepresentable
    private let speedAlertService: SpeedAlertServiceRepresentable
    private let speedFenceService: SpeedFenceServiceRepresentable
    private let topViewService: TopViewServiceRepresentable
    private let valetProtectService: ValetProtectServiceRepresentable
	private let vehicleImageService: VehicleImageServiceRepresentable
	private let vehicleService: VehicleServiceRepresentable

	static var defaultRequestTimeout: TimeInterval = 10
	
	
	// MARK: - Public
	
	/// Access to account linkage services
	public static var accountLinkageService: AccountLinkageServiceRepresentable {
		return self.shared.accountLinkageService
	}
	
	/// Access to assignment services
	public static var assignmentService: AssignmentServiceRepresentable {
		return self.shared.assignmentService
	}
	
	/// Access to dealer services
	public static var dealerService: DealerServiceRepresentable {
		return self.shared.dealerService
	}
	
	/// Access to geofencing service
    public static var geofencingService: GeofencingServiceRepresentable {
        return self.shared.geofencingService
    }
    
    /// Access to geofencing violations service
    public static var geofencingViolationsService: GeofencingViolationServiceRepresentable {
        return self.shared.geofencingViolationsService
    }
	
	/// Access to service services
	public static var servicesService: ServicesServiceRepresentable {
		return self.shared.servicesService
	}
	
	/// Access to send to car services
    @available(*, deprecated, message: "Please instantiate SendToCarServiceV2 instead.")
	public static var sendToCarService: SendToCarServiceRepresentable {
		return self.shared.sendToCarService
	}
	
	/// Access to socket services
	public static var socketService: SocketServiceRepresentable {
		return self.shared.socketService
	}

	/// Access to speed alert service
    public static var speedAlertService: SpeedAlertServiceRepresentable {
        return self.shared.speedAlertService
    }
    
    /// Access to speedfence service
    public static var speedFenceService: SpeedFenceServiceRepresentable {
        return self.shared.speedFenceService
    }
	
	/// Access to top view services
    public static var topViewService: TopViewServiceRepresentable {
        return self.shared.topViewService
    }
	
	/// Access to valet protect service
    public static var valetProtectService: ValetProtectServiceRepresentable {
        return self.shared.valetProtectService
    }
	
	/// Access to vehicle service
	public static var vehicleService: VehicleServiceRepresentable {
		return self.shared.vehicleService
	}
	
	/// Access to vehicle image services
	public static var vehicleImageService: VehicleImageServiceRepresentable {
		return self.shared.vehicleImageService
	}
	
	/// Returns the cached status of the selected vehicle
	public class func currentVehicleStatus() -> VehicleStatusModel {
		return CacheService().getCurrentStatus()
	}
	
	/// Web socket has connection to network
	public class var isConnectToWebSocket: Bool {
		return Socket.service.isConnected
	}
	
	/// Returns whether a vehicle has been selected
	public class var isVehicleSelected: Bool {
		return CarKit.selectedFinOrVin?.isEmpty == false
	}
	
	/// Returns the vin for a selected vehicle
	public class var selectedFinOrVin: String? {
		return VehicleSelectionDbStore().selectedVehicle?.finOrVin
	}
	
	/// Returns the vehicle for the selected vin
	public class var selectedVehicle: VehicleModel? {
		guard let selectedFinOrVin = CarKit.selectedFinOrVin else {
			return nil
		}
		return VehicleDbStore().item(with: selectedFinOrVin)
	}

	/// Returns the vehicle for a finOrVin
	public class func vehicle(for finOrVin: String) -> VehicleModel? {
		return VehicleDbStore().item(with: finOrVin)
	}
	
    /// Selects a vehicle with given fin or vin
    public class func selectVehicle(with finOrVin: String, completion: @escaping VehicleSelectionResult) {
        
        guard let vehicle = CarKit.vehicle(for: finOrVin) else {
            completion(.failure(.vehicleForVinNotFound))
            return
        }
        // TODO: There is no such check on Android and it is needed
        //  to clarify if or why this condition checker is required.
        if (vehicle.trustLevel > 1 && vehicle.pending == nil) ||
            (vehicle.trustLevel == 1 && vehicle.vehicleConnectivity?.isLegacy == true) {
            
            DatabaseService.update(finOrVin: vehicle.finOrVin) { (result) in
				
				switch result {
				case .failure(let dbError):
					LOG.E("Vehicle selection failed: \(dbError.localizedDescription)")
					completion(.failure(.dbOperationError))
				case .success:
					completion(.success(()))
				}
            }
            
        } else {
            completion(.failure(.invalidAssignment))
        }
        
    }
    
	/// Returns the cached status of vehicle, finOrVin-based
	public class func vehicleStatus(for finOrVin: String) -> VehicleStatusModel {
		return CacheService().getStatus(for: finOrVin)
	}
    
    // Returns the bff provider
	public static var bffProvider: BffProviding?
	
	/// Returns the bluetooth provider for send to car feature
	public static var bluetoothProvider: BluetoothProviding?
	
	/// Returns the cdn provider
	public static var cdnProvider: UrlProviding?

	/// Returns the custom pin provider
	public static var pinProvider: PinProviding?
	
	/// Shared vehicle selection for app family concept
	public static var sharedVehicleSelection: String?
	
	/// Returns the custom token provider
	public static var tokenProvider: TokenProviding = TokenProviderArchetype()

	private var databaseNotificationService: VehicleDatabaseNotificationService
	
	
	// MARK: - Initializer
	
	private init() {
		
		let networking: Networking & NetworkingDownload = NetworkService()
		let servicesService = ServicesService(networking: networking)
		let userManagementService: UserManagementServiceRepresentable = UserManagementService(networking: networking)
		let vehicleService: VehicleServiceRepresentable & VehicleServiceCarKitRepresentable = VehicleService(networking: networking, userManagementService: userManagementService)
		
		self.accountLinkageService 			= AccountLinkageService(networking: networking)
		self.assignmentService   			= AssignmentService(networking: networking)
		self.dealerService       			= DealerService(networking: networking)
        self.geofencingService   			= GeofencingService(networking: networking)
        self.geofencingViolationsService 	= GeofencingViolationService(networking: networking)
		self.sendToCarService    			= SendToCarService(networking: networking)
		self.servicesService     			= servicesService
		self.socketService       			= SocketService(networking: networking,
															servicesService: servicesService,
															vehicleServiceCarKit: vehicleService)
        self.speedAlertService   			= SpeedAlertService(networking: networking)
        self.speedFenceService   			= SpeedFenceService(networking: networking)
		self.topViewService      			= TopViewService(networking: networking)
        self.valetProtectService 			= ValetProtectService(networking: networking)
		self.vehicleImageService 			= VehicleImageService(networking: networking)
		self.vehicleService      			= vehicleService
		
		self.databaseNotificationService = VehicleDatabaseNotificationService()
	}
	
	
	// MARK: - Socket

	public class func logout() {

		CacheService().deleteAll()
		ImageDbStore().deleteAll { _ in }
	}
}
