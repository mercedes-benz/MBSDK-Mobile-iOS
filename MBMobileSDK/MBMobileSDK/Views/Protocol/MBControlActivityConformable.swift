//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

// MARK: Struct

private struct ControlActivityConstants {
    static let animationDuration = 0.4
    static let delay = 0.2
}


// MARK: - Enumaration

/**
 Defines the status that the control could takes on
*/
enum MBControlActivityState {
    case loading
    case interactable
    case disabled
}

/**
 Defines the action that the control will use to display the action
 */
enum MBControlActivityAction {

    /// No additional control will display
    case none

    /// Will present a UILoadingIndicatorView
    case loadingIndicator
}


// MARK: - Protocol

protocol MBControlActivityConformable {

	/// The style of the indicator view
	var loadingIndicatorStyle: MBLoadingIndicatorView.Style { get }
	
    /// The element that should be display, when a process is running (e.g. none, activityinidicator)
    var backgroundAction: MBControlActivityAction { get }

    func activate(state: MBControlActivityState)
    func addLoadingIndicator(to view: UIView) -> MBLoadingIndicatorView
    func handleLoadingIndicatorActivity(with state: MBControlActivityState)
}


// MARK: - Extension

extension MBControlActivityConformable {

    var indicatorTag: Int {
        switch self {
        case _ as UIViewController:
            return 9999
			
        default:
            return 8888
        }
    }

    func addLoadingIndicator(to view: UIView) -> MBLoadingIndicatorView {

        let indicator = self.initializeLoadingIndicator()
        view.addSubview(indicator)
        view.bringSubviewToFront(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            indicator.heightAnchor.constraint(equalToConstant: 20),
            indicator.widthAnchor.constraint(equalToConstant: 20)
            ])
        return indicator
    }

    func initializeLoadingIndicator() -> MBLoadingIndicatorView {

        let indicator = MBLoadingIndicatorView(style: self.loadingIndicatorStyle)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.tag = self.indicatorTag
        indicator.alpha = 0
        return indicator
    }

    private func determineLoadingIndicator(at view: UIView) -> MBLoadingIndicatorView? {

        guard let indicatorView = view.viewWithTag(self.indicatorTag) as? MBLoadingIndicatorView else {
            return self.addLoadingIndicator(to: view)
        }
        return indicatorView
    }

	func activate(state: MBControlActivityState) {
        switch self.backgroundAction {
        case .loadingIndicator:
            self.handleLoadingIndicatorActivity(with: state)
			
        default:
            return
        }
    }
}

extension MBControlActivityConformable where Self: UIViewController {

    private var loadingIndicator: MBLoadingIndicatorView? {
        return self.determineLoadingIndicator(at: self.view)
    }
	
    func handleLoadingIndicatorActivity(with state: MBControlActivityState) {

        switch state {
        case .disabled:
            self.view.isUserInteractionEnabled = false
			
        case .interactable:
            self.view.isUserInteractionEnabled = true
            UIView.animate(withDuration: ControlActivityConstants.animationDuration, animations: {
                self.loadingIndicator?.alpha = 0
            })

        case .loading:
            self.view.isUserInteractionEnabled = false
            self.loadingIndicator?.startAnimating()
            UIView.animate(withDuration: ControlActivityConstants.animationDuration, delay: ControlActivityConstants.delay, animations: {
                self.loadingIndicator?.alpha = 1
            })
        }
    }
}

extension MBControlActivityConformable where Self: MBBaseButton {

    private var loadingIndicator: MBLoadingIndicatorView? {
		
        let indicator = self.determineLoadingIndicator(at: self)
//        indicator?.color = self.titleLabel?.textColor
		return indicator
    }

    func handleLoadingIndicatorActivity(with state: MBControlActivityState) {

        switch state {
        case .disabled:
            self.isUserInteractionEnabled = false
			
        case .interactable:
            self.isUserInteractionEnabled = true

            UIView.animate(withDuration: ControlActivityConstants.animationDuration, animations: {
                self.loadingIndicator?.alpha = 0
            })

            UIView.animate(withDuration: ControlActivityConstants.animationDuration, delay: ControlActivityConstants.delay, animations: {
                self.titleLabel?.alpha = 1
            })

            DispatchQueue.main.asyncAfter(deadline: .now() + ControlActivityConstants.delay) {
                self.imageViewTransition(to: self.internalImage)
            }

        case .loading:
            self.isUserInteractionEnabled = false
            self.loadingIndicator?.startAnimating()
            
            UIView.animate(withDuration: ControlActivityConstants.animationDuration, animations: {
                self.titleLabel?.alpha = 0
                
            })
            let imageSize = self.imageView?.image?.size ?? .zero
            self.imageViewTransition(to: UIColor.clear.image(imageSize))

            UIView.animate(withDuration: ControlActivityConstants.animationDuration, delay: ControlActivityConstants.delay, animations: {
                self.loadingIndicator?.alpha = 1
            })
        }
    }

    private func imageViewTransition(to image: UIImage?) {

        guard let image = image else {
            return
        }

        if let imageView = self.imageView {

            UIView.transition(with: imageView,
                              duration: ControlActivityConstants.animationDuration,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.setImage(image, for: .normal)
            })
        }
    }
}
