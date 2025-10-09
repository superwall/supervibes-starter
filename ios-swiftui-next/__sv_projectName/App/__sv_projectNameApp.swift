import SwiftUI
import SwiftData

/// Main app entry point - composition root that wires SwiftData container, injects environment objects/values, and mounts the RootView.
///
/// ## Purpose
/// Composition root. Wires SwiftData container, injects environment objects/values, and mounts the RootView.
///
/// ## Include
/// - Scene setup
/// - Dependency injection
/// - Initial analytics event
///
/// ## Don't Include
/// - Business logic
/// - Navigation decisions beyond initial wiring
/// - Persistence/network code
///
/// ## Lifecycle & Usage
/// Created at launch by the system; remains minimal and stable.
///
// TODO: This is the composition root - wire dependencies here
@main
struct __sv_projectNameApp: App {
  // MARK: - Services

  @State private var router = Router()
  @State private var appState = AppState()
  @State private var networkClient = NetworkClient()

  // MARK: - Lifecycle

  @Environment(\.scenePhase) private var scenePhase

  // MARK: - SwiftData Container

  var modelContainer: ModelContainer = {
    let schema = Schema([User.self])
    // Allow automatic migration for schema changes
    let modelConfiguration = ModelConfiguration(
      schema: schema,
      isStoredInMemoryOnly: false,
      allowsSave: true
    )

    do {
      let container = try ModelContainer(for: schema, configurations: [modelConfiguration])

      // Bootstrap: Create user if none exists
      let context = container.mainContext
      let descriptor = FetchDescriptor<User>()
      let existingUsers = try? context.fetch(descriptor)

      if existingUsers?.isEmpty ?? true {
        let newUser = User()
        context.insert(newUser)
        try? context.save()
      }

      return container
    } catch {
      // If migration fails, try deleting and recreating
      #if DEBUG
      print("[SwiftData] Migration failed, attempting to recreate container: \(error)")

      // Delete existing store
      let url = modelConfiguration.url
      try? FileManager.default.removeItem(at: url)

      // Create fresh container
      do {
        let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        let context = container.mainContext
        let newUser = User()
        context.insert(newUser)
        try? context.save()
        return container
      } catch {
        fatalError("Could not create ModelContainer even after reset: \(error)")
      }
      #else
      fatalError("Could not create ModelContainer: \(error)")
      #endif
    }
  }()

  // MARK: - Scene

  var body: some Scene {
    WindowGroup {
      RootView()
        .modelContainer(modelContainer)
        .environment(router)
        .environment(appState)
        .environment(networkClient)
        .onAppear {
          Appearance.configure()
        }
    }
    .onChange(of: scenePhase) { _, newPhase in
      handleScenePhaseChange(newPhase)
    }
  }

  // MARK: - Lifecycle Handlers

  private func handleScenePhaseChange(_ phase: ScenePhase) {
    let context = modelContainer.mainContext

    switch phase {
    case .background:
      // Sync user attributes as failsafe when app goes to background
      if let user = try? context.fetch(FetchDescriptor<User>()).first {
        user.syncToAnalytics()
      }

    case .active, .inactive:
      break

    @unknown default:
      break
    }
  }
}
