import SwiftUI

/// Progress bar for onboarding flow.
///
/// ## Purpose
/// Visual progress indicator for onboarding steps.
///
/// ## Include
/// - Progress calculation
/// - Animated bar UI
/// - Current/total display logic
///
/// ## Don't Include
/// - Step navigation
/// - Data access
/// - Feature logic
///
/// ## Lifecycle & Usage
/// Displayed in navigation title area; shows current step position.
///
// TODO: Displays compact progress indicator for navigation title
struct OnboardingProgressBar: View {
  let current: Int
  let total: Int

  var progress: Double {
    guard total > 0 else { return 0 }
    return Double(current) / Double(total)
  }

  var body: some View {
    VStack(spacing: 4) {
      // Progress bar
      GeometryReader { geometry in
        ZStack(alignment: .leading) {
          // Background
          RoundedRectangle(cornerRadius: 2)
            .fill(Theme.Colors.border.opacity(0.3))
            .frame(height: 4)

          // Progress fill
          RoundedRectangle(cornerRadius: 2)
            .fill(Theme.Colors.primary)
            .frame(width: geometry.size.width * progress, height: 4)
            .animation(.easeInOut(duration: 0.3), value: progress)
        }
      }
      .frame(width: 200, height: 5)
    }
  }
}

#Preview {
  VStack(spacing: 20) {
    OnboardingProgressBar(current: 1, total: 3)
    OnboardingProgressBar(current: 2, total: 3)
    OnboardingProgressBar(current: 3, total: 3)
  }
  .padding()
}
