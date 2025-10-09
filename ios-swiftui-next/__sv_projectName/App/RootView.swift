import SwiftUI
import SwiftData

/// Root view that switches between feature trees based on user state.
///
/// ## Purpose
/// App-level switcher that chooses which feature tree to show (e.g., Onboarding vs Main).
///
/// ## Include
/// - Simple branching/composition based on User/AppState
///
/// ## Don't Include
/// - Heavy logic
/// - Storage/network behavior
///
/// ## Lifecycle & Usage
/// Always present; reacts to state and swaps feature trees.
///
// TODO: This is where you decide what the user sees (Onboarding vs Main app)
struct RootView: View {
  @Query private var users: [User]
  @Environment(Router.self) private var router

  var body: some View {
    Group {
      if let user = users.first {
        if user.isNewUser {
          OnboardingView(user: user)
        } else {
          NavigationStack(path: Bindable(router).path) {
            MainView(user: user)
              .navigationDestination(for: Route.self) { route in
                destinationView(for: route)
              }
          }
        }
      } else {
        LoadingView(message: "Setting up your app...")
      }
    }
    .preferredColorScheme(users.first?.colorScheme)
  }

  // MARK: - Navigation Destinations

  @ViewBuilder
  private func destinationView(for route: Route) -> some View {
    switch route {
    case .main:
      if let user = users.first {
        MainView(user: user)
      }

    case .settings:
      if let user = users.first {
        UserSettingsView(user: user)
      }

    case .onboarding:
      if let user = users.first {
        OnboardingView(user: user)
      }
    }
  }
}

#Preview {
  RootView()
    .modelContainer(for: User.self, inMemory: true)
    .environment(Router())
    .environment(AppState())
}
