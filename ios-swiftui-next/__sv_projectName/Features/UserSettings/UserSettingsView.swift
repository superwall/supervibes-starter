import SwiftUI

/// User settings and preferences view.
///
/// ## Purpose
/// Edit preferences backed directly by the User model; reflect theme/preferences.
///
/// ## Include
/// - Bindings to User fields
/// - Small validation
/// - Optional analytics event on change
///
/// ## Don't Include
/// - Non-user settings
/// - Orchestration for other features
///
/// ## Lifecycle & Usage
/// Reads/writes SwiftData through bindings; emits analytics as needed.
///
// TODO: Customize with your app's settings
struct UserSettingsView: View {
  @Bindable var user: User
  @Environment(\.modelContext) private var modelContext
  @Environment(Router.self) private var router

  @State private var showingResetConfirmation = false

  var body: some View {
    Form {
      // Profile Section
      Section("Profile") {
        // Dynamic user fields from UserFieldRegistry
        ForEach(UserFieldRegistry.settingsFields, id: \.key) { field in
          userFieldEditor(for: field)
        }

        // Static fields
        HStack {
          Image(systemName: "person.text.rectangle.fill")
            .foregroundStyle(Theme.Colors.primary)
            .frame(width: 24)
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
          Text("Core Feature Uses")
          Spacer()
          Text("\(user.totalUsage)")
            .foregroundStyle(Theme.Colors.secondaryText)
        }

        HStack {
          Text("Last Activity")
          Spacer()
          Text(user.lastActivityDate, style: .relative)
            .foregroundStyle(Theme.Colors.secondaryText)
        }
        
        HStack {
          Text("Days Since Install")
          Spacer()
          Text("\(user.daysSinceFirstLaunch)")
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
          showingResetConfirmation = true
        }
        .foregroundStyle(Theme.Colors.error)
      } footer: {
        Text("This will clear all app data and return you to onboarding.")
          .font(Theme.Typography.caption)
      }
    }
    .scrollDismissesKeyboard(.immediately)
    .navigationTitle("Settings")
    .navigationBarTitleDisplayMode(.inline)
    .task {
      Analytics.track(event: .settingsViewed)
    }
    .alert("Reset App?", isPresented: $showingResetConfirmation) {
      Button("Cancel", role: .cancel) { }
      Button("Reset", role: .destructive) {
        resetApp()
      }
    } message: {
      Text("This will clear all your data and return you to onboarding. This action cannot be undone.")
    }
  }

  // MARK: - User Field Editors

  @ViewBuilder
  private func userFieldEditor(for field: any UserField) -> some View {
    switch field.inputType {
    case .textField:
      HStack {
        Image(systemName: field.icon)
          .foregroundStyle(Theme.Colors.primary)
          .frame(width: 24)
        UserFieldTextEditor(
          field: field,
          value: bindingForTextField(key: field.key)
        )
      }

    case .singleSelection:
      HStack {
        Image(systemName: field.icon)
          .foregroundStyle(Theme.Colors.primary)
          .frame(width: 24)
        UserFieldSingleSelectionEditor(
          field: field,
          value: bindingForSingleSelection(key: field.key)
        )
      }

    case .multiSelection:
      HStack {
        Image(systemName: field.icon)
          .foregroundStyle(Theme.Colors.primary)
          .frame(width: 24)
        UserFieldMultiSelectionEditor(
          field: field,
          values: bindingForMultiSelection(key: field.key)
        )
      }
    }
  }

  private func bindingForTextField(key: String) -> Binding<String> {
    switch key {
    case "name":
      return Binding(
        get: { user.displayName ?? "" },
        set: { user.displayName = $0.isEmpty ? nil : $0 }
      )
    default:
      return .constant("")
    }
  }

  private func bindingForSingleSelection(key: String) -> Binding<String?> {
    switch key {
    case "ageGroup":
      return $user.ageGroup
    default:
      return .constant(nil)
    }
  }

  private func bindingForMultiSelection(key: String) -> Binding<[String]> {
    switch key {
    case "interests":
      return $user.interests
    default:
      return .constant([])
    }
  }

  // MARK: - Actions

  private func handleThemeChange(_ newTheme: String) {
    user.updateTheme(newTheme)

    // Save context
    try? modelContext.save()

    // Sync to analytics
    user.syncToAnalytics()

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
    user.reset()

    // Save changes
    try? modelContext.save()

    // Sync to analytics (clears properties)
    user.syncToAnalytics()

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
      totalUsage: 42
    ))
  }
  .modelContainer(for: User.self, inMemory: true)
  .environment(Router())
}
