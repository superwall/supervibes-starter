import Foundation
import SwiftData
import SwiftUI

/// SwiftData model representing the user and their settings.
///
/// ## Purpose
/// SwiftData @Model. Single source of truth for user settings and local counters.
///
/// ## Include
/// - User ID
/// - Settings (e.g., theme/flags)
/// - Local analytics counters (e.g., totalUsage)
/// - Relevant timestamps
/// - User profile data (displayName, ageGroup, interests)
///
/// ## Don't Include
/// - UI state
/// - Routing
/// - Transient view flags
/// - Secrets
///
/// ## Lifecycle & Usage
/// Create on first run via `User.fetchOrCreate(in:)` helper; update from features; SwiftData persists. Includes helper methods like `completeOnboarding()`, `logUsage()`, `updateTheme()`, `reset()`, and `syncToAnalytics()`.
///
/// This is the single source of truth for user preferences and local state
// TODO: Extend this model with your app-specific user properties
@Model
final class User {
  // MARK: - Identity

  /// Unique identifier for the user
  // TODO: This could be a server-provided ID or locally generated UUID
  @Attribute(.unique) var id: UUID

  // MARK: - Onboarding

  /// Whether the user has completed onboarding
  var hasCompletedOnboarding: Bool

  /// Date when the user first launched the app
  var firstLaunchDate: Date

  // MARK: - Preferences

  /// User's preferred theme (light/dark/system)
  // TODO: Add theme enum if needed
  var preferredTheme: String

  /// User's display name
  // TODO: Optional - remove if not needed
  var displayName: String?

  /// User's age group
  // TODO: Example onboarding data - customize as needed
  var ageGroup: String?

  /// User's selected interests
  // TODO: Example onboarding data - customize as needed
  var interests: [String]

  // MARK: - Analytics Counters
  // TODO:  Track local usage metrics here, sync to analytics service when appropriate

  /// Total number of times the app has been used
  var totalUsage: Int

  /// Date of last activity
  var lastActivityDate: Date

  // MARK: - Initialization

  init(
    id: UUID = UUID(),
    hasCompletedOnboarding: Bool = false,
    firstLaunchDate: Date = Date(),
    preferredTheme: String = "system",
    displayName: String? = nil,
    ageGroup: String? = nil,
    interests: [String] = [],
    totalUsage: Int = 0,
    lastActivityDate: Date = Date()
  ) {
    self.id = id
    self.hasCompletedOnboarding = hasCompletedOnboarding
    self.firstLaunchDate = firstLaunchDate
    self.preferredTheme = preferredTheme
    self.displayName = displayName
    self.ageGroup = ageGroup
    self.interests = interests
    self.totalUsage = totalUsage
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

  /// User attributes for analytics
  // TODO: Extend with additional user properties as needed
  var userAttributes: [String: Any] {
    var attributes: [String: Any] = [
      "user_id": id.uuidString,
      "has_completed_onboarding": hasCompletedOnboarding,
      "preferred_theme": preferredTheme,
      "total_usage": totalUsage,
      "days_since_first_launch": daysSinceFirstLaunch
    ]

    if let displayName = displayName {
      attributes["display_name"] = displayName
    }

    if let ageGroup = ageGroup {
      attributes["age_group"] = ageGroup
    }

    if !interests.isEmpty {
      attributes["interests"] = interests
      attributes["interests_count"] = interests.count
    }

    return attributes
  }
  
  /// Fetch the current user or create a new one if none exists
  // TODO: This ensures a single User record exists in the database
  /// - Parameter context: The SwiftData model context
  /// - Returns: The existing or newly created User
  static func fetchOrCreate(in context: ModelContext) -> User {
    let descriptor = FetchDescriptor<User>(
      sortBy: [SortDescriptor(\.firstLaunchDate)]
    )

    // Try to fetch existing user
    if let existingUser = try? context.fetch(descriptor).first {
      return existingUser
    }

    // Create new user if none exists
    let newUser = User()
    context.insert(newUser)

    // Save the context
    try? context.save()

    return newUser
  }

  /// Increment the total usage counter
  // TODO: Call this when tracking user engagement
  func logUsage() {
    totalUsage += 1
    lastActivityDate = Date()
  }

  /// Mark onboarding as completed
  // TODO: Call this when user finishes onboarding flow
  func completeOnboarding() {
    hasCompletedOnboarding = true
    lastActivityDate = Date()
  }

  /// Update the user's theme preference
  // TODO: Extend with additional preference setters as needed
  /// - Parameter theme: The new theme preference ("light", "dark", or "system")
  func updateTheme(_ theme: String) {
    preferredTheme = theme
    lastActivityDate = Date()
  }

  /// Reset all user data to defaults
  // TODO: Call this when user wants to reset the app and return to onboarding
  func reset() {
    hasCompletedOnboarding = false
    displayName = nil
    ageGroup = nil
    interests = []
    preferredTheme = "system"
    totalUsage = 0
    lastActivityDate = Date()
  }

  /// Sync user attributes to analytics
  // TODO: Call this after updating user properties to keep analytics in sync
  func syncToAnalytics() {
    Analytics.setUserProperties(userAttributes)
  }

}
