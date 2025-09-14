import SwiftUI
import UIKit

/// A model that defines the appearance properties for an input field component.
public struct InputFieldVM: ComponentVM {
  /// The autocapitalization behavior for the input field.
  ///
  /// Defaults to `.sentences`, which capitalizes the first letter of each sentence.
  public var autocapitalization: TextAutocapitalization = .sentences

  /// The caption displayed below the input field.
  public var caption: String?

  /// The font used for the input field's caption.
  ///
  /// If not provided, the font is automatically calculated based on the input field's size.
  public var captionFont: UniversalFont?

  /// The color of the input field.
  public var color: ComponentColor?

  /// The corner radius of the input field.
  ///
  /// Defaults to `.medium`.
  public var cornerRadius: ComponentRadius = .medium

  /// The font used for the input field's text.
  ///
  /// If not provided, the font is automatically calculated based on the input field's size.
  public var font: UniversalFont?

  /// A Boolean value indicating whether autocorrection is enabled for the input field.
  ///
  /// Defaults to `true`.
  public var isAutocorrectionEnabled: Bool = true

  /// A Boolean value indicating whether the input field is enabled or disabled.
  ///
  /// Defaults to `true`.
  public var isEnabled: Bool = true

  /// A Boolean value indicating whether the input field is required to be filled.
  ///
  /// Defaults to `false`.
  public var isRequired: Bool = false

  /// A Boolean value indicating whether the input field should hide the input text for secure data entry (e.g., passwords).
  ///
  /// Defaults to `false`.
  public var isSecureInput: Bool = false

  /// The type of keyboard to display when the input field is active.
  ///
  /// Defaults to `.default`.
  public var keyboardType: UIKeyboardType = .default

  /// The placeholder text displayed when there is no input.
  public var placeholder: String?

  /// The predefined size of the input field.
  ///
  /// Defaults to `.medium`.
  public var size: ComponentSize = .medium

  /// The visual style of the input field.
  ///
  /// Defaults to `.light`.
  public var style: InputStyle = .light

  /// The type of the submit button on the keyboard.
  ///
  /// Defaults to `.return`.
  public var submitType: SubmitType = .return

  /// The tint color applied to the input field's cursor.
  ///
  /// Defaults to `.accent`.
  public var tintColor: UniversalColor = .accent

  /// The title displayed on the input field.
  public var title: String?

  /// The font used for the input field's title.
  ///
  /// If not provided, the font is automatically calculated based on the input field's size.
  public var titleFont: UniversalFont?

  /// The position of the title relative to the input field.
  ///
  /// Defaults to `.inside`.
  public var titlePosition: TitlePosition = .inside

  /// Initializes a new instance of `InputFieldVM` with default values.
  public init() {}
}

// MARK: - Shared Helpers

extension InputFieldVM {
  var preferredFont: UniversalFont {
    if let font {
      return font
    }

    switch self.size {
    case .small:
      return .smBody
    case .medium:
      return .mdBody
    case .large:
      return .lgBody
    }
  }
  var preferredTitleFont: UniversalFont {
    if let titleFont {
      return titleFont
    }

    switch self.size {
    case .small:
      return .smBody
    case .medium:
      return .mdBody
    case .large:
      return .lgBody
    }
  }
  var preferredCaptionFont: UniversalFont {
    if let captionFont {
      return captionFont
    }

    switch self.size {
    case .small:
      return .smCaption
    case .medium:
      return .mdCaption
    case .large:
      return .lgCaption
    }
  }
  var height: CGFloat {
    return switch self.size {
    case .small: 40
    case .medium: 48
    case .large: 56
    }
  }
  var horizontalPadding: CGFloat {
    switch self.cornerRadius {
    case .none, .small, .medium, .large, .custom:
      return 12
    case .full:
      return 16
    }
  }
  var spacing: CGFloat {
    switch self.titlePosition {
    case .inside:
      return 12
    case .outside:
      return 8
    }
  }
  var backgroundColor: UniversalColor {
    switch self.style {
    case .light, .faded:
      return self.color?.background ?? .content1
    case .bordered:
      return .background
    }
  }
  var foregroundColor: UniversalColor {
    return (self.color?.main ?? .foreground).enabled(self.isEnabled)
  }
  var placeholderColor: UniversalColor {
    if let color {
      return color.main.withOpacity(self.isEnabled ? 0.7 : 0.3)
    } else {
      return .secondaryForeground.enabled(self.isEnabled)
    }
  }
  var captionColor: UniversalColor {
    return (self.color?.main ?? .secondaryForeground).enabled(self.isEnabled)
  }
  var borderWidth: CGFloat {
    switch self.style {
    case .light:
      return 0
    case .bordered, .faded:
      switch self.size {
      case .small:
        return BorderWidth.small.value
      case .medium:
        return BorderWidth.medium.value
      case .large:
        return BorderWidth.large.value
      }
    }
  }
  var borderColor: UniversalColor {
    return (self.color?.main ?? .content3).enabled(self.isEnabled)
  }
}

// MARK: - UIKit Helpers

extension InputFieldVM {
  var autocorrectionType: UITextAutocorrectionType {
    return self.isAutocorrectionEnabled ? .yes : .no
  }
  var nsAttributedPlaceholder: NSAttributedString? {
    guard let placeholder else {
      return nil
    }
    return NSAttributedString(string: placeholder, attributes: [
      .font: self.preferredFont.uiFont,
      .foregroundColor: self.placeholderColor.uiColor
    ])
  }
  var nsAttributedTitle: NSAttributedString? {
    guard let title else {
      return nil
    }

    let attributedString = NSMutableAttributedString()
    attributedString.append(NSAttributedString(
      string: title,
      attributes: [
        .font: self.preferredTitleFont.uiFont,
        .foregroundColor: self.foregroundColor.uiColor
      ]
    ))
    if self.isRequired {
      attributedString.append(NSAttributedString(
        string: " ",
        attributes: [
          .font: UIFont.systemFont(ofSize: 5)
        ]
      ))
      attributedString.append(NSAttributedString(
        string: "*",
        attributes: [
          .font: self.preferredTitleFont.uiFont,
          .foregroundColor: UniversalColor.danger.enabled(self.isEnabled).uiColor
        ]
      ))
    }
    return attributedString
  }
  func shouldUpdateTitlePosition(_ oldModel: Self) -> Bool {
    return self.titlePosition != oldModel.titlePosition
  }
  func shouldUpdateLayout(_ oldModel: Self) -> Bool {
    return self.size != oldModel.size
    || self.horizontalPadding != oldModel.horizontalPadding
    || self.spacing != oldModel.spacing
    || self.cornerRadius != oldModel.cornerRadius
    || self.titlePosition != oldModel.titlePosition
    || self.title.isNilOrEmpty != oldModel.title.isNilOrEmpty
  }
}

// MARK: - SwiftUI Helpers

extension InputFieldVM {
  var attributedTitle: AttributedString? {
    guard let nsAttributedTitle else {
      return nil
    }

    return AttributedString(nsAttributedTitle)
  }
}
