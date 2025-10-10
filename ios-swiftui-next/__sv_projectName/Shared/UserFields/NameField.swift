import Foundation

/// Name field definition.
///
/// ## Purpose
/// Concrete UserField implementation for collecting user's name.
///
/// ## Include
/// - Field metadata (key, icon, display name)
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
// TODO: Customize field metadata and messaging for your app
struct NameField: UserField {
  let key = "name"
  let displayName = "Name"
  let icon = "person.fill"
  let isRequired = true
  let showInOnboarding = true
  let showInSettings = true
  let inputType = UserFieldInputType.textField(placeholder: "Your name")

  var onboardingTitle: String? { "What should we call you?" }
  var onboardingSubtitle: String? { "Help us personalize your experience" }
}
