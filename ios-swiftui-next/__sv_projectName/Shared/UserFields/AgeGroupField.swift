import Foundation

/// Age group field definition.
///
/// ## Purpose
/// Concrete UserField implementation for collecting user's age group.
///
/// ## Include
/// - Field metadata (key, icon, display name)
/// - AgeGroup enum with available options
/// - Input type configuration
/// - Onboarding messaging
///
/// ## Don't Include
/// - UI rendering code
/// - Validation logic (handled by views)
///
/// ## Lifecycle & Usage
/// Registered in UserFieldRegistry; used by onboarding and settings views.
///
// TODO: Customize age group options and messaging for your app
struct AgeGroupField: UserField {
  let key = "ageGroup"
  let displayName = "Age Group"
  let icon = "calendar"
  let isRequired = true
  let showInOnboarding = true
  let showInSettings = true

  /// Age group options
  // TODO: Customize these options for your app
  enum AgeGroup: String, CaseIterable {
    case under18 = "Under 18"
    case age18to24 = "18-24"
    case age25to34 = "25-34"
    case age35to49 = "35-49"
    case age50plus = "50+"

    var displayName: String {
      rawValue
    }
  }

  var inputType: UserFieldInputType {
    .singleSelection(options: AgeGroup.allCases.map(\.rawValue))
  }

  var onboardingTitle: String? { "What's your age group?" }
  var onboardingSubtitle: String? { "This helps us show you relevant content" }
}
