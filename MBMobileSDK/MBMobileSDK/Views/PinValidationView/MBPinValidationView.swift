//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

class MBPinValidationView: UIView {

    // MARK: - Outlets

    @IBOutlet weak var pinView: MBPinView!
    @IBOutlet private weak var captionLabel: MBBody1Label!


    // MARK: - View Livecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.pinView.setupUI()
        self.pinView.numberOfDigits = 4
        self.pinView.isSecureTextEntry = true
    }


    // MARK: - Interface

    func configure(withCaption caption: String) {
        self.captionLabel.text = caption
    }
}
