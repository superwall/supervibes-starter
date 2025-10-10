# iOS SwiftUI Starter

A modern, production-ready iOS app template built with SwiftUI, SwiftData, and best practices.

## Overview

This is a starter template designed to accelerate iOS app development. It provides a solid architectural foundation with essential features pre-configured, allowing you to focus on building your app's unique functionality rather than boilerplate code.

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

## Project Structure

```
├── App/                          # App entry point and core infrastructure
├── Persistence/                  # SwiftData models
├── Services/                     # Networking, analytics, and other services
├── Features/                     # Feature modules (Onboarding, Main, Settings)
├── Shared/
│   ├── Components/               # Reusable UI components
│   ├── Models/                   # Domain models and protocols
│   ├── UserFields/               # Custom user field definitions
│   ├── Styles/                   # ButtonStyles, TextFieldStyles
│   ├── Theme.swift               # Design tokens
│   └── Extensions.swift          # View, Color, String extensions
├── Resources/                    # Assets, fonts
└── Configuration/                # App config and Info.plist
```

## Getting Started

- Add/modify user fields in `Shared/UserFields/` to update onboarding / user settings
- Replace example features with your app's logic

### Key Customization Points

#### 1. User Fields
Add custom fields for onboarding and settings:

```swift
// Create a new field in Shared/UserFields/
struct EmailField: UserField {
  let key = "email"
  let displayName = "Email"
  let icon = "envelope.fill"
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

#### 2. Theme
Customize colors and typography in `Shared/Theme.swift`:

```swift
enum Colors {
  static let primary = Color.accentColor // Change to your brand color
  // ... customize other colors
}
```

#### 3. Analytics
Connect your analytics provider in `Services/Analytics/Analytics.swift`:

```swift
static func track(event: AnalyticsEvent, properties: [String: Any] = [:]) {
  // Add your analytics SDK here
  // e.g., Mixpanel.track(event.rawValue, properties: properties)
}
```

## Common Tasks

### Adding a new feature
1. Create a new folder in `Features/`
2. Add views and logic specific to that feature
3. Register navigation routes in `App/Router.swift`

### Adding a new onboarding step
1. Create a new UserField in `Shared/UserFields/`
2. Add it to `UserFieldRegistry.allFields`
3. The step automatically appears in onboarding flow

### Modifying the User model
1. Edit `Persistence/User.swift`
2. SwiftData handles migrations automatically for simple changes
3. Update field bindings in onboarding/settings views