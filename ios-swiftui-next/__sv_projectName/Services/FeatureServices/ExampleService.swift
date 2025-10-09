import Foundation

/// Example feature service demonstrating how to use NetworkClient.
///
/// ## Purpose
/// A focused service that uses NetworkClient to perform a single capability (e.g., "generate something").
///
/// ## Include
/// - Request assembly for that capability
/// - Parameter validation
/// - Response shaping for the view/domain
///
/// ## Don't Include
/// - Cross-feature utilities
/// - Storage
/// - Navigation logic
///
/// ## Lifecycle & Usage
/// Created near the feature (or injected). Stateless; called from views during .task/.onChange.
///
// TODO: Replace this with your actual feature services
/// This service is stateless and focused on a single capability
struct ExampleService {
  // MARK: - Properties

  private let networkClient: NetworkClient

  // MARK: - Initialization

  init(networkClient: NetworkClient) {
    self.networkClient = networkClient
  }

  // MARK: - API Methods

  /// Fetch example data from the server
  // TODO: Replace with your actual API endpoints and models
  /// - Parameter url: Full URL to the API endpoint
  /// - Returns: An array of example items
  func fetchExampleData(url: String) async throws -> [ExampleItem] {
    try await networkClient.get(url: url)
  }

  /// Submit example data to the server
  // TODO: Customize request/response types for your needs
  /// - Parameters:
  ///   - url: Full URL to the API endpoint
  ///   - item: The item to submit
  /// - Returns: The created item with server-generated ID
  func submitExample(url: String, item: ExampleItemRequest) async throws -> ExampleItem {
    try await networkClient.post(url: url, body: item)
  }
}

// MARK: - Data Models

/// Example response model
// TODO: Replace with your actual API response models
struct ExampleItem: Codable, Identifiable {
  let id: String
  let title: String
  let description: String
  let createdAt: Date
}

/// Example request model
// TODO: Replace with your actual API request models
struct ExampleItemRequest: Codable {
  let title: String
  let description: String
}
