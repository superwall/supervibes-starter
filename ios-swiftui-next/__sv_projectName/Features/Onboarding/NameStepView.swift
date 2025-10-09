import SwiftUI

/// Text input step for onboarding.
///
/// ## Purpose
/// Dedicated step view for collecting user's name.
///
/// ## Include
/// - TextField input
/// - Validation
/// - ProfileField-driven rendering
///
/// ## Don't Include
/// - Hard-coded field definitions (uses NameField from ProfileField system)
///
/// ## Lifecycle & Usage
/// Rendered as part of onboarding flow; updates User.displayName.
///
// TODO: Generic view driven by ProfileField for any text input field
struct NameStepView: View {
  let field: any ProfileField
  @Binding var value: String
  let onContinue: () -> Void

  @FocusState private var isFocused: Bool

  private var canContinue: Bool {
    !field.isRequired || !value.trimmingCharacters(in: .whitespaces).isEmpty
  }

  private var placeholder: String {
    if case .textField(let placeholder) = field.inputType {
      return placeholder
    }
    return "Enter text"
  }

  var body: some View {
    VStack(spacing: 0) {
      ScrollView {
        VStack(spacing: 32) {

          // Icon
          Image(systemName: field.icon)
            .font(.system(size: 60))
            .foregroundStyle(Theme.Colors.primary)

          // Title & Subtitle
          VStack(spacing: 12) {
            Text(field.onboardingTitle ?? field.displayName)
              .font(Theme.Typography.title2)
              .multilineTextAlignment(.center)

            if let subtitle = field.onboardingSubtitle {
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
    NameStepView(
      field: NameField(),
      value: .constant(""),
      onContinue: {}
    )
  }
}
