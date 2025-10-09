import Foundation

/// Analytics service for tracking user events and properties.
///
/// ## Purpose
/// Single entry point for analytics events/traits. Counters themselves live on User.
///
/// ## Include
/// - Event keys/enums
/// - Thin wrappers around the analytics SDK
/// - Optional global context
///
/// ## Don't Include
/// - PII bundling
/// - Blocking work
/// - Feature-specific business logic
///
/// ## Lifecycle & Usage
/// Called by views upon user actions and after updating User counters.
///
// TODO: This is a thin wrapper around your analytics provider (e.g., Mixpanel, Amplitude, Firebase)
/// Counters themselves are stored on the User model; this service sends events to external analytics
struct Analytics {
  // MARK: - Events

  /// Track an analytics event
  // TODO: Wire this up to your analytics SDK
  /// - Parameters:
  ///   - event: The event name
  ///   - properties: Optional event properties
  static func track(event: AnalyticsEvent, properties: [String: Any]? = nil) {
    guard AppConfig.analyticsEnabled else { return }

    if AppConfig.debugLoggingEnabled {
      print("[Analytics] Event: \(event.rawValue), Properties: \(properties ?? [:])")
    }

    // TODO:  Replace with your analytics SDK call
    // YourAnalyticsSDK.track(event: event.rawValue, properties: properties)
  }

  /// Identify the current user
  // TODO: Call this when user logs in or app launches
  /// - Parameters:
  ///   - userId: The unique user identifier
  ///   - traits: Optional user traits/properties
  static func identify(userId: String, traits: [String: Any]? = nil) {
    guard AppConfig.analyticsEnabled else { return }

    if AppConfig.debugLoggingEnabled {
      print("[Analytics] Identify: \(userId), Traits: \(traits ?? [:])")
    }

    // TODO:  Replace with your analytics SDK call
    // YourAnalyticsSDK.identify(userId: userId, traits: traits)
  }

  /// Set user properties
  // TODO: Use this to update user traits over time
  /// - Parameter properties: User properties to set
  static func setUserProperties(_ properties: [String: Any]) {
    guard AppConfig.analyticsEnabled else { return }

    if AppConfig.debugLoggingEnabled {
      print("[Analytics] Set User Properties: \(properties)")
    }

    // TODO:  Replace with your analytics SDK call
    // YourAnalyticsSDK.setUserProperties(properties)
  }

  /// Reset analytics (clear user identity and data)
  // TODO: Call this when the app is reset or user logs out
  static func reset() {
    if AppConfig.debugLoggingEnabled {
      print("[Analytics] Reset: Clearing all analytics data")
    }

    // TODO:  Replace with your analytics SDK call
    // YourAnalyticsSDK.reset()
  }
}

// MARK: - Analytics Events

/// Predefined analytics events
// TODO: Extend this enum with your app-specific events
enum AnalyticsEvent: String {
  // Onboarding
  case onboardingStarted = "Onboarding Started"
  case onboardingStepViewed = "Onboarding Step Viewed"
  case onboardingStepCompleted = "Onboarding Step Completed"
  case onboardingStepSkipped = "Onboarding Step Skipped"
  case onboardingCompleted = "Onboarding Completed"

  // Feature Usage
  // TODO: Rename this to something that makes sense, like WorkoutComplete for a fitness app
  case coreFeatureUsed = "Core Feature Used"

  // Settings
  case themeChanged = "Theme Changed"
  case settingsViewed = "Settings Viewed"
  case appReset = "App Reset"
}
