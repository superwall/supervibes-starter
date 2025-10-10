import SwiftUI
import Pow

/// Selectable card component for onboarding choices.
///
/// ## Purpose
/// Reusable card component for single/multi-selection in onboarding.
///
/// ## Include
/// - Selection visual state
/// - Press feedback via ButtonStyle
/// - Icon/title/checkmark layout
///
/// ## Don't Include
/// - Data models
/// - Navigation
/// - Analytics
///
/// ## Lifecycle & Usage
/// Used in step views for choosing options; demonstrates proper ButtonStyle usage with `configuration.isPressed`.
///
// TODO: Reusable card for single or multiple selection flows
struct SelectableCard: View {
  let title: String
  let icon: String?
  let isSelected: Bool
  let onTap: () -> Void

  var body: some View {
    Button(action: onTap) {
      HStack(spacing: 16) {
        // Icon (if provided)
        if let icon = icon {
          Image(systemName: icon)
            .font(.system(size: 24))
            .foregroundStyle(isSelected ? Theme.Colors.primary : Theme.Colors.secondaryText)
            .frame(width: 32)
        }

        // Title
        Text(title)
          .font(Theme.Typography.body)
          .foregroundStyle(isSelected ? Theme.Colors.primaryText : Theme.Colors.secondaryText)
          .frame(maxWidth: .infinity, alignment: .leading)

        // Checkmark
        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
          .font(.system(size: 24))
          .foregroundStyle(isSelected ? Theme.Colors.primary : Theme.Colors.border)
      }
      .padding(16)
      .background(
        isSelected ? Theme.Colors.primary.opacity(0.1) : Theme.Colors.secondaryBackground
      )
      .cornerRadius(12)
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(
            isSelected ? Theme.Colors.primary : Theme.Colors.borderLight,
            lineWidth: isSelected ? 2 : 1
          )
      )
    }
    .buttonStyle(SelectableCardButtonStyle())
  }
}

// MARK: - Button Style

/// Button style for selectable cards with press feedback
private struct SelectableCardButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .conditionalEffect(
        .pushDown,
        condition: configuration.isPressed
      )
  }
}

#Preview {
  VStack(spacing: 16) {
    SelectableCard(
      title: "Cooking",
      icon: "fork.knife",
      isSelected: false,
      onTap: {}
    )

    SelectableCard(
      title: "Sports",
      icon: "figure.run",
      isSelected: true,
      onTap: {}
    )

    SelectableCard(
      title: "Music",
      icon: nil,
      isSelected: false,
      onTap: {}
    )
  }
  .padding()
}
