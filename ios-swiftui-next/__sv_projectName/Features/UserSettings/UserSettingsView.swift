import SwiftUI

/// User settings and preferences view.
///
/// ## Purpose
/// Edit preferences backed directly by the User model; reflect theme/preferences.
///
/// ## Include
/// - Bindings to User fields
/// - Field definitions (inline, declarative)
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
/// ## Customization
/// To customize settings:
/// 1. Add/remove fields in the Profile section
/// 2. Modify field labels, icons, and options inline
/// 3. Add corresponding properties to the User model if needed
///
struct UserSettingsView: View {
  @Bindable var user: User
  @Environment(\.modelContext) private var modelContext
  @Environment(Router.self) private var router

  @State private var showingResetConfirmation = false
  @State private var showingInterestsSheet = false

  var body: some View {
    Form {
      // Profile Section
      Section("Profile") {
        // Name Field
        HStack {
          Image(systemName: "person.fill")
            .foregroundStyle(Theme.Colors.primary)
            .frame(width: 24)
          Text("Name")
          Spacer()
          TextField("Your name", text: Binding(
            get: { user.displayName ?? "" },
            set: { user.displayName = $0.isEmpty ? nil : $0 }
          ))
          .multilineTextAlignment(.trailing)
          .foregroundStyle(Theme.Colors.secondaryText)
          .textContentType(.name)
          .autocapitalization(.words)
        }

        // Age Group Field
        HStack {
          Image(systemName: "calendar")
            .foregroundStyle(Theme.Colors.primary)
            .frame(width: 24)
          Picker("Age Group", selection: $user.ageGroup) {
            Text("Not set").tag(nil as String?)
            ForEach(User.ageGroupOptions, id: \.self) { ageGroup in
              Text(ageGroup).tag(ageGroup as String?)
            }
          }
        }

        // Interests Field
        HStack {
          Image(systemName: "star.fill")
            .foregroundStyle(Theme.Colors.primary)
            .frame(width: 24)
          Button {
            showingInterestsSheet = true
          } label: {
            HStack {
              Text("Interests")
                .foregroundStyle(Theme.Colors.primaryText)
              Spacer()
              Text(user.interests.isEmpty ? "None" : "\(user.interests.count) selected")
                .foregroundStyle(Theme.Colors.secondaryText)
              Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(Theme.Colors.secondaryText)
            }
          }
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
          ForEach(User.Theme.allCases, id: \.self) { theme in
            Text(theme.displayName).tag(theme)
          }
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
    .sheet(isPresented: $showingInterestsSheet) {
      InterestsSelectionSheet(
        interests: User.interestOptions.map(\.title),
        selectedInterests: $user.interests
      )
      .presentationDetents([.medium])
    }
  }

  // MARK: - Actions

  private func handleThemeChange(_ newTheme: User.Theme) {
    user.updateTheme(newTheme)

    // Save context
    try? modelContext.save()

    // Sync to analytics
    user.syncToAnalytics()

    // Track analytics
    Analytics.track(
      event: .themeChanged,
      properties: ["theme": newTheme.rawValue]
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

// MARK: - Interests Selection Sheet

/// Sheet view for selecting multiple interests
private struct InterestsSelectionSheet: View {
  let interests: [String]
  @Binding var selectedInterests: [String]

  @Environment(\.dismiss) private var dismiss

  var body: some View {
    NavigationStack {
      List {
        ForEach(interests, id: \.self) { interest in
          Button {
            toggleSelection(interest)
          } label: {
            HStack(spacing: 12) {
              Text(interest)
                .foregroundStyle(Theme.Colors.primaryText)

              Spacer()

              if selectedInterests.contains(interest) {
                Image(systemName: "checkmark")
                  .foregroundStyle(Theme.Colors.primary)
              }
            }
          }
        }
      }
      .navigationTitle("Interests")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Image(systemName: "star.fill")
            .foregroundStyle(Theme.Colors.primary)
        }

        ToolbarItem(placement: .topBarTrailing) {
          Button("Done") {
            dismiss()
          }
        }
      }
    }
  }

  private func toggleSelection(_ interest: String) {
    if selectedInterests.contains(interest) {
      selectedInterests.removeAll { $0 == interest }
    } else {
      selectedInterests.append(interest)
    }
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
