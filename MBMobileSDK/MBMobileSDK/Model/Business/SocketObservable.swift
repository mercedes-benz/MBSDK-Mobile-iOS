//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of the available observables
public protocol SocketObservableProtocol {
	
	var debugString: Observable<String> { get }
	var sequenceNumber: Observable<Int32> { get }
	
	var auxheat: Observable<VehicleAuxheatModel> { get }
	var doors: Observable<VehicleDoorsModel> { get }
    var drivingMode: Observable<VehicleDrivingModeModel> { get }
	var ecoScore: Observable<VehicleEcoScoreModel> { get }
	var engine: Observable<VehicleEngineModel> { get }
	var eventTime: Observable<Int64> { get }
	var hu: Observable<VehicleHuModel> { get }
	var location: Observable<VehicleLocationModel> { get }
	var statistics: Observable<VehicleStatisticsModel> { get }
	var status: Observable<VehicleStatusModel> { get }
	var tank: Observable<VehicleTankModel> { get }
	var theft: Observable<VehicleTheftModel> { get }
	var tires: Observable<VehicleTiresModel> { get }
	var vehicle: Observable<VehicleVehicleModel> { get }
	var warnings: Observable<VehicleWarningsModel> { get }
	var windows: Observable<VehicleWindowsModel> { get }
	var zev: Observable<VehicleZEVModel> { get }
}


class SocketObservable {
	
	// MARK: Properties
	var debugMessage: WriteObservable<String>
	var sequnce: WriteObservable<Int32>
	
	var vepAuxheat: WriteObservable<VehicleAuxheatModel>
	var vepDoors: WriteObservable<VehicleDoorsModel>
    var vepDrivingMode: WriteObservable<VehicleDrivingModeModel>
	var vepEcoScroe: WriteObservable<VehicleEcoScoreModel>
	var vepEngine: WriteObservable<VehicleEngineModel>
	var vepEventTime: WriteObservable<Int64>
	var vepHu: WriteObservable<VehicleHuModel>
	var vepLocation: WriteObservable<VehicleLocationModel>
	var vepStatistics: WriteObservable<VehicleStatisticsModel>
	var vepStatus: WriteObservable<VehicleStatusModel>
	var vepTank: WriteObservable<VehicleTankModel>
	var vepTheft: WriteObservable<VehicleTheftModel>
	var vepTires: WriteObservable<VehicleTiresModel>
	var vepVehicle: WriteObservable<VehicleVehicleModel>
	var vepWarnings: WriteObservable<VehicleWarningsModel>
	var vepWindows: WriteObservable<VehicleWindowsModel>
	var vepZEV: WriteObservable<VehicleZEVModel>

	
	// MARK: - Init
	
	init(vehicleStatusModel: VehicleStatusModel) {
		
		self.debugMessage  = WriteObservable("")
		self.sequnce       = WriteObservable(0)
		
		self.vepAuxheat    = WriteObservable(vehicleStatusModel.auxheat)
        self.vepDrivingMode = WriteObservable(vehicleStatusModel.drivingMode)
		self.vepDoors      = WriteObservable(vehicleStatusModel.doors)
		self.vepEcoScroe   = WriteObservable(vehicleStatusModel.ecoScore)
		self.vepEngine     = WriteObservable(vehicleStatusModel.engine)
		self.vepEventTime  = WriteObservable(0)
		self.vepHu         = WriteObservable(vehicleStatusModel.hu)
		self.vepLocation   = WriteObservable(vehicleStatusModel.location)
		self.vepStatistics = WriteObservable(vehicleStatusModel.statistics)
		self.vepStatus     = WriteObservable(vehicleStatusModel)
		self.vepTank       = WriteObservable(vehicleStatusModel.tank)
		self.vepTheft      = WriteObservable(vehicleStatusModel.theft)
		self.vepTires      = WriteObservable(vehicleStatusModel.tires)
		self.vepVehicle    = WriteObservable(vehicleStatusModel.vehicle)
		self.vepWarnings   = WriteObservable(vehicleStatusModel.warnings)
		self.vepWindows    = WriteObservable(vehicleStatusModel.windows)
		self.vepZEV        = WriteObservable(vehicleStatusModel.zev)
	}
}


// MARK: - SocketObservableProtocol

extension SocketObservable: SocketObservableProtocol {
    
	public var debugString: Observable<String> {
		return self.debugMessage
	}
	
	public var sequenceNumber: Observable<Int32> {
		return self.sequnce
	}
	
	public var auxheat: Observable<VehicleAuxheatModel> {
		return self.vepAuxheat
	}
	
    public var drivingMode: Observable<VehicleDrivingModeModel> {
        return self.vepDrivingMode
    }
    
	public var doors: Observable<VehicleDoorsModel> {
		return self.vepDoors
	}
	
	public var ecoScore: Observable<VehicleEcoScoreModel> {
		return self.vepEcoScroe
	}
	
	public var engine: Observable<VehicleEngineModel> {
		return self.vepEngine
	}
	
	public var eventTime: Observable<Int64> {
		return self.vepEventTime
	}
	
	public var hu: Observable<VehicleHuModel> {
		return self.vepHu
	}
	
	public var location: Observable<VehicleLocationModel> {
		return self.vepLocation
	}
	
	public var statistics: Observable<VehicleStatisticsModel> {
		return self.vepStatistics
	}
	
	public var status: Observable<VehicleStatusModel> {
		return self.vepStatus
	}
	
	public var tank: Observable<VehicleTankModel> {
		return self.vepTank
	}
	
	public var theft: Observable<VehicleTheftModel> {
		return self.vepTheft
	}
	
	public var tires: Observable<VehicleTiresModel> {
		return self.vepTires
	}
	
	public var vehicle: Observable<VehicleVehicleModel> {
		return self.vepVehicle
	}
	
	public var warnings: Observable<VehicleWarningsModel> {
		return self.vepWarnings
	}
	
	public var windows: Observable<VehicleWindowsModel> {
		return self.vepWindows
	}
	
	public var zev: Observable<VehicleZEVModel> {
		return self.vepZEV
	}
}
