import Foundation

/// Represents a step in the onboarding flow.
///
/// ## Purpose
/// Enum representing onboarding steps, driven by ProfileField definitions.
///
/// ## Include
/// - Step enum cases
/// - ProfileField lookups via ProfileFieldRegistry
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
// TODO: Onboarding steps are now driven by ProfileField definitions
enum OnboardingStep: Hashable {
  case field(String) // ProfileField key

  /// Get the profile field for this step
  var profileField: any ProfileField {
    switch self {
    case .field(let key):
      return ProfileFieldRegistry.field(forKey: key) ?? NameField()
    }
  }

  /// Display title for the step
  var title: String {
    profileField.onboardingTitle ?? profileField.displayName
  }

  /// Optional subtitle for additional context
  var subtitle: String? {
    profileField.onboardingSubtitle
  }

  /// SF Symbol icon for the step
  var icon: String {
    profileField.icon
  }

  /// Whether this step is required to complete onboarding
  var isRequired: Bool {
    profileField.isRequired
  }

  /// All onboarding steps (generated from ProfileFieldRegistry)
  static var allSteps: [OnboardingStep] {
    ProfileFieldRegistry.onboardingFields.map { .field($0.key) }
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
