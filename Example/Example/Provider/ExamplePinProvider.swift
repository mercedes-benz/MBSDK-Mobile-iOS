//
//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit
import MBMobileSDK

final class ExamplePinProvider: NSObject {
    
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
    
    
    // MARK: - Helper
    
    public func showNoPinCreated() {
        
        let alertVC = UIAlertController(title: "Hint", message: "You have not yet created a PIN", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertVC.addAction(okAction)
        
        UIApplication.shared.topViewController()?.present(alertVC, animated: true)
    }
    
    private func showPinVerification(reason: String?, onSuccess: @escaping (UserAuthenticationPIN) -> Void, onCancel: @escaping CancelPinProvidingCompletion) {
        
        let message = reason ?? "Please enter your \(Constants.maxPinCount) digit PIN"
        let alertVC = UIAlertController(title: "Confirm", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            onCancel()
        }
        let okAction = UIAlertAction(title: "Send", style: .default) { _ in
            onSuccess(alertVC.textFields?.first?.text ?? "")
        }
        
        alertVC.addTextField { (textField) in
            textField.placeholder = "PIN"
        }
        
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        
        UIApplication.shared.topViewController()?.present(alertVC, animated: true)
    }
    
    private func showUserBlocked(attempts: Int, blockedUntil: Int) {
        
        let blockingDate = Date(timeIntervalSince1970: TimeInterval(blockedUntil))
        let convertSeconds = blockingDate.timeIntervalSince(Date())
        let timeString = self.dateComponentsFormatter.string(from: convertSeconds) ?? "1 Minute"
        let message = "You have entered your PIN incorrectly \(attempts) times. Your Mercedes me ID has therefore been blocked for \(timeString)."
        
        let alertVC = UIAlertController(title: "User blocked", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertVC.addAction(okAction)
        
        UIApplication.shared.topViewController()?.present(alertVC, animated: true)
    }
}


// MARK: - PinProviding

extension ExamplePinProvider: PinProviding {
    
    var nextProvider: PinProviding? {
        get {
            return nil
        }
        set {
            LOG.D("Trying to set next provider \(newValue.debugDescription)")
        }
    }
    

    static var preconditionsFullFilled: Bool {
        return UserService().currentUser?.userPinStatus == .set
    }
    
    func handlePinFailure<T>(
        with errors: [T.Error],
        command: T,
        provider: PinProviding?,
        completion: ((CommandProcessingState<T.Error>, CommandProcessingMetaData) -> Void)?
    ) where T: BaseCommandProtocol, T: CommandTypeProtocol {
            
        guard let firstGenericError = errors.compactMap({ $0.unwrapGenericError() }).first else {
            return
        }

        switch firstGenericError {
        case .pinInvalid:
            
            self.showWrongPinAlert {
                
                guard let completion = completion else {
                    return
                }
                
                CarKit.socketService.send(command: command, completion: completion)
            }
            
        case .userBlocked(let attempts, let blockedUntil):
            self.showUserBlocked(attempts: attempts, blockedUntil: blockedUntil)
            
        default:
            break
        }
    }

    func requestPin(forReason reason: String? = nil, preventFromUsageAlert: Bool, onSuccess: @escaping (UserAuthenticationPIN) -> Void, onCancel: @escaping CancelPinProvidingCompletion) {

        if ExamplePinProvider.preconditionsFullFilled {
            self.showPinVerification(reason: reason, onSuccess: onSuccess, onCancel: onCancel)
        } else {
            
            self.showNoPinCreated()
            onCancel()
        }
    }
    
    func showWrongPinAlert(onRetry: @escaping () -> Void) {
        
        let alertVC = UIAlertController(title: "Incorrect PIN", message: "The PIN is incorrect. Please try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Try again", style: .default) { _ in
            onRetry()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        
        UIApplication.shared.topViewController()?.present(alertVC, animated: true)
    }
}
