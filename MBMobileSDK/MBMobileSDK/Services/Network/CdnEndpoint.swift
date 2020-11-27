//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct CdnEndpoint {
	
	// MARK: - Properties
	
	private static var baseURL: String {
		guard let cdnProvider = CarKit.cdnProvider else {
			fatalError("This is a placeholder implementation. Please implement your own cdnProvider or use the implementation from MBMobileSDK")
		}
		return cdnProvider.baseUrl
	}
	
	
	// MARK: - Public
	
	static func getUrl(for baumuster: String) -> URL? {
		
		guard baumuster.isEmpty == false else {
			return nil
		}
		
		let fileName = baumuster + ".svg"
		return URL(string: self.baseURL)?.appendingPathComponent(fileName)
	}
}
