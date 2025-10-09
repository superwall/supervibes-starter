import SwiftUI

// MARK: - Text Field Styles
// TEMPLATE NOTE: Define reusable text field styles for consistent appearance

/// Standard text field style with border
struct StandardTextFieldStyle: TextFieldStyle {
  var isError: Bool = false

  func _body(configuration: TextField<Self._Label>) -> some View {
    configuration
      .padding(16)
      .background(Theme.Colors.secondaryBackground)
      .cornerRadius(8)
      .overlay(
        RoundedRectangle(cornerRadius: 8)
          .stroke(isError ? Theme.Colors.error : Theme.Colors.border, lineWidth: 1)
      )
  }
}

// MARK: - Helper View Modifiers

extension View {
  /// Apply standard text field styling
  func standardTextField(isError: Bool = false) -> some View {
    self.textFieldStyle(StandardTextFieldStyle(isError: isError))
  }
}
