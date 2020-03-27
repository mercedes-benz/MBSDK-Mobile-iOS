// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  internal enum IdentifierUI {
    /// login_button_next
    internal static let loginButtonNext = L10n.tr("IdentifierUI", "login_button_next")
    /// login_textfield
    internal static let loginTextfield = L10n.tr("IdentifierUI", "login_textfield")
    /// login_view
    internal static let loginView = L10n.tr("IdentifierUI", "login_view")
    /// verification_button_login
    internal static let verificationBtnLogin = L10n.tr("IdentifierUI", "verification_btn_login")
    /// verification_button_send_again
    internal static let verificationBtnSendAgain = L10n.tr("IdentifierUI", "verification_btn_send_again")
    /// verification_pin_textfield
    internal static let verificationPinTextfield = L10n.tr("IdentifierUI", "verification_pin_textfield")
  }
  internal enum Localizable {
    /// The PIN is not valid.
    internal static let alertMessageInvalidPin = L10n.tr("Localizable", "alert_message_invalid_pin")
    /// You have entered your PIN incorrectly %1$d times. Your Mercedes me ID has therefore been blocked for %2$@.
    internal static func commandErrorBlockedCiamId(_ p1: Int, _ p2: String) -> String {
      return L10n.tr("Localizable", "command_error_blocked_ciam_id", p1, p2)
    }
    /// %1$d minute
    internal static func commandErrorMinute(_ p1: Int) -> String {
      return L10n.tr("Localizable", "command_error_minute", p1)
    }
    /// %1$d minutes
    internal static func commandErrorMinutes(_ p1: Int) -> String {
      return L10n.tr("Localizable", "command_error_minutes", p1)
    }
    /// You have entered an incorrect PIN %1$d times.
    internal static func commandErrorPinInvalid(_ p1: Int) -> String {
      return L10n.tr("Localizable", "command_error_pin_invalid", p1)
    }
    /// Cancel
    internal static let generalCancel = L10n.tr("Localizable", "general_cancel")
    /// An error occurred. Please try again.
    internal static let generalErrorMsg = L10n.tr("Localizable", "general_error_msg")
    /// Something went wrong. Please check your internet connection.
    internal static let generalErrorNetworkMsg = L10n.tr("Localizable", "general_error_network_msg")
    /// Error
    internal static let generalErrorTitle = L10n.tr("Localizable", "general_error_title")
    /// Note
    internal static let generalHint = L10n.tr("Localizable", "general_hint")
    /// No
    internal static let generalNo = L10n.tr("Localizable", "general_no")
    /// OK
    internal static let generalOk = L10n.tr("Localizable", "general_ok")
    /// Yes
    internal static let generalYes = L10n.tr("Localizable", "general_yes")
    /// Authentication failed.Please try again.
    internal static let loginErrorAuthenticationFailed = L10n.tr("Localizable", "login_error_authentication_failed")
    /// Unfortunately you have entered incorrect information. Please note that you may need to wait a few minutes before trying again.
    internal static let loginErrorWrongTan = L10n.tr("Localizable", "login_error_wrong_tan")
    /// The Mercedes me ID consists of either your personal mobile number or your email address. With your Mercedes me ID you can log in to the digital world of Mercedes-Benz everywhere. It offers access to all services, functions and platforms available in your address country.
    internal static let loginInfoAlertMessage = L10n.tr("Localizable", "login_info_alert_message")
    /// Mercedes me ID
    internal static let loginInfoAlertTitle = L10n.tr("Localizable", "login_info_alert_title")
    /// Please enter a valid email address or telephone number.
    internal static let loginInvalidInput = L10n.tr("Localizable", "login_invalid_input")
    /// Mercedes me ID
    internal static let loginMercedesmeId = L10n.tr("Localizable", "login_mercedesme_id")
    /// Continue
    internal static let loginNext = L10n.tr("Localizable", "login_next")
    /// Login
    internal static let loginOnlyCaption = L10n.tr("Localizable", "login_only_caption")
    /// Please register free of charge in one of the other Mercedes me Apps.
    internal static let loginUserNotRegistered = L10n.tr("Localizable", "login_user_not_registered")
    /// Mobile number or email address
    internal static let loginUsername = L10n.tr("Localizable", "login_username")
    /// Try again
    internal static let pinPopupButtonAgain = L10n.tr("Localizable", "pin_popup_button_again")
    /// Cancel
    internal static let pinPopupCancel = L10n.tr("Localizable", "pin_popup_cancel")
    /// Please set a PIN in one of the Mercedes me Apps.
    internal static let pinPopupDefaultNoPinMessage = L10n.tr("Localizable", "pin_popup_default_no_pin_message")
    /// Please enter your %1$d-digit PIN:
    internal static func pinPopupDescription(_ p1: Int) -> String {
      return L10n.tr("Localizable", "pin_popup_description", p1)
    }
    /// Send
    internal static let pinPopupSend = L10n.tr("Localizable", "pin_popup_send")
    /// PIN entry
    internal static let pinPopupTitle = L10n.tr("Localizable", "pin_popup_title")
    /// The PIN is incorrect. Please try again.
    internal static let pinPopupWrongPinMsg = L10n.tr("Localizable", "pin_popup_wrong_pin_msg")
    /// Incorrect PIN
    internal static let pinPopupWrongPinTitle = L10n.tr("Localizable", "pin_popup_wrong_pin_title")
    /// In order to continually improve the app, we analyse the use of the app and its functions without reference to you personally. This function can be deactivated at any time via Menu > Settings > Analytics.
    internal static let registrationUserConsentMessage = L10n.tr("Localizable", "registration_user_consent_message")
    /// Mercedes me usage data
    internal static let registrationUserConsentTitle = L10n.tr("Localizable", "registration_user_consent_title")
    /// Next
    internal static let verificationBtnNext = L10n.tr("Localizable", "verification_btn_next")
    /// Request new TAN code
    internal static let verificationBtnSendAgain = L10n.tr("Localizable", "verification_btn_send_again")
    /// Verification code
    internal static let verificationHeadline = L10n.tr("Localizable", "verification_headline")
    /// Please enter the TAN code we sent you by email.
    internal static let verificationLoginMsgMail = L10n.tr("Localizable", "verification_login_msg_mail")
    /// For verification, we have sent you a %1$d-digit code to %2$@. Please enter this code.
    internal static func verificationLoginMsgUser(_ p1: Int, _ p2: String) -> String {
      return L10n.tr("Localizable", "verification_login_msg_user", p1, p2)
    }
    /// No TAN code received?
    internal static let verificationNotReceived = L10n.tr("Localizable", "verification_not_received")
    /// Please check the entered email address or request a new verification code.
    internal static let verificationNotReceivedHintMail = L10n.tr("Localizable", "verification_not_received_hint_mail")
    /// Please check the entered mobile number or request a new TAN code.
    internal static let verificationNotReceivedHintPhone = L10n.tr("Localizable", "verification_not_received_hint_phone")
    /// Your enquiry has been sent again
    internal static let verificationSendAgainMsg = L10n.tr("Localizable", "verification_send_again_msg")
    /// Verification
    internal static let verificationTitle = L10n.tr("Localizable", "verification_title")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
