import Foundation
import SwiftData
import SwiftUI

/// SwiftData model representing the user and their settings
/// This is the single source of truth for user preferences and local state
/// TEMPLATE NOTE: Extend this model with your app-specific user properties
@Model
final class User {
  // MARK: - Identity

  /// Unique identifier for the user
  /// TEMPLATE NOTE: This could be a server-provided ID or locally generated UUID
  @Attribute(.unique) var id: UUID

  // MARK: - Onboarding

  /// Whether the user has completed onboarding
  var hasCompletedOnboarding: Bool

  /// Date when the user first launched the app
  var firstLaunchDate: Date

  // MARK: - Preferences

  /// User's preferred theme (light/dark/system)
  /// TEMPLATE NOTE: Add theme enum if needed
  var preferredTheme: String

  /// User's display name
  /// TEMPLATE NOTE: Optional - remove if not needed
  var displayName: String?

  // MARK: - Analytics Counters
  // TEMPLATE NOTE: Track local usage metrics here, sync to analytics service when appropriate

  /// Total number of times the core feature has been used
  var totalCoreFeatureUses: Int

  /// Date of last activity
  var lastActivityDate: Date

  // MARK: - Initialization

  init(
    id: UUID = UUID(),
    hasCompletedOnboarding: Bool = false,
    firstLaunchDate: Date = Date(),
    preferredTheme: String = "system",
    displayName: String? = nil,
    totalCoreFeatureUses: Int = 0,
    lastActivityDate: Date = Date()
  ) {
    self.id = id
    self.hasCompletedOnboarding = hasCompletedOnboarding
    self.firstLaunchDate = firstLaunchDate
    self.preferredTheme = preferredTheme
    self.displayName = displayName
    self.totalCoreFeatureUses = totalCoreFeatureUses
    self.lastActivityDate = lastActivityDate
  }
}

// MARK: - Convenience Properties

extension User {
  /// Whether this is a new user (onboarding not completed)
  var isNewUser: Bool {
    !hasCompletedOnboarding
  }

  /// How many days since first launch
  var daysSinceFirstLaunch: Int {
    Calendar.current.dateComponents([.day], from: firstLaunchDate, to: Date()).day ?? 0
  }

  /// Convert theme string to SwiftUI ColorScheme
  var colorScheme: ColorScheme? {
    switch preferredTheme {
    case "light": return .light
    case "dark": return .dark
    default: return nil // system
    }
  }
}
