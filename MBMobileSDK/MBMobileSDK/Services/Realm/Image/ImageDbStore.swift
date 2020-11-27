//
//  ImageDbStore.swift
//  MBCarKit
//
//  Created by Christoph G. on 28.09.20.
//  Copyright © 2020 Daimler AG. All rights reserved.
//

import Foundation
import RealmSwift
import MBRealmKit

// MARK: - ImageDbStoreError

public enum ImageDbStoreError: Error {
	case dbError
	case unknown
}


// MARK: - ImageDbStoreRepresentable

protocol ImageDbStoreRepresentable {
	
	typealias Completion = (Result<Void, ImageDbStoreError>) -> Void
	
	/// Delete a single image from database
	///
	/// - Parameters:
	///   - finOrVin: Vehicle identifier
	///   - requestImage: VehicleImageRequest with image definition
	func delete(with finOrVin: String, requestImage: VehicleImageRequest, completion: @escaping Completion)
	
	/// Delete the complete vahicle image database
	func deleteAll(completion: @escaping Completion)
	
	/// Fetch a image from database
	///
	/// - Parameters:
	///   - finOrVin: Vehicle identifier
	///   - requestImage: VehicleImageRequest with image definition
	/// - Returns: Optional image data. If there no image exists the return value is nil.
	func item(with finOrVin: String, requestImage: VehicleImageRequest) -> Data?
	
	func save(finOrVin: String, requestImage: VehicleImageRequest, imageData: Data?, completion: @escaping Completion)
}

protocol ImageDbStoreObservable {

	typealias ImageDataItem = (Data?) -> Void
	
	/// Fetch a image from database with the possibility to observe any changes of that
	///
	/// - Parameters:
	///   - finOrVin: Vehicle identifier
	///   - requestImage: VehicleImageRequest with image definition
	///   - imageData: Closure with ImageDataItem
	///   - error: Closure with ErrorCompletion
	/// - Returns: Optional NotificationToken to observe any changes
	func item(with finOrVin: String, requestImage: VehicleImageRequest, imageData: @escaping ImageDataItem, error: RealmConstants.ErrorCompletion?) -> NotificationToken?
}

class ImageDbStore {
	
	private let dbOperating: DbOperations<DBImageModel>
	private let realm: RealmLayer<DBImageModel>
	
	
	// MARK: - Init
	
	public convenience init() {
		self.init(config: ImageCacheConfig())
	}
	
	init(config: RealmConfigProtocol) {
		
		self.dbOperating = DbOperations(config: config)
		self.realm = RealmLayer<DBImageModel>(config: config)
	}
	
	
	// MARK: - Helper
	
	private func handle(result: Result<Void, DbError>, completion: @escaping (Result<Void, ImageDbStoreError>) -> Void) {
		
		switch result {
		case .failure(let dbError):	completion(.failure(self.map(dbError)))
		case .success:				completion(.success(()))
		}
	}
	
	private func item(with finOrVin: String, requestImage: VehicleImageRequest, in realm: Realm) -> DBImageModel? {
		
		let primaryKey = self.primaryKey(with: finOrVin, requestImage: requestImage)
		return realm.object(ofType: DBImageModel.self, forPrimaryKey: primaryKey)
	}
	
	private func map(_ error: DbError) -> ImageDbStoreError {
		
		switch error {
		case .unknown:	return .unknown
		default:		return .dbError
		}
	}
	
	private func primaryKey(with finOrVin: String, requestImage: VehicleImageRequest) -> String {
		
		let boolFlagBasedString = (requestImage.centered ? "Centered" : "") +
			(requestImage.fallbackImage ? "FallbackImage" : "") +
			(requestImage.night ? "Night" : "") +
			(requestImage.roofOpen ? "RoofOpen" : "")
		return finOrVin +
			requestImage.background.parameter +
			requestImage.degrees.parameter +
			requestImage.size.parameter +
			boolFlagBasedString +
			requestImage.cropOption.parameter
	}
}


// MARK: - ImageDbStoreRepresentable

extension ImageDbStore: ImageDbStoreRepresentable {
	
	public func delete(with finOrVin: String, requestImage: VehicleImageRequest, completion: @escaping (Result<Void, ImageDbStoreError>) -> Void) {
		
		self.dbOperating.realmEdit(.delete, block: { (realm, finished) in
			
			if let item = self.item(with: finOrVin, requestImage: requestImage, in: realm) {
				realm.deleteCascade(object: item)
			}
			
			finished()
		}, completion: { (result) in
			self.handle(result: result, completion: completion)
		})
	}
	
	public func deleteAll(completion: @escaping (Result<Void, ImageDbStoreError>) -> Void) {
		
		self.dbOperating.realmEdit(.delete, block: { (realm, finished) in
			
			realm.objects(DBImageModel.self).forEach {
				realm.deleteCascade(object: $0)
			}
			
			finished()
		}, completion: { [weak self] (result) in
			self?.handle(result: result, completion: completion)
		})
	}
	
	public func item(with finOrVin: String, requestImage: VehicleImageRequest) -> Data? {
		
		guard let realm = self.dbOperating.realm else {
			return nil
		}
		return self.item(with: finOrVin, requestImage: requestImage, in: realm)?.imageData
	}
	
	func save(finOrVin: String, requestImage: VehicleImageRequest, imageData: Data?, completion: @escaping (Result<Void, ImageDbStoreError>) -> Void) {
		
		self.dbOperating.realmEdit(.write, block: { (realm, finished) in
			
			let dbImageModel        = CarKitDatabaseModelMapper.map(requestImage: requestImage)
			dbImageModel.imageData  = imageData
			dbImageModel.primaryKey = self.primaryKey(with: finOrVin, requestImage: requestImage)
			dbImageModel.vin        = finOrVin
			
			realm.add(dbImageModel, update: .modified)
			
			finished()
		}, completion: { [weak self] (result) in
			self?.handle(result: result, completion: completion)
		})
	}
}


// MARK: - ImageDbStoreObservable

extension ImageDbStore: ImageDbStoreObservable {
	
	public func item(with finOrVin: String, requestImage: VehicleImageRequest, imageData: @escaping ImageDataItem, error: RealmConstants.ErrorCompletion?) -> NotificationToken? {
		
		guard let realm = self.dbOperating.realm else {
			return nil
		}
		
		let item = self.item(with: finOrVin, requestImage: requestImage, in: realm)
		return self.realm.observe(item: item, error: { (observeError) in
			RealmLayer.handle(observeError: observeError, completion: error)
		}, initial: { (item) in
			imageData(item.imageData)
		}, change: { (properties) in
			
			properties.forEach {
				if $0.name == "imageData" {
					imageData($0.newValue as? Data)
				}
			}
		}, deleted: {})
	}
}
