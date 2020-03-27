//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

extension MBDialogueController {
	
	/// Convenience function to show a MBDialogueController with style alert
	///
	/// - Parameters:
	///   - viewController: ViewController which should present the alert (optional)
	///   - title: Alert title (optional)
	///   - message: Alert message (optional)
	///   - buttonTitles: Array of button titles which should be added to the alert
	///   - completion: completion triggered on button tap (optional)
	class func show(from viewController: UIViewController?, title: String? = nil, message: String? = nil, buttonTitles: [String], completion: MBDialogueCompletion?) {
		
		let alert = MBDialogueController.create(for: .alert(message: message ?? ""), with: title ?? "")
		for btnTitle in buttonTitles {
			
			_ = alert.addButton(with: btnTitle) {
				completion?(btnTitle)
			}
		}
		
		viewController?.present(alert, animated: true, completion: nil)
	}
}
