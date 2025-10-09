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
///
/// ## Don't Include
/// - Global state management
/// - Heavy data access layers
/// - Field definitions (those belong in ProfileField)
///
/// ## Lifecycle & Usage
/// Mounted for new users; navigates through steps defined in ProfileFieldRegistry; marks onboarding complete on User model.
///
// TODO: Multi-step onboarding using NavigationStack for automatic back button handling
struct OnboardingView: View {
  @Bindable var user: User
  @Environment(\.modelContext) private var modelContext

  // Navigation
  @State private var navigationPath: [OnboardingStep] = []

  // Form Data
  @State private var name = ""
  @State private var selectedAgeGroup: String?
  @State private var selectedInterests: Set<String> = []

  private var currentStep: OnboardingStep? {
    navigationPath.last
  }

  private var currentStepNumber: Int {
    navigationPath.count
  }

  var body: some View {
    NavigationStack(path: $navigationPath) {
      // Welcome Screen (Step 0)
      WelcomeStepView {
        navigateToNextStep(from: nil)
      }
      .navigationDestination(for: OnboardingStep.self) { step in
        stepView(for: step)
          .toolbar {
            // Progress bar in title
            ToolbarItem(placement: .principal) {
              if currentStepNumber > 0 {
                OnboardingProgressBar(
                  current: currentStepNumber,
                  total: OnboardingStep.totalSteps
                )
              }
            }

            // Skip button for optional steps
            ToolbarItem(placement: .topBarTrailing) {
              if let currentStep = currentStep, !currentStep.isRequired {
                Button("Skip") {
                  navigateToNextStep(from: currentStep)
                }
                .font(Theme.Typography.body)
              }
            }
          }
      }
    }
    .onAppear {
      // Track onboarding start
      Analytics.track(event: .onboardingStarted)
    }
  }

  // MARK: - Step Views

  @ViewBuilder
  private func stepView(for step: OnboardingStep) -> some View {
    let field = step.profileField
    let isLastStep = step == OnboardingStep.allSteps.last

    switch field.inputType {
    case .textField:
      NameStepView(
        field: field,
        value: bindingForField(key: field.key),
        onContinue: {
          if isLastStep {
            completeOnboarding()
          } else {
            navigateToNextStep(from: step)
          }
        }
      )

    case .singleSelection:
      AgeGroupStepView(
        field: field,
        selectedValue: bindingForOptionalField(key: field.key),
        onContinue: {
          if isLastStep {
            completeOnboarding()
          } else {
            navigateToNextStep(from: step)
          }
        }
      )

    case .multiSelection:
      InterestsStepView(
        field: field,
        selectedValues: bindingForMultiField(key: field.key),
        onComplete: {
          completeOnboarding()
        }
      )
    }
  }

  // MARK: - Field Bindings

  private func bindingForField(key: String) -> Binding<String> {
    switch key {
    case "name":
      return $name
    default:
      return .constant("")
    }
  }

  private func bindingForOptionalField(key: String) -> Binding<String?> {
    switch key {
    case "ageGroup":
      return $selectedAgeGroup
    default:
      return .constant(nil)
    }
  }

  private func bindingForMultiField(key: String) -> Binding<Set<String>> {
    switch key {
    case "interests":
      return $selectedInterests
    default:
      return .constant([])
    }
  }

  // MARK: - Navigation

  private func navigateToNextStep(from currentStep: OnboardingStep?) {
    // Track step completion
    if let currentStep = currentStep {
      Analytics.track(
        event: .onboardingStepCompleted,
        properties: ["step": currentStep.profileField.key]
      )
    }

    // Determine next step
    let allSteps = OnboardingStep.allSteps
    let nextStep: OnboardingStep? = {
      guard let currentStep = currentStep else {
        return allSteps.first // First step after welcome
      }

      // Find current step index and get next step
      if let currentIndex = allSteps.firstIndex(of: currentStep) {
        let nextIndex = currentIndex + 1
        return nextIndex < allSteps.count ? allSteps[nextIndex] : nil
      }
      return nil
    }()

    // Navigate to next step or complete
    if let nextStep = nextStep {
      navigationPath.append(nextStep)
      Analytics.track(
        event: .onboardingStepViewed,
        properties: ["step": nextStep.profileField.key]
      )
    } else {
      completeOnboarding()
    }
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
