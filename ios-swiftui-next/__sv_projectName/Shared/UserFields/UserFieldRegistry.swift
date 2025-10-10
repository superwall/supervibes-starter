import Foundation

/// Central registry of all user fields.
///
/// ## Purpose
/// Central registry that aggregates all available user fields.
///
/// ## Include
/// - Static field collections (allFields, onboardingFields, settingsFields)
/// - Field lookup by key
///
/// ## Don't Include
/// - UI code
/// - Business logic
/// - Data persistence
/// - Field definitions (those go in separate files)
///
/// ## Lifecycle & Usage
/// Add new fields to `allFields` array to make them available throughout the app; queried by onboarding and settings views.
///
// TODO: Add new user fields to the allFields array to make them available in onboarding and settings
struct UserFieldRegistry {
  /// All available user fields
  static let allFields: [any UserField] = [
    NameField(),
    AgeGroupField(),
    InterestsField()
  ]

  /// Fields that should appear in onboarding
  static var onboardingFields: [any UserField] {
    allFields.filter { $0.showInOnboarding }
  }

  /// Fields that should appear in settings
  static var settingsFields: [any UserField] {
    allFields.filter { $0.showInSettings }
  }

  /// Find a field by its key
  static func field(forKey key: String) -> (any UserField)? {
    allFields.first { $0.key == key }
  }
}
