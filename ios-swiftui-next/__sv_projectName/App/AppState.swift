import SwiftUI

/// Ephemeral app-level state (non-persisted) for cross-feature flags and resolved config.
///
/// ## Purpose
/// Ephemeral, cross-feature flags and resolved config (non-persisted).
///
/// ## Include
/// - Session flags (e.g., isBusy)
/// - Resolved env snapshot (active environment)
/// - Lightweight permission/capability snapshots
///
/// ## Don't Include
/// - User data/settings
/// - Navigation paths
/// - Feature state
/// - Analytics counters
///
/// ## Lifecycle & Usage
/// Instantiated once and injected via .environment(...). Read by views; it doesn't own long-lived data.
///
// TODO: Use this for session flags and resolved config snapshots
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
    // TODO:  Add any app-level initialization here
    if AppConfig.debugLoggingEnabled {
      print("[AppState] Initialized")
    }
  }
}
