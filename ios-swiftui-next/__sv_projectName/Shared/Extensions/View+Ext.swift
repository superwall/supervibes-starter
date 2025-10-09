import SwiftUI

// MARK: - View Extensions
// TEMPLATE NOTE: Add generic, reusable view modifiers here

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
