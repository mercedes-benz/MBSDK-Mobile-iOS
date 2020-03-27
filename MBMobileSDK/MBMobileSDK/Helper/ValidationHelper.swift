//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public class ValidationHelper {
    
    /// Validate mail address
    /// some text before @
    /// some text after @
    /// 2 or more alpha characters after dot
	public static func isValid(mail: String) -> Bool {
        return mail.isValid(regEx: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
    }
    
    /// Validate phone number
    /// some text with 7 or more numeric characters
	public static func isValid(phone: String) -> Bool {
        
        let trimmed = phone.replacingOccurrences(of: " ", with: "")
        return trimmed.isValid(regEx: "^((\\+)|(00))[0-9]{6,14}|[0-9]{6,14}$")
    }
    
    /// Validate pin input
    /// some text with 6 numeric characters
    static func isValid(pin: String) -> Bool {
        return pin.isValid(regEx: "^[0-9]{6}$")
    }
}


// MARK: - String

extension String {
    
    /// evaluate regEx in string
    fileprivate func isValid(regEx: String) -> Bool {
        
        guard self.count > 0 else {
            return false
        }
        
        let pred = NSPredicate(format: "SELF MATCHES %@", regEx)
        return pred.evaluate(with: self)
    }
}
