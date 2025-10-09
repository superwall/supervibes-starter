import SwiftUI
import Pow

/// Main app view - primary feature surface.
///
/// ## Purpose
/// Primary app surface; composes core feature entry points.
///
/// ## Include
/// - Lightweight composition
/// - Triggers to services
/// - Read-only views into User
///
/// ## Don't Include
/// - Data layers
/// - Deep networking
/// - Global configuration
///
/// ## Lifecycle & Usage
/// Lives most of the session; navigates via Router.
///
// TODO: Replace this with your app's main functionality. This is just an example.
struct MainView: View {
  @Bindable var user: User
  @Environment(Router.self) private var router
  @Environment(\.modelContext) private var modelContext

  @State private var showingSettings = false

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 32) {
        // Header
        VStack(alignment: .leading, spacing: 12) {
          if let displayName = user.displayName {
            Text("Hello, \(displayName)!")
              .font(Theme.Typography.title1)
          } else {
            Text("Welcome!")
              .font(Theme.Typography.title1)
          }
          
          Text("This is your main app view.")
          .font(Theme.Typography.callout)
          .foregroundStyle(Theme.Colors.secondaryText)

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 32)
        .padding(.top, 32)
        
     

        // Stats Card
        VStack(alignment: .leading, spacing: 16) {
           
        Text("Your Activity")
          .font(Theme.Typography.bodyBold)
          .foregroundStyle(Theme.Colors.secondaryText)

          HStack(spacing: 24) {
            StatItem(
              title: "Days Active",
              value: "\(user.daysSinceFirstLaunch)"
            )

            Divider()
              .frame(height: 40)

            StatItem(
              title: "Total Uses",
              value: "\(user.totalUsage)"
            )
          }
        }
        .padding(16)
        .cardStyle()
        .padding(.horizontal, 32)

        // Action Button
        PrimaryButton(title: "Log Usage") {
          logUsage()
        }
        .padding(.horizontal, 32)

        Spacer()
      }
    }
    .background(Theme.Colors.background)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          router.navigate(to: .settings)
        } label: {
          Image(systemName: "gearshape.fill")
        }
      }
    }
  }

  // MARK: - Actions

  private func logUsage() {
    // Increment usage counter
    user.logUsage()

    // Save context
    try? modelContext.save()

    // Sync to analytics
    user.syncToAnalytics()

    // Track analytics
    Analytics.track(event: .coreFeatureUsed)
  }
}

// MARK: - Stat Item Component

private struct StatItem: View {
  let title: String
  let value: String

  var body: some View {
    VStack(spacing: 8) {
      Text(value)
        .font(Theme.Typography.title1)
        .foregroundStyle(Theme.Colors.primary)
        .contentTransition(.numericText())
        .changeEffect(
          .rise(origin: .center) {
            Text("+1")
              .font(Theme.Typography.title3)
              .foregroundStyle(Theme.Colors.primary)
          },
          value: value
        )

      Text(title)
        .font(Theme.Typography.caption)
        .foregroundStyle(Theme.Colors.secondaryText)
    }
    .frame(maxWidth: .infinity)
  }
}

#Preview {
  NavigationStack {
    MainView(user: User(hasCompletedOnboarding: true, displayName: "John"))
  }
  .modelContainer(for: User.self, inMemory: true)
  .environment(Router())
}
