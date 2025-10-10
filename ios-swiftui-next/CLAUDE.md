# Project Configuration

- Make changes to the Xcode project by updating `project.yml` and running `xcodegen generate`
- The project uses XcodeGen for project generation - never edit the `.xcodeproj` directly

## Project Overview

<ProjectOverview/>

## Project Structure

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

# Animations - Guidelines & Best Practices (powered by [POW](https://movingparts.io/pow))

## Change Effects

Change Effects are effects that will trigger a visual or haptic every time a value changes.

Use the `changeEffect` modifier and pass in an `AnyChangeEffect` as well as a value to watch for changes.

```swift
Button {
    post.toggleLike()
} label: {
    Label(post.likes.formatted(), systemName: "heart.fill")
}
.changeEffect(.spray { heart }, value: post.likes, isEnabled: post.isLiked)
.tint(post.isLiked ? .red : .gray)
```

---

### Film Exposure

[Preview](https://movingparts.io/pow/#film-exposure)

A transition from completely dark to fully visible on insertion, and from fully visible to completely dark on removal.

```swift
static var filmExposure: AnyTransition
```

**When to use:**
- Revealing images dramatically
- Photo gallery transitions
- Image loading states with dramatic effect

**Example:**
```swift
if let selectedImage = selectedImage {
    Image(selectedImage)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .transition(.movingParts.filmExposure)
}
```

---

### Glow

[Preview](https://movingparts.io/pow/#glow)

An effect that adds a glowing highlight to indicate the next step or valid state.

```swift
static var glow: AnyChangeEffect
```

**When to use:**
- Indicating the next step in a flow
- Highlighting valid form fields
- Drawing attention to enabled actions
- Showing interactive elements

**Example:**
```swift
Button("Continue") {
    // action
}
.changeEffect(.glow, value: isFormValid, isEnabled: isFormValid)
```

---

### Pop

[Preview](https://movingparts.io/pow/#pop)

A transition that shows a view with a ripple effect and a flurry of tint-colored particles.

```swift
static var pop: AnyTransition
static func pop<S: ShapeStyle>(_ style: S) -> AnyTransition
```

**When to use:**
- Icon button interactions (like, favorite, star)
- Toggle state changes with visual feedback
- Celebratory interactions
- Apply to the icon only, not the entire button

**Example:**
```swift
Button {
    starred.toggle()
} label: {
    if starred {
        Image(systemName: "star.fill")
            .foregroundStyle(.orange)
            .transition(.movingParts.pop(.orange))
    } else {
        Image(systemName: "star")
            .foregroundStyle(.gray)
            .transition(.identity)
    }
}
```

---

### Push Down

An effect that scales down the view while a condition is true (such as while being pressed).

```swift
static var pushDown: AnyChangeEffect
```

**When to use:**
- Button press feedback
- Interactive element responses
- Tactile feedback for user actions

**Example:**
```swift
Button("Submit") {
    // action
}
.changeEffect(.pushDown, value: isPressed)
```

---

### Rise

[Preview](https://movingparts.io/pow/#rise)

An effect that emits the provided particles from the origin point and slowly float up while moving side to side.

```swift
static func rise(origin: UnitPoint = .center, layer: ParticleLayer = .local, @ViewBuilder _ particles: () -> some View) -> AnyChangeEffect
```

**When to use:**
- Value increments (likes, points, scores)
- Reward animations
- Achievement unlocks
- Counter increases

**Example:**
```swift
Text("\(points)")
    .changeEffect(
        .rise(origin: .center) {
            Text("+1")
                .foregroundStyle(.green)
        },
        value: points
    )
```

---

### Shake

[Preview](https://movingparts.io/pow/#shake)

An effect that shakes the view when a change happens.

```swift
static var shake: AnyChangeEffect
static func shake(rate: ShakeRate) -> AnyChangeEffect
```

**When to use:**
- Incorrect password entries
- Form validation errors
- Failed button presses
- Invalid input feedback
- Any error or failure state

**Example:**
```swift
TextField("Password", text: $password)
    .changeEffect(.shake, value: loginAttempts, isEnabled: loginFailed)
```

---

### Shine

[Preview](https://movingparts.io/pow/#shine)

An effect that highlights the view with a shine moving over the view.

```swift
static var shine: AnyChangeEffect
static func shine(duration: Double) -> AnyChangeEffect
static func shine(angle: Angle, duration: Double = 1.0) -> AnyChangeEffect
```

**When to use:**
- Loading indicators
- AI response generation in progress
- Content placeholders
- Buttons becoming ready to press
- Skeleton loading states
- Processing feedback

**Example:**
```swift
Button("Submit") {
    // action
}
.disabled(name.isEmpty)
.changeEffect(.shine.delay(1), value: name.isEmpty, isEnabled: !name.isEmpty)
```

---

### Spray

[Preview](https://movingparts.io/pow/#spray)

An effect that emits multiple particles in different shades and sizes moving up from the origin point.

```swift
static func spray(origin: UnitPoint = .center, layer: ParticleLayer = .local, @ViewBuilder _ particles: () -> some View) -> AnyChangeEffect
```

**When to use:**
- Icon button interactions (like, favorite, star)
- Similar to Pop but with custom particle icons
- Celebratory actions
- Achievement animations
- Apply to the icon only, not the entire button

**Example:**
```swift
Button {
    likes += 1
} label: {
    Image(systemName: "heart.fill")
}
.changeEffect(
    .spray(origin: .center) {
        Image(systemName: "heart.fill")
    },
    value: likes
)
.tint(isLiked ? .red : .gray)
```

---

### Wiggle

An effect that wiggles the view when a change happens.

```swift
static var wiggle: AnyChangeEffect
```

**When to use:**
- Drawing attention to a button that should be pressed
- Indicating an action is required
- Prompting user interaction
- Call-to-action emphasis

**Example:**
```swift
Button {
    answer()
} label: {
    Label("Answer", systemName: "phone.fill")
}
.conditionalEffect(.repeat(.wiggle(rate: .fast), every: .seconds(1))
```

---

## Particle Layer

A particle layer is a context in which particle effects draw their particles.

The `particleLayer(name:)` view modifier wraps the view in a particle layer with the given name.

Particle effects such as `AnyChangeEffect.spray` can render their particles on this position in the view tree to avoid being clipped by their immediate ancestor.

For example, certain `List` styles may clip their rows. Use `particleLayer(_:)` to render particles on top of the entire `List` or even its enclosing `NavigationStack`.

```swift
func particleLayer(name: AnyHashable) -> some View
```

---

## Delay

Every change effect can be delayed to trigger the effect after some time.

```swift
Button("Submit") {
    // action
}
.buttonStyle(.borderedProminent)
.disabled(name.isEmpty)
.changeEffect(.shine.delay(1), value: name.isEmpty, isEnabled: !name.isEmpty)
```

**Parameters:**
- `delay`: The delay in seconds.

```swift
func delay(_ delay: Double) -> AnyChangeEffect
```

### Putting it all together

Here's an example of a well architected view following best practices on animations.

```swift
import SwiftUI
import Pow

/// Main app view - primary feature surface
/// TEMPLATE NOTE: Replace this with your app's main functionality. This is just an example.
struct MainView: View {
  @Bindable var user: User
  @Environment(Router.self) private var router
  @Environment(\.modelContext) private var modelContext

  @State private var showingSettings = false

  var body: some View {
    ScrollView {
      VStack(spacing: 32) {
        // Header
        VStack(alignment: .leading, spacing: 12) {
          if let displayName = user.displayName {
            Text("Hello, \(displayName)!")
              .font(Theme.Typography.title1)
          } else {
            Text("Welcome!")
              .font(Theme.Typography.title1)
          }

          Text("This is your main app view")
            .font(Theme.Typography.callout)
            .foregroundStyle(Theme.Colors.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 32)
        .padding(.top, 32)

        // Stats Card
        VStack(alignment: .leading, spacing: 16) {
          Text("Your Activity")
            .font(Theme.Typography.title3)

          HStack(spacing: 24) {
            StatItem(
              title: "Days Active",
              value: "\(user.daysSinceFirstLaunch)"
            )

            Divider()
              .frame(height: 40)

            StatItem(
              title: "Total Uses",
              value: "\(user.totalCoreFeatureUses)"
            )
          }
        }
        .padding(24)
        .cardStyle()
        .padding(.horizontal, 32)

        // Action Button
        PrimaryButton(title: "Use Core Feature") {
          useCoreFeature()
        }
        .padding(.horizontal, 32)

        Spacer()
      }
    }
    .background(Theme.Colors.background)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          router.navigate(to: .settings)
        } label: {
          Image(systemName: "gearshape")
        }
      }
    }
  }

  // MARK: - Actions

  private func useCoreFeature() {
    // Increment usage counter
    user.incrementCoreFeatureUse()

    // Save context
    try? modelContext.save()

    // Track analytics
    Analytics.track(event: .coreFeatureUsed)
    Analytics.increment(property: "total_feature_uses")
  }
}

// MARK: - Stat Item Component
// Move this to another file if it gets too large. If it's used in other places, move it to Shared/Components 

private struct StatItem: View {
  let title: String
  let value: String

  var body: some View {
    VStack(spacing: 8) {
      Text(value)
        .font(Theme.Typography.title2)
        .foregroundStyle(Theme.Colors.primary)
        .contentTransition(.numericText())
        .changeEffect(
          .rise(origin: .center) {
            Text("+1")
              .font(Theme.Typography.title3)
              .foregroundStyle(Theme.Colors.primary)
          },
          value: value
        )

      Text(title)
        .font(Theme.Typography.caption)
        .foregroundStyle(Theme.Colors.secondaryText)
    }
    .frame(maxWidth: .infinity)
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
