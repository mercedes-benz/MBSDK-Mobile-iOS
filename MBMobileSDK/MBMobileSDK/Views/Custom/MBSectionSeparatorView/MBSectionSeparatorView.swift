//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

class MBSectionSeparatorView: MBBaseView {

	@IBOutlet private weak var topShadowView: MBShadowView! {
		didSet {
			self.topShadowView.apply(preset: .standard)
		}
	}

	@IBOutlet private weak var bottomShadowView: MBShadowView! {
		didSet {
			self.bottomShadowView.apply(preset: .standard)
		}
	}

	override func awakeFromNib() {
		super.awakeFromNib()

		self.backgroundColor = .clear
	}
}
