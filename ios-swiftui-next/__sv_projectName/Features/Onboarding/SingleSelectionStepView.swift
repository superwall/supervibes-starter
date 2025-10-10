import SwiftUI

/// Generic single selection step view for onboarding.
///
/// ## Purpose
/// Reusable step view for single selection from options during onboarding.
///
/// ## Include
/// - Single-selection UI via SelectableCard
/// - Option validation
///
/// ## Don't Include
/// - Business logic
/// - Data persistence
///
/// ## Lifecycle & Usage
/// Rendered as part of onboarding flow; accepts title, icon, and options as parameters.
///
struct SingleSelectionStepView: View {
  let title: String
  let subtitle: String?
  let icon: String
  let options: [String]
  @Binding var selectedValue: String?
  let isRequired: Bool
  let onContinue: () -> Void

  private var canContinue: Bool {
    !isRequired || selectedValue != nil
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

          // Selection Options
          VStack(spacing: 8) {
            ForEach(options, id: \.self) { option in
              SelectableCard(
                title: option,
                icon: nil,
                isSelected: selectedValue == option,
                onTap: {
                  selectedValue = option
                }
              )
            }
          }
          .padding(.horizontal, 32)

          Spacer()
            .frame(height: 20)
        }
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
  }
}

#Preview {
  NavigationStack {
    SingleSelectionStepView(
      title: "What's your age group?",
      subtitle: "This helps us show relevant content",
      icon: "calendar",
      options: ["Under 18", "18-24", "25-34", "35-49", "50+"],
      selectedValue: .constant(nil),
      isRequired: true,
      onContinue: {}
    )
  }
}
