//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit
import ZIPFoundation
import MBCommonKit
import MBNetworkKit

/// Service to fetch topView image components
public class TopViewService: TopViewServiceRepresentable {
    
    /// Completion for fetching the topview images
    ///
    /// Returns the TopImageModel containing all the images for the topview
    public typealias TopViewImageResult = (Result<TopViewComponentModel, MBError>) -> Void
	
	// MARK: Dependencies
	private let dbTopImageStore: TopImageDbStoreRepresentable
	private let networking: Networking & NetworkingDownload
	private let tokenProviding: TokenProviding?
    private let topViewUnarchiver = TopViewUnarchiver()
	
	
	// MARK: - Init
	
	convenience init(networking: Networking & NetworkingDownload) {
		self.init(networking: networking,
				  dbTopImageStore: TopImageDbStore(),
				  tokenProviding: nil)
	}
	
	init(
		networking: Networking & NetworkingDownload,
		dbTopImageStore: TopImageDbStoreRepresentable,
		tokenProviding: TokenProviding?) {
		
		self.dbTopImageStore = dbTopImageStore
		self.networking = networking
		self.tokenProviding = tokenProviding
	}
	
	
	// MARK: - Public
	
    public func cachedVehicleTopImage(vin: String) -> TopViewComponentModel? {
		
		guard let model = self.dbTopImageStore.item(with: vin) else {
            return nil
        }
		return self.buildCompontentModel(from: model)
    }
    
    public func fetchVehicleTopImage(finOrVin: String, onLoading: ((Bool) -> Void)? = nil, onCompletion: @escaping TopViewImageResult) {
        
        let cachedTopViewImage = self.cachedVehicleTopImage(vin: finOrVin)
        
        if let imageModel = cachedTopViewImage {
            onLoading?(true)
            onCompletion(.success(imageModel))
        } else {
            onLoading?(false)
			
            let tokenProvider = self.tokenProviding ?? CarKit.tokenProvider
        tokenProvider.refreshTokenIfNeeded { [weak self] (result) in
                
                switch result {
                case .success(let token):
                    let router = BffVehicleImageRouter.topViewImage(accessToken: token.accessToken, vin: finOrVin)
                    self?.topViewImage(router: router, vin: finOrVin, completion: onCompletion)
                    
                case .failure(let error):
                    onCompletion(.failure(MBError(description: nil, type: .specificError(error))))
                }
            }
        }
    }
    
    public func deleteAllImages() {
		
		self.dbTopImageStore.deleteAll { (result) in
			
			switch result {
			case .failure(let error):	LOG.E("Error during delete the top image: \(error)")
			case .success:				break
			}
		}
    }
    
	
	// MARK: - Helper
	
    private func topViewImage(router: EndpointRouter, vin: String, completion: @escaping TopViewImageResult) {
        
        guard let request = router.urlRequest else {
            return
        }
        
		self.networking.download(urlRequest: request) { [weak self] (result) in
			
			switch result {
			case .failure:						break
			case .success(let destinationURL):	self?.unarchiveTopView(downloadDestination: destinationURL, vin: vin, completion: completion)
			}
		}
    }
    
    private func buildCompontentModel(from model: TopImageModel) -> TopViewComponentModel {
        
        let comps = model.components
            .compactMap { comp -> (key: String, img: UIImage)? in
                guard let imgData = comp.imageData,
                    let img = UIImage(data: imgData),
                    let keyName = componentKeyName(forFileName: comp.name) else {
                    return nil
                }
                
                return (keyName, img)
                
            }.reduce(into: [String: UIImage]()) { result, imgTuple in
                result[imgTuple.key] = imgTuple.img
            }
        
        return TopViewComponentModel(vin: model.vin, components: comps)
    }
    
    private func componentKeyName(forFileName name: String) -> String? {
        guard let key = name.split(separator: ".").first else {
            return nil
        }
        return String(key)
    }
    
    private func unarchiveTopView(downloadDestination destinationURL: URL, vin: String, completion: @escaping TopViewImageResult) {
        
		self.topViewUnarchiver.unarchive(fileUrl: destinationURL) { [weak self] (result) in
            switch result {
                
            case .success(let componentModels):
                let apiModel = APIVehicleTopViewImageModel(vin: vin, components: componentModels)
                
                let topViewModel = NetworkModelMapper.map(apiVehicleTopViewImageModel: apiModel)
				self?.dbTopImageStore.save(topImageModel: topViewModel) { [weak self] (result) in
					
					switch result {
					case .failure(let error):
						LOG.E("Error during save the top image: \(error)")
						
					case .success(let value):
						if let buildCompontentModel = self?.buildCompontentModel(from: value) {
							completion(.success(buildCompontentModel))
						}
					}
                }
                
            case .failure(let error):
				completion(.failure(MBError(description: nil, type: .specificError(error))))
            }
        }
    }
}
