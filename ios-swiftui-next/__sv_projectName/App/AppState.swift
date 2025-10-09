import SwiftUI

/// Ephemeral app-level state (non-persisted)
/// TEMPLATE NOTE: Use this for session flags and resolved config snapshots
/// DO NOT put user data, navigation paths, or feature state here
@Observable
final class AppState {
  // MARK: - Session State

  /// Whether the app is currently busy with a blocking operation
  var isBusy: Bool = false

  // MARK: - App Lifecycle

  /// Date when the app was launched
  let launchDate = Date()

  /// Whether the app is currently in the foreground
  var isActive: Bool = true

  // MARK: - Initialization

  init() {
    // TEMPLATE NOTE: Add any app-level initialization here
    if AppConfig.debugLoggingEnabled {
      print("[AppState] Initialized")
    }
  }
}
