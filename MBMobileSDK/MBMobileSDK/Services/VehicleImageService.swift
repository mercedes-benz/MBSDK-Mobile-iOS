//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit
import MBCommonKit

/// Service to call all vehicle image related requests
public class VehicleImageService: VehicleImageServiceRepresentable {

	// MARK: Typealias
	
	/// Completion for fetching one image
	///
	/// Returns an enum with image data in succeeded case and a error string in failure case
	public typealias ImageResult = (Result<Data, MBError>) -> Void
	
	/// Completion for fetching images
	///
    /// Returns array of VehicleImageModel
    public typealias ImagesCompletion = (Result<[VehicleImageModel], MBError>) -> Void
    
	internal typealias ImageHelperResult = (Result<[ImageModel], MBError>) -> Void
	internal typealias ImagesHelperResult = (Result<[VehicleImageModel], MBError>) -> Void
	
	// MARK: Dependencies
	private let dbImageStore: ImageDbStoreRepresentable
	private let networking: Networking
	private let tokenProviding: TokenProviding?

	
	// MARK: - Init
	
	convenience init(networking: Networking) {
		self.init(networking: networking,
				  dbImageStore: ImageDbStore(),
				  tokenProviding: nil)
	}
	
	init(
		networking: Networking,
		dbImageStore: ImageDbStoreRepresentable,
		tokenProviding: TokenProviding?) {
		
		self.dbImageStore = dbImageStore
		self.networking = networking
		self.tokenProviding = tokenProviding
	}
	
	
	// MARK: - Public
	
	public func cachedVehicleImage(vin: String, requestImage: VehicleImageRequest) -> Data? {
		return self.dbImageStore.item(with: vin, requestImage: requestImage)
	}
	
	public func deleteAllImages() {
		self.dbImageStore.deleteAll(completion: { _ in })
	}
	
    public func fetchVehicleImage(finOrVin: String,
                                  requestImage: VehicleImageRequest,
                                  forceUpdate: Bool = false,
                                  completion: @escaping ImageResult) {
        
        if let image = self.cachedVehicleImage(vin: finOrVin, requestImage: requestImage) {
            completion(.success(image))
            
            if forceUpdate == true {
                self.requestVehicleImage(finOrVin: finOrVin, requestImage: requestImage, forceUpdate: forceUpdate, completion: nil)
            }
        } else {
            self.requestVehicleImage(finOrVin: finOrVin, requestImage: requestImage, forceUpdate: forceUpdate, completion: completion)
        }
    }
	
	public func fetchVehicleImages(requestImage: VehicleImageRequest, completion: @escaping ImagesCompletion) {

		let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { [weak self] result in
            
            switch result {
            case .failure(let error):
                completion(.failure(MBError(description: nil, type: .specificError(error))))
            case .success(let token):
                
                let requestDict = self?.getDict(requestImage: requestImage)
                let router      = BffVehicleImageRouter.images(accessToken: token.accessToken,
                                                        requestModel: requestDict)
                
                self?.networking.request(router: router) { [weak self] (result: Result<[APIVehicleVinImageModel], MBError>) in

                    switch result {
                    case .failure(let error):
                        LOG.E(error.localizedDescription)

                        completion(.failure(error))

                    case .success(let apiVehicleVinImages):
                        LOG.D(apiVehicleVinImages)

                        let images = NetworkModelMapper.map(apiVehicleVinImagesModel: apiVehicleVinImages)
                        self?.fetch(images: images,
                                    requestImage: requestImage,
                                    completion: completion)
                    }
                }
            }
        }
	}

    
    // MARK: - Helper
    
    private func requestVehicleImage(finOrVin: String,
                                     requestImage: VehicleImageRequest,
                                     forceUpdate: Bool = false,
                                     completion: ImageResult? = nil) {
		
		let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { [weak self] result in
        
            switch result {
            case .failure(let error):
                completion?(.failure(MBError(description: nil, type: .specificError(error))))
            case .success(let token):

                let requestDict = self?.getDict(requestImage: requestImage)
                let router      = BffVehicleImageRouter.image(accessToken: token.accessToken,
                                                       vin: finOrVin,
                                                       requestModel: requestDict)
                
                self?.networking.request(router: router) { [weak self] (result: Result<[APIVehicleImageModel], MBError>) in
                    
                    switch result {
                    case .failure(let error):
                        LOG.E(error.localizedDescription)
                        
                        completion?(.failure(error))
                        
                    case .success(let apiVehicleImagesModel):
                        LOG.D(apiVehicleImagesModel)
                        
                        let images = NetworkModelMapper.map(apiVehicleImagesModel: apiVehicleImagesModel)
                        
                        guard let urlString = images.first?.url else {
                            completion?(.failure(MBError(description: "Invalid Image URL", type: .unknown)))
                            return
                        }

                        self?.fetch(urlString: urlString,
                                    finOrVin: finOrVin,
                                    requestImage: requestImage,
                                    completion: completion)
                    }
                }
            }
        }
    }
    
	private func fetch(images: [VehicleImageModel], requestImage: VehicleImageRequest, completion: @escaping ImagesCompletion) {
		
		let dispatchGroup = DispatchGroup()
		
		for item in images {
			
			guard let urlString = images.first?.images.first?.url else {
				continue
			}
			
			dispatchGroup.enter()
			self.fetch(urlString: urlString, finOrVin: item.vin, requestImage: requestImage) { _ in
				dispatchGroup.leave()
			}
		}
		
		dispatchGroup.notify(queue: .main) {
            completion(.success(images))
		}
	}
	
	private func fetch(urlString: String, finOrVin: String, requestImage: VehicleImageRequest, completion: ImageResult?) {
		
		let router = CustomUrlRouter.url(string: urlString)
		self.networking.request(router: router) { [weak self] (result: Result<Data, MBError>) in

			switch result {
			case .failure(let error):
				completion?(.failure(error))
				
			case .success(let data):
				completion?(.success(data))
				
				if requestImage.shouldBeCached {
					self?.dbImageStore.save(finOrVin: finOrVin, requestImage: requestImage, imageData: data, completion: { _ in })
				}
			}
		}
	}
	
	private func getDict(requestImage: VehicleImageRequest) -> [String: Any]? {
		
		let imageKeys   = "BE" + requestImage.degrees.parameter + "-" + requestImage.size.parameter + requestImage.cropOption.parameter
		let imageModel  = VehicleImageRequestModel(background: requestImage.background.parameter,
												   centered: requestImage.centered,
												   fallbackImage: requestImage.fallbackImage,
												   imageKeys: imageKeys,
												   night: requestImage.night,
												   roofOpen: requestImage.roofOpen)
		let json        = try? imageModel.toJson()
		return json as? [String: Any]
	}
}
