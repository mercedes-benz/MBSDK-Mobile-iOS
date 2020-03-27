// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSColor
  internal typealias Color = NSColor
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIColor
  internal typealias Color = UIColor
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Colors

// swiftlint:disable identifier_name line_length type_body_length
internal struct MBColorName {
  internal let rgbaValue: UInt32
  internal var color: Color { return Color(named: self) }

  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#3088c5"></span>
  /// Alpha: 100% <br/> (0x3088c5ff)
  internal static let risAccentPrimary = MBColorName(rgbaValue: 0x3088c5ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#3facf2"></span>
  /// Alpha: 100% <br/> (0x3facf2ff)
  internal static let risAccentSecondary = MBColorName(rgbaValue: 0x3facf2ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
  /// Alpha: 100% <br/> (0x000000ff)
  internal static let risBlack = MBColorName(rgbaValue: 0x000000ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#1f1f1f"></span>
  /// Alpha: 100% <br/> (0x1f1f1fff)
  internal static let risGrey0 = MBColorName(rgbaValue: 0x1f1f1fff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#666666"></span>
  /// Alpha: 100% <br/> (0x666666ff)
  internal static let risGrey2 = MBColorName(rgbaValue: 0x666666ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#dddddd"></span>
  /// Alpha: 100% <br/> (0xddddddff)
  internal static let risGrey3 = MBColorName(rgbaValue: 0xddddddff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ececec"></span>
  /// Alpha: 100% <br/> (0xecececff)
  internal static let risGrey4 = MBColorName(rgbaValue: 0xecececff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#f4f4f4"></span>
  /// Alpha: 100% <br/> (0xf4f4f4ff)
  internal static let risGrey5 = MBColorName(rgbaValue: 0xf4f4f4ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#9f1901"></span>
  /// Alpha: 100% <br/> (0x9f1901ff)
  internal static let risStatusError = MBColorName(rgbaValue: 0x9f1901ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#e50013"></span>
  /// Alpha: 100% <br/> (0xe50013ff)
  internal static let risStatusErrorDarkbackground = MBColorName(rgbaValue: 0xe50013ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#f8be02"></span>
  /// Alpha: 100% <br/> (0xf8be02ff)
  internal static let risStatusMedium = MBColorName(rgbaValue: 0xf8be02ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#338a00"></span>
  /// Alpha: 100% <br/> (0x338a00ff)
  internal static let risStatusSuccess = MBColorName(rgbaValue: 0x338a00ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
  /// Alpha: 100% <br/> (0xffffffff)
  internal static let risWhite = MBColorName(rgbaValue: 0xffffffff)
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

// swiftlint:disable operator_usage_whitespace
internal extension Color {
  convenience init(rgbaValue: UInt32) {
    let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
    let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
    let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0
    let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0

    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}
// swiftlint:enable operator_usage_whitespace

internal extension Color {
  convenience init(named color: MBColorName) {
    self.init(rgbaValue: color.rgbaValue)
  }
}
