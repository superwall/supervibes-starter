import SwiftUI
import SwiftData

/// Main app entry point
/// TEMPLATE NOTE: This is the composition root - wire dependencies here
@main
struct __sv_projectNameApp: App {
  // MARK: - Services

  @State private var router = Router()
  @State private var appState = AppState()
  @State private var networkClient = NetworkClient()

  // MARK: - SwiftData Container

  var modelContainer: ModelContainer = {
    let schema = Schema([User.self])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

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
      fatalError("Could not create ModelContainer: \(error)")
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
  }
}
