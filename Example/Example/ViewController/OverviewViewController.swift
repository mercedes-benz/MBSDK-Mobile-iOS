//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import UIKit
import MBCarKit
import MBMobileSDK
import Foundation
import MBIngressKit

class OverviewViewController: UIViewController, VehicleSelectionDelegate {

    // MARK: - IBOutlet
    
    @IBOutlet private weak var buttonLockDoor: UIButton!
    @IBOutlet private weak var buttonUnlockDoor: UIButton!
    @IBOutlet private weak var buttonConnect: UIButton!
    @IBOutlet private weak var buttonDisconnect: UIButton!
    @IBOutlet private weak var buttonSelectVehicle: UIButton!
    @IBOutlet private weak var buttonStartLogin: UIButton!
    @IBOutlet private weak var buttonLogout: UIButton!

    @IBOutlet private weak var labelSelectedCarHeader: UILabel!
    @IBOutlet private weak var labelSelectedCarModel: UILabel!
    @IBOutlet private weak var labelCarCommandsHeader: UILabel!
    @IBOutlet private weak var labelFuelTank: UILabel!
    @IBOutlet private weak var labelLiquidTank: UILabel!
    @IBOutlet private weak var labelEelectricTank: UILabel!
    @IBOutlet private weak var labelFuelTankHeader: UILabel!
    @IBOutlet private weak var labelLoginState: UILabel!
    @IBOutlet private weak var labelConnectionState: UILabel!
    @IBOutlet private weak var labelDoorLockingState: UILabel!

    @IBOutlet private weak var carImageView: UIImageView!

    
    // MARK: - Properties
    
    private var disposal = Disposal()
    private var myCarToken: MyCarSocketNotificationToken?
    
    
    // MARK: - Lifecycle
    
    deinit {
        
        // remove observer
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.didLogin, object: nil)
        self.resetSocket()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
		
        self.title = "Overview"
        
        // add observer
		NotificationCenter.default.addObserver(self, selector: #selector(self.didLoginSuccessfully), name: NSNotification.Name.didLogin, object: nil)

        self.buttonLogout.isEnabled = false

        // If the user is already logged in, we can skip the login process
        if IngressKit.userService.validUser != nil {
			self.didLoginSuccessfully()
        }
    }

    
    // MARK: - Notification Observer
    
    @objc private func didLoginSuccessfully() {
		
        self.presentedViewController?.dismiss(animated: true)
        self.buttonSelectVehicle.isEnabled = true
        self.buttonStartLogin.isEnabled = false
        self.buttonLogout.isEnabled = true
        self.labelLoginState.text = "Logged in"
        self.startSocketConnection()
        
        if let selectedVehicle = CarKit.selectedVehicle {

            self.setCarImage(vehicle: selectedVehicle)
            self.labelSelectedCarModel.text = selectedVehicle.model
        }
    }

    
    // MARK: - IBActions
    
    @IBAction func didTapConnect(_ sender: UIButton) {
        
        self.labelConnectionState.text = "Connecting..."
        
        if CarKit.isConnectToWebSocket == false {
            
            // If the Socket isn't connect, reconnect it
            // The UI will be updated in the completion of the `startSocketConnection` function
            CarKit.socketService.reconnect(manually: false)
        }
    }

    @IBAction func didTapDisconnect(_ sender: UIButton) {
        
        self.labelConnectionState.text = "Disconnecting..."
        
        if CarKit.isConnectToWebSocket {
            
            // If the Socket is connect, disconnect it
            // The UI will be updated in the completion of the `startSocketConnection` function
            CarKit.socketService.disconnect()
        }
    }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
		
        // We use the MobileSDK login workflow to handle the user login completely
        let loginViewController = MobileSDK.coordinator.getLoginViewController()
        self.navigationController?.present(loginViewController, animated: true)
    }
    
    @IBAction func didTapLogout(_ sender: UIButton) {
        
        self.resetSocket()
        MobileSDK.doLogout()

        self.buttonLogout.isEnabled = false
        self.buttonSelectVehicle.isEnabled = false
        self.labelFuelTank.isEnabled = false
        self.labelFuelTankHeader.isEnabled = false
        self.buttonStartLogin.isEnabled = true
        self.carImageView.image = nil
        self.labelSelectedCarHeader.isEnabled = false
        self.labelSelectedCarModel.text = nil
        self.labelCarCommandsHeader.isEnabled = false
        self.buttonLockDoor.isEnabled = false
        self.buttonUnlockDoor.isEnabled = false
        self.buttonConnect.isEnabled = false
        self.buttonDisconnect.isEnabled = false
        self.labelDoorLockingState.text = "Unknown"
        self.labelLoginState.text = "Not logged in"
    }

    @IBAction func didTapLockDoor(_ sender: UIButton) {
		
        self.labelDoorLockingState.text = "Locking doors..."
        self.buttonLockDoor.isEnabled = false
		
        // All possible Commands can be found in the `Command` struct
        CarKit.socketService.send(command: Command.DoorsLock(), completion: { (commandProcessingState, _) in
            LOG.D("Result of send doors lock command: \(commandProcessingState)")
        })
    }

    @IBAction func didTapUnlockDoor(_ sender: UIButton) {
		
        self.labelDoorLockingState.text = "Unlocking doors..."
        self.buttonUnlockDoor.isEnabled = false
		
        // All possible Commands can be found in the `Command` struct
        CarKit.socketService.send(command: Command.DoorsUnlock(), completion: { (commandProcessingState, _) in
			LOG.D("Result of send doors unlock command: \(commandProcessingState)")
        })
    }
    
    @IBAction func didTapSelectVehicle(_ sender: UIButton) {
        
        let vc = VehicleViewController.instantiate(delegate: self)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    // MARK: - VehicleSelectionDelegate

    func didSelectVehicle(vehicle: VehicleModel) {
		
        self.navigationController?.popToViewController(self, animated: true)

        // We use the database service to persist the VIN of the selected vehicle
        DatabaseService.update(finOrVin: vehicle.finOrVin, completion: nil)
        self.setCarImage(vehicle: vehicle)

        self.labelSelectedCarModel.text = vehicle.model
    }

    
    // MARK: - Helper
    
    /// Starts oberserving the door status from the socket
    private func observeDoorStatus(socketObservable: SocketObservableProtocol) {
        
        socketObservable.doors.observe({ [weak self] (state) in
                
            switch state {
            case .initial(let doors):
                self?.updateDoorLockState(doorLockStatus: doors.lockStatusOverall.value)
            
            case .updated(let doors):
                self?.updateDoorLockState(doorLockStatus: doors.lockStatusOverall.value)
            }
        }).add(to: &self.disposal)
    }
    
    /// Starts oberserving the tank level from the socket
    private func observeTankLevel(socketObservable: SocketObservableProtocol) {
        
        socketObservable.tank.observe({ [weak self] (state) in
            
            switch state {
            case .initial(let store):
                LOG.D("Initial Store: \(store)")
                
                self?.updateTankLevel(store)
                
            case .updated(let store):
                LOG.D("Updated Store: \(store)")
                
                self?.updateTankLevel(store)
            }
        }).add(to: &self.disposal)
    }
    
    private func resetSocket() {
        
        // stop observer
        self.disposal.removeAll()
        CarKit.socketService.unregisterAndDisconnectIfPossible(token: self.myCarToken)
    }
    
    private func setCarImage(vehicle: VehicleModel) {
		
        let vehicleImageRequest = VehicleImageRequest(background: VehicleImageBackground.transparent,
													  centered: true,
													  degrees: .d0,
													  night: false,
													  roofOpen: false,
													  shouldBeCached: true,
													  size: .png(size: .size1920x1080))

        // We use the vehicle image service to load an image for the currently selected vehicle
        CarKit.vehicleImageService.fetchVehicleImage(finOrVin: vehicle.finOrVin, requestImage: vehicleImageRequest, completion: { [weak self] (result) in
			
			switch result {
			case .failure(let error):
				LOG.D("Failed image fetch \(error)")
                
				self?.carImageView.image = nil
			
			case .success(let data):
				LOG.D("Successful image fetch, \(data)")
                
				let image = UIImage(data: data)
				self?.carImageView.image = image
			}
		})
    }
    
    private func startSocketConnection() {
        
        self.labelConnectionState.text = "Connecting..."
        /* it is necessary to be connected to the socket service to send vehicle commands.
           We receive a socketObservable object with which it is possible to observe the status
           of vehicle components such as the fuel tank level. */
        let socketStateTupel = CarKit.socketService.connect(notificationTokenCreated: { [weak self] (token: MyCarSocketNotificationToken?) -> Void in
            LOG.D("Socket Connected \(String(describing: token))")
            
            // Token that will be used to remove the socket connection
            self?.myCarToken = token
        }, socketConnectionState: { [weak self] (state) in
            LOG.D("Socket Connected with state: \(state)")
            
            self?.updateConnectionState(with: state)
        })
        
        self.updateConnectionState(with: socketStateTupel.socketConnectionState)
        
        // Handle the possible obervable socket data
        self.observeDoorStatus(socketObservable: socketStateTupel.socketObservable)
        self.observeTankLevel(socketObservable: socketStateTupel.socketObservable)
    }
    
    
    /// Update the UI based on the connection state of the socket
    private func updateConnectionState(with state: MyCarSocketConnectionState) {
        
        switch state {
        case .connected:
            LOG.D("Connected")
            
            self.updateConnectionView(connected: true)
            
        case .closed, .connecting, .disconnected:
            LOG.D("Not connected")
        
            self.updateConnectionView(connected: false)
            self.buttonLockDoor.isEnabled = false
            self.buttonUnlockDoor.isEnabled = false
            self.labelDoorLockingState.text = "Unknown"
            
        case .connectionLost(let needsTokenUpdate):
            LOG.D("Connection lost")
            
            self.updateConnectionView(connected: false)
            
            if needsTokenUpdate {
                CarKit.socketService.update(reconnectManually: false)
            }
        }
    }
    
    private func updateConnectionView(connected: Bool) {

        self.buttonConnect.isEnabled = connected == false
        self.buttonDisconnect.isEnabled = connected
        self.labelConnectionState.text = connected ? "Connected" : "Not connected"
    }
    
    private func updateDoorLockState(doorLockStatus: DoorLockOverallStatus?) {
        
        guard CarKit.selectedVehicle != nil,
            let doorLockStatus = doorLockStatus else {
                return
        }
        
        self.buttonLockDoor.isEnabled = doorLockStatus == .unlocked
        self.buttonUnlockDoor.isEnabled = doorLockStatus == .locked
        self.labelDoorLockingState.text = doorLockStatus.toString
    }
    
    private func updateTankLevel(_ model: VehicleTankModel) {
        
        self.labelFuelTank.text = self.toString(double: model.gasLevel.value)
        self.labelLiquidTank.text = self.toString(int: model.liquidLevel.value)
        self.labelEelectricTank.text = self.toString(int: model.electricLevel.value)
    }
    
    private func toString(double: Double?) -> String? {
        
        guard let double = double else {
            return "-"
        }
        return "\(double)"
    }

    private func toString(int: Int?) -> String {
        
        guard let int = int else {
            return "-"
        }
        return "\(int)"
    }
}
