//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBMobileSDK

internal final class MockPinProvider: PinProviding {

    static var preconditionsFullFilled: Bool {
        get {
            true
        }
    }

    var nextProvider: PinProviding?

    func requestPin(forReason reason: String?, preventFromUsageAlert: Bool, onSuccess: @escaping (String) -> Void, onCancel: @escaping CancelPinProvidingCompletion) {
        onSuccess("1234")
    }

    func handlePinFailure<T>(with errors: [T.Error], command: T, provider: PinProviding?, completion: CarKit.CommandUpdateCallback<T.Error>?) where T : BaseCommandProtocol, T : CommandTypeProtocol {
        print("Wrong PIN entered!")
    }

    func showWrongPinAlert(onRetry: @escaping () -> Void) {
        print("Wrong PIN entered!")
    }
}
