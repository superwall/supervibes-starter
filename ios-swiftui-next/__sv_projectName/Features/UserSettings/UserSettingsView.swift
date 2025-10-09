import SwiftUI

/// User settings and preferences view
/// TEMPLATE NOTE: Customize with your app's settings
struct UserSettingsView: View {
  @Bindable var user: User
  @Environment(\.modelContext) private var modelContext
  @Environment(Router.self) private var router

  var body: some View {
    Form {
      // Profile Section
      Section("Profile") {
        HStack {
          Text("Display Name")
          Spacer()
          Text(user.displayName ?? "Not set")
            .foregroundStyle(Theme.Colors.secondaryText)
        }

        HStack {
          Text("Member Since")
          Spacer()
          Text(user.firstLaunchDate, style: .date)
            .foregroundStyle(Theme.Colors.secondaryText)
        }
      }

      // Preferences Section
      Section("Preferences") {
        Picker("Theme", selection: $user.preferredTheme) {
          Text("System").tag("system")
          Text("Light").tag("light")
          Text("Dark").tag("dark")
        }
        .onChange(of: user.preferredTheme) { _, newValue in
          handleThemeChange(newValue)
        }
      }

      // Statistics Section
      Section("Statistics") {
        HStack {
          Text("Days Since First Launch")
          Spacer()
          Text("\(user.daysSinceFirstLaunch)")
            .foregroundStyle(Theme.Colors.secondaryText)
        }

        HStack {
          Text("Core Feature Uses")
          Spacer()
          Text("\(user.totalCoreFeatureUses)")
            .foregroundStyle(Theme.Colors.secondaryText)
        }

        HStack {
          Text("Last Activity")
          Spacer()
          Text(user.lastActivityDate, style: .relative)
            .foregroundStyle(Theme.Colors.secondaryText)
        }
      }

      // App Info Section
      Section("About") {
        HStack {
          Text("Version")
          Spacer()
          Text(AppConfig.appVersion)
            .foregroundStyle(Theme.Colors.secondaryText)
        }

        HStack {
          Text("Build")
          Spacer()
          Text(AppConfig.buildNumber)
            .foregroundStyle(Theme.Colors.secondaryText)
        }
      }

      // Reset Section
      Section {
        Button("Reset App") {
          resetApp()
        }
        .foregroundStyle(Theme.Colors.error)
      } footer: {
        Text("This will clear all app data and return you to onboarding.")
          .font(Theme.Typography.caption)
      }
    }
    .navigationTitle("Settings")
    .navigationBarTitleDisplayMode(.inline)
    .task {
      Analytics.track(event: .settingsViewed)
    }
  }

  // MARK: - Actions

  private func handleThemeChange(_ newTheme: String) {
    user.updateTheme(newTheme)

    // Save context
    try? modelContext.save()

    // Track analytics
    Analytics.track(
      event: .themeChanged,
      properties: ["theme": newTheme]
    )
  }

  private func resetApp() {
    // Track reset event before clearing
    Analytics.track(event: .appReset)

    // Reset user data
    user.hasCompletedOnboarding = false
    user.displayName = nil
    user.preferredTheme = "system"
    user.totalCoreFeatureUses = 0
    user.lastActivityDate = Date()

    // Save changes
    try? modelContext.save()

    // Reset analytics
    Analytics.reset()

    // Navigate back to root (will trigger onboarding)
    router.popToRoot()
  }
}

#Preview {
  NavigationStack {
    UserSettingsView(user: User(
      hasCompletedOnboarding: true,
      displayName: "John Doe",
      totalCoreFeatureUses: 42
    ))
  }
  .modelContainer(for: User.self, inMemory: true)
  .environment(Router())
}
