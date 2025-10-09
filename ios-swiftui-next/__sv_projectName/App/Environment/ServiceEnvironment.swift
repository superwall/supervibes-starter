import SwiftUI

/// Typed environment registrations for app-wide services.
///
/// ## Purpose
/// Typed environment registrations for app-wide services (e.g., NetworkClient, theme, auth handle).
///
/// ## Include
/// - Custom EnvironmentKeys and convenience accessors
/// - Service wiring
///
/// ## Don't Include
/// - Business rules
/// - Feature logic
///
/// ## Lifecycle & Usage
/// Initialize services in __sv_projectNameApp and inject via .environment(...). Views retrieve them with @Environment(ServiceType.self).

// MARK: - Service Environment Keys
// TODO:  Define custom environment keys for app-wide services

/// Environment key for NetworkClient
private struct NetworkClientKey: EnvironmentKey {
  nonisolated(unsafe) static let defaultValue = NetworkClient()
}

/// Environment key for Router
private struct RouterKey: EnvironmentKey {
  nonisolated(unsafe) static let defaultValue = Router()
}

/// Environment key for AppState
private struct AppStateKey: EnvironmentKey {
  nonisolated(unsafe) static let defaultValue = AppState()
}

// MARK: - Environment Values Extension

extension EnvironmentValues {
  var networkClient: NetworkClient {
    get { self[NetworkClientKey.self] }
    set { self[NetworkClientKey.self] = newValue }
  }

  var router: Router {
    get { self[RouterKey.self] }
    set { self[RouterKey.self] = newValue }
  }

  var appState: AppState {
    get { self[AppStateKey.self] }
    set { self[AppStateKey.self] = newValue }
  }
}

// MARK: - Convenience Accessors
// TODO:  These make it easier to access services in views

extension View {
  func withServices(
    networkClient: NetworkClient,
    router: Router,
    appState: AppState
  ) -> some View {
    self
      .environment(networkClient)
      .environment(router)
      .environment(appState)
  }
}
