import SwiftUI

/// Reusable progress bar component.
///
/// ## Purpose
/// Generic visual progress indicator showing current/total completion.
///
/// ## Include
/// - Progress calculation
/// - Animated bar UI
/// - Current/total display logic
///
/// ## Don't Include
/// - Navigation logic
/// - Data access
/// - Feature-specific behavior
///
/// ## Lifecycle & Usage
/// Used in navigation bars, forms, or any multi-step flow to show progress.
///
// TODO: Displays compact progress indicator (e.g., in navigation title)
struct ProgressBar: View {
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
    ProgressBar(current: 1, total: 3)
    ProgressBar(current: 2, total: 3)
    ProgressBar(current: 3, total: 3)
  }
  .padding()
}
