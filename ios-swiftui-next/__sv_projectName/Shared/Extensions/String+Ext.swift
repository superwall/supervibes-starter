import Foundation

// MARK: - String Extensions
// TEMPLATE NOTE: Add lightweight, pure string utilities here

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
  /// TEMPLATE NOTE: Basic validation - adjust regex for your requirements
  var isValidEmail: Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: self)
  }
}
