//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Protocol to implement an own provider for the pin handling
public protocol PinProviding: class {

    // MARK: - Types

	/// Completion for pin providing
	typealias UserAuthenticationPIN = String

	/// Completion for cancelled pin providing
	typealias CancelPinProvidingCompletion = () -> Void
	
	/// Completion for pin providing
	///
	/// Returns a UserAuthenticationPIN as string
	typealias PinProvidingCompletion = (String) -> Void


    // MARK: - Properties

    /// Completion for pin providing
    static var preconditionsFullFilled: Bool { get }

    /// Optional provider to deliver a PIN if the current provider is not able to do it (Chain of Responsibility)
    var nextProvider: PinProviding? { get set }


    // MARK: - Public Interface

	/// Request a pin
	///
	/// - Parameters:
	///   - reason: Describes the reason for the pin request (e.g. send a command to the car)
    ///   - preventFromUsageAlert: Prevent the alert for first usage of faceID/touchID
    ///   - onSuccess: Closure with PinProvidingCompletion
    ///   - onCancel: Closure with CancelPinProvidingCompletion
    func requestPin(forReason reason: String?, preventFromUsageAlert: Bool, onSuccess: @escaping PinProviding.PinProvidingCompletion, onCancel: @escaping CancelPinProvidingCompletion)
    
    /// Handles Invalid Pin Response
    ///
    /// - Parameters:
    ///   - errors: contains all the errors that occurs
    ///   - object: The object depending on the action (e.g. CommandRequest)
    ///   - provider: The provider that forwards the error
    ///   - completion: Closure with CancelPinProvidingCompletion
    func handlePinFailure<T>(with errors: [T.Error], command: T, provider: PinProviding?, completion: CarKit.CommandUpdateCallback<T.Error>?) where T: BaseCommandProtocol, T: CommandTypeProtocol
	
    /// Presents an alert after faulty pin validation
    ///
    /// - Parameters:
    ///   - onRetry: Closure to get the possibility to retry the previous action
    func showWrongPinAlert(onRetry: @escaping () -> Void)

    init()
}
