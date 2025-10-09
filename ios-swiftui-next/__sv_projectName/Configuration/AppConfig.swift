import Foundation

/// Centralized configuration for the application.
///
/// ## Purpose
/// Centralized config (base URLs for NetworkClient, feature flags snapshot).
///
/// ## Include
/// - Static constants or light resolution logic
///
/// ## Don't Include
/// - Secrets in source control
/// - Mutable runtime state
///
/// ## Lifecycle & Usage
/// Read early (e.g., in __sv_projectNameApp) and pass into services.
///
// TODO: Customize these values for your specific application needs
enum AppConfig {
  // MARK: - Feature Flags

  /// Enable analytics tracking
  // TODO: Set to false during development if needed
  static let analyticsEnabled = true

  /// Enable debug logging
  // TODO: Should be tied to build configuration
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
  // TODO: Customize to match your bundle identifier pattern
  static let userDefaultsSuiteName = "com.supervibes.__sv_projectName.defaults"
}
