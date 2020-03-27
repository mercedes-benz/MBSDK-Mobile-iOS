//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public struct MBFile {
	
	var name: String
	
	
	// MARK: - Getter
	
	var bundle: Bundle {
		return Bundle(for: BundleToken.self)
	}
	var path: String {
		return self.bundle.path(forResource: self.name, ofType: nil) ?? ""
	}
	var url: URL {
		return URL(fileURLWithPath: self.path)
	}
	
	
	// MARK: - Enums
	
	public enum Video {
        /// welcome_compressed.mp4
        public static let welcomeCompressed = MBFile(name: "welcome_compressed.mp4")
	}
}


private final class BundleToken {}
