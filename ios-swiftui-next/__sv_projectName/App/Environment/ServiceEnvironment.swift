import SwiftUI

// MARK: - Service Environment Keys
// TEMPLATE NOTE: Define custom environment keys for app-wide services

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
// TEMPLATE NOTE: These make it easier to access services in views

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
