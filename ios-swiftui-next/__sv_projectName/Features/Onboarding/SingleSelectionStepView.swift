import SwiftUI

/// Generic single selection step view for onboarding.
///
/// ## Purpose
/// Generic step view for single selection from options for any UserField with singleSelection input type.
///
/// ## Include
/// - Single-selection UI via SelectableCard
/// - UserField-driven options and rendering
///
/// ## Don't Include
/// - Hard-coded options (driven by UserField protocol)
///
/// ## Lifecycle & Usage
/// Rendered as part of onboarding flow; works with any UserField where inputType == .singleSelection.
///
// TODO: Generic view driven by UserField for any single selection field
struct SingleSelectionStepView: View {
  let field: any UserField
  @Binding var selectedValue: String?
  let onContinue: () -> Void

  private var canContinue: Bool {
    !field.isRequired || selectedValue != nil
  }

  private var options: [String] {
    if case .singleSelection(let options) = field.inputType {
      return options
    }
    return []
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
      field: AgeGroupField(),
      selectedValue: .constant(nil),
      onContinue: {}
    )
  }
}
