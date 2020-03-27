//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import MBIngressKit
import MBNetworkKit

public typealias MBAlertCompletion = () -> Void

// MARK: - AlertMessageType

public enum AlertMessageType {
    case error(MBError?)
    case hint(message: String)
    case `default`(title: String, message: String)
}

extension AlertMessageType {

    var title: String {
        switch self {
        case .error:					return L10n.Localizable.generalErrorTitle
        case .hint:						return L10n.Localizable.generalHint
        case .default(let title, _):	return title
        }
    }

    var message: String {
        switch self {
        case .error(let errorObject):	return self.retrieveErrorMessage(from: errorObject)
        case .hint(let message):		return message
        case .default( _, let message):	return message
        }
    }


    // MARK: - Helper

    private func retrieveErrorMessage(from error: MBError?) -> String {
        return error?.localizedDescription ??  L10n.Localizable.generalErrorMsg
    }
}


// MARK: - AlertHelper

public struct AlertHelper {

    // MARK: - Public Interface

    /// Convenience function to show a MBDialogueController with style alert
    ///
    /// Button is always "OK"
    ///
    /// - Parameters:
    ///   - viewController: ViewController which should present the alert (optional)
    ///   - type: type of the specific message (e.g. hint, error...)
    ///   - completion: completion triggered on button tap (optional)
    public static func showOK(from viewController: UIViewController?, type: AlertMessageType, completion: MBAlertCompletion? = nil) {

        let alert = MBDialogueController.create(for: .alert(message: type.message), with: type.title)

        _ = alert.addButton(with: L10n.Localizable.generalOk) {
            completion?()
        }

        viewController?.present(alert, animated: true, completion: nil)
    }
}


// MARK: - Snackbar

extension AlertHelper {

    public static func showSnackBar(error: MBError) {

        let errorMessage = error.localizedDescription ?? L10n.Localizable.generalErrorMsg
        LOG.E(errorMessage)

        MBSnackBarView.show(with: errorMessage)
    }
}
