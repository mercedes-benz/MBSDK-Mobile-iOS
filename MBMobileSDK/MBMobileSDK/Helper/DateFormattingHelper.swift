//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

class DateFormattingHelper {
	
	// MARK: Lazy
	private lazy var df: DateFormatter = {
		
		let df = DateFormatter()
		df.locale = Locale.current
		return df
	}()
	
	// MARK: Properties
	private static let shared = DateFormattingHelper()
	
	
	// MARK: - Public
	
	class func date(_ string: String, format: String) -> Date? {
		return self.shared.df.dateFormat(format).date(from: string)
	}
	
	class func date(_ string: String?, format: String) -> Date? {
		return self.shared.df.dateFormat(format).date(from: string ?? "")
	}
	
	class func string(_ date: Date?, format: String) -> String? {
		
		guard let date = date else {
			return nil
		}
		return self.string(date, format: format) as String
	}
	
	class func string(_ date: Date, format: String) -> String {
		return self.shared.df.dateFormat(format).string(from: date)
	}
	
	class func string(_ date: Date?, dateStyle: DateFormatter.Style) -> String? {
		
		guard let date = date else {
			return nil
		}
		return self.string(date, dateStyle: dateStyle) as String
	}
	
	class func string(_ date: Date, dateStyle: DateFormatter.Style) -> String {
		return self.shared.df.dateStyle(dateStyle).string(from: date)
	}
	
	class func string(_ date: Date?, localizedFormat: String) -> String? {
		
		guard let date = date else {
			return nil
		}
		return self.string(date, localizedFormat: localizedFormat) as String
	}
	
	class func string(_ date: Date, localizedFormat: String) -> String {
		
		self.shared.df.setLocalizedDateFormatFromTemplate(localizedFormat)
		return self.shared.df.string(from: date)
	}
}


// MARK: - DateFormatter

extension DateFormatter {
	
	fileprivate func dateFormat(_ dateFormat: String) -> Self {
		
		if self.dateFormat != dateFormat {
			self.dateFormat = dateFormat
		}
		return self
	}
	
	fileprivate func dateStyle(_ dateStyle: DateFormatter.Style) -> Self {
		
		if self.dateStyle != dateStyle {
			self.dateStyle = dateStyle
		}
		return self
	}
}
