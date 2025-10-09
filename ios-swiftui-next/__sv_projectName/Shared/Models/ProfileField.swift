import Foundation

/// Protocol representing an editable profile field.
///
/// ## Purpose
/// Protocol and concrete field implementations defining editable user profile fields.
///
/// ## Include
/// - ProfileField protocol definition
/// - ProfileFieldInputType enum
/// - Concrete field structs (NameField, AgeGroupField, InterestsField)
/// - Supporting enums (AgeGroup, Interest)
///
/// ## Don't Include
/// - UI rendering code (that goes in ProfileFieldEditors)
/// - User model definition
/// - Navigation logic
///
/// ## Lifecycle & Usage
/// Single source of truth for field metadata used in both onboarding and settings; extend by creating new ProfileField implementations.
///
// TODO: Single source of truth for field definitions used in onboarding and settings
protocol ProfileField: Sendable {
  /// Unique identifier for the field
  var key: String { get }

  /// Display name shown in UI
  var displayName: String { get }

  /// SF Symbol icon
  var icon: String { get }

  /// Whether this field is required during onboarding
  var isRequired: Bool { get }

  /// Whether to show this field in onboarding flow
  var showInOnboarding: Bool { get }

  /// Whether to show this field in settings
  var showInSettings: Bool { get }

  /// How to render this field
  var inputType: ProfileFieldInputType { get }

  /// Onboarding-specific title (optional, uses displayName if nil)
  var onboardingTitle: String? { get }

  /// Onboarding-specific subtitle
  var onboardingSubtitle: String? { get }
}

// MARK: - Default Implementations

extension ProfileField {
  var onboardingTitle: String? { nil }
  var onboardingSubtitle: String? { nil }
}

// MARK: - Input Type

/// Defines how a profile field should be rendered
enum ProfileFieldInputType {
  case textField(placeholder: String)
  case singleSelection(options: [String])
  case multiSelection(options: [String])
}

// MARK: - Concrete Field Implementations

/// Name field
struct NameField: ProfileField {
  let key = "name"
  let displayName = "Name"
  let icon = "person.fill"
  let isRequired = true
  let showInOnboarding = true
  let showInSettings = true
  let inputType = ProfileFieldInputType.textField(placeholder: "Your name")

  var onboardingTitle: String? { "What should we call you?" }
  var onboardingSubtitle: String? { "Help us personalize your experience" }
}

/// Age group field
struct AgeGroupField: ProfileField {
  let key = "ageGroup"
  let displayName = "Age Group"
  let icon = "calendar"
  let isRequired = true
  let showInOnboarding = true
  let showInSettings = true

  var inputType: ProfileFieldInputType {
    .singleSelection(options: AgeGroup.allCases.map(\.rawValue))
  }

  var onboardingTitle: String? { "What's your age group?" }
  var onboardingSubtitle: String? { "This helps us show you relevant content" }
}

/// Interests field
struct InterestsField: ProfileField {
  let key = "interests"
  let displayName = "Interests"
  let icon = "star.fill"
  let isRequired = false
  let showInOnboarding = true
  let showInSettings = true

  var inputType: ProfileFieldInputType {
    .multiSelection(options: Interest.allCases.map(\.rawValue))
  }

  var onboardingTitle: String? { "What are you interested in?" }
  var onboardingSubtitle: String? { "Select all that apply" }
}

// MARK: - Age Group & Interest Enums (moved from OnboardingStep)

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

/// Interest options
// TODO: Customize these options for your app
enum Interest: String, CaseIterable {
  case cooking = "Cooking"
  case sports = "Sports"
  case music = "Music"
  case reading = "Reading"
  case travel = "Travel"
  case gaming = "Gaming"
  case art = "Art"
  case technology = "Technology"

  var displayName: String {
    rawValue
  }

  var icon: String {
    switch self {
    case .cooking:
      return "fork.knife"
    case .sports:
      return "figure.run"
    case .music:
      return "music.note"
    case .reading:
      return "book.fill"
    case .travel:
      return "airplane"
    case .gaming:
      return "gamecontroller.fill"
    case .art:
      return "paintpalette.fill"
    case .technology:
      return "laptopcomputer"
    }
  }
}
