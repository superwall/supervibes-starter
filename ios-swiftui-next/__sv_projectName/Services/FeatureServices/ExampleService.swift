import Foundation

/// Example feature service demonstrating how to use NetworkClient
/// TEMPLATE NOTE: Replace this with your actual feature services
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
  /// TEMPLATE NOTE: Replace with your actual API endpoints and models
  /// - Parameter url: Full URL to the API endpoint
  /// - Returns: An array of example items
  func fetchExampleData(url: String) async throws -> [ExampleItem] {
    try await networkClient.get(url: url)
  }

  /// Submit example data to the server
  /// TEMPLATE NOTE: Customize request/response types for your needs
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
/// TEMPLATE NOTE: Replace with your actual API response models
struct ExampleItem: Codable, Identifiable {
  let id: String
  let title: String
  let description: String
  let createdAt: Date
}

/// Example request model
/// TEMPLATE NOTE: Replace with your actual API request models
struct ExampleItemRequest: Codable {
  let title: String
  let description: String
}
