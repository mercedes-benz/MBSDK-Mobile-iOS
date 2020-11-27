//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// The command name of a command capability
public enum CommandName: String {
	case auxheatConfigure = "AUXHEAT_CONFIGURE"
	case auxheatStart = "AUXHEAT_START"
	case auxheatStop = "AUXHEAT_STOP"
	case batteryChagreProgramConfigure = "BATTERY_CHARGE_PROGRAM_CONFIGURE"
	case batteryMaxSocConfigure = "BATTERY_MAX_SOC_CONFIGURE"
	case chargeOptConfigure = "CHARGE_OPT_CONFIGURE"
	case chargeOptStart = "CHARGE_OPT_START"
	case chargeOptStop = "CHARGE_OPT_STOP"
	case chargeProgramConfigure = "CHARGE_PROGRAM_CONFIGURE"
	case doorsLock = "DOORS_LOCK"
	case doorsUnlock = "DOORS_UNLOCK"
	case engineStart = "ENGINE_START"
	case engineStop = "ENGINE_STOP"
	case sigposStart = "SIGPOS_START"
	case speedAlertStart = "SPEEDALERT_START"
	case speedAlertStop = "SPEEDALERT_STOP"
	case sunroofClose = "SUNROOF_CLOSE"
	case sunroofLift = "SUNROOF_LIFT"
	case sunroofOpen = "SUNROOF_OPEN"
	case tempertatureConfigure = "TEMPERATURE_CONFIGURE"
	case theftAlarmConfirmDamageDetection = "THEFTALARM_CONFIRM_DAMAGEDETECTION"
	case theftAlarmDeselectDamageDetection = "THEFTALARM_DESELECT_DAMAGEDETECTION"
	case theftAlarmDeselectInterior = "THEFTALARM_DESELECT_INTERIOR"
	case theftAlarmDeselectTow = "THEFTALARM_DESELECT_TOW"
	case theftAlarmSelectDamageDetection = "THEFTALARM_SELECT_DAMAGEDETECTION"
	case theftAlarmSelectInterior = "THEFTALARM_SELECT_INTERIOR"
	case theftAlarmSelectTow = "THEFTALARM_SELECT_TOW"
	case theftAlarmStart = "THEFTALARM_START"
	case theftAlarmStop = "THEFTALARM_STOP"
	case weekProfileConfigure = "WEEK_PROFILE_CONFIGURE"
	case windowsClose = "WINDOWS_CLOSE"
	case windowsOpen = "WINDOWS_OPEN"
	case windowsVentilate = "WINDOWS_VENTILATE"
	case zevPreconditionConfigure = "ZEV_PRECONDITION_CONFIGURE"
	case zevPreconditionConfigureSeats = "ZEV_PRECONDITION_CONFIGURE_SEATS"
	case zevPreconditioningStart = "ZEV_PRECONDITIONING_START"
	case zevPreconditioningStop = "ZEV_PRECONDITIONING_STOP"
	case unknown
}
