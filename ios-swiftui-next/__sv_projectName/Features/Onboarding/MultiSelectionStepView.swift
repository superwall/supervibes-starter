import SwiftUI

/// Generic multi-selection step view for onboarding.
///
/// ## Purpose
/// Reusable step view for multiple selection from options during onboarding.
///
/// ## Include
/// - Multi-selection UI via SelectableCard
/// - Support for optional icons per option
///
/// ## Don't Include
/// - Business logic
/// - Data persistence
///
/// ## Lifecycle & Usage
/// Rendered as part of onboarding flow; accepts title, icon, and options (with optional icons) as parameters.
///
struct MultiSelectionStepView: View {
  let title: String
  let subtitle: String?
  let icon: String
  let options: [(title: String, icon: String?)]
  @Binding var selectedValues: Set<String>
  let onComplete: () -> Void

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
            ForEach(options, id: \.title) { option in
              SelectableCard(
                title: option.title,
                icon: option.icon,
                isSelected: selectedValues.contains(option.title),
                onTap: {
                  toggleSelection(option.title)
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
      title: "What are you interested in?",
      subtitle: "Select all that apply",
      icon: "star.fill",
      options: [
        ("Cooking", "fork.knife"),
        ("Sports", "figure.run"),
        ("Music", "music.note"),
        ("Reading", "book.fill")
      ],
      selectedValues: .constant(["Cooking", "Sports"]),
      onComplete: {}
    )
  }
}
