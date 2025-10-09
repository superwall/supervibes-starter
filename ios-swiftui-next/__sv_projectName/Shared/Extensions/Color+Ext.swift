import SwiftUI

/// Color conveniences (e.g., hex init, semantic aliases to Theme/assets).
///
/// ## Purpose
/// Color conveniences (e.g., hex init, semantic aliases to Theme/assets).
///
/// ## Include
/// - Safe initializers
/// - Mapping to asset colors
///
/// ## Don't Include
/// - Random ad-hoc constants; prefer Theme/Assets
///
/// ## Lifecycle & Usage
/// Reference semantic names consistently.

// MARK: - Color Extensions
// TODO:  Add color utilities and hex init here

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
