//
//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Quick
import Nimble
import MBCommonKit
import MBNetworkKit
@testable import MBMobileSDK

class SendToCarServiceV2Tests: QuickSpec {

    override func spec() {
        var networking: MockNetworking!
        var tokenProviding: MockTokenProviding!
        var dbStore: MockS2CCapabilitiesDbStore!
        var trackingManager: MockTrackingManager!
        var capabilityBuilding: SendToCarCapabilitiesModelBuilder!
        var optionsBuilding: SendToCarOptionsBuilder!
        var notificationSending: MockS2CNotificationSending!
        var bluetoothProviding: MockBluetoothProviding!
        var subject: SendToCarServiceV2Representable!
        
        beforeEach {
            networking = MockNetworking()
            tokenProviding = MockTokenProviding()
            dbStore = MockS2CCapabilitiesDbStore()
            trackingManager = MockTrackingManager()
            capabilityBuilding = SendToCarCapabilitiesModelBuilder()
            optionsBuilding = SendToCarOptionsBuilder()
            notificationSending = MockS2CNotificationSending()
            bluetoothProviding = MockBluetoothProviding()
            
            subject = SendToCarServiceV2(networking: networking, tokenProviding: tokenProviding, dbStore: dbStore, trackingManager: trackingManager, capabilityBuilding: capabilityBuilding, optionsBuilding: optionsBuilding, notificationSending: notificationSending, bluetoothProviding: bluetoothProviding)
        }
        
        context("fetchCapabilities") {
            describe("when token refresh fails") {
                it("should return with appropriate error") {
                    tokenProviding.token = nil
					subject.fetchCapabilities(finOrVin: "aVin") { result in
                        switch result {
                        case .success:
                            fail()
                        case .failure(let error):
                            switch error {
                            case .token:
                                success()
                            default:
                                fail()
                            }
                        }
                    }
                }
            }
            
            describe("when network request fails and there are no cached capabilities") {
                it("should return with appropriate error") {
                    let networkError = MBError(description: nil, type: MBErrorType.network(.timeOut(description: nil)))
                    let mockedReturn: ((EndpointRouter) -> (model: APISendToCarCapabilitiesModel?, error: MBError?)) = { _ in (nil, networkError) }
                    networking.onRequest = mockedReturn
                    
                    subject.fetchCapabilities(finOrVin: "aVin") { result in
                        switch result {
                        case .success:
                            fail()
                        case .failure(let error):
                            switch error {
                            case .network:
                                success()
                            default:
                                fail()
                            }
                        }
                    }
                }
            }
            
            describe("when network request fails and there are cached capabilities") {
                it("should return with capabilities from cache") {
                    let networkError = MBError(description: nil, type: MBErrorType.network(.timeOut(description: nil)))
                    let mockedReturn: ((EndpointRouter) -> (model: APISendToCarCapabilitiesModel?, error: MBError?)) = { _ in (nil, networkError) }
                    networking.onRequest = mockedReturn
                    
                    let cachedCapabilities = SendToCarCapabilitiesModel(capabilities: [SendToCarCapability.dynamicRouteBackend], finOrVin: "aVin", preconditions: [])
                    
                    dbStore.item = cachedCapabilities
                    
                    subject.fetchCapabilities(finOrVin: "aVin") { result in
                        switch result {
                        case .success(let capabilities):
                            expect(capabilities).to(equal(cachedCapabilities))
                        case .failure:
                            fail()
                        }
                    }
                }
            }
            
            describe("when network request succeeds and fetched capabilities are same as cached capabilities") {
                it("should return those capabilities and not update DB and not send notification") {
                    let model = APISendToCarCapabilitiesModel(capabilities: [SendToCarCapability.dynamicRouteBackend.rawValue], preconditions: [SendToCarPrecondition.enableMBApps.rawValue])
                    
                    let mockedReturn: ((EndpointRouter) -> (model: APISendToCarCapabilitiesModel?, error: MBError?)) = { _ in (model, nil) }
                    networking.onRequest = mockedReturn
                    
                    let cachedCapabilities = SendToCarCapabilitiesModel(capabilities: [SendToCarCapability.dynamicRouteBackend], finOrVin: "aVin", preconditions: [SendToCarPrecondition.enableMBApps])
                    
                    dbStore.item = cachedCapabilities
                    
                    subject.fetchCapabilities(finOrVin: "aVin") { result in
                        switch result {
                        case .success(let capabilities):
                            expect(capabilities) == cachedCapabilities
                            
                            expect(notificationSending.didSendNotification) != true
                            expect(dbStore.didSave) == false
                        case .failure:
                            fail()
                        }
                    }
                }
            }
            
            describe("when network request succeeds and fetched capabilities are not same as cached capabilities") {
                it("should return those capabilities and update DB and send notification") {
                    let model = APISendToCarCapabilitiesModel(capabilities: [SendToCarCapability.dynamicRouteBackend.rawValue], preconditions: [SendToCarPrecondition.enableMBApps.rawValue])

                    let mockedReturn: ((EndpointRouter) -> (model: APISendToCarCapabilitiesModel?, error: MBError?)) = { _ in (model, nil) }
                    networking.onRequest = mockedReturn

                    let cachedCapabilities = SendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBluetooth], finOrVin: "aVin", preconditions: [])

                    dbStore.item = cachedCapabilities

                    subject.fetchCapabilities(finOrVin: "aVin") { result in
                        switch result {
                        case .success(let capabilities):
                            expect(capabilities) != cachedCapabilities
                            expect(notificationSending.didSendNotification) == true
                            expect(dbStore.didSave) == true
                        case .failure:
                            fail()
                        }
                    }
                }
            }
        }
        
        context("sendPOIOrRoute BT") {
            
            describe("when no waypoints are supplied") {
                it("should return with appropriate error") {
                    let routeModel = SendToCarRouteModel(routeType: .singlePOI, waypoints: [])
                    let cachedCapabilities = SendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBluetooth, SendToCarCapability.singlePoiBackend], finOrVin: "aVin", preconditions: [])
                    dbStore.item = cachedCapabilities
                    
                    let capabilities = APISendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBluetooth.rawValue], preconditions: [SendToCarPrecondition.enableMBApps.rawValue])
                    let mockedReturn: ((EndpointRouter) -> (model: APISendToCarCapabilitiesModel?, error: MBError?)) = { _ in (capabilities, nil) }
                    networking.onRequest = mockedReturn
                    
                    subject.sendPoiOrRoute(finOrVin: "aVin", routeModel: routeModel, completion: { result in
                        switch result {
                        case .failure(let error):
                            switch error {
                            case .noWaypointsSupplied:
                                success()
                            default:
                                fail()
                            }
                        case .success:
                            fail()
                        }
                    })
                    
                    // silent capability update
                    expect(dbStore.item).toEventually(equal(capabilityBuilding.build(bluetoothProviding: bluetoothProviding, apiModel: capabilities, for: "aVin")))
                    expect(notificationSending.didSendNotification).toEventually(beTrue())
                }
            }
            
            describe("S2C BT while connected to vehicle with correct VIN") {
                it("should send over bluetooth") {
                    let routeModel = SendToCarRouteModel(routeType: .singlePOI, waypoints: [SendToCarWaypointModel(latitude: 10.0, longitude: 10.0)])
                    let cachedCapabilities = SendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBluetooth], finOrVin: "aVin", preconditions: [])
                    dbStore.item = cachedCapabilities
                    
                    let capabilities = APISendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBluetooth.rawValue], preconditions: [SendToCarPrecondition.enableMBApps.rawValue])
                    let mockedReturn: ((EndpointRouter) -> (model: APISendToCarCapabilitiesModel?, error: MBError?)) = { _ in (capabilities, nil) }
                    networking.onRequest = mockedReturn
                    
                    bluetoothProviding.connectionStatus = .connected
                    bluetoothProviding.connectedFinOrVin = "aVin"
                    bluetoothProviding.bluetoothSendResult = .success
                    
                    subject.sendPoiOrRoute(finOrVin: "aVin", routeModel: routeModel, completion: { result in
                        switch result {
                        case .failure:
                            fail()
                        case .success:
                            success()
                        }
                    })
                    
                    // silent capability update
                    expect(dbStore.item).toEventually(equal(capabilityBuilding.build(bluetoothProviding: bluetoothProviding, apiModel: capabilities, for: "aVin")))
                    expect(notificationSending.didSendNotification).toEventually(beTrue())
                }
                
                it("return appropriate error when bluetooth sending fails") {
                    let routeModel = SendToCarRouteModel(routeType: .singlePOI, waypoints: [SendToCarWaypointModel(latitude: 10.0, longitude: 10.0)])
                    let cachedCapabilities = SendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBluetooth], finOrVin: "aVin", preconditions: [])
                    dbStore.item = cachedCapabilities
                    
                    let capabilities = APISendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBluetooth.rawValue], preconditions: [SendToCarPrecondition.enableMBApps.rawValue])
                    let mockedReturn: ((EndpointRouter) -> (model: APISendToCarCapabilitiesModel?, error: MBError?)) = { _ in (capabilities, nil) }
                    networking.onRequest = mockedReturn
                    
                    bluetoothProviding.connectionStatus = .connected
                    bluetoothProviding.connectedFinOrVin = "aVin"
                    bluetoothProviding.bluetoothSendResult = .failure(nil)
                    
                    subject.sendPoiOrRoute(finOrVin: "aVin", routeModel: routeModel, completion: { result in
                        switch result {
                        case .failure(let error):
                            switch error {
                            case .sendViaBluetoothFailed:
                                success()
                            default:
                                fail()
                            }
                        case .success:
                            fail()
                        }
                    })
                    
                    // silent capability update
                    expect(dbStore.item).toEventually(equal(capabilityBuilding.build(bluetoothProviding: bluetoothProviding, apiModel: capabilities, for: "aVin")))
                    expect(notificationSending.didSendNotification).toEventually(beTrue())
                }
            }
            
            describe("S2C BT only while connected to vehicle with correct VIN") {
                it("should send over bluetooth to correct VIN") {
                    let routeModel = SendToCarRouteModel(routeType: .singlePOI, waypoints: [SendToCarWaypointModel(latitude: 10.0, longitude: 10.0)])
                    let cachedCapabilities = SendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBluetooth], finOrVin: "aVin", preconditions: [])
                    dbStore.item = cachedCapabilities
                    
                    let capabilities = APISendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBluetooth.rawValue], preconditions: [SendToCarPrecondition.enableMBApps.rawValue])
                    let mockedReturn: ((EndpointRouter) -> (model: APISendToCarCapabilitiesModel?, error: MBError?)) = { _ in (capabilities, nil) }
                    networking.onRequest = mockedReturn
                    
                    bluetoothProviding.connectionStatus = .connected
                    bluetoothProviding.connectedFinOrVin = "aVin"
                    bluetoothProviding.bluetoothSendResult = .success
                    
                    subject.sendPoiOrRoute(finOrVin: "aVin", routeModel: routeModel, completion: { result in
                        switch result {
                        case .failure:
                            fail()
                        case .success:
                            success()
                        }
                    })
                    
                    // silent capability update
                    expect(dbStore.item).toEventually(equal(capabilityBuilding.build(bluetoothProviding: bluetoothProviding, apiModel: capabilities, for: "aVin")))
                    expect(notificationSending.didSendNotification).toEventually(beTrue())
                }
                
                it("should not send over bluetooth to wrong vehicle") {
                    let routeModel = SendToCarRouteModel(routeType: .singlePOI, waypoints: [SendToCarWaypointModel(latitude: 10.0, longitude: 10.0)])
                    let cachedCapabilities = SendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBluetooth], finOrVin: "aVin", preconditions: [])
                    dbStore.item = cachedCapabilities
                    
                    let capabilities = APISendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBluetooth.rawValue], preconditions: [SendToCarPrecondition.enableMBApps.rawValue])
                    let mockedReturn: ((EndpointRouter) -> (model: APISendToCarCapabilitiesModel?, error: MBError?)) = { _ in (capabilities, nil) }
                    networking.onRequest = mockedReturn
                    
                    bluetoothProviding.connectionStatus = .connected
                    bluetoothProviding.connectedFinOrVin = "anotherVin"
                    
                    subject.sendPoiOrRoute(finOrVin: "aVin", routeModel: routeModel, completion: { result in
                        switch result {
                        case .failure(let error):
                            switch error {
                            case .sendViaBluetoothFailed(_):
                                success()
                            default:
                                fail()
                            }
                            
                        case .success:
                            fail()
                        }
                    })
                    
                    // silent capability update
                    expect(dbStore.item).toEventually(equal(capabilityBuilding.build(bluetoothProviding: bluetoothProviding, apiModel: capabilities, for: "aVin")))
                    expect(notificationSending.didSendNotification).toEventually(beTrue())
                }
            }
        }
        
        context("sendPOIOrRoute BT and Backend") {
            
            describe("S2C while connected to VIN but bluetooth sending fails") {
                it("should send with backend fallback") {
                    let routeModel = SendToCarRouteModel(routeType: .singlePOI, waypoints: [SendToCarWaypointModel(latitude: 10.0, longitude: 10.0)])
                    let cachedCapabilities = SendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBluetooth, SendToCarCapability.singlePoiBackend], finOrVin: "aVin", preconditions: [])
                    dbStore.item = cachedCapabilities

                    let capabilities = APISendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBluetooth.rawValue], preconditions: [SendToCarPrecondition.enableMBApps.rawValue])
                    let mockedReturn: ((EndpointRouter) -> (model: APISendToCarCapabilitiesModel?, error: MBError?)) = { _ in (capabilities, nil) }
                    networking.onRequest = mockedReturn
                    
                    networking.onDataRequest = { _ in (Data(), nil) }

                    bluetoothProviding.connectionStatus = .connected
                    bluetoothProviding.connectedFinOrVin = "aVin"
                    bluetoothProviding.bluetoothSendResult = .failure(nil)

                    subject.sendPoiOrRoute(finOrVin: "aVin", routeModel: routeModel, completion: { result in
                        switch result {
                        case .failure:
                            fail()
                        case .success:
                            success()
                        }
                    })
                    
                    // silent capability update
                    expect(dbStore.item).toEventually(equal(capabilityBuilding.build(bluetoothProviding: bluetoothProviding, apiModel: capabilities, for: "aVin")))
                    expect(notificationSending.didSendNotification).toEventually(beTrue())
                }
            }
            
            describe("S2C BT while connected to vehicle with another VIN") {
                it("should return with appropriate error when S2C over backend fails") {
                    let routeModel = SendToCarRouteModel(routeType: .singlePOI, waypoints: [SendToCarWaypointModel(latitude: 10.0, longitude: 10.0)])
                    let cachedCapabilities = SendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBluetooth, SendToCarCapability.singlePoiBackend], finOrVin: "aVin", preconditions: [])
                    dbStore.item = cachedCapabilities

                    let capabilities = APISendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBluetooth.rawValue], preconditions: [SendToCarPrecondition.enableMBApps.rawValue])
                    let mockedReturn: ((EndpointRouter) -> (model: APISendToCarCapabilitiesModel?, error: MBError?)) = { _ in (capabilities, nil) }
                    networking.onRequest = mockedReturn
                    
                    let networkError = MBError(description: nil, type: MBErrorType.network(.timeOut(description: nil)))
                    networking.onDataRequest = { _ in (nil, networkError) }

                    bluetoothProviding.connectionStatus = .connected
                    bluetoothProviding.connectedFinOrVin = "anotherVIN"

                    subject.sendPoiOrRoute(finOrVin: "aVin", routeModel: routeModel, completion: { result in
                        switch result {
                        case .failure(let error):
                            switch error {
                            case .sendViaBackendFailed(_):
                                success()
                            default:
                                fail()
                            }
                        case .success:
                            fail()
                        }
                    })
                    
                    // silent capability update
                    expect(dbStore.item).toEventually(equal(capabilityBuilding.build(bluetoothProviding: bluetoothProviding, apiModel: capabilities, for: "aVin")))
                    expect(notificationSending.didSendNotification).toEventually(beTrue())
                }
                
                it("should send over backend to other vehicle") {
                    let routeModel = SendToCarRouteModel(routeType: .singlePOI, waypoints: [SendToCarWaypointModel(latitude: 10.0, longitude: 10.0)])
                    let cachedCapabilities = SendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBluetooth, SendToCarCapability.singlePoiBackend], finOrVin: "aVin", preconditions: [])
                    dbStore.item = cachedCapabilities

                    let capabilities = APISendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBluetooth.rawValue], preconditions: [SendToCarPrecondition.enableMBApps.rawValue])
                    let mockedReturn: ((EndpointRouter) -> (model: APISendToCarCapabilitiesModel?, error: MBError?)) = { _ in (capabilities, nil) }
                    networking.onRequest = mockedReturn
                    
                    networking.onDataRequest = { _ in (Data(), nil) }

                    bluetoothProviding.connectionStatus = .connected
                    bluetoothProviding.connectedFinOrVin = "anotherVIN"

                    subject.sendPoiOrRoute(finOrVin: "aVin", routeModel: routeModel, completion: { result in
                        switch result {
                        case .failure:
                            fail()
                        case .success:
                            success()
                        }
                    })
                    
                    // silent capability update
                    expect(dbStore.item).toEventually(equal(capabilityBuilding.build(bluetoothProviding: bluetoothProviding, apiModel: capabilities, for: "aVin")))
                    expect(notificationSending.didSendNotification).toEventually(beTrue())
                }
            }
        }
        
        context("sendPOIOrRoute BE") {
            
            describe("when token refresh fails") {
                it("should exit with error") {
                    tokenProviding.token = nil
                    
                    let routeModel = SendToCarRouteModel(routeType: .singlePOI, waypoints: [SendToCarWaypointModel(latitude: 10.0, longitude: 10.0)])
                    let cachedCapabilities = SendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBackend], finOrVin: "aVin", preconditions: [])
                    dbStore.item = cachedCapabilities

                    subject.sendPoiOrRoute(finOrVin: "aVin", routeModel: routeModel, completion: { result in
                        switch result {
                        case .failure(let error):
                            switch error {
                            case .token:
                                success()
                            default:
                                fail()
                            }
                        case .success:
                            fail()
                        }
                    })
                    
                    expect(notificationSending.didSendNotification).toNotEventually(beTrue())
                }
            }
            
            describe("when BE returns with success") {
                it("should send over backend") {
                    let routeModel = SendToCarRouteModel(routeType: .singlePOI, waypoints: [SendToCarWaypointModel(latitude: 10.0, longitude: 10.0)])
                    let cachedCapabilities = SendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBackend], finOrVin: "aVin", preconditions: [])
                    dbStore.item = cachedCapabilities

                    let capabilities = APISendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBackend.rawValue], preconditions: [SendToCarPrecondition.enableMBApps.rawValue])
                    let mockedReturn: ((EndpointRouter) -> (model: APISendToCarCapabilitiesModel?, error: MBError?)) = { _ in (capabilities, nil) }
                    networking.onRequest = mockedReturn
                    
                    networking.onDataRequest = { _ in (Data(), nil) }

                    subject.sendPoiOrRoute(finOrVin: "aVin", routeModel: routeModel, completion: { result in
                        switch result {
                        case .failure:
                            fail()
                        case .success:
                            success()
                        }
                    })
                    
                    // silent capability update
                    expect(dbStore.item).toEventually(equal(capabilityBuilding.build(bluetoothProviding: bluetoothProviding, apiModel: capabilities, for: "aVin")))
                    expect(notificationSending.didSendNotification).toEventually(beTrue())
                }
            }
            
            describe("when BE returns with error") {
                it("should return appropriate error") {
                    let routeModel = SendToCarRouteModel(routeType: .singlePOI, waypoints: [SendToCarWaypointModel(latitude: 10.0, longitude: 10.0)])
                    let cachedCapabilities = SendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBackend], finOrVin: "aVin", preconditions: [])
                    dbStore.item = cachedCapabilities

                    let capabilities = APISendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBackend.rawValue], preconditions: [SendToCarPrecondition.enableMBApps.rawValue])
                    let mockedReturn: ((EndpointRouter) -> (model: APISendToCarCapabilitiesModel?, error: MBError?)) = { _ in (capabilities, nil) }
                    networking.onRequest = mockedReturn
                    
                    let networkError = MBError(description: nil, type: MBErrorType.network(.timeOut(description: nil)))
                    networking.onDataRequest = { _ in (nil, networkError) }

                    subject.sendPoiOrRoute(finOrVin: "aVin", routeModel: routeModel, completion: { result in
                        switch result {
                        case .failure(let error):
                            switch error {
                            case .sendViaBackendFailed(_):
                                success()
                            default:
                                fail()
                            }
                        case .success:
                            fail()
                        }
                    })
                    
                    // silent capability update
                    expect(dbStore.item).toEventually(equal(capabilityBuilding.build(bluetoothProviding: bluetoothProviding, apiModel: capabilities, for: "aVin")))
                    expect(notificationSending.didSendNotification).toEventually(beTrue())
                }
            }
        }
        
        context("no cached capabilities") {
            describe("no cached capabilities available") {
                it("should fetch capabilities first and then send route") {
                    let routeModel = SendToCarRouteModel(routeType: .singlePOI, waypoints: [])
                    
                    let capabilities = APISendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBluetooth.rawValue], preconditions: [SendToCarPrecondition.enableMBApps.rawValue])
                    let mockedReturn: ((EndpointRouter) -> (model: APISendToCarCapabilitiesModel?, error: MBError?)) = { _ in (capabilities, nil) }
                    networking.onRequest = mockedReturn
                    
                    subject.sendPoiOrRoute(finOrVin: "aVin", routeModel: routeModel, completion: { result in
                        switch result {
                        case .failure(let error):
                            switch error {
                            case .noWaypointsSupplied:
                                success()
                            default:
                                fail()
                            }
                        case .success:
                            fail()
                        }
                    })
                    
                    // silent capability update
                    expect(dbStore.item).toEventually(equal(capabilityBuilding.build(bluetoothProviding: bluetoothProviding, apiModel: capabilities, for: "aVin")))
                    expect(notificationSending.didSendNotification).toEventually(beTrue())
                }
            }
            
            describe("no cached capabilities available and BE request fails") {
                it("should fail with error") {
                    let routeModel = SendToCarRouteModel(routeType: .singlePOI, waypoints: [])
                    
                    let networkError = MBError(description: nil, type: MBErrorType.network(.timeOut(description: nil)))
                    let mockedReturn: ((EndpointRouter) -> (model: APISendToCarCapabilitiesModel?, error: MBError?)) = { _ in (nil, networkError) }
                    networking.onRequest = mockedReturn
                    
                    subject.sendPoiOrRoute(finOrVin: "aVin", routeModel: routeModel, completion: { result in
                        switch result {
                        case .failure(let error):
                            switch error {
                            case .noCapabilitiesAvailable:
                                success()
                            default:
                                fail()
                            }
                        case .success:
                            fail()
                        }
                    })
                    
                    expect(notificationSending.didSendNotification).toNotEventually(beTrue())
                }
            }
        }
        
        context("mbApps preconditions failures") {
            
            describe("when S2C over BE") {
                it("should return with error if there are preconditions") {
                    let routeModel = SendToCarRouteModel(routeType: .singlePOI, waypoints: [SendToCarWaypointModel(latitude: 10.0, longitude: 10.0)])
                    let cachedCapabilities = SendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBackend], finOrVin: "aVin", preconditions: [.enableMBApps, .registerUser])
                    dbStore.item = cachedCapabilities

                    let capabilities = APISendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBackend.rawValue], preconditions: [SendToCarPrecondition.enableMBApps.rawValue, SendToCarPrecondition.registerUser.rawValue])
                    let mockedReturn: ((EndpointRouter) -> (model: APISendToCarCapabilitiesModel?, error: MBError?)) = { _ in (capabilities, nil) }
                    networking.onRequest = mockedReturn
                    
                    networking.onDataRequest = { _ in (Data(), nil) }

                    subject.sendPoiOrRoute(finOrVin: "aVin", routeModel: routeModel, completion: { result in
                        switch result {
                        case .failure(let error):
                            switch error {
                            case .mbAppsPreconditionsNotSatisfied(let preconditions):
                                expect(preconditions).to(equal([.enableMBApps, .registerUser]))
                            default:
                                fail()
                            }
                        case .success:
                            fail()
                        }
                    })
                    
                    expect(notificationSending.didSendNotification).toNotEventually(beTrue())
                }
            }
            
        }
    }
}

class MockTrackingManager: TrackingManager {
    var isTrackingEnabled: Bool = true
    
    var hasRegisteredServices: Bool = false
    
    func register(service: TrackingService) {
        
    }
    
    func startSession() {
        
    }
    
    func track(event: TrackingEvent) {
        
    }
    
    func cancelSession() {
        
    }
}

class MockS2CNotificationSending: Send2CarNotificationSending {
    var didSendNotificationCapabilities: SendToCarCapabilitiesModel?
    var didSendNotification: Bool {
        return didSendNotificationCapabilities != nil
    }
    
    func sendDidChangeSendToCarCapabilities(capabilities: SendToCarCapabilitiesModel) {
        didSendNotificationCapabilities = capabilities
    }
}

class MockS2CCapabilitiesDbStore: SendToCarCapabilitiesDbStoreRepresentable {
    var item: SendToCarCapabilitiesModel?
    var didSave: Bool = false
    
    func delete(with finOrVin: String, completion: @escaping Completion) {
        
    }
    
    func deleteAll(completion: @escaping Completion) {
        
    }
    
    func item(with finOrVin: String) -> SendToCarCapabilitiesModel? {
        return item
    }
    
    func save(sendToCarModel: SendToCarCapabilitiesModel, completion: @escaping (Result<SendToCarCapabilitiesModel, SendToCarCapabilitiesDbStoreError>) -> Void) {
        didSave = true
        item = sendToCarModel
        if let item = item {
            completion(.success(item))
        } else {
            completion(.failure(.dbError))
        }
    }
    
    
}
