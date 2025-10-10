import SwiftUI

/// Generic extensions for common types.
///
/// ## Purpose
/// Lightweight, reusable extensions for View, Color, and String.
///
/// ## Include
/// - View modifiers (cardStyle, conditional transforms, keyboard helpers)
/// - Color utilities (hex init)
/// - String utilities (validation, trimming)
///
/// ## Don't Include
/// - Feature-specific logic
/// - Heavy business logic
/// - Side-effects beyond UI updates
///
/// ## Lifecycle & Usage
/// Keep minimal and well-named to avoid collisions; lean on Foundation when possible.
///
// TODO: Add generic, reusable extensions here

// MARK: - View Extensions

extension View {
  /// Apply standard card styling
  func cardStyle() -> some View {
    self
      .background(Theme.Colors.secondaryBackground)
      .cornerRadius(12)
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(Theme.Colors.borderLight, lineWidth: 1)
      )
  }

  /// Apply conditional view modification
  @ViewBuilder
  func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
    if condition {
      transform(self)
    } else {
      self
    }
  }

  /// Hide keyboard
  func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}

// MARK: - Color Extensions

extension Color {
  /// Initialize a Color from a hex string
  // TODO: Use sparingly - prefer theme colors from Assets or Theme.swift
  /// - Parameter hex: Hex string (e.g., "#FF5733" or "FF5733")
  init(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)

    let a, r, g, b: UInt64
    switch hex.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (255, 0, 0, 0)
    }

    self.init(
      .sRGB,
      red: Double(r) / 255,
      green: Double(g) / 255,
      blue: Double(b) / 255,
      opacity: Double(a) / 255
    )
  }
}

// MARK: - String Extensions

extension String {
  /// Check if string is empty or contains only whitespace
  var isBlank: Bool {
    trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  /// Trim whitespace and newlines
  var trimmed: String {
    trimmingCharacters(in: .whitespacesAndNewlines)
  }

  /// Validate email format
  // TODO: Basic validation - adjust regex for your requirements
  var isValidEmail: Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: self)
  }
}
