//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

enum SendToCarOptionsBuildingError: Error {
    case noWaypointsSupplied
}

protocol SendToCarOptionsBuilding {
    func build(bluetoothProviding: BluetoothProviding?,
               capabilities: SendToCarCapabilitiesModel,
               routeModel: SendToCarRouteModel) -> Result<SendToCarServiceV2.SendToCarOptions, SendToCarOptionsBuildingError>
}

class SendToCarOptionsBuilder: SendToCarOptionsBuilding {
    
    func build(bluetoothProviding: BluetoothProviding?,
               capabilities: SendToCarCapabilitiesModel,
               routeModel: SendToCarRouteModel) -> Result<SendToCarServiceV2.SendToCarOptions, SendToCarOptionsBuildingError> {
        
        guard let poi = routeModel.waypoints.first else {
            return .failure(.noWaypointsSupplied)
        }
        
        guard self.doesSupportBluetooth(bluetoothProviding: bluetoothProviding, vin: capabilities.finOrVin, routeModel: routeModel, capabilities: capabilities.capabilities) else {
            return .success(.backend)
        }
        
        if capabilities.capabilities.count == 1 { // make sure ONLY singlePoiBluetooth is available, nothing else
            return .success(.bluetoothOnly(poi))
        }
        
        return .success(.bluetoothWithBackendFallback(poi))
    }
    
    private func doesSupportBluetooth(bluetoothProviding: BluetoothProviding?, vin: String, routeModel: SendToCarRouteModel, capabilities: [SendToCarCapability]) -> Bool {
        return bluetoothProviding != nil &&
                routeModel.routeType == .singlePOI &&
                capabilities.contains(SendToCarCapability.singlePoiBluetooth)
    }
}
