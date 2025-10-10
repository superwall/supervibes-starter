A production-ready iOS app template built with SwiftUI & SwiftData

## Overview

This is a starter template designed to accelerate iOS app development. It provides a solid architectural foundation with essential features pre-configured, allowing you to focus on building your app's unique functionality rather than boilerplate code.

## Project Overview

Here's what the user wants you to build:

<ProjectOverview/>

## Features

### Built-in Functionality
- **Multi-step onboarding flow** with progress tracking and reusable step components
- **User settings & preferences** with SwiftData persistence
- **Theme system** with semantic color tokens and typography
- **Analytics integration** ready to connect to your provider
- **Declarative field definitions** - Define onboarding and settings inline, no abstractions

### Architecture Highlights
- **Clean separation of concerns** - Persistence, Services, Features, and Shared components
- **Declarative, view-level design** - Fields defined where they're used, easy to customize
- **Modern SwiftUI patterns** - @Observable, @Bindable, NavigationStack
- **Reusable step components** - Text input, single/multi-selection views for onboarding
- **Beginner-friendly** - Simple switch statements and native SwiftUI, no protocols or registries
- **Centralized navigation** - Router pattern for app-wide navigation

## Getting Started

There are three main steps in getting started.

### 1. Design Your Onboarding Experience

Pick 4-6 screens users need to answer about themselves when they install the app. Name, Age & Interests are included by default, but you should use first priciples to come upw ith your own onboarding screens. These are just included as examples of text, single, and multi-selection inputs.

**Why onboarding matters:** It helps you learn who is downloading your app and gives you the opportunity to segment users for price testing or product analytics. This tells you who to market to. For example, asking interests in a camera app may seem pointless, but it:
- Makes users believe the experience is personalized for them
- Enables you to validate hypotheses about which segments have the most willingness to pay and highest retention

**How to customize:**

**Step A: Define field options in `Persistence/User.swift`** (if they appear in both onboarding and settings)

Field options are centralized in User.swift to maintain consistency. Add your options to the Field Options extension:

```swift
// In User.swift, add to the Field Options extension
static let languageOptions = [
  ("English", "en"),
  ("Spanish", "es"),
  ("French", "fr")
]
```

**Step B: Add the onboarding step in `Features/Onboarding/OnboardingView.swift`**

```swift
// Add a new step in the switch statement
case 4:
  SingleSelectionStepView(
    title: "Choose your language",
    subtitle: "We'll use this for the app interface",
    icon: "globe",
    options: User.languageOptions.map(\.0),  // Use options from User.swift
    selectedValue: $selectedLanguage,
    isRequired: true,
    onContinue: { nextStep() }
  )
```

**Available step components:**
- `TextFieldStepView` - For text input (name, email, etc.)
- `SingleSelectionStepView` - For single choice (age group, plan, etc.)
- `MultiSelectionStepView` - For multiple choices (interests, preferences, etc.)

**Don't forget to:**
1. Add options to `User.swift` if they're used in both onboarding and settings
2. Add a `@State` variable for your new field (e.g., `@State private var selectedLanguage: String?`)
3. Update `completeOnboarding()` to save the data to the User model
4. Update `totalSteps` count
5. Update analytics tracking if needed

**Step C: Add the field to settings in `Features/UserSettings/UserSettingsView.swift`**

```swift
// Add to the Profile section
HStack {
  Image(systemName: "globe")
    .foregroundStyle(Theme.Colors.primary)
    .frame(width: 24)
  Picker("Language", selection: $user.language) {
    ForEach(User.languageOptions, id: \.1) { name, code in
      Text(name).tag(code)
    }
  }
}
```

**Note:** By defining options in `User.swift`, changes are automatically consistent across onboarding and settings. 

### 2. Build Your Features

Keep a minimal UX that is easy to use. 

- Main functionality belongs in Features/Main/MainView.swift, the view the user sees when they open the app
- Define what your "core feature" is in Analytics.swift 

```swift
  // Feature Usage
  // TODO: Rename this to something that makes sense, like WorkoutComplete for a fitness app
  case coreFeatureUsed = "Core Feature Used"
```

For example...
Workout Apps -> .workoutComplete
Calorie Trackers -> .mealLogged
Editors -> .projectCreated

### 3. Choose a Theme

Customize colors and typography in `Shared/Theme.swift`:

- Choose a brand color that fits the usecase.
- Leave fonts as is for now

```swift
enum Colors {
  static let primary = Color.accentColor // Change to your brand color
  // ... customize other colors
}
```

## Common Tasks

### Adding a new feature
1. Create a new folder in `Features/`
2. Add views and logic specific to that feature
3. Register navigation routes in `App/Router.swift`

### Modifying the User model
1. Edit `Persistence/User.swift` to add new properties
2. SwiftData handles migrations automatically for simple changes
3. Update field bindings in onboarding/settings views as shown in step 1 above

### Adding application settings
1. Add a user property in `Persistence/User.swift`
2. Add the field inline in `Features/UserSettings/UserSettingsView.swift` using native SwiftUI components (TextField, Picker, Toggle, etc.)
3. No need for separate field definition files - define everything where it's used