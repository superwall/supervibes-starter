import SwiftUI
import Pow

/// Reusable button styles to enforce consistency.
///
/// ## Purpose
/// Reusable button styles to enforce consistency.
///
/// ## Include
/// - Style structs/enums and shared visual rules
///
/// ## Don't Include
/// - Actions
/// - Analytics
///
/// ## Lifecycle & Usage
/// Apply via modifiers.

// MARK: - Button Styles
// TODO:  Define reusable button styles for consistent appearance

/// Primary button style (filled CTA)
struct PrimaryButtonStyle: ButtonStyle {
  var isLoading: Bool = false
  var isDisabled: Bool = false

  func makeBody(configuration: Configuration) -> some View {
    HStack(spacing: 12) {
      if isLoading {
        ProgressView()
          .tint(.white)
      } else {
        configuration.label
      }
    }
    .font(Theme.Typography.buttonLabel)
    .foregroundStyle(.white)
    .frame(maxWidth: .infinity)
    .frame(height: 55)
    .background(isDisabled ? Theme.Colors.primary.opacity(0.5) : Theme.Colors.primary)
    .cornerRadius(12)
    .opacity(isDisabled ? 0.8 : 1.0)
    .conditionalEffect(
      .pushDown,
      condition: configuration.isPressed
    )
  }
}

/// Secondary button style with outline appearance
struct SecondaryButtonStyle: ButtonStyle {
  var isLoading: Bool = false
  var isDisabled: Bool = false

  func makeBody(configuration: Configuration) -> some View {
    HStack(spacing: 12) {
      if isLoading {
        ProgressView()
          .tint(Theme.Colors.primary)
      } else {
        configuration.label
      }
    }
    .font(Theme.Typography.buttonLabel)
    .foregroundStyle(isDisabled ? Theme.Colors.primary.opacity(0.5) : Theme.Colors.primary)
    .frame(maxWidth: .infinity)
    .frame(height: 55)
    .background(Theme.Colors.background)
    .overlay(
      RoundedRectangle(cornerRadius: 12)
        .stroke(isDisabled ? Theme.Colors.primary.opacity(0.5) : Theme.Colors.primary, lineWidth: 2)
    )
    .opacity(isDisabled ? 0.8 : 1.0)
    .conditionalEffect(
      .pushDown,
      condition: configuration.isPressed
    )
  }
}

/// Tertiary button style (text-only)
struct TertiaryButtonStyle: ButtonStyle {
  var isLoading: Bool = false
  var isDisabled: Bool = false

  func makeBody(configuration: Configuration) -> some View {
    HStack(spacing: 12) {
      if isLoading {
        ProgressView()
//          .tint(Theme.Colors.primary)
      } else {
        configuration.label
      }
    }
    .font(Theme.Typography.buttonLabel)
    .foregroundStyle(isDisabled ? Theme.Colors.primary.opacity(0.5) : Theme.Colors.primary)
    .opacity(isDisabled ? 0.8 : 1.0)
    .conditionalEffect(
      .pushDown,
      condition: configuration.isPressed
    )
  }
}

/// Destructive button style
struct DestructiveButtonStyle: ButtonStyle {
  var isLoading: Bool = false
  var isDisabled: Bool = false

  func makeBody(configuration: Configuration) -> some View {
    HStack(spacing: 12) {
      if isLoading {
        ProgressView()
          .tint(.white)
      } else {
        configuration.label
      }
    }
    .font(Theme.Typography.bodyBold)
    .foregroundStyle(.white)
    .frame(maxWidth: .infinity)
    .frame(height: 50)
    .background(isDisabled ? Theme.Colors.error.opacity(0.5) : Theme.Colors.error)
    .cornerRadius(12)
    .opacity(isDisabled ? 0.8 : 1.0)
    .conditionalEffect(
      .pushDown,
      condition: configuration.isPressed
    )
  }
}
