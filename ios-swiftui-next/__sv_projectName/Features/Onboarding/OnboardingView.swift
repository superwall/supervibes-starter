import SwiftUI

/// Onboarding flow for new users.
///
/// ## Purpose
/// Main onboarding flow container that orchestrates multi-step profile collection.
///
/// ## Include
/// - Navigation state
/// - Step progression logic
/// - Bindings to User model
/// - Completion handling
/// - Field definitions (inline, declarative)
///
/// ## Don't Include
/// - Global state management
/// - Heavy data access layers
///
/// ## Lifecycle & Usage
/// Mounted for new users; navigates through steps defined inline; marks onboarding complete on User model.
///
/// ## Customization
/// To customize onboarding:
/// 1. Add/remove/reorder steps in the switch statement
/// 2. Modify step titles, subtitles, icons, and options inline
/// 3. Add corresponding @State variables for new fields
/// 4. Update completeOnboarding() to save new field data
///
struct OnboardingView: View {
  @Bindable var user: User
  @Environment(\.modelContext) private var modelContext

  // MARK: - Navigation State

  @State private var currentStep = 0

  // MARK: - Form Data
  // TODO: Add/modify state variables for your onboarding fields

  @State private var name = ""
  @State private var selectedAgeGroup: String?
  @State private var selectedInterests: Set<String> = []

  // MARK: - Constants

  private var totalSteps: Int { 3 } // Update this when adding/removing steps

  // MARK: - Body

  var body: some View {
    NavigationStack {
      Group {
        switch currentStep {
        case 0:
          // Welcome Screen
          WelcomeStepView {
            nextStep()
          }

        case 1:
          // Name Step
          TextFieldStepView(
            title: "What should we call you?",
            subtitle: "Help us personalize your experience",
            icon: "person.fill",
            placeholder: "Your name",
            value: $name,
            isRequired: true,
            onContinue: {
              nextStep()
            }
          )

        case 2:
          // Age Group Step
          SingleSelectionStepView(
            title: "What's your age group?",
            subtitle: "This helps us show you relevant content",
            icon: "calendar",
            options: User.ageGroupOptions,
            selectedValue: $selectedAgeGroup,
            isRequired: true,
            onContinue: {
              nextStep()
            }
          )

        case 3:
          // Interests Step
          MultiSelectionStepView(
            title: "What are you interested in?",
            subtitle: "Select all that apply",
            icon: "star.fill",
            options: User.interestOptions.map { ($0.title, $0.icon) },
            selectedValues: $selectedInterests,
            onComplete: {
              completeOnboarding()
            }
          )

        default:
          EmptyView()
        }
      }
      .toolbar {
        // Progress bar (show for steps 1+)
        ToolbarItem(placement: .principal) {
          if currentStep > 0 {
            ProgressBar(
              current: currentStep,
              total: totalSteps
            )
          }
        }

        // Skip button (show for optional steps only)
        ToolbarItem(placement: .topBarTrailing) {
          if currentStep == 3 { // Interests is optional
            Button("Skip") {
              nextStep()
            }
            .font(Theme.Typography.body)
          }
        }
      }
    }
    .onAppear {
      // Track onboarding start
      Analytics.track(event: .onboardingStarted)
    }
  }

  // MARK: - Navigation

  private func nextStep() {
    // Track step completion
    trackStepCompletion(currentStep)

    // Move to next step
    currentStep += 1

    // Track step view
    trackStepView(currentStep)

    // Complete onboarding if we've gone past the last step
    if currentStep > totalSteps {
      completeOnboarding()
    }
  }

  // MARK: - Analytics

  private func trackStepCompletion(_ step: Int) {
    let stepName: String
    switch step {
    case 1: stepName = "name"
    case 2: stepName = "age_group"
    case 3: stepName = "interests"
    default: return
    }

    Analytics.track(
      event: .onboardingStepCompleted,
      properties: ["step": stepName]
    )
  }

  private func trackStepView(_ step: Int) {
    let stepName: String
    switch step {
    case 1: stepName = "name"
    case 2: stepName = "age_group"
    case 3: stepName = "interests"
    default: return
    }

    Analytics.track(
      event: .onboardingStepViewed,
      properties: ["step": stepName]
    )
  }

  // MARK: - Actions

  private func completeOnboarding() {
    // Update user record with collected data
    user.displayName = name.trimmingCharacters(in: .whitespaces).isEmpty ? nil : name
    user.ageGroup = selectedAgeGroup
    user.interests = Array(selectedInterests)
    user.completeOnboarding()

    // Save context
    try? modelContext.save()

    // Sync to analytics
    user.syncToAnalytics()

    // Track analytics
    Analytics.track(
      event: .onboardingCompleted,
      properties: [
        "has_name": user.displayName != nil,
        "has_age_group": user.ageGroup != nil,
        "interests_count": user.interests.count
      ]
    )
  }

}

#Preview {
  OnboardingView(user: User())
    .modelContainer(for: User.self, inMemory: true)
}
