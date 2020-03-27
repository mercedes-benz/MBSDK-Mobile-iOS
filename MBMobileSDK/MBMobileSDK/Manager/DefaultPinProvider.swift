//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit
import MBIngressKit
import MBCarKit

final class DefaultPinProvider: NSObject {

    // MARK: - Typealias

    typealias SavePinCompletion = (_ success: Bool) -> Void


    // MARK: - Struct

    private struct Constants {
        static let maxPinCount: Int = 4
    }
    
    // MARK: - Lazy
    
    private lazy var dateComponentsFormatter: DateComponentsFormatter = {
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        return formatter
    }()


    // MARK: - Properties

    static var hasPin: Bool {
        return IngressKit.userService.validUser?.userPinStatus == .set
    }

    private var _nextProvider: PinProviding?
    private var _internalReason: String?
    private var observer: NSKeyValueObservation?
    private var sendButton: MBBaseButton?


    // MARK: - Alerts

    private func showNoPinCreatedAlert() {

        let alert = MBDialogueController.create(for: .alert(message: L10n.Localizable.pinPopupDefaultNoPinMessage), with: L10n.Localizable.generalHint)
        _ = alert.addButton(with: L10n.Localizable.pinPopupCancel, style: .cancel) {
        }
        UIApplication.shared.topViewController()?.present(alert, animated: true)
    }


    private func showPinVerification(reason: String?, onSuccess: @escaping PinProvidingCompletion, onCancel: @escaping CancelPinProvidingCompletion) {

        let contentView: MBPinValidationView = MBPinValidationView.mbLoadFromNib(with: Bundle(for: MBPinValidationView.self))
        contentView.configure(withCaption: reason ?? L10n.Localizable.pinPopupDescription(Constants.maxPinCount))
        let pinValidation = MBDialogueController.create(for: .custom(view: contentView), with: L10n.Localizable.pinPopupTitle)
        pinValidation.closeButtonOption = .none

        _ = pinValidation.addButton(with: L10n.Localizable.generalCancel, style: .cancel) { [weak self] in

            self?.cleanProperties()
            onCancel()
        }

        self.sendButton = pinValidation.addButton(with: L10n.Localizable.pinPopupSend) { [weak self] in

            self?.cleanProperties()
            onSuccess(contentView.pinView.pin)
        }
        self.sendButton?.isEnabled = false

        self.observer = contentView.pinView.observe(\.isPinInputComplete, options: [.initial, .new], changeHandler: { [weak self] (_, change) in
            self?.sendButton?.isEnabled = change.newValue == true
        })

        UIApplication.shared.topViewController()?.present(pinValidation, animated: true)
    }


    // MARK: - Helper

    private func cleanProperties() {

        self.observer = nil
        self.sendButton = nil
    }

    private func filterByCiamIdBlocked(errors: [CommandErrorProtocol]) -> [CommandErrorProtocol] {
        return errors.filter {

            guard let error = $0.unwrapGenericError() else {
                return false
            }

            switch error {
            case .userBlocked:  return true
            default:            return false
            }
        }
    }

    private func filterByPinInvalid(errors: [CommandErrorProtocol]) -> [CommandErrorProtocol] {
        return errors.filter {

            guard let error = $0.unwrapGenericError() else {
                return false
            }

            switch error {
            case .pinInvalid:   return true
            default:            return false
            }
        }
    }
}


// MARK: - PinProviding

extension DefaultPinProvider: PinProviding {

    static var preconditionsFullFilled: Bool {
        return DefaultPinProvider.hasPin
    }

    var nextProvider: PinProviding? {
        get {
            return self._nextProvider
        }
        set(newValue) {
            self._nextProvider = newValue
        }
    }

    func handlePinFailure<T>(
		with errors: [T.Error],
		command: T,
		provider: PinProviding?,
		completion: ((CommandProcessingState<T.Error>, CommandProcessingMetaData) -> Void)?
	) where T: BaseCommandProtocol, T: CommandTypeProtocol {

        let ciamIdBlockedErrors = self.filterByCiamIdBlocked(errors: errors)
        let pinInvalidErrors = self.filterByPinInvalid(errors: errors)

        if ciamIdBlockedErrors.isEmpty == false {

            // show ciam id blocked popup
            guard let error = ciamIdBlockedErrors.first?.unwrapGenericError() else {
                return
            }

            switch error {
            case .userBlocked(let attempts, let blockedUntil):
                let blockingDate = Date(timeIntervalSince1970: TimeInterval(blockedUntil))
                let convertSeconds = blockingDate.timeIntervalSince(Date())
                let timeString = self.dateComponentsFormatter.string(from: convertSeconds) ?? L10n.Localizable.commandErrorMinute(1)
                let message = L10n.Localizable.commandErrorBlockedCiamId(attempts, timeString)
                AlertHelper.showOK(from: UIApplication.shared.topViewController(), type: .hint(message: message))

            default:
                break
            }
        } else if pinInvalidErrors.isEmpty == false {

            // send command again
            guard let error = pinInvalidErrors.first?.unwrapGenericError() else {
                return
            }

            switch error {
            case .pinInvalid(let attempts):
                self._internalReason = L10n.Localizable.commandErrorPinInvalid(attempts)

                self.showWrongPinAlert {

                    guard let completion = completion else {
                        return
                    }

                    CarKit.socketService.send(command: command, completion: completion)
                }

            default:
                break
            }
        }
    }

    func requestPin(forReason reason: String? = nil, preventFromUsageAlert: Bool, onSuccess: @escaping (UserAuthenticationPIN) -> Void, onCancel: @escaping CancelPinProvidingCompletion) {

        if DefaultPinProvider.preconditionsFullFilled {

            let validReason = reason ?? self._internalReason
            self._internalReason = nil
            self.showPinVerification(reason: validReason, onSuccess: onSuccess, onCancel: onCancel)
        } else {

            self.showNoPinCreatedAlert()
            onCancel()
        }
    }
}

extension PinProviding {

    func showWrongPinAlert(onRetry: @escaping () -> Void) {

        let alert = MBDialogueController.create(for: .alert(message: L10n.Localizable.pinPopupWrongPinMsg), with: L10n.Localizable.pinPopupWrongPinTitle)
        _ = alert.addButton(with: L10n.Localizable.pinPopupCancel, style: .cancel) {
        }
        _ = alert.addButton(with: L10n.Localizable.pinPopupButtonAgain) {
            onRetry()
        }
        UIApplication.shared.topViewController()?.present(alert, animated: true)
    }
}
