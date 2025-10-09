import SwiftUI

/// Centralized navigation router
/// TEMPLATE NOTE: Extend Route enum with your app's routes
/// This provides a single place to manage all navigation
@Observable
final class Router {
  // MARK: - Navigation State

  var path = NavigationPath()

  // MARK: - Navigation Actions

  /// Navigate to a route
  func navigate(to route: Route) {
    path.append(route)
  }

  /// Go back one step
  func goBack() {
    guard !path.isEmpty else { return }
    path.removeLast()
  }

  /// Pop to root
  func popToRoot() {
    path = NavigationPath()
  }

  /// Handle deep link
  /// TEMPLATE NOTE: Implement deep link parsing for your routes
  func handleDeepLink(_ url: URL) {
    // Example: myapp://feature/detail/123
    // guard url.scheme == "myapp" else { return }

    // Parse and navigate
    // let components = url.pathComponents
    // ... parse and navigate to appropriate route
  }
}

// MARK: - Routes

/// App navigation routes
/// TEMPLATE NOTE: Add your app-specific routes here
enum Route: Hashable {
  case main
  case settings
  case onboarding

  // Example parameterized routes
  // case detail(id: String)
  // case profile(userId: String)
}
