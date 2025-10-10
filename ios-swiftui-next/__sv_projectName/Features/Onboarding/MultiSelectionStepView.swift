import SwiftUI

/// Generic multi-selection step view for onboarding.
///
/// ## Purpose
/// Generic step view for multiple selection from options for any UserField with multiSelection input type.
///
/// ## Include
/// - Multi-selection UI via SelectableCard
/// - UserField-driven options and rendering
///
/// ## Don't Include
/// - Hard-coded options (driven by UserField protocol)
///
/// ## Lifecycle & Usage
/// Rendered as part of onboarding flow; works with any UserField where inputType == .multiSelection.
///
// TODO: Generic view driven by UserField for any multi-selection field
struct MultiSelectionStepView: View {
  let field: any UserField
  @Binding var selectedValues: Set<String>
  let onComplete: () -> Void

  private var options: [String] {
    if case .multiSelection(let options) = field.inputType {
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
                icon: InterestsField.Interest(rawValue: option)?.icon,
                isSelected: selectedValues.contains(option),
                onTap: {
                  toggleSelection(option)
                }
              )
            }
          }
          .padding(.horizontal, 32)

          Spacer()
            .frame(height: 20)
        }
      }

      // Finish Button
      PrimaryButton(
        title: "Finish",
        action: onComplete
      )
      .padding(.horizontal, 32)
      .padding(.bottom, 32)
    }
    .background(Theme.Colors.background)
    .navigationBarTitleDisplayMode(.inline)
  }

  private func toggleSelection(_ value: String) {
    if selectedValues.contains(value) {
      selectedValues.remove(value)
    } else {
      selectedValues.insert(value)
    }
  }
}

#Preview {
  NavigationStack {
    MultiSelectionStepView(
      field: InterestsField(),
      selectedValues: .constant(["Cooking", "Sports"]),
      onComplete: {}
    )
  }
}
