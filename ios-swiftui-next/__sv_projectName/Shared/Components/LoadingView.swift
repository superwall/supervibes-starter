import SwiftUI

/// Standard loading indicator view
/// TEMPLATE NOTE: Use this for async operations and data loading states
struct LoadingView: View {
  var message: String?

  var body: some View {
    VStack(spacing: 16) {
      ProgressView()
        .scaleEffect(1.5)

      if let message {
        Text(message)
          .font(Theme.Typography.callout)
          .foregroundStyle(Theme.Colors.secondaryText)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Theme.Colors.background)
  }
}

#Preview("Without Message") {
  LoadingView()
}

#Preview("With Message") {
  LoadingView(message: "Loading your data...")
}
