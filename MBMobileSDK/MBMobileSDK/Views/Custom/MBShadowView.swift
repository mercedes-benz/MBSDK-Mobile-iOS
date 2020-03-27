//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

class MBShadowView: UIView {

	enum Presets {
		case standard

		var shadowRadius: CGFloat {
			switch self {
			case .standard:
				return 4.0
			}
		}

		var shadowOpacity: Float {
			switch self {
			case .standard:
				return 0.8
			}
		}

		var cornerRadius: CGFloat {
			switch self {
			default:
				return 0
			}
		}

		var shadowColor: UIColor {
			switch self {
			default:
				return .black
			}
		}
	}

	/// The blur radius of the drop-shadow, defaults to 0.
	var shadowRadius = CGFloat() { didSet { self.update() } }
	/// The opacity of the drop-shadow, defaults to 0.
	var shadowOpacity = Float() { didSet { self.update() } }
	/// The x,y offset of the drop-shadow from being cast straight down.
	var shadowOffset = CGSize.zero { didSet { self.update() } }
	/// The color of the drop-shadow, defaults to black.
	var shadowColor = UIColor.black { didSet { self.update() } }
	/// Whether to display the shadow, defaults to false.
	var enableShadow = false { didSet { self.update() } }
	/// The corner radius to take into account when casting the shadow, defaults to 0.
	var cornerRadius = CGFloat() { didSet { self.update() } }

	override var frame: CGRect {
		didSet {
			// Check to see if the size of the frame has changed, if it has then we need to recalculate
			// the shadow.
			if oldValue.size != self.frame.size {
				self.update()
			}
		}
	}

	
	// MARK: - Init
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.setup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.setup()
	}

	
	// MARK: - Helper
	
	private func setup() {
		// Configure the view
		self.backgroundColor = UIColor.clear
		self.isOpaque = false
		self.isHidden = true

		// Enable rasterization on the layer, this will improve the performance of shadow rendering.
		self.layer.shouldRasterize = true
	}

	
	// MARK: - Public
	
	func update(frame: CGRect? = nil) {

		self.isHidden = !self.enableShadow
		if self.enableShadow {
			// Configure the layer properties.
			self.layer.shadowRadius = self.shadowRadius
			self.layer.shadowOffset = self.shadowOffset
			self.layer.shadowOpacity = self.shadowOpacity
			self.layer.shadowColor = self.shadowColor.cgColor

			// Set a shadow path as an optimization, this significantly improves shadow performance.
			if let frame = frame {
				let rect = CGRect(origin: self.bounds.origin, size: CGSize(width: frame.width, height: self.bounds.height))
				self.layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
			} else {
				self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
			}

		} else {

			self.layer.shadowRadius = 0
			self.layer.shadowOpacity = 0
		}
	}

	func apply(preset: Presets, enable: Bool = true) {

		self.enableShadow = enable
		self.shadowRadius = preset.shadowRadius
		self.shadowColor = preset.shadowColor
		self.shadowOpacity = preset.shadowOpacity
		self.shadowColor = preset.shadowColor
	}
}
