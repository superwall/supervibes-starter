import SwiftUI

/// Multiple selection step for onboarding.
///
/// ## Purpose
/// Dedicated step view for multi-interest selection.
///
/// ## Include
/// - Multi-selection UI via SelectableCard
/// - Interest enum options
/// - ProfileField-driven rendering
///
/// ## Don't Include
/// - Hard-coded options (uses InterestsField from ProfileField system)
///
/// ## Lifecycle & Usage
/// Rendered as part of onboarding flow; updates User.interests array.
///
// TODO: Generic view driven by ProfileField for any multi-selection field
struct InterestsStepView: View {
  let field: any ProfileField
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
                icon: Interest(rawValue: option)?.icon,
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
    InterestsStepView(
      field: InterestsField(),
      selectedValues: .constant(["Cooking", "Sports"]),
      onComplete: {}
    )
  }
}
