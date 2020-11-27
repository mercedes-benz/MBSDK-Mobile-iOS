//
//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Quick
import Nimble
@testable import MBMobileSDK

class SendToCarOptionsBuildingTests: QuickSpec {

    override func spec() {
        
        var subject: SendToCarOptionsBuilding!
        
        beforeEach {
            subject = SendToCarOptionsBuilder()
        }
        
        describe("when routeModel does not contain waypoints") {
            it("should return with proper error") {
                let vin = "WD123"
                let capabilitites = SendToCarCapabilitiesModel(capabilities: [SendToCarCapability.dynamicRouteBackend], finOrVin: vin, preconditions: [SendToCarPrecondition.enableMBApps])
                let routeModel = SendToCarRouteModel(routeType: .singlePOI, waypoints: [])
                
                let result = subject.build(bluetoothProviding: nil, capabilities: capabilitites, routeModel: routeModel)
                switch result {
                case .success:
                    fail()
                case .failure(let error):
                    expect(error).to(equal(SendToCarOptionsBuildingError.noWaypointsSupplied))
                }
            }
        }
        
        describe("when bluetooth is not supported") {
            it("should return only with backend option") {
                let vin = "WD123"
                let capabilitites = SendToCarCapabilitiesModel(capabilities: [SendToCarCapability.dynamicRouteBackend], finOrVin: vin, preconditions: [SendToCarPrecondition.enableMBApps])
                let routeModel = SendToCarRouteModel(routeType: .singlePOI, waypoints: [SendToCarWaypointModel(latitude: 10.0, longitude: 10.0)])
                
                let result = subject.build(bluetoothProviding: nil, capabilities: capabilitites, routeModel: routeModel)
                switch result {
                case .success(let options):
                    expect(options).to(equal(SendToCarServiceV2.SendToCarOptions.backend))
                case .failure:
                    fail()
                }
            }
            
            it("should return only with backend option") {
                let vin = "WD123"
                let capabilitites = SendToCarCapabilitiesModel(capabilities: [SendToCarCapability.dynamicRouteBackend], finOrVin: vin, preconditions: [SendToCarPrecondition.enableMBApps])
                let routeModel = SendToCarRouteModel(routeType: .dynamicRoute, waypoints: [SendToCarWaypointModel(latitude: 10.0, longitude: 10.0)])
                
                let result = subject.build(bluetoothProviding: MockBluetoothProviding(), capabilities: capabilitites, routeModel: routeModel)
                switch result {
                case .success(let options):
                    expect(options).to(equal(SendToCarServiceV2.SendToCarOptions.backend))
                case .failure:
                    fail()
                }
            }
            
            it("should return only with backend option") {
                let vin = "WD123"
                let capabilitites = SendToCarCapabilitiesModel(capabilities: [SendToCarCapability.dynamicRouteBackend], finOrVin: vin, preconditions: [SendToCarPrecondition.enableMBApps])
                let routeModel = SendToCarRouteModel(routeType: .staticRoute, waypoints: [SendToCarWaypointModel(latitude: 10.0, longitude: 10.0)])
                
                let result = subject.build(bluetoothProviding: MockBluetoothProviding(), capabilities: capabilitites, routeModel: routeModel)
                switch result {
                case .success(let options):
                    expect(options).to(equal(SendToCarServiceV2.SendToCarOptions.backend))
                case .failure:
                    fail()
                }
            }
            
            it("should return only with backend option") {
                let vin = "WD123"
                let capabilitites = SendToCarCapabilitiesModel(capabilities: [SendToCarCapability.dynamicRouteBackend], finOrVin: vin, preconditions: [SendToCarPrecondition.enableMBApps])
                let routeModel = SendToCarRouteModel(routeType: .singlePOI, waypoints: [SendToCarWaypointModel(latitude: 10.0, longitude: 10.0)])
                
                let result = subject.build(bluetoothProviding: MockBluetoothProviding(), capabilities: capabilitites, routeModel: routeModel)
                switch result {
                case .success(let options):
                    expect(options).to(equal(SendToCarServiceV2.SendToCarOptions.backend))
                case .failure:
                    fail()
                }
            }
        }
        
        describe("when Bluetooth is supported") {
            it("should return bluetoothOnly when there is no backend capabilities") {
                let vin = "WD123"
                let capabilitites = SendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBluetooth], finOrVin: vin, preconditions: [SendToCarPrecondition.enableMBApps])
                let waypointModel = SendToCarWaypointModel(latitude: 10.0, longitude: 10.0)
                let routeModel = SendToCarRouteModel(routeType: .singlePOI, waypoints: [waypointModel])
                
                let result = subject.build(bluetoothProviding: MockBluetoothProviding(), capabilities: capabilitites, routeModel: routeModel)
                switch result {
                case .success(let options):
                    expect(options).to(equal(SendToCarServiceV2.SendToCarOptions.bluetoothOnly(waypointModel)))
                case .failure:
                    fail()
                }
            }
            
            it("should return bluetoothWithBackendFallback when there are backend capabilities") {
                let vin = "WD123"
                let capabilitites = SendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBluetooth, SendToCarCapability.singlePoiBackend], finOrVin: vin, preconditions: [SendToCarPrecondition.enableMBApps])
                let waypointModel = SendToCarWaypointModel(latitude: 10.0, longitude: 10.0)
                let routeModel = SendToCarRouteModel(routeType: .singlePOI, waypoints: [waypointModel])
                
                let result = subject.build(bluetoothProviding: MockBluetoothProviding(), capabilities: capabilitites, routeModel: routeModel)
                switch result {
                case .success(let options):
                    expect(options).to(equal(SendToCarServiceV2.SendToCarOptions.bluetoothWithBackendFallback(waypointModel)))
                case .failure:
                    fail()
                }
            }
        }
        
    }

}
