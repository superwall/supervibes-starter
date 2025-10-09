import Foundation
import SwiftData

extension User {
  /// Fetch the current user or create a new one if none exists
  /// TEMPLATE NOTE: This ensures a single User record exists in the database
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

  /// Increment the core feature usage counter
  /// TEMPLATE NOTE: Call this when tracking user engagement
  func incrementCoreFeatureUse() {
    totalCoreFeatureUses += 1
    lastActivityDate = Date()
  }

  /// Mark onboarding as completed
  /// TEMPLATE NOTE: Call this when user finishes onboarding flow
  func completeOnboarding() {
    hasCompletedOnboarding = true
    lastActivityDate = Date()
  }

  /// Update the user's theme preference
  /// TEMPLATE NOTE: Extend with additional preference setters as needed
  /// - Parameter theme: The new theme preference ("light", "dark", or "system")
  func updateTheme(_ theme: String) {
    preferredTheme = theme
    lastActivityDate = Date()
  }
}
