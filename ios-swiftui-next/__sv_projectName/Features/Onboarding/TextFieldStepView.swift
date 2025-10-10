import SwiftUI

/// Generic text field step view for onboarding.
///
/// ## Purpose
/// Reusable step view for collecting text input during onboarding.
///
/// ## Include
/// - TextField input
/// - Validation
/// - Auto-focus behavior
///
/// ## Don't Include
/// - Business logic
/// - Data persistence
///
/// ## Lifecycle & Usage
/// Rendered as part of onboarding flow; accepts title, icon, and placeholder as parameters.
///
struct TextFieldStepView: View {
  let title: String
  let subtitle: String?
  let icon: String
  let placeholder: String
  @Binding var value: String
  let isRequired: Bool
  let onContinue: () -> Void

  @FocusState private var isFocused: Bool

  private var canContinue: Bool {
    !isRequired || !value.trimmingCharacters(in: .whitespaces).isEmpty
  }

  var body: some View {
    VStack(spacing: 0) {
      ScrollView {
        VStack(spacing: 32) {

          // Icon
          Image(systemName: icon)
            .font(.system(size: 60))
            .foregroundStyle(Theme.Colors.primary)

          // Title & Subtitle
          VStack(spacing: 12) {
            Text(title)
              .font(Theme.Typography.title2)
              .multilineTextAlignment(.center)

            if let subtitle = subtitle {
              Text(subtitle)
                .font(Theme.Typography.callout)
                .foregroundStyle(Theme.Colors.secondaryText)
                .multilineTextAlignment(.center)
            }
          }
          .padding(.horizontal, 32)

          // Text Input
          VStack(alignment: .leading, spacing: 8) {
            TextField(placeholder, text: $value)
              .standardTextField()
              .focused($isFocused)
              .textContentType(.name)
              .autocapitalization(.words)
              .submitLabel(.continue)
              .onSubmit {
                if canContinue {
                  onContinue()
                }
              }

          }
          .padding(.horizontal, 32)

          Spacer()
        }
      }
      .scrollDismissesKeyboard(.interactively)
      .onTapGesture {
        isFocused = false
      }

      // Continue Button
      PrimaryButton(
        title: "Continue",
        action: onContinue,
        isDisabled: !canContinue
      )
      .padding(.horizontal, 32)
      .padding(.bottom, 32)
    }
    .background(Theme.Colors.background)
    .navigationBarTitleDisplayMode(.inline)
    .onAppear {
      // Auto-focus text field when view appears
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
        isFocused = true
      }
    }
  }
}

#Preview {
  NavigationStack {
    TextFieldStepView(
      title: "What should we call you?",
      subtitle: "Help us personalize your experience",
      icon: "person.fill",
      placeholder: "Your name",
      value: .constant(""),
      isRequired: true,
      onContinue: {}
    )
  }
}
