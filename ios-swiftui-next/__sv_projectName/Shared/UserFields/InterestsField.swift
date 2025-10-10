import Foundation

/// Interests field definition.
///
/// ## Purpose
/// Concrete UserField implementation for collecting user's interests.
///
/// ## Include
/// - Field metadata (key, icon, display name)
/// - Interest enum with available options and icons
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
// TODO: Customize interest options and messaging for your app
struct InterestsField: UserField {
  let key = "interests"
  let displayName = "Interests"
  let icon = "star.fill"
  let isRequired = false
  let showInOnboarding = true
  let showInSettings = true

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

  var inputType: UserFieldInputType {
    .multiSelection(options: Interest.allCases.map(\.rawValue))
  }

  var onboardingTitle: String? { "What are you interested in?" }
  var onboardingSubtitle: String? { "Select all that apply" }
}
