//
//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit
#if canImport(MBCommonKitTracking)
import MBCommonKitTracking
#endif

public enum MyCarTrackingEvent: TrackingEvent {
    
    case doorLock(fin: String, state: CommandState, condition: String)
    case doorUnlock(fin: String, state: CommandState, condition: String)
    case startAuxHeat(fin: String, state: CommandState, condition: String)
    case stopAuxHeat(fin: String, state: CommandState, condition: String)
    case configureAuxHeat(fin: String, state: CommandState, condition: String)
    case engineStart(fin: String, state: CommandState, condition: String)
    case engineStop(fin: String, state: CommandState, condition: String)
    case openSunroof(fin: String, state: CommandState, condition: String)
    case closeSunroof(fin: String, state: CommandState, condition: String)
    case liftSunroof(fin: String, state: CommandState, condition: String)
    case openWindow(fin: String, state: CommandState, condition: String)
    case closeWindow(fin: String, state: CommandState, condition: String)
    case sendToCar(fin: String, routeType: HuCapability, state: CommandState, condition: String)
    case sendToCarBluetooth(fin: String, routeType: SendToCarCapability, state: CommandState, condition: String)
    case locateMe(fin: String, state: CommandState, condition: String)
    case locateVehicle(fin: String, state: CommandState, condition: String)
    case theftAlarmConfirmDamageDetection(fin: String, state: CommandState, condition: String)
    case theftAlarmDeselectDamageDetection(fin: String, state: CommandState, condition: String)
    case theftAlarmDeselectInterior(fin: String, state: CommandState, condition: String)
    case theftAlarmDeselectTow(fin: String, state: CommandState, condition: String)
    case theftAlarmSelectDamageDetection(fin: String, state: CommandState, condition: String)
    case theftAlarmSelectInterior(fin: String, state: CommandState, condition: String)
    case theftAlarmSelectTow(fin: String, state: CommandState, condition: String)
    case theftAlarmStart(fin: String, state: CommandState, condition: String)
    case theftAlarmStop(fin: String, state: CommandState, condition: String)
    
    public var name: String {
        switch self {
        case .doorLock:
            return CommandTrackingKeys.doorLock
        case .doorUnlock:
            return CommandTrackingKeys.doorUnlock
        case .startAuxHeat:
            return CommandTrackingKeys.startAuxHeat
        case .stopAuxHeat:
            return CommandTrackingKeys.stopAuxHeat
        case .configureAuxHeat:
            return CommandTrackingKeys.configureAuxHeat
        case .engineStart:
            return CommandTrackingKeys.engineStart
        case .engineStop:
            return CommandTrackingKeys.engineStop
        case .openSunroof:
            return CommandTrackingKeys.openSunroof
        case .closeSunroof:
            return CommandTrackingKeys.closeSunroof
        case .liftSunroof:
            return CommandTrackingKeys.liftSunroof
        case .openWindow:
            return CommandTrackingKeys.openWindow
        case .closeWindow:
            return CommandTrackingKeys.closeWindow
        case .sendToCar:
            return CommandTrackingKeys.sendToCar
        case .sendToCarBluetooth:
            return CommandTrackingKeys.sendToCarBluetooth
        case .locateMe:
            return CommandTrackingKeys.locateMe
        case .locateVehicle:
            return CommandTrackingKeys.locateVehicle
        case .theftAlarmConfirmDamageDetection:
            return CommandTrackingKeys.theftAlarmConfirmDamageDetection
        case .theftAlarmDeselectDamageDetection:
            return CommandTrackingKeys.theftAlarmDeselectDamageDetection
        case .theftAlarmDeselectInterior:
            return CommandTrackingKeys.theftAlarmDeselectInterior
        case .theftAlarmDeselectTow:
            return CommandTrackingKeys.theftAlarmDeselectTow
        case .theftAlarmSelectDamageDetection:
            return CommandTrackingKeys.theftAlarmSelectDamageDetection
        case .theftAlarmSelectInterior:
            return CommandTrackingKeys.theftAlarmSelectInterior
        case .theftAlarmSelectTow:
            return CommandTrackingKeys.theftAlarmSelectTow
        case .theftAlarmStart:
            return CommandTrackingKeys.theftAlarmStart
        case .theftAlarmStop:
            return CommandTrackingKeys.theftAlarmStop
        }
    }
    
    public var parameters: [String: String] {
        return [:]
    }
    
    private enum CommandTrackingKeys {
        static var doorLock: String { "DoorLock" }
        static var doorUnlock: String { "DoorUnlock" }
        static var startAuxHeat: String { "StartAuxHeat" }
        static var stopAuxHeat: String { "StopAuxHeat" }
        static var configureAuxHeat: String { "ConfigureAuxHeat" }
        static var engineStart: String { "EngineStart" }
        static var engineStop: String { "EngineStop" }
        static var openSunroof: String { "OpenSunroof" }
        static var closeSunroof: String { "CloseSunroof" }
        static var liftSunroof: String { "LiftSunroof" }
        static var openWindow: String { "OpenWindow" }
        static var closeWindow: String { "CloseWindow" }
        static var sendToCar: String { "SendToCar" }
        static var sendToCarBluetooth: String { "SinglePOIBluetooth" }
        static var locateMe: String { "LocateMe" }
        static var locateVehicle: String { "LocateVehicle" }
        static var theftAlarmConfirmDamageDetection: String { "TheftAlarmConfirmDamageDetection" }
        static var theftAlarmDeselectDamageDetection: String { "TheftAlarmDeselectDamageDetection" }
        static var theftAlarmDeselectInterior: String { "TheftAlarmDeselectInterior" }
        static var theftAlarmDeselectTow: String { "TheftAlarmDeselectTow" }
        static var theftAlarmSelectDamageDetection: String { "TheftAlarmSelectDamageDetection" }
        static var theftAlarmSelectInterior: String { "TheftAlarmSelectInterior" }
        static var theftAlarmSelectTow: String { "TheftAlarmSelectTow" }
        static var theftAlarmStart: String { "TheftAlarmStart" }
        static var theftAlarmStop: String { "TheftAlarmStop" }
    }
}
