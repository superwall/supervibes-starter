import Foundation

/// Generic HTTP client for making network requests.
///
/// ## Purpose
/// Generic HTTP transport for one-off "do work" calls (no persistence/sync).
///
/// ## Include
/// - Base URL
/// - Request building
/// - Headers
/// - Error handling
/// - (De)serialization policy
///
/// ## Don't Include
/// - Feature-specific behavior
/// - Global state
/// - Business branching
///
/// ## Lifecycle & Usage
/// Constructed once with base URL; injected via environment; used by feature services.
///
// TODO: This is a simple, stateless HTTP transport layer.
/// Customize error handling, authentication, and request/response patterns for your needs.
@Observable
final class NetworkClient {
  // MARK: - Properties

  /// Default request timeout
  let timeout: TimeInterval

  /// URLSession for making requests
  private let session: URLSession

  // MARK: - Initialization

  init(timeout: TimeInterval = 120.0) {
    self.timeout = timeout

    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = timeout
    self.session = URLSession(configuration: configuration)
  }

  // MARK: - Request Methods

  /// Perform a GET request
  // TODO: Extend with additional HTTP methods as needed
  func get<T: Decodable>(
    url: String,
    queryItems: [URLQueryItem]? = nil
  ) async throws -> T {
    let request = try buildRequest(url: url, method: "GET", queryItems: queryItems)
    return try await performRequest(request)
  }

  /// Perform a POST request
  func post<T: Decodable, Body: Encodable>(
    url: String,
    body: Body
  ) async throws -> T {
    var request = try buildRequest(url: url, method: "POST")
    request.httpBody = try JSONEncoder().encode(body)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    return try await performRequest(request)
  }

  // MARK: - Private Helpers

  private func buildRequest(
    url: String,
    method: String,
    queryItems: [URLQueryItem]? = nil
  ) throws -> URLRequest {
    guard var components = URLComponents(string: url) else {
      throw NetworkError.invalidURL
    }

    // Add query items if provided
    if let queryItems = queryItems {
      components.queryItems = queryItems
    }

    guard let finalURL = components.url else {
      throw NetworkError.invalidURL
    }

    var request = URLRequest(url: finalURL)
    request.httpMethod = method
    request.setValue("application/json", forHTTPHeaderField: "Accept")

    // TODO:  Add authentication headers here
    // request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    return request
  }

  private func performRequest<T: Decodable>(_ request: URLRequest) async throws -> T {
    let (data, response) = try await session.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkError.invalidResponse
    }

    guard (200...299).contains(httpResponse.statusCode) else {
      throw NetworkError.httpError(statusCode: httpResponse.statusCode)
    }

    do {
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      return try decoder.decode(T.self, from: data)
    } catch {
      throw NetworkError.decodingError(error)
    }
  }
}

// MARK: - Network Errors

enum NetworkError: LocalizedError {
  case invalidURL
  case invalidResponse
  case httpError(statusCode: Int)
  case decodingError(Error)

  var errorDescription: String? {
    switch self {
    case .invalidURL:
      return "The URL is invalid."
    case .invalidResponse:
      return "The server response was invalid."
    case .httpError(let statusCode):
      return "Request failed with status code \(statusCode)."
    case .decodingError(let error):
      return "Failed to decode response: \(error.localizedDescription)"
    }
  }
}
