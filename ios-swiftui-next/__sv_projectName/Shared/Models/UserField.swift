import Foundation

/// Protocol defining an editable user field.
///
/// ## Purpose
/// Core protocol and input type enum for user field infrastructure.
///
/// ## Include
/// - UserField protocol definition
/// - UserFieldInputType enum
/// - Protocol default implementations
///
/// ## Don't Include
/// - Concrete field implementations (those go in Shared/UserFields/)
/// - Registry (that goes in UserFieldRegistry.swift)
/// - UI code
///
/// ## Lifecycle & Usage
/// Infrastructure-level protocol that rarely changes; concrete field implementations live in Shared/UserFields/.
///
protocol UserField: Sendable {
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
  var inputType: UserFieldInputType { get }

  /// Onboarding-specific title (optional, uses displayName if nil)
  var onboardingTitle: String? { get }

  /// Onboarding-specific subtitle
  var onboardingSubtitle: String? { get }
}

// MARK: - Default Implementations

extension UserField {
  var onboardingTitle: String? { nil }
  var onboardingSubtitle: String? { nil }
}

// MARK: - Input Type

/// Defines how a user field should be rendered
enum UserFieldInputType {
  case textField(placeholder: String)
  case singleSelection(options: [String])
  case multiSelection(options: [String])
}
