//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

public protocol VehicleImageServiceRepresentable {
    
    /// Checks the cache for image data
    ///
    /// - Parameters:
    ///   - vin: vehicle identifier (use finOrVin)
    ///   - requestImage: VehicleImageRequest with image definition
    /// - Returns: Optional image data
    func cachedVehicleImage(vin: String, requestImage: VehicleImageRequest) -> Data?
    
    /// Delete all cached images
    func deleteAllImages()
    
    
    /// Request a single image for a vehicle. If their exist any cached data for the request you get this data immediately
    ///
    /// - Parameters:
    ///   - finOrVin: The fin or vin of the car
    ///   - requestImage: VehicleImageRequest with image definition
    ///   - completion: Closure with enum-based ImageResult
    func fetchVehicleImage(finOrVin: String, requestImage: VehicleImageRequest, completion: @escaping VehicleImageService.ImageResult)
    
    /// Request a single image for a vehicle. If cached data exists for the `requestImage` you get this data immediately.
    ///
    /// - Parameters:
    ///   - finOrVin: The fin or vin of the car
    ///   - requestImage: VehicleImageRequest with image definition
    ///   - forceUpdate: Set this to true if you want to force a silent cache refresh whether there was a cached image or not. Set this value to true only in exceptional cases. 
    ///   - completion: Closure with enum-based ImageResult
    func fetchVehicleImage(finOrVin: String, requestImage: VehicleImageRequest, forceUpdate: Bool, completion: @escaping VehicleImageService.ImageResult)
    
    /// Request all images for user assigned vehicles
    ///
    /// - Parameters:
    ///   - requestImage: VehicleImageRequest with image definition
    ///   - completion: Closure with enum-based ImageResult
    func fetchVehicleImages(requestImage: VehicleImageRequest, completion: @escaping VehicleImageService.ImagesCompletion)
}

public extension VehicleImageServiceRepresentable {
    
    func cachedVehicleImage(vin: String, requestImage: VehicleImageRequest) -> Data? { return nil }
    func deleteAllImages() {}
    func fetchVehicleImage(finOrVin: String, requestImage: VehicleImageRequest, forceUpdate: Bool, completion: @escaping VehicleImageService.ImageResult) {}
    func fetchVehicleImages(requestImage: VehicleImageRequest, completion: @escaping VehicleImageService.ImagesCompletion) {}
}

public extension VehicleImageServiceRepresentable {
    
    func fetchVehicleImage(finOrVin: String, requestImage: VehicleImageRequest, completion: @escaping VehicleImageService.ImageResult) {
        self.fetchVehicleImage(finOrVin: finOrVin, requestImage: requestImage, forceUpdate: false, completion: completion)
    }
}
