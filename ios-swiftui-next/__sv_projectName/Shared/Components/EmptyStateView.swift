import SwiftUI

/// Empty state view for lists and collections
/// TEMPLATE NOTE: Use this when there's no content to display
struct EmptyStateView: View {
  let icon: String
  let title: String
  let message: String
  var actionTitle: String?
  var action: (() -> Void)?

  var body: some View {
    VStack(spacing: 24) {
      Image(systemName: icon)
        .font(.system(size: 64))
        .foregroundStyle(Theme.Colors.secondaryText)

      VStack(spacing: 8) {
        Text(title)
          .font(Theme.Typography.title3)
          .foregroundStyle(Theme.Colors.primaryText)

        Text(message)
          .font(Theme.Typography.callout)
          .foregroundStyle(Theme.Colors.secondaryText)
          .multilineTextAlignment(.center)
      }

      if let actionTitle, let action {
        Button(action: action) {
          Text(actionTitle)
            .font(Theme.Typography.bodyBold)
            .foregroundStyle(Theme.Colors.primary)
        }
        .padding(.top, 12)
      }
    }
    .padding(32)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Theme.Colors.background)
  }
}

#Preview("Without Action") {
  EmptyStateView(
    icon: "tray",
    title: "No Items",
    message: "You don't have any items yet. They'll appear here when you add them."
  )
}

#Preview("With Action") {
  EmptyStateView(
    icon: "plus.circle",
    title: "Get Started",
    message: "Create your first item to begin.",
    actionTitle: "Create Item",
    action: { print("Create tapped") }
  )
}
