import Foundation

/// Represents a step in the onboarding flow.
///
/// ## Purpose
/// Enum representing onboarding steps, driven by UserField definitions.
///
/// ## Include
/// - Step enum cases
/// - UserField lookups via UserFieldRegistry
/// - Step metadata (title, subtitle, icon, isRequired)
///
/// ## Don't Include
/// - UI code
/// - Data models
/// - Business logic beyond step definitions
///
/// ## Lifecycle & Usage
/// Used by OnboardingView to determine flow; provides convenience static cases (`.name`, `.ageGroup`, `.interests`).
///
// TODO: Onboarding steps are now driven by UserField definitions
enum OnboardingStep: Hashable {
  case field(String) // UserField key

  /// Get the user field for this step
  var userField: any UserField {
    switch self {
    case .field(let key):
      return UserFieldRegistry.field(forKey: key) ?? NameField()
    }
  }

  /// Display title for the step
  var title: String {
    userField.onboardingTitle ?? userField.displayName
  }

  /// Optional subtitle for additional context
  var subtitle: String? {
    userField.onboardingSubtitle
  }

  /// SF Symbol icon for the step
  var icon: String {
    userField.icon
  }

  /// Whether this step is required to complete onboarding
  var isRequired: Bool {
    userField.isRequired
  }

  /// All onboarding steps (generated from UserFieldRegistry)
  static var allSteps: [OnboardingStep] {
    UserFieldRegistry.onboardingFields.map { .field($0.key) }
  }

  /// Total number of onboarding steps
  static var totalSteps: Int {
    allSteps.count
  }

  // MARK: - Convenience Cases

  static let name = OnboardingStep.field("name")
  static let ageGroup = OnboardingStep.field("ageGroup")
  static let interests = OnboardingStep.field("interests")
}
