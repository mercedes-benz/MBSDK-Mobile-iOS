//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

class MBSectionFooterView: MBBaseView {

	@IBOutlet private weak var shadowView: MBShadowView! {
		didSet {
			self.shadowView.apply(preset: .standard)
		}
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.shadowView.update(frame: self.frame)
	}

	override func awakeFromNib() {
		super.awakeFromNib()

		self.backgroundColor = .clear
	}
}
