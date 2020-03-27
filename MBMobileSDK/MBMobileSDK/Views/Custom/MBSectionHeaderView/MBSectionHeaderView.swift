//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

class MBSectionHeaderView: MBBaseView {

	@IBInspectable
	var title: String = ""

	@IBInspectable
	var separatorEnabled: Bool = false {
		didSet {
			if let view = self.separatorView {
				view.isHidden = !self.separatorEnabled
			}
		}
	}

	@IBOutlet private weak var separatorView: MBSeparatorView! {
		didSet {
			self.separatorView.isHidden = true
		}
	}

	@IBOutlet private weak var titleLabel: MBOverlineLabel! {
		didSet {
			self.titleLabel.setTextColor(.risGrey2)
			self.titleLabel.text = self.title.uppercased()
		}
	}

	@IBOutlet private weak var shadowView: MBShadowView! {
		didSet {
			self.shadowView.apply(preset: .standard)
		}
	}

	
	// MARK: - Public
	
	func configure(with title: String, separatorEnabled: Bool = false, shadowEnabled: Bool = true) {
		
		self.title = title
		self.titleLabel.text = title.uppercased()
		self.separatorView.isHidden = !separatorEnabled
		self.separatorEnabled = separatorEnabled
        self.shadowView.enableShadow = shadowEnabled
	}
	
	
	// MARK: - View life cycle
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		self.separatorView.isHidden = !self.separatorEnabled
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.shadowView.update(frame: self.frame)
	}
}
