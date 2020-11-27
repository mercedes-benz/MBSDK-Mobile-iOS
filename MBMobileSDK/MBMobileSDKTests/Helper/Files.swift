//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct File {
	var name: String
	
	// MARK: - Getter
	var path: String {
		
		let bundle = Bundle(for: BundleToken.self)
		return bundle.path(forResource: self.name, ofType: nil) ?? ""
	}
	var url: URL {
		return URL(fileURLWithPath: self.path)
	}
	
	
	enum Jsons {
		/// invalidToken.json
		static let invalidToken = File(name: "invalidToken.json")
		/// validJwtToken.json
		static let validJwtToken = File(name: "validJwtToken.json")
		/// validToken.json
		static let validToken = File(name: "validToken.json")
	}
}

private final class BundleToken {}


extension File {
	
	// MARK: - Getter
	
	var data: Data? {
		return try? Data(contentsOf: self.url)
	}
	var json: Any? {
		
		guard let data = self.data else {
			return nil
		}
		
		return try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
	}
	
	
	// MARK: - Codable
	
	func asyncDecode<T: Decodable>(object: T.Type, queue: DispatchQueue = DispatchQueue.global(), completion: @escaping (T) -> Void) {
		
		queue.async {
			
			let decode = self.decode(object: object)
			
			DispatchQueue.main.async {
				
				guard let decode = decode else {
					return
				}
				
				completion(decode)
			}
		}
	}
	
	func decode<T: Decodable>(object: T.Type) -> T? {
		
		guard let jsonData = self.data else {
			return nil
		}
		
		let decoder = JSONDecoder()
		return try? decoder.decode(T.self, from: jsonData)
	}
}
