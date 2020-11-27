//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

protocol SendToCarCapabilitiesModelBuilding {
    func build(bluetoothProviding: BluetoothProviding?, apiModel: APISendToCarCapabilitiesModel, for vin: String) -> SendToCarCapabilitiesModel
}

class SendToCarCapabilitiesModelBuilder: SendToCarCapabilitiesModelBuilding {
    
    func build(bluetoothProviding: BluetoothProviding?, apiModel: APISendToCarCapabilitiesModel, for vin: String) -> SendToCarCapabilitiesModel {
        let capabilities: [SendToCarCapability] = {
            
            let capabilities = apiModel.capabilities.compactMap { SendToCarCapability(rawValue: $0) }
            guard bluetoothProviding == nil else {
                return capabilities
            }
            // if BT is an available capability, but the BT provider is not set, remove the BT capability
            return capabilities.filter { $0 != .singlePoiBluetooth }
        }()
        
        return SendToCarCapabilitiesModel(capabilities: capabilities,
                                          finOrVin: vin,
                                          preconditions: apiModel.preconditions.compactMap { SendToCarPrecondition(rawValue: $0) })
    }
}
