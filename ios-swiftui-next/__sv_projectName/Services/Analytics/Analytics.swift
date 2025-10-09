import Foundation

/// Analytics service for tracking user events and properties
/// TEMPLATE NOTE: This is a thin wrapper around your analytics provider (e.g., Mixpanel, Amplitude, Firebase)
/// Counters themselves are stored on the User model; this service sends events to external analytics
struct Analytics {
  // MARK: - Events

  /// Track an analytics event
  /// TEMPLATE NOTE: Wire this up to your analytics SDK
  /// - Parameters:
  ///   - event: The event name
  ///   - properties: Optional event properties
  static func track(event: AnalyticsEvent, properties: [String: Any]? = nil) {
    guard AppConfig.analyticsEnabled else { return }

    if AppConfig.debugLoggingEnabled {
      print("[Analytics] Event: \(event.rawValue), Properties: \(properties ?? [:])")
    }

    // TEMPLATE NOTE: Replace with your analytics SDK call
    // MixpanelSDK.track(event: event.rawValue, properties: properties)
    // AmplitudeSDK.logEvent(event.rawValue, withEventProperties: properties)
  }

  /// Identify the current user
  /// TEMPLATE NOTE: Call this when user logs in or app launches
  /// - Parameters:
  ///   - userId: The unique user identifier
  ///   - traits: Optional user traits/properties
  static func identify(userId: String, traits: [String: Any]? = nil) {
    guard AppConfig.analyticsEnabled else { return }

    if AppConfig.debugLoggingEnabled {
      print("[Analytics] Identify: \(userId), Traits: \(traits ?? [:])")
    }

    // TEMPLATE NOTE: Replace with your analytics SDK call
    // MixpanelSDK.identify(distinctId: userId)
    // MixpanelSDK.people.set(properties: traits)
  }

  /// Set user properties
  /// TEMPLATE NOTE: Use this to update user traits over time
  /// - Parameter properties: User properties to set
  static func setUserProperties(_ properties: [String: Any]) {
    guard AppConfig.analyticsEnabled else { return }

    if AppConfig.debugLoggingEnabled {
      print("[Analytics] Set User Properties: \(properties)")
    }

    // TEMPLATE NOTE: Replace with your analytics SDK call
    // MixpanelSDK.people.set(properties: properties)
  }

  /// Increment a user property counter
  /// TEMPLATE NOTE: Use this in conjunction with User model counters
  /// - Parameters:
  ///   - property: The property name
  ///   - by: The amount to increment (default 1)
  static func increment(property: String, by amount: Double = 1) {
    guard AppConfig.analyticsEnabled else { return }

    if AppConfig.debugLoggingEnabled {
      print("[Analytics] Increment: \(property) by \(amount)")
    }

    // TEMPLATE NOTE: Replace with your analytics SDK call
    // MixpanelSDK.people.increment(property: property, by: amount)
  }

  /// Reset analytics (clear user identity and data)
  /// TEMPLATE NOTE: Call this when the app is reset or user logs out
  static func reset() {
    if AppConfig.debugLoggingEnabled {
      print("[Analytics] Reset: Clearing all analytics data")
    }

    // TEMPLATE NOTE: Replace with your analytics SDK call
    // MixpanelSDK.reset()
    // AmplitudeSDK.setUserId(nil)
    // AmplitudeSDK.regenerateDeviceId()
  }
}

// MARK: - Analytics Events

/// Predefined analytics events
/// TEMPLATE NOTE: Extend this enum with your app-specific events
enum AnalyticsEvent: String {
  // App Lifecycle
  case appLaunched = "App Launched"
  case appBackgrounded = "App Backgrounded"
  case appForegrounded = "App Foregrounded"

  // Onboarding
  case onboardingStarted = "Onboarding Started"
  case onboardingCompleted = "Onboarding Completed"

  // Feature Usage
  case coreFeatureUsed = "Core Feature Used"

  // Settings
  case themeChanged = "Theme Changed"
  case settingsViewed = "Settings Viewed"
  case appReset = "App Reset"
}
