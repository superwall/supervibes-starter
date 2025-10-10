A production-ready iOS app template built with SwiftUI & SwiftData

## Overview

This is a starter template designed to accelerate iOS app development. It provides a solid architectural foundation with essential features pre-configured, allowing you to focus on building your app's unique functionality rather than boilerplate code.

## Project Overview

Here's what the user wants you to build:

<ProjectOverview/>

## Features

### Built-in Functionality
- **Multi-step onboarding flow** with progress tracking
- **User settings & preferences** with SwiftData persistence
- **Theme system** with semantic color tokens and typography
- **Analytics integration** ready to connect to your provider
- **Extensible field system** for collecting user data

### Architecture Highlights
- **Clean separation of concerns** - Persistence, Services, Features, and Shared components
- **Protocol-driven design** - Extensible UserField system for custom data collection
- **Modern SwiftUI patterns** - @Observable, @Bindable, NavigationStack
- **Reusable components** - Buttons, cards, progress bars, and more
- **Centralized navigation** - Router pattern for app-wide navigation

## Getting Started

There are three main steps in getting started. 

1. Design your onboarding experience. Pick 4-6 screens users need to answer about themselves when they install the app. Name, Age & Interests are included by default, but only because they are examples of text, single and multi selection inputs. 

Note: Onboarding is important - it helps you learn who is downloading your app, and gives you the opportunity to segment users down the line, either for price testing or product analytics. This essentially tells you who to market to. For example, asking a users interests for a camera app may seem pointless, but it does a few things. First, it lets the user believe the experience is personalized for them, even if it isn't. Second, it enables you to form and validate hypotheses about which segments have the most willingness to pay and the highest retention. So, always start with thoughtful onboarding questions. 

- Add/modify user fields in `Shared/UserFields/` to update onboarding & user settings. 

```swift
// Create a new field in Shared/UserFields/
struct EmailField: UserField {
  let key = "email"
  let displayName = "Email"
  let icon = "envelope.fill" // SFSymbol
  let isRequired = true
  let showInOnboarding = true
  let showInSettings = true
  let inputType = UserFieldInputType.textField(placeholder: "your@email.com")
}

// Register in UserFieldRegistry.swift
static let allFields: [any UserField] = [
  NameField(),
  EmailField(), // Add here
  AgeGroupField(),
  InterestsField()
]
```

Doing the above automatically includes it in both Onboarding & Settings as configured. 

2. Build Your Features

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

3. Choose a Theme

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
1. Edit `Persistence/User.swift`
2. SwiftData handles migrations automatically for simple changes
3. Update field bindings in onboarding/settings views

### Adding application settings
1. Add a user property in `Persistence/User.swift`
2. Add the settings to `Features/UserSettings/UserSettingsView.swift`