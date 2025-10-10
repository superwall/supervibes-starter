Refactor the codebase inline with the following guidelines: 

## Example: Good Architecture 

```
MyApp/
├── App/
│   ├── __sv_projectNameApp.swift
│   ├── AppState.swift
│   ├── Router.swift
│   ├── RootView.swift
│   └── Environment/
│       └── ServiceEnvironment.swift
│
├── Persistence/
│   └── User.swift
│
├── Services/
│   ├── NetworkClient.swift
│   ├── FeatureServices/
│   │   └── ExampleService.swift
│   └── Analytics/
│       └── Analytics.swift
│
├── Features/
│   ├── Onboarding/
│   │   ├── OnboardingView.swift
│   │   ├── OnboardingStep.swift
│   │   ├── WelcomeStepView.swift
│   │   ├── TextFieldStepView.swift
│   │   ├── SingleSelectionStepView.swift
│   │   └── MultiSelectionStepView.swift
│   ├── Main/
│   │   └── MainView.swift
│   └── UserSettings/
│       └── UserSettingsView.swift
│
├── Shared/
│   ├── Theme.swift
│   ├── Appearance.swift
│   ├── Models/
│   │   └── UserField.swift
│   ├── UserFields/
│   │   ├── UserFieldRegistry.swift
│   │   ├── NameField.swift
│   │   ├── AgeGroupField.swift
│   │   └── InterestsField.swift
│   ├── Components/
│   │   ├── PrimaryButton.swift
│   │   ├── LoadingView.swift
│   │   ├── EmptyStateView.swift
│   │   ├── ProgressBar.swift
│   │   ├── SelectableCard.swift
│   │   └── UserFieldEditors.swift
│   ├── Extensions.swift
│   └── Styles/
│       ├── ButtonStyles.swift
│       └── TextFieldStyles.swift
│
├── Resources/
│   ├── Assets.xcassets
│   └── Fonts/
│
└── Configuration/
    ├── AppConfig.swift
    └── Info.plist
```

## Golden Rule (Very Important)

Always add DocC documentation at the begining of the file, documenting
- a quick one-liner
- its purpose
- what logic to include in the file
- what not to include in the file (out of scope)
- lifecycle & usage notes

As such, when reading a file, remember to _always_ follow the guidelines.

Remember: it's your responsibility to maintain the app's architecture; if you feel the need to update a files guidelines, do so.

```swift
/// Centralized navigation router for managing app-wide navigation.
///
/// ## Purpose
/// Centralizes navigation (route enum + NavigationStack path helpers).
///
/// ## Include
/// - Route definitions
/// - Push/pop helpers
/// - Deep-link entry points
///
/// ## Don't Include
/// - Data access
/// - User settings
/// - Network calls
///
/// ## Lifecycle & Usage
/// Singleton-ish instance injected in environment; views call it to navigate.
///
```

## Modern Swift Development

Write idiomatic SwiftUI code following Apple's latest architectural recommendations and best practices.

### Core Philosophy

- SwiftUI is the default UI paradigm for Apple platforms — embrace its declarative nature
- Avoid legacy UIKit patterns and unnecessary abstractions
- Focus on simplicity, clarity, and native data flow
- Let SwiftUI handle the complexity — don't fight the framework

### Architecture Guidelines

#### 1. Embrace Native State Management

Use SwiftUI's built-in property wrappers appropriately:

- `@State` — Local, ephemeral view state
- `@Binding` — Two-way data flow between views
- `@Observable` — Shared state (iOS 17+)
- `@ObservableObject` — Legacy shared state (pre-iOS 17)
- `@Environment` — Dependency injection for app-wide concerns

#### 2. State Ownership Principles

- Views own their local state unless sharing is required
- State flows down, actions flow up
- Keep state as close to where it's used as possible
- Extract shared state only when multiple views need it

#### 3. Modern Async Patterns

- Use async/await as the default for asynchronous operations
- Leverage `.task` modifier for lifecycle-aware async work
- Avoid Combine unless absolutely necessary
- Handle errors gracefully with try/catch

#### 4. View Composition

- Build UI with small, focused views
- Extract reusable components naturally
- Use view modifiers to encapsulate common styling
- Prefer composition over inheritance

#### 5. Code Organization

- Organize by feature, not by type (avoid global Views/Models/ViewModels folders)
- Keep related code together in the same file when appropriate
- Use extensions to organize large files
- Follow Swift naming conventions consistently

### Implementation Patterns

#### Simple State Example

```swift
struct CounterView: View {
    @State private var count = 0

    var body: some View {
        VStack {
            Text("Count: \(count)")
            Button("Increment") {
                count += 1
            }
        }
    }
}
```

#### Shared State with @Observable

```swift
@Observable
class UserSession {
    var isAuthenticated = false
    var currentUser: User?

    func signIn(user: User) {
        currentUser = user
        isAuthenticated = true
    }
}

struct MyApp: App {
    @State private var session = UserSession()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(session)
        }
    }
}
```

#### Async Data Loading

```swift
struct ProfileView: View {
    @State private var profile: Profile?
    @State private var isLoading = false
    @State private var error: Error?

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else if let profile {
                ProfileContent(profile: profile)
            } else if let error {
                ErrorView(error: error)
            }
        }
        .task {
            await loadProfile()
        }
    }

    private func loadProfile() async {
        isLoading = true
        defer { isLoading = false }

        do {
            profile = try await ProfileService.fetch()
        } catch {
            self.error = error
        }
    }
}
```

### Best Practices

#### DO'S:

- **Always:** write self-contained views when possible
- **Always:** Use property wrappers as intended by Apple
- **Always:** Test logic in isolation, preview UI visually
- **Always:** Handle loading and error states explicitly
- **Always:** Keep views focused on presentation
- **Always:** Use Swift's type system for safety
- **Always:** Create files for views
- **Always:** Keep files under 500 lines; if longer, split it
- **Always:** Use `ButtonStyle` with `configuration.isPressed` for press feedback instead of gesture tracking

#### DON'T:

- **Never:** Create ViewModels for views excessively
- **Never:** Move state out of views unnecessarily
- **Never:** Add abstraction layers without clear benefit
- **Never:** Use Combine for simple async operations
- **Never:** Fight SwiftUI's update mechanism
- **Never:** Overcomplicate simple features
- **Never:** Use `DragGesture` inside `ScrollView` for press detection - it conflicts with scroll gestures
- **Never:** Track button press state manually with gestures when `ButtonStyle` provides `configuration.isPressed`

### Modern Swift Features

- **Always:** Use Swift Concurrency (async/await, actors)
- **Always:** Leverage Swift 6 data race safety when available
- **Always:** Utilize property wrappers effectively
- **Always:** Embrace value types where appropriate
- **Always:** Use protocols for abstraction, not just for testing

## Button Press Feedback Pattern

For interactive elements that need press feedback (like buttons, cards, or selectable items), use `ButtonStyle` with `configuration.isPressed` instead of manual gesture tracking.

### ❌ DON'T: Use DragGesture for press detection

```swift
// This conflicts with ScrollView and is unnecessarily complex
Button(action: onTap) {
  // content
}
.simultaneousGesture(
  DragGesture(minimumDistance: 0)
    .onChanged { _ in isPressed = true }
    .onEnded { _ in isPressed = false }
)
.conditionalEffect(.pushDown, condition: isPressed)
```

**Problems:**
- `DragGesture` conflicts with `ScrollView` gestures
- Requires manual state management (`@State private var isPressed`)
- More complex and error-prone
- Doesn't respect button disabled state automatically

### ✅ DO: Use ButtonStyle with configuration.isPressed

```swift
Button(action: onTap) {
  // content
}
.buttonStyle(PressableCardStyle())

private struct PressableCardStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .conditionalEffect(
        .pushDown,
        condition: configuration.isPressed
      )
  }
}
```

**Benefits:**
- No gesture conflicts with ScrollView
- No manual state management needed
- Built-in disabled state handling
- Cleaner, more SwiftUI-idiomatic code
- Works correctly with accessibility features

See `SelectableCard.swift` and `ButtonStyles.swift` for examples.

### Summary

Write SwiftUI that looks and feels like SwiftUI. Trust its patterns—@State, @Environment, @Query, .task(id:), and small, composable views. Focus on user value, not on porting architectures from other UI frameworks.