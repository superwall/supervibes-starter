import SwiftUI

/// Design system tokens and styling constants.
///
/// ## Purpose
/// Design tokens (colors, fonts). Single source of truth for styling constants.
///
/// ## Include
/// - Semantic color tokens
/// - Typography presets
/// - Reusable design values
///
/// ## Don't Include
/// - View-specific layout logic
/// - Business rules
/// - UIKit appearance customizations
///
/// ## Lifecycle & Usage
/// Imported wherever UI is built; avoid hard-coding values in features.
///
// TODO: Customize these values to match your brand and design system
/// This is the single source of truth for all visual styling in the app
enum Theme {
  // MARK: - Colors

  enum Colors {
    // Primary
    static let primary = Color.accentColor
    static let primaryText = Color.primary
    static let secondaryText = Color.secondary

    // Background
    static let background = Color(uiColor: .systemBackground)
    static let secondaryBackground = Color(uiColor: .secondarySystemBackground)
    static let tertiaryBackground = Color(uiColor: .tertiarySystemBackground)

    // Semantic
    static let success = Color.green
    static let error = Color.red
    static let warning = Color.orange
    static let info = Color.blue

    // Borders
    static let border = Color(uiColor: .separator)
    static let borderLight = Color(uiColor: .separator).opacity(0.5)
  }

  // MARK: - Typography

  enum Typography {
    // Headings
    static let largeTitle = Font.largeTitle.weight(.bold)
    static let title1 = Font.title.weight(.bold)
    static let title2 = Font.title2.weight(.semibold)
    static let title3 = Font.title3.weight(.semibold)

    // Body
    static let body = Font.body
    static let bodyBold = Font.body.weight(.semibold)
    static let buttonLabel = Font.system(size: 19.0).weight(.semibold)
    static let callout = Font.callout
    static let caption = Font.caption

    // Custom sizes
    static func custom(size: CGFloat, weight: Font.Weight = .regular) -> Font {
      Font.system(size: size, weight: weight)
    }
  }

}
