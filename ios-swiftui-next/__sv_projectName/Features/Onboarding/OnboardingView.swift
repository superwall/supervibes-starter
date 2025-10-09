import SwiftUI

/// Onboarding flow for new users
/// TEMPLATE NOTE: Customize this with your app's onboarding steps
struct OnboardingView: View {
  @Bindable var user: User
  @Environment(\.modelContext) private var modelContext

  @State private var currentStep = 0
  @State private var displayName = ""
  @FocusState private var isFocused: Bool

  var body: some View {
    VStack(spacing: 0) {
      ScrollView {
        VStack(spacing: 32) {
          Spacer()

          // Header
          VStack(spacing: 16) {
            Image(systemName: "star.circle.fill")
              .font(.system(size: 80))
              .foregroundStyle(Theme.Colors.primary)

            Text("Welcome to __sv_projectName")
              .font(Theme.Typography.title1)
              .fixedSize(horizontal: false, vertical: true)
              .multilineTextAlignment(.center)
          }
          
          Spacer()

          // Optional: Name input
          VStack(spacing: 16) {
            Text("What should we call you?")
              .font(Theme.Typography.body)

            TextField("Your name", text: $displayName)
              .standardTextField()
              .focused($isFocused)
              .textContentType(.name)
              .autocapitalization(.words)
          }
          

          Spacer()
        }
        .padding(.horizontal, 32)

      }
      .scrollDismissesKeyboard(.interactively)
      // Continue button
      PrimaryButton(title: "Get Started") {
        completeOnboarding()
        isFocused = false
      }.padding()
    }
    .onTapGesture {
      isFocused = false
    }
    .background(Theme.Colors.background)
  }

  // MARK: - Actions

  private func completeOnboarding() {
    // Update user record
    user.displayName = displayName.isBlank ? nil : displayName
    user.completeOnboarding()

    // Save context
    try? modelContext.save()

    // Track analytics
    Analytics.track(event: .onboardingCompleted)
  }
}

#Preview {
  OnboardingView(user: User())
    .modelContainer(for: User.self, inMemory: true)
}
