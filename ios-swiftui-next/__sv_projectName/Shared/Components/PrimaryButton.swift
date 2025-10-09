import SwiftUI

/// Primary call-to-action button component
/// TEMPLATE NOTE: This is a reusable button that maintains consistent styling across the app
struct PrimaryButton: View {
  let title: String
  let action: () -> Void
  var isLoading: Bool = false
  var isDisabled: Bool = false

  var body: some View {
    Button(action: action) {
      Text(title)
    }
    .buttonStyle(PrimaryButtonStyle(isLoading: isLoading, isDisabled: isDisabled))
    .disabled(isLoading || isDisabled)
  }
}

#Preview("Normal") {
  PrimaryButton(title: "Continue") {
    print("Button tapped")
  }
  .padding()
}

#Preview("Loading") {
  PrimaryButton(title: "Continue", action: {}, isLoading: true)
    .padding()
}

#Preview("Disabled") {
  PrimaryButton(title: "Continue", action: {}, isDisabled: true)
    .padding()
}
