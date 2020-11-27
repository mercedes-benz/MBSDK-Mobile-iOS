//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit
import MBRealmKit
import RealmSwift

class VehicleDatabaseNotificationService {
	
	// MARK: Struct
	private struct Keys {
		static let deletions = "deletions"
		static let insertions = "insertions"
		static let modifications = "modifications"
		static let selectedFinOrVin = "selectedFinOrVin"
	}
	
	private struct Token {
		static let select = "select"
		static let services = "services"
		static let vehicles = "vehicles"
	}
	
	// MARK: Lazy
	private lazy var tokenName: String = {
		return String(describing: self)
	}()
	
	// MARK: - Dependency
	private let dbVehicleSelectionStore: VehicleSelectionDbStoreRepresentable
	private let dbVehicleServiceStore: VehicleServicesDbStoreRepresentable
	private let dbVehicleServiceStoreCarKit: VehicleServicesDbStoreCarKitRepresentable
	private let dbVehicleStore: VehicleDbStoreRepresentable

	
	// MARK: - Init
	
	convenience init () {
		self.init(dbVehicleService: VehicleServicesDbStore())
	}
	
	convenience init(dbVehicleService: VehicleServicesDbStoreRepresentable & VehicleServicesDbStoreCarKitRepresentable) {
		self.init(dbVehicleSelectionStore: VehicleSelectionDbStore(),
				  dbVehicleServiceStore: dbVehicleService,
				  dbVehicleServiceStoreCarKit: dbVehicleService,
				  dbVehicleStore: VehicleDbStore())
	}
	
	init(
		dbVehicleSelectionStore: VehicleSelectionDbStoreRepresentable,
		dbVehicleServiceStore: VehicleServicesDbStoreRepresentable,
		dbVehicleServiceStoreCarKit: VehicleServicesDbStoreCarKitRepresentable,
		dbVehicleStore: VehicleDbStoreRepresentable) {
		
		self.dbVehicleSelectionStore = dbVehicleSelectionStore
		self.dbVehicleServiceStoreCarKit = dbVehicleServiceStoreCarKit
		self.dbVehicleServiceStore = dbVehicleServiceStore
		self.dbVehicleStore = dbVehicleStore
		
		let isTargetExtension = Bundle.main.bundleURL.pathExtension == "appex"
		if isTargetExtension == false {
			
			self.observeVehicles()
			self.observeSelectVehicle()
			self.observeServices()
		}
	}
	
	
	// MARK: - Object life cycle
	
	deinit {
		LOG.V()
		
		RealmToken.invalide(for: self.tokenName + Token.vehicles)
		RealmToken.invalide(for: self.tokenName + Token.select)
		RealmToken.invalide(for: self.tokenName + Token.services)
	}
	
	
	// MARK: - Helper
	
	private func didChangeServices(results: Results<DBVehicleServiceModel>, deletions: [Int]?, insertions: [Int]?, modifications: [Int]?) {
		
		guard let selectedFinOrVin = CarKit.selectedFinOrVin,
			results.isEmpty == false,
			selectedFinOrVin.isEmpty == false else {
				return
		}
		
		let insertedFinOrVins = insertions?.compactMap { results.item(at: $0)?.finOrVin } ?? []
		let modifiedFinOrVins = modifications?.compactMap { results.item(at: $0)?.finOrVin } ?? []
		let uniqueFinOrVins = Set(insertedFinOrVins + modifiedFinOrVins)
		if uniqueFinOrVins.isEmpty {
			self.postServicesNotifications(finOrVin: selectedFinOrVin)
		} else {
			uniqueFinOrVins.forEach {
				self.postServicesNotifications(finOrVin: $0)
			}
		}
	}
	
	private func didChangeVehicles(provider: ResultsVehicleProvider, deletions: [Int]?, insertions: [Int]?, modifications: [Int]?) {
		
		LOG.D("post didChangeVehicles")
		
		let userInfo: [String: [Int]]? = {
			
			guard let deletions = deletions,
				let insertions = insertions,
				let modifications = modifications else {
					return nil
			}
			
			return [
				Keys.deletions: deletions,
				Keys.insertions: insertions,
				Keys.modifications: modifications
			]
		}()
		NotificationCenter.default.post(name: NSNotification.Name.didChangeVehicles,
										object: provider,
										userInfo: userInfo)
	}
	
	private func didChangeVehicleSelection(updateObservables: Bool) {
		
		let selectedFinOrVin = CarKit.selectedFinOrVin ?? ""
		
		LOG.D("post didChangeVehicleSelection: \(selectedFinOrVin)")
		
		if selectedFinOrVin.isEmpty == false {
			CarKit.servicesService.fetchVehicleServices(finOrVin: selectedFinOrVin, groupedOption: .categoryName, requestsMissingData: false, services: nil, completion: { _ in })
		}
		
		let currentVehicleStatus = CarKit.currentVehicleStatus()
		let userInfo = [
			Keys.selectedFinOrVin: selectedFinOrVin
		]
		
		if updateObservables {
			CarKit.socketService.updateObservables()
		}
		
		NotificationCenter.default.post(name: NSNotification.Name.didChangeVehicleSelection,
										object: currentVehicleStatus,
										userInfo: userInfo)
	}
	
	private func observeSelectVehicle() {
		
		let token = self.dbVehicleSelectionStore.get(initial: { [weak self] in
			self?.didChangeVehicleSelection(updateObservables: false)
		}, update: { [weak self] in
			self?.didChangeVehicleSelection(updateObservables: true)
		}, error: nil)
		
		RealmToken.set(token: token, for: self.tokenName + Token.select)
	}
	
	private func observeServices() {
		
		let token = self.dbVehicleServiceStoreCarKit.fetch(initial: { [weak self] (results) in
			self?.didChangeServices(results: results,
									deletions: nil,
									insertions: nil,
									modifications: nil)
		}, update: { [weak self] (results, deletions, insertions, modifications) in
			self?.didChangeServices(results: results,
									deletions: deletions,
									insertions: insertions,
									modifications: modifications)
		}, error: nil)
		
		RealmToken.set(token: token, for: self.tokenName + Token.services)
	}
	
	private func observeVehicles() {
		
		let token = self.dbVehicleStore.fetch(initial: { [weak self] (provider) in
			self?.didChangeVehicles(provider: provider,
									deletions: nil,
									insertions: nil,
									modifications: nil)
		}, update: { [weak self] (provider, deletions, insertions, modifications) in
			self?.didChangeVehicles(provider: provider,
									deletions: deletions,
									insertions: insertions,
									modifications: modifications)
		}, error: nil)
		
		RealmToken.set(token: token, for: self.tokenName + Token.vehicles)
	}
	
	private func postServicesNotifications(finOrVin: String) {
		LOG.D("post didChangeServices")
		
		let servicesProvider = self.dbVehicleServiceStore.fetchProvider(with: finOrVin)
		NotificationCenter.default.post(name: NSNotification.Name.didChangeServices,
										object: servicesProvider)

		let serviceGroupProvider = self.dbVehicleServiceStore.fetchServiceGroupProvider(with: finOrVin)
		NotificationCenter.default.post(name: NSNotification.Name.didChangeServiceGroups,
										object: serviceGroupProvider)
	}
}
