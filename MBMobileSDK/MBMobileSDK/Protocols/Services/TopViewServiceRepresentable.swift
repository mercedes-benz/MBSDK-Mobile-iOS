//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

public protocol TopViewServiceRepresentable {
    
    /// Checks the cache for top image data
    ///
    /// - Parameters:
    ///   - vin: vehicle identifier (use finOrVin)
    /// - Returns: Optional TopImageCacheModel with included image data
    func cachedVehicleTopImage(vin: String) -> TopViewComponentModel?
    
    /// Request a single top image for a vehicle. If their exist any cached data for the request you get this data immediately
    ///
    /// - Parameters:
    ///   - finOrVin: The fin or vin of the car
    ///   - onLoading: Closure that is called when a fetch is initiated. Closure param true indicates that the images are loaded from cache; on false the images are loaded from back-end systems
    ///   - onCompletion: Closure with enum-based TopViewImageResult
    func fetchVehicleTopImage(finOrVin: String, onLoading: ((Bool) -> Void)?, onCompletion: @escaping TopViewService.TopViewImageResult)
    
    /// Delete all cached images
    func deleteAllImages()
}
