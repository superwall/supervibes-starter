import Foundation

/// Central registry of all profile fields.
///
/// ## Purpose
/// Central registry of all available profile fields.
///
/// ## Include
/// - Static field collections (allFields, onboardingFields, settingsFields)
/// - Field lookup by key
///
/// ## Don't Include
/// - UI code
/// - Business logic
/// - Data persistence
///
/// ## Lifecycle & Usage
/// Add new fields to `allFields` array to make them available throughout the app; queried by onboarding and settings views.
///
// TODO: Add new profile fields here to make them available in onboarding and settings
struct ProfileFieldRegistry {
  /// All available profile fields
  static let allFields: [any ProfileField] = [
    NameField(),
    AgeGroupField(),
    InterestsField()
  ]

  /// Fields that should appear in onboarding
  static var onboardingFields: [any ProfileField] {
    allFields.filter { $0.showInOnboarding }
  }

  /// Fields that should appear in settings
  static var settingsFields: [any ProfileField] {
    allFields.filter { $0.showInSettings }
  }

  /// Find a field by its key
  static func field(forKey key: String) -> (any ProfileField)? {
    allFields.first { $0.key == key }
  }
}
