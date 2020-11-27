//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

class NumberFormattingHelper {
	
	// MARK: Lazy
	private lazy var nf: NumberFormatter = {
		
		let nf                   = NumberFormatter()
		nf.locale                = Locale.current
		nf.numberStyle           = .decimal
		nf.usesSignificantDigits = true
		return nf
	}()
	
	// MARK: Properties
	private static let shared = NumberFormattingHelper()
	
	
	// MARK: - Public
	
	class func string(_ any: Any?, style: NumberFormatter.Style = .decimal) -> String? {
		return self.shared.nf.numberStyle(style).string(for: any)
	}
	
	class func string(_ any: Any?, minimumDigits: Int, style: NumberFormatter.Style = .decimal) -> String? {
		return self.shared.nf.numberStyle(style).minimumDigits(minimumDigits).string(for: any)
	}
	
	class func string(_ number: NSNumber, style: NumberFormatter.Style = .decimal) -> String? {
		return self.shared.nf.numberStyle(style).string(from: number)
	}
	
	class func string(_ number: NSNumber, minimumDigits: Int, style: NumberFormatter.Style = .decimal) -> String? {
		return self.shared.nf.numberStyle(style).minimumDigits(minimumDigits).string(from: number)
	}
}


// MARK: - DateFormatter

extension NumberFormatter {
	
	fileprivate func minimumDigits(_ minimumDigits: Int) -> Self {
		
		if self.minimumSignificantDigits != minimumDigits {
			self.minimumSignificantDigits = minimumDigits
		}
		
		return self
	}
	
	fileprivate func locale(_ locale: Locale) -> Self {
		
		if self.locale != locale {
			self.locale = locale
		}
		
		return self
	}
	
	fileprivate func numberStyle(_ numberStyle: NumberFormatter.Style) -> Self {
		
		if self.numberStyle != numberStyle {
			self.numberStyle = numberStyle
		}
		
		return self
	}
}
