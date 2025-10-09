import SwiftUI

/// Initial welcome screen for onboarding.
///
/// ## Purpose
/// Welcome screen for onboarding flow.
///
/// ## Include
/// - Welcome message
/// - App introduction
/// - Simple navigation to first step
///
/// ## Don't Include
/// - Data collection
/// - Complex logic
///
/// ## Lifecycle & Usage
/// First screen shown to new users; optional welcome step before profile fields.
///
// TODO: Customize branding and welcome message
struct WelcomeStepView: View {
  let onGetStarted: () -> Void

  var body: some View {
    VStack(spacing: 0) {
      ScrollView {
        VStack(spacing: 32) {
          Spacer()
            .frame(height: 60)

          // App Icon/Branding
          Image(systemName: "hands.clap.fill")
            .font(.system(size: 100))
            .foregroundStyle(Theme.Colors.primary)

          // Welcome Text
          VStack(spacing: 16) {
            Text("Welcome to __sv_projectName")
              .font(Theme.Typography.title1)
              .multilineTextAlignment(.center)

            Text("Let's get you started with a quick setup")
              .font(Theme.Typography.callout)
              .foregroundStyle(Theme.Colors.secondaryText)
              .multilineTextAlignment(.center)
          }
          .padding(.horizontal, 32)

          Spacer()
            .frame(height: 60)
        }
      }

      // Get Started Button
      PrimaryButton(title: "Get Started") {
        onGetStarted()
      }
      .padding(.horizontal, 32)
      .padding(.bottom, 32)
    }
    .background(Theme.Colors.background)
  }
}

#Preview {
  WelcomeStepView(onGetStarted: {})
}
