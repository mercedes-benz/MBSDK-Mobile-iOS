//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import XCTest
import OHHTTPStubs
import MBNetworkKit

@testable import MBMobileSDK

class VehicleServiceIntegrationTests: XCTestCase {

    private struct Constants {
        static let vin: String = "WDD1770871Z000099"
        static let pin: String = "1234"
        static let locale: String = "en_GB"
        static let bookingId: String = "booking_id"
        static let profileId: VehicleProfileID = "profile_id"
        static let dealerId: String = "dealer_id"
        static let dealerRole: DealerRole = .sales
        static let consumptionFile = "consumption_success.json"
        static let pinSyncStateFile = "pin_sync_state_success.json"
        static let profileStateFile = "profile_sync_state_success.json"
        static let avpReservationStatusFile = "avp_reservation_status_success.json"
    }

	private let networkService: Networking = NetworkService()
	private lazy var vehicleService: VehicleServiceRepresentable = {
		return VehicleService(networking: self.networkService,
							  userManagementService: UserManagementService(networking: self.networkService),
							  tokenProviding: MockTokenProvider(),
							  localeProvider: MockLocaleProviding(),
							  dbCommandCapabilitiesStore: CommandCapabilitiesDbStore(),
							  dbUserManagementStore: UserManagementDbStore(config: MockRealmConfiguration()),
							  dbVehicleSelectionStore: VehicleSelectionDbStore(config: MockRealmConfiguration()),
							  dbVehicleStore: VehicleDbStore(config: MockRealmConfiguration()))
	}()
	
	
    // MARK: - Setup

    override func setUp() {
		
        CarKit.tokenProvider = MockTokenProvider()
        CarKit.bffProvider = MockBffProvider()
        CarKit.pinProvider = MockPinProvider()

        HTTPStubs.onStubActivation { (request: URLRequest, stub: HTTPStubsDescriptor, response: HTTPStubsResponse) in
            print("[OHHTTPStubs] Request to \(request.url!) has been stubbed with \(String(describing: stub.name))")
        }
    }

    // MARK: - Tests

    func testAutomaticValetParking() {
		
        let acceptModel = AcceptAVPDriveModel(bookingId: Constants.bookingId, startDrive: true)
		self.installValetParkingStub(withAcceptModel: acceptModel, shouldFail: false)

		let expectation = XCTestExpectation(description: "Post automatic valet parking")
		
		self.vehicleService.automaticValetParking(finOrVin: Constants.vin, requestModel: acceptModel) { parkingCompletion in
			
            switch (parkingCompletion) {
            case .failure(_):
                XCTFail()
				
            case .success:
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 3.0)
    }

    func testAutomaticValetParkingFailure() {
		
        let acceptModel = AcceptAVPDriveModel(bookingId: Constants.bookingId, startDrive: true)
		self.installValetParkingStub(withAcceptModel: acceptModel, shouldFail: true)

        let expectation = XCTestExpectation(description: "Error automatic valet parking")

		self.vehicleService.automaticValetParking(finOrVin: Constants.vin, requestModel: acceptModel) { parkingCompletion in
			
            switch (parkingCompletion) {
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
				
            case .success:
                XCTFail()
            }
        }

        wait(for: [expectation], timeout: 3.0)
    }
    
    func testAutomatedValetParkingReservationStatus() {
        // constants
        let mockReservationIds = ["abcde12345678", "xyz9876543210"]
        let mockEstimatedTime = ["2020-05-08 08:51:07 +0000", "2020-04-16 22:09:23 +0000"]
        let mockParkedLocation = ["Parkhaus 307, Benzstr. 18, Sindelfinden", "Smart Area, Mercedesweg 52, Böblingen"]
        let mockErrorText = ["no error", "nothing here"]

        self.installAVPReservationStatusStub(with: mockReservationIds, shouldFail: false)
        
        let expectation = XCTestExpectation(description: "Get reservation status for automated valet parking")
        
        self.vehicleService.avpReservationStatus(finOrVin: Constants.vin, reservationIds: mockReservationIds) { reservationStatusResult in
            switch (reservationStatusResult) {
            case .failure(let error):
                LOG.D(error.localizedDescription)
                XCTFail()
				
            case.success(let models):
                // check array count
                XCTAssertEqual(models.count, 2)
                
                //check first model data
                let firstModel = models.first
                XCTAssertNotNil(firstModel)
                XCTAssertEqual(firstModel?.reservationId, mockReservationIds.first!)
                XCTAssertEqual(firstModel?.driveType, AutomaticValetParkingDriveType.pickUp)
                XCTAssertEqual(firstModel?.driveStatus, AutomatedValetParkingDriveStatus.ready)
                XCTAssertEqual(firstModel?.errorIds?.first, mockErrorText.first!)
                XCTAssertEqual(firstModel?.estimatedTimeOfArrival?.description, mockEstimatedTime.first!)
                XCTAssertEqual(firstModel?.parkedLocation, mockParkedLocation.first!)
                
                //check second model data
                let secondModel = models.last
                XCTAssertNotNil(secondModel)
                XCTAssertEqual(secondModel?.reservationId, mockReservationIds.last!)
                XCTAssertEqual(secondModel?.driveType, AutomaticValetParkingDriveType.dropOff)
                XCTAssertEqual(secondModel?.driveStatus, AutomatedValetParkingDriveStatus.completed)
                XCTAssertEqual(secondModel?.errorIds?.first, mockErrorText.last!)
                XCTAssertEqual(secondModel?.estimatedTimeOfArrival?.description, mockEstimatedTime.last!)
                XCTAssertEqual(secondModel?.parkedLocation, mockParkedLocation.last!)
                
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testAutomatedValetParkingReservationStatusFailure() {
        let mockReservationIds = ["abcde12345678"]
        self.installAVPReservationStatusStub(with: mockReservationIds, shouldFail: true)
        
        let expectation = XCTestExpectation(description: "Erro reservation status for automated valet parking")
        
        self.vehicleService.avpReservationStatus(finOrVin: Constants.vin, reservationIds: mockReservationIds) { reservationStatusResult in
            switch (reservationStatusResult) {
                case .failure(let error):
                    XCTAssertNotNil(error)
                    expectation.fulfill()
                    
                case .success:
                    XCTFail()
            }
        }
        
        wait(for: [expectation], timeout: 3.0)
    }

    func testQrCodeInviteForVehicle() {
		
		self.installQrCodeInviteStub(shouldFail: false)
        let expectation = XCTestExpectation(description: "Post QR code invite")

		self.vehicleService.qrCodeInviteForVehicle(finOrVin: Constants.vin, profileId: Constants.profileId) { inviteCompletion in
			
			switch (inviteCompletion) {
			case .failure(_):
				XCTFail()
			
			case .success(let data):
				XCTAssertNotNil(data)
				expectation.fulfill()
			}
		}

        wait(for: [expectation], timeout: 3.0)
    }

    func testQrCodeInviteForVehicleFailure() {
		
		self.installQrCodeInviteStub(shouldFail: true)
        let expectation = XCTestExpectation(description: "Error QR code invite")

		self.vehicleService.qrCodeInviteForVehicle(finOrVin: Constants.vin, profileId: Constants.profileId) { inviteCompletion in
			
			switch (inviteCompletion) {
            case .failure(let error):
				XCTAssertNotNil(error)
				expectation.fulfill()
				
			case .success(_):
				XCTFail()
			}
		}

        wait(for: [expectation], timeout: 3.0)
    }

    func testFetchConsumption() {
		
		self.installConsumptionStub(shouldFail: false)
        let expectation = XCTestExpectation(description: "Get consumption")
		
		self.vehicleService.fetchConsumption(finOrVin: Constants.vin) { consumptionResult in
			
            switch (consumptionResult) {
            case .failure(_):
                XCTFail()
				
            case .success(let model):
                XCTAssertNotNil(model)

                let averageConsumption = model.averageConsumption
                XCTAssertNotNil(averageConsumption)
                XCTAssertEqual(averageConsumption?.changed, true)
                XCTAssertEqual(averageConsumption?.unit, ConsumptionUnit.kilometersPerLiter)
                XCTAssertEqual(averageConsumption?.value, 1.23)

                let consumptionData = model.consumptionData
                XCTAssertNotNil(consumptionData)
                XCTAssertEqual(consumptionData?.changed, false)
                let consumptionDataValue = consumptionData?.value
                XCTAssertNotNil(consumptionDataValue)
                XCTAssertEqual(consumptionDataValue?.count, 1)
                let firstConsumptionValue = consumptionDataValue?.first
                XCTAssertEqual(firstConsumptionValue?.consumption, 3.33)
                XCTAssertEqual(firstConsumptionValue?.group, 23)
                XCTAssertEqual(firstConsumptionValue?.percentage, 0.77)
                XCTAssertEqual(firstConsumptionValue?.unit, ConsumptionUnit.litersPer100Km)

                let individual30DaysConsumption = model.individual30DaysConsumption
                XCTAssertNotNil(individual30DaysConsumption)
                XCTAssertEqual(individual30DaysConsumption?.lastUpdated, 1586338308)
                XCTAssertEqual(individual30DaysConsumption?.unit, ConsumptionUnit.kilometersPerLiter)
                XCTAssertEqual(individual30DaysConsumption?.value, 35.0)

                let individualLifetimeConsumption = model.individualLifetimeConsumption
                XCTAssertNotNil(individualLifetimeConsumption)
                XCTAssertEqual(individualLifetimeConsumption?.changed, true)
                XCTAssertEqual(individualLifetimeConsumption?.unit, ConsumptionUnit.litersPer100Km)
                XCTAssertEqual(individualLifetimeConsumption?.value, 12.5)

                let individualResetConsumption = model.individualResetConsumption
                XCTAssertNotNil(individualResetConsumption)
                XCTAssertEqual(individualResetConsumption?.changed, false)
                XCTAssertEqual(individualResetConsumption?.unit, ConsumptionUnit.litersPer100Km)
                XCTAssertEqual(individualResetConsumption?.value, 9.5)

                let individualStartConsumption = model.individualStartConsumption
                XCTAssertNotNil(individualStartConsumption)
                XCTAssertEqual(individualStartConsumption?.changed, true)
                XCTAssertEqual(individualStartConsumption?.unit, ConsumptionUnit.litersPer100Km)
                XCTAssertEqual(individualStartConsumption?.value, 11.1)

                let wltpCombined = model.wltpCombined
                XCTAssertNotNil(wltpCombined)
                XCTAssertEqual(wltpCombined?.changed, true)
                XCTAssertEqual(wltpCombined?.unit, ConsumptionUnit.litersPer100Km)
                XCTAssertEqual(wltpCombined?.value, 10.3)

                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 3.0)
    }

    func testFetchConsumptionFailure() {
		
		self.installConsumptionStub(shouldFail: true)
        let expectation = XCTestExpectation(description: "Error consumption")
		
		self.vehicleService.fetchConsumption(finOrVin: Constants.vin) { consumptionResult in
			
            switch (consumptionResult) {
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
				
            case .success(_):
                XCTFail()
            }
        }

        wait(for: [expectation], timeout: 3.0)
    }

    func testResetDamageDetection() {
		
		self.installResetDamageDetectionStub(shouldFail: false)
        let expectation = XCTestExpectation(description: "Delete damage detection")

		self.vehicleService.resetDamageDetection(finOrVin: Constants.vin) { damageCompletion in
			
            switch (damageCompletion) {
            case .failure(_):
                XCTFail()
				
            case .success:
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 3.0)
    }

    func testResetDamageDetectionFailure() {
		
        self.installResetDamageDetectionStub(shouldFail: true)
        let expectation = XCTestExpectation(description: "Error damage detection")

        self.vehicleService.resetDamageDetection(finOrVin: Constants.vin) { damageCompletion in
			
            switch (damageCompletion) {
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
				
            case .success:
                XCTFail()
            }
        }

        wait(for: [expectation], timeout: 3.0)
    }

    func testPinSyncState() {
		
        self.installPinSyncStateStub(shouldFail: false)
        let expectation = XCTestExpectation(description: "Get pin sync state")

        self.vehicleService.getPinSyncState(finOrVin: Constants.vin) { pinSyncStatusCompletion in
			
            switch (pinSyncStatusCompletion) {
            case .failure(_):
                XCTFail()
            case .success(let pinSyncStatus):
                XCTAssertNotNil(pinSyncStatus)
                XCTAssertEqual(pinSyncStatus, PinSyncStatus.pending)

                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 3.0)
    }

    func testPinSyncStateFailure() {
		
        self.installPinSyncStateStub(shouldFail: true)
        let expectation = XCTestExpectation(description: "Error pin sync state")

        self.vehicleService.getPinSyncState(finOrVin: Constants.vin) { pinSyncStatusCompletion in
			
            switch (pinSyncStatusCompletion) {
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
				
            case .success(_):
                XCTFail()
            }
        }

        wait(for: [expectation], timeout: 3.0)
    }
    
    func testProfileSyncState() {
        
        self.installProfileSyncStateStub(shouldFail: false)
        let expectation = XCTestExpectation(description: "Get profile sync state")

        self.vehicleService.getProfileSyncState(finOrVin: Constants.vin) { profileSyncStatusCompletion in
            
            switch (profileSyncStatusCompletion) {
            case .failure(_):
                XCTFail()
            case .success(let profileSyncStatus):
                XCTAssertNotNil(profileSyncStatus)
                XCTAssertEqual(profileSyncStatus, ProfileSyncStatus.manageInHeadUnit)

                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 3.0)
    }

    func testProfileSyncStateFailure() {
        
        self.installProfileSyncStateStub(shouldFail: true)
        let expectation = XCTestExpectation(description: "Error profile sync state")

        self.vehicleService.getProfileSyncState(finOrVin: Constants.vin) { profileSyncStatusCompletion in
            
            switch (profileSyncStatusCompletion) {
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
                
            case .success(_):
                XCTFail()
            }
        }

        wait(for: [expectation], timeout: 3.0)
    }

    func testPreferredDealerUpdate() {
		
        var preferredDealers = [VehicleDealerUpdateModel]()
        let preferredDealer = VehicleDealerUpdateModel(dealerId: Constants.dealerId, role: Constants.dealerRole)
        preferredDealers.append(preferredDealer)

        self.installPreferredDealerUpdateStub(withPreferredDealers: preferredDealers, shouldFail: false)

        let expectation = XCTestExpectation(description: "Put preferred dealers")

        self.vehicleService.updatePreferredDealer(finOrVin: Constants.vin, preferredDealers: preferredDealers) { updateCompletion in
			
			switch (updateCompletion) {
			case .failure(_):
				XCTFail()
			
			case .success:
				expectation.fulfill()
			}
		}

        wait(for: [expectation], timeout: 3.0)
    }

    func testPreferredDealerUpdateFailure() {
		
        var preferredDealers = [VehicleDealerUpdateModel]()
        let preferredDealer = VehicleDealerUpdateModel(dealerId: Constants.dealerId, role: Constants.dealerRole)
        preferredDealers.append(preferredDealer)

        self.installPreferredDealerUpdateStub(withPreferredDealers: preferredDealers, shouldFail: true)

        let expectation = XCTestExpectation(description: "Error preferred dealers")

        self.vehicleService.updatePreferredDealer(finOrVin: Constants.vin, preferredDealers: preferredDealers) { updateCompletion in
			
			switch (updateCompletion) {
			case .failure(let error):
				XCTAssertNotNil(error)
				expectation.fulfill()
			
			case .success:
				XCTFail()
			}
		}

        wait(for: [expectation], timeout: 3.0)
    }

	
    // MARK: - Helpers

    private func installValetParkingStub(withAcceptModel acceptModel: AcceptAVPDriveModel, shouldFail: Bool) {
		
        let message = shouldFail ? "Failed" : "Completed"
        let stubData = message.data(using: String.Encoding.utf8)

        let json = try? acceptModel.toJson()
        let requestDict = json as? [String: Any]

        let accessToken = MockToken().accessToken

        let mock: HTTPStubsDescriptor = stub(condition: pathEndsWith(
            BffVehicleRouter.automaticValetParking(accessToken: accessToken, vin: Constants.vin,
                requestModel: requestDict).path)) { _ in
            let statusCode: Int32 = shouldFail ? 400 : 201
            return HTTPStubsResponse(data: stubData!, statusCode: statusCode, headers: nil)
                .requestTime(0.0, responseTime: OHHTTPStubsDownloadSpeedWifi)
        }

        mock.name = "ValetParkingStub"
    }

    private func installAVPReservationStatusStub(with reservationIds: [String], shouldFail: Bool) {
        
        let stubPath = OHPathForFile(Constants.avpReservationStatusFile, type(of: self))
        let accessToken = MockToken().accessToken
        
        let mock: HTTPStubsDescriptor = stub(condition: pathEndsWith(BffVehicleRouter.automaticValetParkingReservationStatus(accessToken: accessToken, vin: Constants.vin, reservationIds: reservationIds).path)) { _ in
            let statusCode: Int32 = shouldFail ? 400 : 200
            return fixture(filePath: stubPath!, status: statusCode, headers: nil)
                .requestTime(0.0, responseTime: OHHTTPStubsDownloadSpeedWifi)
        }

        mock.name = Constants.avpReservationStatusFile
        
    }
    
    private func installQrCodeInviteStub(shouldFail: Bool) {
		
        let message = shouldFail ? "Failed" : "Completed"
        let stubData = message.data(using: String.Encoding.utf8)
        let accessToken = MockToken().accessToken

        let mock: HTTPStubsDescriptor = stub(condition: isPath(
            BffUserManagementRouter.inviteQR(accessToken: accessToken, vin: Constants.vin,
                profileId: Constants.profileId).path)) { _ in
            let statusCode: Int32 = shouldFail ? 400 : 201
            return HTTPStubsResponse(data: stubData!, statusCode: statusCode, headers: nil)
                .requestTime(0.0, responseTime: OHHTTPStubsDownloadSpeedWifi)
        }

        mock.name = "QrCodeInviteStub"
    }

    private func installConsumptionStub(shouldFail: Bool) {
		
        let stubPath = OHPathForFile(Constants.consumptionFile, type(of: self))
        let accessToken = MockToken().accessToken

        let mock: HTTPStubsDescriptor = stub(
            condition: pathEndsWith(
                BffVehicleRouter.consumption(accessToken: accessToken, vin: Constants.vin).path)) { _ in
            let statusCode: Int32 = shouldFail ? 400 : 200
            return fixture(filePath: stubPath!, status: statusCode, headers: nil)
                .requestTime(0.0, responseTime: OHHTTPStubsDownloadSpeedWifi)
        }

        mock.name = Constants.consumptionFile
    }

    private func installResetDamageDetectionStub(shouldFail: Bool) {
		
        let stubData = Data()
        let accessToken = MockToken().accessToken

        let mock: HTTPStubsDescriptor = stub(condition: isPath(
            BffVehicleRouter.resetDamageDetection(accessToken: accessToken, vin: Constants.vin,
                pin: Constants.pin).path)) { _ in
            let statusCode: Int32 = shouldFail ? 400 : 204
            return HTTPStubsResponse(data: stubData, statusCode: statusCode, headers: nil)
                .requestTime(0.0, responseTime: OHHTTPStubsDownloadSpeedWifi)
        }

        mock.name = "ResetDamageDetectionStub"
    }

    private func installPinSyncStateStub(shouldFail: Bool) {
		
        let stubPath = OHPathForFile(Constants.pinSyncStateFile, type(of: self))
        let accessToken = MockToken().accessToken

        let mock: HTTPStubsDescriptor = stub(condition: isPath(
            BffUserManagementRouter.syncState(accessToken: accessToken, vin: Constants.vin).path)) { _ in
            let statusCode: Int32 = shouldFail ? 400 : 200
            return fixture(filePath: stubPath!, status: statusCode, headers: nil)
                .requestTime(0.0, responseTime: OHHTTPStubsDownloadSpeedWifi)
        }

        mock.name = Constants.pinSyncStateFile
    }
    
    private func installProfileSyncStateStub(shouldFail: Bool) {
        
        let stubPath = OHPathForFile(Constants.profileStateFile, type(of: self))
        let accessToken = MockToken().accessToken
        
        let mock: HTTPStubsDescriptor = stub(condition: isPath(
            BffUserManagementRouter.profileSyncState(accessToken: accessToken, vin: Constants.vin).path)) { _ in
                let statusCode: Int32 = shouldFail ? 400 : 200
                return fixture(filePath: stubPath!, status: statusCode, headers: nil)
                    .requestTime(0.0, responseTime: OHHTTPStubsDownloadSpeedWifi)
        }
        
        mock.name = Constants.profileStateFile
    }

    private func installPreferredDealerUpdateStub(withPreferredDealers preferredDealers: [VehicleDealerUpdateModel], shouldFail: Bool) {
		
        let message = shouldFail ? "Failed" : "Updated"
        let stubData = message.data(using: String.Encoding.utf8)

        let apiModels = NetworkModelMapper.map(dealerUpdateModels: preferredDealers)
        let json = try? apiModels.toJson()
        let requestDict = json as? [[String: Any]]

        let accessToken = MockToken().accessToken

        let mock: HTTPStubsDescriptor = stub(condition: isPath(
            BffVehicleRouter.dealersPreferred(accessToken: accessToken, vin: Constants.vin,
                requestModel: requestDict).path)) { _ in
            let statusCode: Int32 = shouldFail ? 400 : 201
            return HTTPStubsResponse(data: stubData!, statusCode: statusCode, headers: nil)
                .requestTime(0.0, responseTime: OHHTTPStubsDownloadSpeedWifi)
        }

        mock.name = "PreferredDealerUpdateStub"
    }
}
