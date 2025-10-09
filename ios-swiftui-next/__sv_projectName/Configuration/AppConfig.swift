import Foundation

/// Centralized configuration for the application
/// TEMPLATE NOTE: Customize these values for your specific application needs
enum AppConfig {
  // MARK: - Feature Flags

  /// Enable analytics tracking
  /// TEMPLATE NOTE: Set to false during development if needed
  static let analyticsEnabled = true

  /// Enable debug logging
  /// TEMPLATE NOTE: Should be tied to build configuration
  static let debugLoggingEnabled = {
    #if DEBUG
    return true
    #else
    return false
    #endif
  }()

  // MARK: - App Metadata

  /// App version from bundle
  static let appVersion: String = {
    Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
  }()

  /// Build number from bundle
  static let buildNumber: String = {
    Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
  }()

  // MARK: - Local Storage

  /// UserDefaults suite name for app preferences
  /// TEMPLATE NOTE: Customize to match your bundle identifier pattern
  static let userDefaultsSuiteName = "com.supervibes.__sv_projectName.defaults"
}
