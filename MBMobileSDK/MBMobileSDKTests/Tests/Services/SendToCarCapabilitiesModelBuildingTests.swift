//
//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Quick
import Nimble
@testable import MBMobileSDK

class SendToCarCapabilitiesModelBuildingTests: QuickSpec {

    override func spec() {
        var subject: SendToCarCapabilitiesModelBuilding!
        
        beforeEach {
            subject = SendToCarCapabilitiesModelBuilder()
        }
        
        describe("When no Bluetooth Provider is supplied") {
            
            it("should return all capabilities from API model if there is no Bluetooth capability") {
                let mockAPIModel = APISendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBackend.rawValue, SendToCarCapability.dynamicRouteBackend.rawValue], preconditions: [""])
                let vin = "VIN"
                let expectedResult = SendToCarCapabilitiesModel(capabilities: [.singlePoiBackend, .dynamicRouteBackend], finOrVin: vin, preconditions: [])
                
                expect(subject.build(bluetoothProviding: nil, apiModel: mockAPIModel, for: vin)).to(equal(expectedResult))
            }
            
            it("should not return blueooth capabilities even if it is a capability of API model") {
                let mockAPIModel = APISendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBackend.rawValue, SendToCarCapability.dynamicRouteBackend.rawValue, SendToCarCapability.singlePoiBluetooth.rawValue], preconditions: [""])
                let vin = "VIN"
                let expectedResult = SendToCarCapabilitiesModel(capabilities: [.singlePoiBackend, .dynamicRouteBackend], finOrVin: vin, preconditions: [])
                
                expect(subject.build(bluetoothProviding: nil, apiModel: mockAPIModel, for: vin)).to(equal(expectedResult))
            }
        }
        
        describe("When a Bluetooth Provider is supplied") {
            
            it("should return blueooth capabilities when it is a capability of API model") {
                let bluetoothProviding = MockBluetoothProviding()
                let mockAPIModel = APISendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBackend.rawValue, SendToCarCapability.dynamicRouteBackend.rawValue, SendToCarCapability.singlePoiBluetooth.rawValue], preconditions: [""])
                let vin = "VIN"
                let expectedResult = SendToCarCapabilitiesModel(capabilities: [.singlePoiBackend, .dynamicRouteBackend, .singlePoiBluetooth], finOrVin: vin, preconditions: [])
                
                expect(subject.build(bluetoothProviding: bluetoothProviding, apiModel: mockAPIModel, for: vin)).to(equal(expectedResult))
            }
            
            it("should not return blueooth capabilities when it is not a capability of API model") {
                let bluetoothProviding = MockBluetoothProviding()
                let mockAPIModel = APISendToCarCapabilitiesModel(capabilities: [SendToCarCapability.singlePoiBackend.rawValue, SendToCarCapability.dynamicRouteBackend.rawValue], preconditions: [""])
                let vin = "VIN"
                let expectedResult = SendToCarCapabilitiesModel(capabilities: [.singlePoiBackend, .dynamicRouteBackend], finOrVin: vin, preconditions: [])
                
                expect(subject.build(bluetoothProviding: bluetoothProviding, apiModel: mockAPIModel, for: vin)).to(equal(expectedResult))
            }
        }
    }

}

class MockBluetoothProviding: BluetoothProviding {
    
    var bluetoothSendResult: BluetoothSendResult?
    
    var connectedFinOrVin: String?
    
    var connectionStatus: BluetoothConnectionStatus = .notConnected
    
    func send<T>(poi: T, to finOrVin: String?, allowedQueuing: Bool, onComplete: @escaping OnSendCompletion) where T : BluetoothPoiMappable {
        onComplete(bluetoothSendResult ?? .failure(nil))
    }
}
