//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

class MBHeadlineSubtitleView: MBBaseView {

    // MARK: IBOutlet
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var headline: MBHeadlineSerif4Label! {
        didSet {
            self.headline.numberOfLines = 0
            self.headline.textAlignment = .center
        }
    }
    @IBOutlet private weak var subtitle: MBSubtitle2Label! {
        didSet {
            self.subtitle.numberOfLines = 0
            self.subtitle.textAlignment = .center
            self.subtitle.apply(style: .emphasized(.medium))
        }
    }
    
    // MARK: - Public
    
    /// Accessibility identifier of headline label
    var accessibilityIdentifierHeadline: String? {
        get {
            return self.headline.accessibilityIdentifier
        }
        set {
            self.headline.accessibilityIdentifier = newValue
        }
    }
    
    /// Accessibility identifier of subtitle label
    var accessibilityIdentifierSubtitle: String? {
        get {
            return self.subtitle.accessibilityIdentifier
        }
        set {
            self.subtitle.accessibilityIdentifier = newValue
        }
    }
    
    /// Set headline and subtitle text
    ///
    /// - Parameter headline: text for headline
    /// - Parameter subtitle: text for subtitle
    func set(headline: String?, subtitle: String?) {
        
        self.subtitle.text       = subtitle
        self.subtitle.isHidden   = subtitle == nil
        self.headline.text       = headline
        self.headline.isHidden   = headline == nil
    }
    
    // MARK: - View life cycle
    
    override func setupUI() {
        super.setupUI()
        
        self.backgroundColor               = .clear
        self.containerView.backgroundColor = .clear
    }
}
