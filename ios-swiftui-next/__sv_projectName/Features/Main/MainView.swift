import SwiftUI
import Pow

/// Main app view - primary feature surface
/// TEMPLATE NOTE: Replace this with your app's main functionality. This is just an example.
struct MainView: View {
  @Bindable var user: User
  @Environment(Router.self) private var router
  @Environment(\.modelContext) private var modelContext

  @State private var showingSettings = false

  var body: some View {
    ScrollView {
      VStack(spacing: 32) {
        // Header
        VStack(alignment: .leading, spacing: 12) {
          if let displayName = user.displayName {
            Text("Hello, \(displayName)!")
              .font(Theme.Typography.title1)
          } else {
            Text("Welcome!")
              .font(Theme.Typography.title1)
          }

          Text("This is your main app view")
            .font(Theme.Typography.callout)
            .foregroundStyle(Theme.Colors.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 32)
        .padding(.top, 32)

        // Stats Card
        VStack(alignment: .leading, spacing: 16) {
          Text("Your Activity")
            .font(Theme.Typography.title3)

          HStack(spacing: 24) {
            StatItem(
              title: "Days Active",
              value: "\(user.daysSinceFirstLaunch)"
            )

            Divider()
              .frame(height: 40)

            StatItem(
              title: "Total Uses",
              value: "\(user.totalCoreFeatureUses)"
            )
          }
        }
        .padding(24)
        .cardStyle()
        .padding(.horizontal, 32)

        // Action Button
        PrimaryButton(title: "Use Core Feature") {
          useCoreFeature()
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
          Image(systemName: "gearshape")
        }
      }
    }
  }

  // MARK: - Actions

  private func useCoreFeature() {
    // Increment usage counter
    user.incrementCoreFeatureUse()

    // Save context
    try? modelContext.save()

    // Track analytics
    Analytics.track(event: .coreFeatureUsed)
    Analytics.increment(property: "total_feature_uses")
  }
}

// MARK: - Stat Item Component

private struct StatItem: View {
  let title: String
  let value: String

  var body: some View {
    VStack(spacing: 8) {
      Text(value)
        .font(Theme.Typography.title2)
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
