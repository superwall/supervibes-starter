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
